/*
 * XMC ASYSMA package writer
 *
 * This small companion tool intentionally performs packaging, not native
 * machine-code compilation. XMC remains the .xclass producer; this writer
 * creates a portable ASYSMA container around already-built artifacts.
 */
#include <errno.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static uint32_t read32le(FILE *f) {
    unsigned char b[4];
    if (fread(b, 1, 4, f) != 4) return 0;
    return (uint32_t)b[0] | ((uint32_t)b[1] << 8) |
           ((uint32_t)b[2] << 16) | ((uint32_t)b[3] << 24);
}

static int copy_file(FILE *out, const char *path, uint64_t *size) {
    FILE *in = fopen(path, "rb");
    unsigned char buf[65536];
    size_t n;
    if (!in) return -1;
    *size = 0;
    while ((n = fread(buf, 1, sizeof buf, in)) != 0) {
        if (fwrite(buf, 1, n, out) != n) { fclose(in); return -1; }
        *size += n;
    }
    if (ferror(in)) { fclose(in); return -1; }
    fclose(in);
    return 0;
}

static void usage(const char *p) {
    fprintf(stderr,
        "usage: %s --output FILE --entry JAVA|NATIVE|NATIVE_THEN_JAVA "
        "--java CLASS [--xclass FILE] [--native FILE]\n", p);
}

int main(int argc, char **argv) {
    const char *out_path = NULL, *entry = NULL, *java_entry = NULL;
    const char *xclass = NULL, *native_payload = NULL;
    FILE *out;
    uint64_t native_size = 0, xclass_size = 0;
    uint32_t flags = 0;

    for (int i = 1; i < argc; ++i) {
        if (!strcmp(argv[i], "--output") && i + 1 < argc) out_path = argv[++i];
        else if (!strcmp(argv[i], "--entry") && i + 1 < argc) entry = argv[++i];
        else if (!strcmp(argv[i], "--java") && i + 1 < argc) java_entry = argv[++i];
        else if (!strcmp(argv[i], "--xclass") && i + 1 < argc) xclass = argv[++i];
        else if (!strcmp(argv[i], "--native") && i + 1 < argc) native_payload = argv[++i];
        else { usage(argv[0]); return 2; }
    }

    if (!out_path || !entry || !java_entry ||
        (strcmp(entry, "JAVA") && strcmp(entry, "NATIVE") &&
         strcmp(entry, "NATIVE_THEN_JAVA"))) {
        usage(argv[0]); return 2;
    }
    if (!strcmp(entry, "NATIVE") && !native_payload) {
        fprintf(stderr, "NATIVE entry requires --native\n"); return 2;
    }
    if (!strcmp(entry, "NATIVE_THEN_JAVA") && !native_payload) {
        fprintf(stderr, "NATIVE_THEN_JAVA requires --native\n"); return 2;
    }

    out = fopen(out_path, "wb");
    if (!out) { perror(out_path); return 1; }

    /*
     * Deliberately simple v0 container:
     * magic[8], version, entry flags, manifest length, then UTF-8 manifest
     * followed by optional native and .xclass payloads.
     * A future format implementation must add canonical integrity records
     * before this writer is considered production-ready.
     */
    const char *mode = entry;
    char manifest[4096];
    int manifest_len = snprintf(manifest, sizeof manifest,
        "format=ASYSMA\nversion=1\narchitecture=x86-64\n"
        "entry_type=%s\njava_runtime=SecureJDK-28\njava_entry=%s\n"
        "xmc_metadata=%s\nnative_payload=%s\n",
        mode, java_entry, xclass ? "present" : "absent",
        native_payload ? "present" : "absent");
    if (manifest_len < 0 || (size_t)manifest_len >= sizeof manifest) {
        fprintf(stderr, "manifest too large\n"); fclose(out); return 1;
    }

    if (fwrite("ASYSMA\0\1", 1, 8, out) != 8) goto io_fail;
    unsigned char hdr[12] = {1,0,0,0, 0,0,0,0, 0,0,0,0};
    flags = !strcmp(entry, "JAVA") ? 1u :
            !strcmp(entry, "NATIVE") ? 2u : 3u;
    hdr[4] = (unsigned char)flags;
    hdr[8] = (unsigned char)(manifest_len & 255);
    hdr[9] = (unsigned char)((manifest_len >> 8) & 255);
    hdr[10] = (unsigned char)((manifest_len >> 16) & 255);
    hdr[11] = (unsigned char)((manifest_len >> 24) & 255);
    if (fwrite(hdr, 1, sizeof hdr, out) != sizeof hdr) goto io_fail;
    if (fwrite(manifest, 1, (size_t)manifest_len, out) != (size_t)manifest_len) goto io_fail;

    if (native_payload && copy_file(out, native_payload, &native_size) != 0) goto io_fail;
    if (xclass && copy_file(out, xclass, &xclass_size) != 0) goto io_fail;

    fclose(out);
    printf("created %s (%llu native bytes, %llu xclass bytes)\n",
           out_path, (unsigned long long)native_size,
           (unsigned long long)xclass_size);
    return 0;

io_fail:
    fprintf(stderr, "write failed: %s\n", strerror(errno));
    fclose(out);
    remove(out_path);
    return 1;
}
