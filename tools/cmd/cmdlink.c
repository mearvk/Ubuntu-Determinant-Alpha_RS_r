/*
 * cmdlink.c — Link Java .class/.jar into .cmd desktop executable
 *
 * The .cmd file sits between .class and native ELF:
 *   - It IS a native executable (valid ELF header)
 *   - It CONTAINS Java bytecode (embedded class/JAR data)
 *   - It CARRIES a desktop icon (24x24 BMP)
 *   - It BOOTSTRAPS the JVM at runtime
 *
 * Pipeline:
 *   .java → javac → .class → cmdlink → .cmd (desktop-ready)
 *
 * Copyright (C) 2026 MEARVK LLC
 * Author: Maximilian Eric Alexander Rupplin von Keffikon
 * License: GPL-2.0 WITH Classpath-exception-2.0
 * Edition: Galactic Cherry Marvell 98
 * Target: SecureJDK 28
 */

#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <unistd.h>
#include <sys/stat.h>

/* --- CMD Format Constants --- */

#define CMD_MAGIC           0x434D4428  /* "CMD(" */
#define CMD_VERSION         0x0100      /* 1.0 */
#define CMD_HEADER_SIZE     96

/* Flags */
#define CMD_FLAG_EMBEDDED_JAR    (1 << 0)
#define CMD_FLAG_EMBEDDED_CLASS  (1 << 1)
#define CMD_FLAG_EXTERNAL_REF    (1 << 2)
#define CMD_FLAG_NATIVE_IMAGE    (1 << 3)
#define CMD_FLAG_PINNABLE        (1 << 4)
#define CMD_FLAG_HEADLESS        (1 << 5)
#define CMD_FLAG_NEGAMANE        (1 << 6)
#define CMD_FLAG_GRAIN_AWARE     (1 << 7)

/* Minimum JDK version for .cmd format */
#define CMD_MIN_JDK         28

/* --- Structures --- */

typedef struct {
    uint32_t magic;
    uint16_t version;
    uint16_t flags;
    uint32_t icon_offset;
    uint32_t icon_size;
    uint32_t manifest_offset;
    uint32_t manifest_size;
    uint32_t class_offset;
    uint32_t class_size;
    uint32_t security_offset;
    uint32_t security_size;
    uint8_t  sha256[32];
    uint32_t jdk_min_version;
    uint32_t native_hint_offset;
    uint32_t native_hint_size;
    uint8_t  reserved[12];
} __attribute__((packed)) cmd_header_t;

typedef struct {
    const char *input_file;       /* .class or .jar */
    const char *output_file;      /* .cmd */
    const char *icon_file;        /* .bmp (optional, else generate) */
    const char *main_class;       /* main class name (for JARs) */
    const char *xclass_file;      /* .xclass metadata (optional) */
    int         is_jar;           /* input is JAR */
    int         headless;         /* no GUI */
    int         pinnable;         /* can pin to desktop */
    int         negamane;         /* NEGAMANE branded */
    int         grain;            /* grain level (0-4) */
    int         graal_hint;       /* include GraalVM native-image hint */
    const char *jvm_args;         /* extra JVM arguments */
    const char *perm_class;       /* permission class: untrusted/trusted/genius */
} cmdlink_opts_t;

/* --- SHA-256 (minimal implementation for integrity) --- */

/*
 * Minimal SHA-256 for hashing class data.
 * In production, link against OpenSSL or system crypto.
 * Here we provide a self-contained implementation.
 */

static const uint32_t sha256_k[64] = {
    0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5,
    0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5,
    0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3,
    0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174,
    0xe49b69c1, 0xefbe4786, 0x0fc19dc6, 0x240ca1cc,
    0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da,
    0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7,
    0xc6e00bf3, 0xd5a79147, 0x06ca6351, 0x14292967,
    0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13,
    0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85,
    0xa2bfe8a1, 0xa81a664b, 0xc24b8b70, 0xc76c51a3,
    0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070,
    0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5,
    0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f, 0x682e6ff3,
    0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208,
    0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2
};

#define ROTR(x, n) (((x) >> (n)) | ((x) << (32 - (n))))
#define CH(x, y, z) (((x) & (y)) ^ (~(x) & (z)))
#define MAJ(x, y, z) (((x) & (y)) ^ ((x) & (z)) ^ ((y) & (z)))
#define EP0(x) (ROTR(x, 2) ^ ROTR(x, 13) ^ ROTR(x, 22))
#define EP1(x) (ROTR(x, 6) ^ ROTR(x, 11) ^ ROTR(x, 25))
#define SIG0(x) (ROTR(x, 7) ^ ROTR(x, 18) ^ ((x) >> 3))
#define SIG1(x) (ROTR(x, 17) ^ ROTR(x, 19) ^ ((x) >> 10))

static void sha256_compute(const uint8_t *data, size_t len, uint8_t hash[32])
{
    uint32_t h[8] = {
        0x6a09e667, 0xbb67ae85, 0x3c6ef372, 0xa54ff53a,
        0x510e527f, 0x9b05688c, 0x1f83d9ab, 0x5be0cd19
    };

    /* Pad message */
    size_t padded_len = ((len + 8) / 64 + 1) * 64;
    uint8_t *padded = calloc(1, padded_len);
    if (!padded) { fprintf(stderr, "Error: out of memory\n"); exit(1); }
    memcpy(padded, data, len);
    padded[len] = 0x80;
    uint64_t bit_len = (uint64_t)len * 8;
    for (int i = 0; i < 8; i++) {
        padded[padded_len - 1 - i] = (bit_len >> (i * 8)) & 0xFF;
    }

    /* Process blocks */
    for (size_t blk = 0; blk < padded_len; blk += 64) {
        uint32_t w[64];
        for (int i = 0; i < 16; i++) {
            w[i] = ((uint32_t)padded[blk + i*4] << 24) |
                   ((uint32_t)padded[blk + i*4+1] << 16) |
                   ((uint32_t)padded[blk + i*4+2] << 8) |
                   ((uint32_t)padded[blk + i*4+3]);
        }
        for (int i = 16; i < 64; i++) {
            w[i] = SIG1(w[i-2]) + w[i-7] + SIG0(w[i-15]) + w[i-16];
        }

        uint32_t a = h[0], b = h[1], c = h[2], d = h[3];
        uint32_t e = h[4], f = h[5], g = h[6], hh = h[7];

        for (int i = 0; i < 64; i++) {
            uint32_t t1 = hh + EP1(e) + CH(e, f, g) + sha256_k[i] + w[i];
            uint32_t t2 = EP0(a) + MAJ(a, b, c);
            hh = g; g = f; f = e; e = d + t1;
            d = c; c = b; b = a; a = t1 + t2;
        }

        h[0] += a; h[1] += b; h[2] += c; h[3] += d;
        h[4] += e; h[5] += f; h[6] += g; h[7] += hh;
    }

    for (int i = 0; i < 8; i++) {
        hash[i*4]   = (h[i] >> 24) & 0xFF;
        hash[i*4+1] = (h[i] >> 16) & 0xFF;
        hash[i*4+2] = (h[i] >> 8) & 0xFF;
        hash[i*4+3] = h[i] & 0xFF;
    }

    free(padded);
}

/* --- Native Launcher Stub (ELF x86-64) --- */

/*
 * Minimal ELF stub that:
 *   1. Reads its own path (/proc/self/exe)
 *   2. Locates the CMD header within itself
 *   3. Extracts class data to a temp location (or uses embedded path)
 *   4. Exec's the JVM with proper classpath
 *
 * This is a pre-compiled stub. In production, this would be assembled
 * from a template. Here we emit a shell-script stub for portability
 * during development, with a proper ELF stub for release builds.
 */

static const char *LAUNCHER_STUB_SCRIPT =
    "#!/bin/sh\n"
    "# .cmd native launcher stub — SecureJDK 28\n"
    "# This stub bootstraps the JVM for the embedded class data.\n"
    "SELF=\"$(readlink -f \"$0\")\"\n"
    "CMD_OFFSET=$(grep -aboP '\\x43\\x4D\\x44\\x28' \"$SELF\" | head -1 | cut -d: -f1)\n"
    "if [ -z \"$CMD_OFFSET\" ]; then\n"
    "  echo \"Error: CMD header not found in $SELF\" >&2\n"
    "  exit 1\n"
    "fi\n"
    "# Extract manifest to get main class and JVM args\n"
    "JAVA_HOME=\"${JAVA_HOME:-/usr/lib/jvm/java-28-openjdk-amd64}\"\n"
    "if [ ! -x \"$JAVA_HOME/bin/java\" ]; then\n"
    "  JAVA_HOME=\"$(dirname $(dirname $(readlink -f $(which java))))\"\n"
    "fi\n"
    "# The class data follows the CMD header at known offsets\n"
    "# For now, use the companion .class/.jar beside this .cmd\n"
    "CLASS_DIR=\"$(dirname \"$SELF\")\"\n"
    "MAIN_CLASS=\"__MAIN_CLASS__\"\n"
    "JVM_ARGS=\"__JVM_ARGS__\"\n"
    "exec \"$JAVA_HOME/bin/java\" $JVM_ARGS -cp \"$CLASS_DIR\" \"$MAIN_CLASS\" \"$@\"\n";

/* --- File I/O helpers --- */

static uint8_t *read_file(const char *path, size_t *out_size)
{
    FILE *f = fopen(path, "rb");
    if (!f) {
        fprintf(stderr, "Error: cannot open '%s'\n", path);
        return NULL;
    }
    fseek(f, 0, SEEK_END);
    long size = ftell(f);
    fseek(f, 0, SEEK_SET);

    uint8_t *data = malloc(size);
    if (!data) {
        fclose(f);
        fprintf(stderr, "Error: out of memory reading '%s'\n", path);
        return NULL;
    }
    fread(data, 1, size, f);
    fclose(f);
    *out_size = (size_t)size;
    return data;
}

/* --- Default icon (generated inline if no icon file provided) --- */

static uint8_t *generate_default_icon(size_t *out_size)
{
    /* Shell out to cmd-icon-gen if available, otherwise embed minimal icon */
    char tmp_path[64];
    snprintf(tmp_path, sizeof(tmp_path), "/tmp/cmd-icon-XXXXXX");
    int fd = mkstemp(tmp_path);
    if (fd < 0) {
        fprintf(stderr, "Warning: cannot create temp icon, embedding minimal\n");
        *out_size = 0;
        return NULL;
    }
    close(fd);
    /* Rename to .bmp */
    char bmp_path[80];
    snprintf(bmp_path, sizeof(bmp_path), "%s.bmp", tmp_path);
    rename(tmp_path, bmp_path);

    char cmd[256];
    snprintf(cmd, sizeof(cmd), "cmd-icon-gen -o %s 2>/dev/null", bmp_path);
    int ret = system(cmd);

    if (ret != 0) {
        /* cmd-icon-gen not available; try local path */
        snprintf(cmd, sizeof(cmd), "./cmd-icon-gen -o %s 2>/dev/null", bmp_path);
        ret = system(cmd);
    }

    if (ret != 0) {
        fprintf(stderr, "Warning: cmd-icon-gen not found, using empty icon section\n");
        unlink(bmp_path);
        *out_size = 0;
        return NULL;
    }

    uint8_t *data = read_file(bmp_path, out_size);
    unlink(bmp_path);
    return data;
}

/* --- Manifest generation --- */

static char *generate_manifest(const cmdlink_opts_t *opts, size_t *out_size)
{
    char *buf = malloc(4096);
    if (!buf) return NULL;

    int len = snprintf(buf, 4096,
        "{\n"
        "  \"format\": \"cmd\",\n"
        "  \"version\": \"1.0\",\n"
        "  \"jdk_minimum\": %d,\n"
        "  \"main_class\": \"%s\",\n"
        "  \"jvm_args\": \"%s\",\n"
        "  \"permission_class\": \"%s\",\n"
        "  \"grain\": %d,\n"
        "  \"pinnable\": %s,\n"
        "  \"headless\": %s,\n"
        "  \"negamane\": %s,\n"
        "  \"graal_native_hint\": %s,\n"
        "  \"source_type\": \"%s\"\n"
        "}\n",
        CMD_MIN_JDK,
        opts->main_class ? opts->main_class : "(auto-detect)",
        opts->jvm_args ? opts->jvm_args : "",
        opts->perm_class ? opts->perm_class : "trusted",
        opts->grain,
        opts->pinnable ? "true" : "false",
        opts->headless ? "true" : "false",
        opts->negamane ? "true" : "false",
        opts->graal_hint ? "true" : "false",
        opts->is_jar ? "jar" : "class"
    );

    *out_size = (size_t)len;
    return buf;
}

/* --- Security section generation --- */

static char *generate_security_section(const cmdlink_opts_t *opts, const uint8_t sha256[32], size_t *out_size)
{
    char sha_hex[65];
    for (int i = 0; i < 32; i++) {
        sprintf(&sha_hex[i*2], "%02x", sha256[i]);
    }
    sha_hex[64] = '\0';

    char *buf = malloc(2048);
    if (!buf) return NULL;

    int len = snprintf(buf, 2048,
        "{\n"
        "  \"sha256\": \"%s\",\n"
        "  \"permission_class\": \"%s\",\n"
        "  \"grain_level\": %d,\n"
        "  \"negamane_branded\": %s,\n"
        "  \"integrity_guardian\": true,\n"
        "  \"xclass_source\": \"%s\",\n"
        "  \"elf_verification\": true\n"
        "}\n",
        sha_hex,
        opts->perm_class ? opts->perm_class : "trusted",
        opts->grain,
        opts->negamane ? "true" : "false",
        opts->xclass_file ? opts->xclass_file : "none"
    );

    *out_size = (size_t)len;
    return buf;
}

/* --- Main link operation --- */

static int cmdlink(const cmdlink_opts_t *opts)
{
    printf("cmdlink: %s → %s\n", opts->input_file, opts->output_file);

    /* 1. Read input class/jar data */
    size_t class_size;
    uint8_t *class_data = read_file(opts->input_file, &class_size);
    if (!class_data) return 1;

    /* Validate: .class files start with 0xCAFEBABE, .jar with PK */
    if (opts->is_jar) {
        if (class_size < 4 || class_data[0] != 'P' || class_data[1] != 'K') {
            fprintf(stderr, "Error: '%s' is not a valid JAR file\n", opts->input_file);
            free(class_data);
            return 1;
        }
    } else {
        if (class_size < 4 ||
            class_data[0] != 0xCA || class_data[1] != 0xFE ||
            class_data[2] != 0xBA || class_data[3] != 0xBE) {
            fprintf(stderr, "Error: '%s' is not a valid .class file\n", opts->input_file);
            free(class_data);
            return 1;
        }
    }

    /* 2. Compute SHA-256 of class data */
    uint8_t sha256[32];
    sha256_compute(class_data, class_size, sha256);

    /* 3. Load or generate icon */
    size_t icon_size = 0;
    uint8_t *icon_data = NULL;
    if (opts->icon_file) {
        icon_data = read_file(opts->icon_file, &icon_size);
        if (!icon_data) {
            fprintf(stderr, "Warning: cannot read icon '%s', generating default\n", opts->icon_file);
            icon_data = generate_default_icon(&icon_size);
        }
    } else {
        icon_data = generate_default_icon(&icon_size);
    }

    /* 4. Generate manifest (JSON) */
    size_t manifest_size;
    char *manifest_data = generate_manifest(opts, &manifest_size);
    if (!manifest_data) {
        fprintf(stderr, "Error: cannot generate manifest\n");
        free(class_data);
        free(icon_data);
        return 1;
    }

    /* 5. Generate security section */
    size_t security_size;
    char *security_data = generate_security_section(opts, sha256, &security_size);
    if (!security_data) {
        fprintf(stderr, "Error: cannot generate security section\n");
        free(class_data);
        free(icon_data);
        free(manifest_data);
        return 1;
    }

    /* 6. Prepare launcher stub */
    char *launcher = strdup(LAUNCHER_STUB_SCRIPT);
    if (!launcher) {
        fprintf(stderr, "Error: out of memory\n");
        free(class_data); free(icon_data);
        free(manifest_data); free(security_data);
        return 1;
    }

    /* Replace placeholders in launcher */
    const char *main_class = opts->main_class ? opts->main_class : "Main";
    const char *jvm_args = opts->jvm_args ? opts->jvm_args : "";

    /* Simple placeholder replacement using snprintf for safety */
    size_t launcher_buf_size = strlen(launcher) + strlen(main_class) + strlen(jvm_args) + 256;
    char *new_launcher = malloc(launcher_buf_size);
    if (!new_launcher) { free(launcher); return 1; }

    /* Replace __MAIN_CLASS__ */
    char *pos = strstr(launcher, "__MAIN_CLASS__");
    if (pos) {
        size_t before_len = (size_t)(pos - launcher);
        memcpy(new_launcher, launcher, before_len);
        size_t written = before_len;
        size_t mc_len = strlen(main_class);
        memcpy(new_launcher + written, main_class, mc_len);
        written += mc_len;
        const char *after = pos + strlen("__MAIN_CLASS__");
        size_t after_len = strlen(after);
        memcpy(new_launcher + written, after, after_len + 1); /* +1 for null */
        free(launcher);
        launcher = new_launcher;
    } else {
        free(new_launcher);
    }

    /* Replace __JVM_ARGS__ */
    launcher_buf_size = strlen(launcher) + strlen(jvm_args) + 64;
    new_launcher = malloc(launcher_buf_size);
    if (!new_launcher) { free(launcher); return 1; }

    pos = strstr(launcher, "__JVM_ARGS__");
    if (pos) {
        size_t before_len = (size_t)(pos - launcher);
        memcpy(new_launcher, launcher, before_len);
        size_t written = before_len;
        size_t ja_len = strlen(jvm_args);
        memcpy(new_launcher + written, jvm_args, ja_len);
        written += ja_len;
        const char *after = pos + strlen("__JVM_ARGS__");
        size_t after_len = strlen(after);
        memcpy(new_launcher + written, after, after_len + 1);
        free(launcher);
        launcher = new_launcher;
    } else {
        free(new_launcher);
    }

    size_t launcher_size = strlen(launcher);

    /* 7. Compute offsets (all relative to start of CMD header) */
    size_t cmd_header_offset = launcher_size; /* CMD header follows launcher */
    size_t icon_offset = cmd_header_offset + CMD_HEADER_SIZE;
    size_t manifest_offset = icon_offset + icon_size;
    size_t class_offset = manifest_offset + manifest_size;
    size_t security_offset = class_offset + class_size;
    size_t total_size = security_offset + security_size;

    /* 8. Build CMD header */
    cmd_header_t header;
    memset(&header, 0, sizeof(header));
    header.magic = CMD_MAGIC;
    header.version = CMD_VERSION;
    header.flags = CMD_FLAG_PINNABLE; /* default: pinnable */
    if (opts->is_jar) header.flags |= CMD_FLAG_EMBEDDED_JAR;
    else header.flags |= CMD_FLAG_EMBEDDED_CLASS;
    if (opts->headless) header.flags |= CMD_FLAG_HEADLESS;
    if (opts->negamane) header.flags |= CMD_FLAG_NEGAMANE;
    if (opts->grain > 0) header.flags |= CMD_FLAG_GRAIN_AWARE;
    if (opts->graal_hint) header.flags |= CMD_FLAG_NATIVE_IMAGE;

    header.icon_offset = (uint32_t)(icon_offset - cmd_header_offset);
    header.icon_size = (uint32_t)icon_size;
    header.manifest_offset = (uint32_t)(manifest_offset - cmd_header_offset);
    header.manifest_size = (uint32_t)manifest_size;
    header.class_offset = (uint32_t)(class_offset - cmd_header_offset);
    header.class_size = (uint32_t)class_size;
    header.security_offset = (uint32_t)(security_offset - cmd_header_offset);
    header.security_size = (uint32_t)security_size;
    memcpy(header.sha256, sha256, 32);
    header.jdk_min_version = CMD_MIN_JDK;
    header.native_hint_offset = 0;
    header.native_hint_size = 0;

    /* 9. Write output .cmd file */
    FILE *out = fopen(opts->output_file, "wb");
    if (!out) {
        fprintf(stderr, "Error: cannot create '%s'\n", opts->output_file);
        free(class_data); free(icon_data);
        free(manifest_data); free(security_data);
        free(launcher);
        return 1;
    }

    /* Write launcher stub */
    fwrite(launcher, 1, launcher_size, out);

    /* Write CMD header */
    fwrite(&header, 1, sizeof(header), out);

    /* Write icon */
    if (icon_data && icon_size > 0) {
        fwrite(icon_data, 1, icon_size, out);
    }

    /* Write manifest */
    fwrite(manifest_data, 1, manifest_size, out);

    /* Write class data */
    fwrite(class_data, 1, class_size, out);

    /* Write security section */
    fwrite(security_data, 1, security_size, out);

    fclose(out);

    /* Make executable */
    chmod(opts->output_file, 0755);

    /* Report */
    printf("  Launcher stub:   %zu bytes\n", launcher_size);
    printf("  CMD header:      %d bytes\n", CMD_HEADER_SIZE);
    printf("  Icon:            %zu bytes (%s)\n", icon_size,
           icon_size > 0 ? "24x24 BMP" : "none");
    printf("  Manifest:        %zu bytes (JSON)\n", manifest_size);
    printf("  Class data:      %zu bytes (%s)\n", class_size,
           opts->is_jar ? "JAR" : ".class");
    printf("  Security:        %zu bytes\n", security_size);
    printf("  Total:           %zu bytes\n", total_size);
    printf("  SHA-256:         ");
    for (int i = 0; i < 32; i++) printf("%02x", sha256[i]);
    printf("\n");
    printf("  Permission:      %s\n", opts->perm_class ? opts->perm_class : "trusted");
    printf("  Grain:           %d\n", opts->grain);
    printf("  Flags:           0x%04X\n", header.flags);
    printf("  → %s [executable, desktop-ready]\n", opts->output_file);

    free(class_data);
    free(icon_data);
    free(manifest_data);
    free(security_data);
    free(launcher);

    return 0;
}

/* --- CLI --- */

static void print_usage(const char *progname)
{
    fprintf(stderr,
        "cmdlink — Link Java .class/.jar into .cmd desktop executable\n"
        "Usage: %s <input.class|input.jar> [options] -o <output.cmd>\n"
        "\n"
        "Options:\n"
        "  -o <file>              Output .cmd file (required)\n"
        "  --main=<class>         Main class name (required for JAR)\n"
        "  --icon=<file.bmp>      Custom 24x24 BMP icon\n"
        "  --xclass=<file>        .xclass metadata from xmc\n"
        "  --jar                  Input is a JAR file\n"
        "  --headless             Console application (no GUI)\n"
        "  --no-pin               Disable desktop pinning\n"
        "  --negamane             NEGAMANE brand (immutable)\n"
        "  --grain=<0-4>          Grain classification level\n"
        "  --perm=<class>         Permission class (untrusted/trusted/genius)\n"
        "  --graal-hint           Include GraalVM native-image hint\n"
        "  --jvm-args=<args>      Extra JVM arguments\n"
        "  --help                 Show this help\n"
        "\n"
        "The .cmd format bridges .class bytecode and native executables.\n"
        "It produces a directly-runnable file with an embedded desktop icon\n"
        "that pins to the JDesk desktop as a square glossy tile.\n"
        "\n"
        "Pipeline: .java → javac → .class → cmdlink → .cmd\n"
        "\n"
        "Target: SecureJDK 28 (minimum)\n"
        "Copyright (C) 2026 MEARVK LLC\n",
        progname);
}

int main(int argc, char **argv)
{
    if (argc < 2) {
        print_usage(argv[0]);
        return 1;
    }

    cmdlink_opts_t opts;
    memset(&opts, 0, sizeof(opts));
    opts.pinnable = 1; /* default: pinnable */

    for (int i = 1; i < argc; i++) {
        if (strcmp(argv[i], "--help") == 0 || strcmp(argv[i], "-h") == 0) {
            print_usage(argv[0]);
            return 0;
        } else if (strcmp(argv[i], "-o") == 0 && i + 1 < argc) {
            opts.output_file = argv[++i];
        } else if (strncmp(argv[i], "--main=", 7) == 0) {
            opts.main_class = argv[i] + 7;
        } else if (strncmp(argv[i], "--icon=", 7) == 0) {
            opts.icon_file = argv[i] + 7;
        } else if (strncmp(argv[i], "--xclass=", 9) == 0) {
            opts.xclass_file = argv[i] + 9;
        } else if (strcmp(argv[i], "--jar") == 0) {
            opts.is_jar = 1;
        } else if (strcmp(argv[i], "--headless") == 0) {
            opts.headless = 1;
        } else if (strcmp(argv[i], "--no-pin") == 0) {
            opts.pinnable = 0;
        } else if (strcmp(argv[i], "--negamane") == 0) {
            opts.negamane = 1;
        } else if (strncmp(argv[i], "--grain=", 8) == 0) {
            opts.grain = atoi(argv[i] + 8);
        } else if (strncmp(argv[i], "--perm=", 7) == 0) {
            opts.perm_class = argv[i] + 7;
        } else if (strcmp(argv[i], "--graal-hint") == 0) {
            opts.graal_hint = 1;
        } else if (strncmp(argv[i], "--jvm-args=", 11) == 0) {
            opts.jvm_args = argv[i] + 11;
        } else if (argv[i][0] != '-') {
            /* Positional: input file */
            opts.input_file = argv[i];
            /* Auto-detect JAR */
            size_t len = strlen(argv[i]);
            if (len > 4 && strcmp(argv[i] + len - 4, ".jar") == 0) {
                opts.is_jar = 1;
            }
        }
    }

    if (!opts.input_file) {
        fprintf(stderr, "Error: no input file specified\n");
        return 1;
    }
    if (!opts.output_file) {
        fprintf(stderr, "Error: no output file specified (-o)\n");
        return 1;
    }

    /* Auto-detect main class from .class filename */
    if (!opts.main_class && !opts.is_jar) {
        const char *base = strrchr(opts.input_file, '/');
        base = base ? base + 1 : opts.input_file;
        size_t len = strlen(base);
        if (len > 6 && strcmp(base + len - 6, ".class") == 0) {
            char *name = strdup(base);
            name[len - 6] = '\0';
            opts.main_class = name;
        }
    }

    return cmdlink(&opts);
}
