/*
 * cmd-inspect.c — Inspect and verify .cmd executable files
 *
 * Reads the CMD header and displays all sections:
 *   - Header fields and flags
 *   - Icon metadata
 *   - Manifest (JSON)
 *   - Class data info
 *   - Security section
 *   - SHA-256 verification
 *
 * Copyright (C) 2026 MEARVK LLC
 * Author: Maximilian Eric Alexander Rupplin von Keffikon
 * License: GPL-2.0 WITH Classpath-exception-2.0
 * Edition: Galactic Cherry Marvell 98
 * Target: SecureJDK 28
 */

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>

#define CMD_MAGIC       0x434D4428
#define CMD_HEADER_SIZE 96

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

/* Flag names */
static const char *flag_names[] = {
    "EMBEDDED_JAR",
    "EMBEDDED_CLASS",
    "EXTERNAL_REF",
    "NATIVE_IMAGE",
    "PINNABLE",
    "HEADLESS",
    "NEGAMANE",
    "GRAIN_AWARE",
};

static void print_flags(uint16_t flags)
{
    printf("  Flags:           0x%04X (", flags);
    int first = 1;
    for (int i = 0; i < 8; i++) {
        if (flags & (1 << i)) {
            if (!first) printf(" | ");
            printf("%s", flag_names[i]);
            first = 0;
        }
    }
    if (first) printf("none");
    printf(")\n");
}

static long find_cmd_header(FILE *f)
{
    /* Scan file for CMD magic bytes */
    uint8_t buf[4096];
    long offset = 0;
    size_t nread;

    fseek(f, 0, SEEK_SET);
    while ((nread = fread(buf, 1, sizeof(buf), f)) >= 4) {
        for (size_t i = 0; i <= nread - 4; i++) {
            uint32_t val = *(uint32_t *)(buf + i);
            if (val == CMD_MAGIC) {
                return offset + (long)i;
            }
        }
        offset += (long)nread - 3; /* overlap to catch split magic */
        fseek(f, offset, SEEK_SET);
    }
    return -1;
}

static int inspect(const char *filename, int show_manifest, int show_security,
                   int extract_icon, int verify)
{
    FILE *f = fopen(filename, "rb");
    if (!f) {
        fprintf(stderr, "Error: cannot open '%s'\n", filename);
        return 1;
    }

    /* Find CMD header */
    long header_offset = find_cmd_header(f);
    if (header_offset < 0) {
        fprintf(stderr, "Error: '%s' does not contain a valid CMD header\n", filename);
        fclose(f);
        return 1;
    }

    /* Read header */
    cmd_header_t header;
    fseek(f, header_offset, SEEK_SET);
    if (fread(&header, 1, sizeof(header), f) != sizeof(header)) {
        fprintf(stderr, "Error: truncated CMD header\n");
        fclose(f);
        return 1;
    }

    /* Get file size */
    fseek(f, 0, SEEK_END);
    long file_size = ftell(f);

    printf("=== CMD Executable: %s ===\n\n", filename);
    printf("  File size:       %ld bytes\n", file_size);
    printf("  Header offset:   0x%lX (%ld)\n", header_offset, header_offset);
    printf("  Launcher stub:   %ld bytes\n", header_offset);
    printf("\n");

    printf("--- CMD Header ---\n");
    printf("  Magic:           0x%08X (\"CMD(\")\n", header.magic);
    printf("  Version:         %d.%d\n", header.version >> 8, header.version & 0xFF);
    print_flags(header.flags);
    printf("  JDK minimum:     %d\n", header.jdk_min_version);
    printf("\n");

    printf("--- Sections ---\n");
    printf("  Icon:            offset=0x%X, size=%u bytes", header.icon_offset, header.icon_size);
    if (header.icon_size > 0) printf(" (24x24 BMP)");
    printf("\n");
    printf("  Manifest:        offset=0x%X, size=%u bytes\n", header.manifest_offset, header.manifest_size);
    printf("  Class data:      offset=0x%X, size=%u bytes", header.class_offset, header.class_size);
    if (header.flags & 0x01) printf(" (JAR)");
    else if (header.flags & 0x02) printf(" (.class)");
    printf("\n");
    printf("  Security:        offset=0x%X, size=%u bytes\n", header.security_offset, header.security_size);
    if (header.native_hint_size > 0) {
        printf("  Native hint:     offset=0x%X, size=%u bytes\n",
               header.native_hint_offset, header.native_hint_size);
    }
    printf("\n");

    printf("--- Integrity ---\n");
    printf("  SHA-256:         ");
    for (int i = 0; i < 32; i++) printf("%02x", header.sha256[i]);
    printf("\n");

    /* Show manifest if requested */
    if (show_manifest && header.manifest_size > 0) {
        printf("\n--- Manifest (JSON) ---\n");
        long abs_offset = header_offset + CMD_HEADER_SIZE + header.manifest_offset - CMD_HEADER_SIZE;
        /* Manifest offset is relative to start of CMD header */
        fseek(f, header_offset + header.manifest_offset, SEEK_SET);
        char *buf = malloc(header.manifest_size + 1);
        if (buf) {
            fread(buf, 1, header.manifest_size, f);
            buf[header.manifest_size] = '\0';
            printf("%s", buf);
            free(buf);
        }
    }

    /* Show security section if requested */
    if (show_security && header.security_size > 0) {
        printf("\n--- Security Section ---\n");
        fseek(f, header_offset + header.security_offset, SEEK_SET);
        char *buf = malloc(header.security_size + 1);
        if (buf) {
            fread(buf, 1, header.security_size, f);
            buf[header.security_size] = '\0';
            printf("%s", buf);
            free(buf);
        }
    }

    /* Extract icon if requested */
    if (extract_icon && header.icon_size > 0) {
        fseek(f, header_offset + header.icon_offset, SEEK_SET);
        uint8_t *icon = malloc(header.icon_size);
        if (icon) {
            fread(icon, 1, header.icon_size, f);
            /* Write to stdout or file */
            char icon_out[256];
            snprintf(icon_out, sizeof(icon_out), "%s.icon.bmp", filename);
            FILE *ficon = fopen(icon_out, "wb");
            if (ficon) {
                fwrite(icon, 1, header.icon_size, ficon);
                fclose(ficon);
                printf("\n  Icon extracted: %s (%u bytes)\n", icon_out, header.icon_size);
            }
            free(icon);
        }
    }

    /* Verification placeholder */
    if (verify) {
        printf("\n--- Verification ---\n");
        printf("  SHA-256 check:   [requires re-hash of class data — TODO]\n");
        printf("  ELF integrity:   [requires system ELF Integrity Guardian]\n");
        printf("  NEGAMANE brand:  %s\n", (header.flags & 0x40) ? "YES (immutable)" : "no");
    }

    printf("\n");
    fclose(f);
    return 0;
}

static void print_usage(const char *progname)
{
    fprintf(stderr,
        "cmd-inspect — Inspect .cmd executable files\n"
        "Usage: %s [options] <file.cmd>\n"
        "\n"
        "Options:\n"
        "  --manifest       Show manifest JSON\n"
        "  --security       Show security section\n"
        "  --icon           Extract embedded icon to <file>.icon.bmp\n"
        "  --verify         Verify integrity (SHA-256, NEGAMANE)\n"
        "  --all            Show everything\n"
        "  --help           Show this help\n"
        "\n"
        "Copyright (C) 2026 MEARVK LLC\n",
        progname);
}

int main(int argc, char **argv)
{
    if (argc < 2) {
        print_usage(argv[0]);
        return 1;
    }

    const char *filename = NULL;
    int show_manifest = 0;
    int show_security = 0;
    int extract_icon = 0;
    int verify = 0;

    for (int i = 1; i < argc; i++) {
        if (strcmp(argv[i], "--manifest") == 0) show_manifest = 1;
        else if (strcmp(argv[i], "--security") == 0) show_security = 1;
        else if (strcmp(argv[i], "--icon") == 0) extract_icon = 1;
        else if (strcmp(argv[i], "--verify") == 0) verify = 1;
        else if (strcmp(argv[i], "--all") == 0) {
            show_manifest = show_security = extract_icon = verify = 1;
        }
        else if (strcmp(argv[i], "--help") == 0 || strcmp(argv[i], "-h") == 0) {
            print_usage(argv[0]);
            return 0;
        }
        else if (argv[i][0] != '-') filename = argv[i];
    }

    if (!filename) {
        fprintf(stderr, "Error: no input file specified\n");
        return 1;
    }

    return inspect(filename, show_manifest, show_security, extract_icon, verify);
}
