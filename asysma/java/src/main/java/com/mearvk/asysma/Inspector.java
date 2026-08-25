package com.mearvk.asysma;

import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.security.PublicKey;
import java.security.Signature;
import java.security.spec.X509EncodedKeySpec;
import java.security.KeyFactory;
import java.security.MessageDigest;
import java.util.HexFormat;
import java.util.Properties;
import java.util.zip.ZipEntry;
import java.util.zip.ZipFile;

/**
 * Read-only ASYSMA rehearsal verifier. It never executes package payloads.
 */
public final class Inspector {
    private static final String MANIFEST = "META-INF/ASYSMA.MF";
    private static final String SIGNATURE = "META-INF/ASYSMA.SIG";
    private static final String PUBLIC_KEY = "META-INF/ASYSMA.PUB";

    private Inspector() {}

    public static void main(String[] args) throws Exception {
        if (args.length != 1) {
            System.err.println("usage: asysma-inspect <package.asysma>");
            System.exit(2);
        }
        inspect(Path.of(args[0]));
    }

    static void inspect(Path packagePath) throws Exception {
        try (ZipFile zip = new ZipFile(packagePath.toFile())) {
            ZipEntry manifestEntry = required(zip, MANIFEST);
            ZipEntry signatureEntry = required(zip, SIGNATURE);
            ZipEntry keyEntry = required(zip, PUBLIC_KEY);

            byte[] manifest = readBounded(zip, manifestEntry, 1024 * 1024);
            Properties p = new Properties();
            p.load(new java.io.ByteArrayInputStream(manifest));
            require(p, "format", "ASYSMA-0.1");
            require(p, "package-id", null);
            require(p, "package-version", null);
            require(p, "entrypoint", null);

            verifyPaths(zip);
            verifyPayloadDigests(zip, p);
            verifySignature(manifest, readBounded(zip, signatureEntry, 4096),
                    readBounded(zip, keyEntry, 4096));

            System.out.println("ASYSMA VERIFIED");
            System.out.println("package-id=" + p.getProperty("package-id"));
            System.out.println("package-version=" + p.getProperty("package-version"));
            System.out.println("entrypoint=" + p.getProperty("entrypoint"));
        }
    }

    private static ZipEntry required(ZipFile zip, String name) throws IOException {
        ZipEntry e = zip.getEntry(name);
        if (e == null || e.isDirectory()) throw new SecurityException("missing required entry: " + name);
        return e;
    }

    private static byte[] readBounded(ZipFile zip, ZipEntry e, long limit) throws IOException {
        if (e.getSize() > limit) throw new SecurityException("entry exceeds limit: " + e.getName());
        try (InputStream in = zip.getInputStream(e)) {
            return in.readNBytes((int) limit + 1);
        }
    }

    private static void verifyPaths(ZipFile zip) {
        zip.stream().forEach(e -> {
            String n = e.getName();
            if (n.startsWith("/") || n.contains("\\") || n.contains("../") || n.equals("..") || n.contains("\0"))
                throw new SecurityException("unsafe archive path: " + n);
        });
    }

    private static void verifyPayloadDigests(ZipFile zip, Properties p) throws Exception {
        for (String key : p.stringPropertyNames()) {
            if (!key.startsWith("sha384.")) continue;
            String path = key.substring("sha384.".length());
            ZipEntry e = zip.getEntry(path);
            if (e == null || e.isDirectory()) throw new SecurityException("missing payload: " + path);
            byte[] actual;
            try (InputStream in = zip.getInputStream(e)) {
                actual = MessageDigest.getInstance("SHA-384").digest(in.readAllBytes());
            }
            String expected = p.getProperty(key).trim().toLowerCase();
            String got = HexFormat.of().formatHex(actual);
            if (!MessageDigest.isEqual(expected.getBytes(StandardCharsets.US_ASCII), got.getBytes(StandardCharsets.US_ASCII)))
                throw new SecurityException("digest mismatch: " + path);
        }
    }

    private static void verifySignature(byte[] manifest, byte[] sigBytes, byte[] encodedKey) throws Exception {
        PublicKey key = KeyFactory.getInstance("Ed25519").generatePublic(new X509EncodedKeySpec(encodedKey));
        Signature sig = Signature.getInstance("Ed25519");
        sig.initVerify(key);
        sig.update(manifest);
        if (!sig.verify(sigBytes)) throw new SecurityException("ASYSMA signature verification failed");
    }

    private static void require(Properties p, String key, String expected) {
        String value = p.getProperty(key);
        if (value == null || value.isBlank() || (expected != null && !expected.equals(value)))
            throw new SecurityException("invalid manifest field: " + key);
    }
}
