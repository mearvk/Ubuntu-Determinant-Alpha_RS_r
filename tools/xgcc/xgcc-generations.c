/*
 * XGCC generation front-end.
 *
 * Provides the approved future-generation compile-roll functionality:
 *   xgcc-1: preflight / syntax-oriented source inspection
 *   xgcc-2: XGCC .xobj packaging
 *   xgcc-3: deterministic build manifest generation
 *
 * Author: Max Rupplin - MEARVK LLC 2026
 * Copyright (C) 2026 MEARVK LLC
 * License: GPL-2.0
 */
#define _POSIX_C_SOURCE 200809L
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>

#define MAX_SOURCE (16U * 1024U * 1024U)

static void usage(const char *name)
{
    printf("%s <source> [output]\n", name);
    printf("  Preflight, package, or manifest generation is selected by binary name.\n");
}

static int read_source(const char *path, char **data, size_t *len)
{
    struct stat st;
    FILE *f;
    size_t got;

    if (stat(path, &st) != 0) {
        fprintf(stderr, "xgcc: cannot stat '%s': %s\n", path, strerror(errno));
        return 1;
    }
    if (st.st_size < 0 || (unsigned long long)st.st_size > MAX_SOURCE) {
        fprintf(stderr, "xgcc: source exceeds %u-byte limit\n", MAX_SOURCE);
        return 1;
    }
    f = fopen(path, "rb");
    if (!f) {
        fprintf(stderr, "xgcc: cannot open '%s': %s\n", path, strerror(errno));
        return 1;
    }
    *len = (size_t)st.st_size;
    *data = malloc(*len + 1);
    if (!*data) {
        fclose(f);
        fputs("xgcc: out of memory\n", stderr);
        return 1;
    }
    got = fread(*data, 1, *len, f);
    fclose(f);
    if (got != *len) {
        fprintf(stderr, "xgcc: short read on '%s'\n", path);
        free(*data);
        *data = NULL;
        return 1;
    }
    (*data)[*len] = '\0';
    return 0;
}

static int balanced(const char *s)
{
    int paren = 0, brace = 0, bracket = 0;
    int in_string = 0, in_char = 0, escape = 0;
    const char *p;

    for (p = s; *p; ++p) {
        if (escape) { escape = 0; continue; }
        if (*p == '\\' && (in_string || in_char)) { escape = 1; continue; }
        if (*p == '"' && !in_char) { in_string = !in_string; continue; }
        if (*p == '\'' && !in_string) { in_char = !in_char; continue; }
        if (in_string || in_char) continue;
        if (*p == '(') ++paren;
        else if (*p == ')' && --paren < 0) return 0;
        else if (*p == '{') ++brace;
        else if (*p == '}' && --brace < 0) return 0;
        else if (*p == '[') ++bracket;
        else if (*p == ']' && --bracket < 0) return 0;
    }
    return !in_string && !in_char && paren == 0 && brace == 0 && bracket == 0;
}

static void report_extension(const char *path)
{
    const char *dot = strrchr(path, '.');
    if (!dot) puts("language: unknown");
    else if (!strcmp(dot, ".c") || !strcmp(dot, ".h")) puts("language: C");
    else if (!strcmp(dot, ".cpp") || !strcmp(dot, ".cc") || !strcmp(dot, ".cxx") || !strcmp(dot, ".hpp")) puts("language: C++");
    else printf("language: unclassified (%s)\n", dot);
}

static int preflight(const char *path, const char *src, size_t len)
{
    printf("XGCC-1 PREFLIGHT\nsource: %s\nbytes: %zu\n", path, len);
    report_extension(path);
    printf("delimiter-balance: %s\n", balanced(src) ? "pass" : "fail");
    puts("execution: not performed");
    return balanced(src) ? 0 : 2;
}

static int write_xobj(const char *source_path, const char *src, size_t len, const char *out)
{
    FILE *f = fopen(out, "wb");
    if (!f) {
        fprintf(stderr, "xgcc-2: cannot create '%s': %s\n", out, strerror(errno));
        return 1;
    }
    fprintf(f, "XGCC-XOBJ\nversion=2\nauthor=Max Rupplin - MEARVK LLC 2026\nsource=%s\nsize=%zu\nmode=source-package\n---\n", source_path, len);
    if (len && fwrite(src, 1, len, f) != len) {
        fclose(f);
        fprintf(stderr, "xgcc-2: write failed: %s\n", strerror(errno));
        return 1;
    }
    if (fclose(f) != 0) {
        fprintf(stderr, "xgcc-2: close failed: %s\n", strerror(errno));
        return 1;
    }
    printf("XGCC-2 XOBJ\ncreated: %s\nbytes: %zu\n", out, len);
    return 0;
}

static int manifest(const char *source_path, size_t len, const char *out)
{
    FILE *f = fopen(out, "w");
    if (!f) {
        fprintf(stderr, "xgcc-3: cannot create '%s': %s\n", out, strerror(errno));
        return 1;
    }
    fprintf(f, "{\n  \"format\": \"xgcc-manifest-3\",\n  \"author\": \"Max Rupplin - MEARVK LLC 2026\",\n  \"source\": \"%s\",\n  \"source_bytes\": %zu,\n  \"execution\": \"not performed\"\n}\n", source_path, len);
    if (fclose(f) != 0) return 1;
    printf("XGCC-3 MANIFEST\ncreated: %s\n", out);
    return 0;
}

int main(int argc, char **argv)
{
    const char *source, *out = NULL;
    char *data = NULL;
    size_t len = 0;
    const char *name = strrchr(argv[0], '/');
    name = name ? name + 1 : argv[0];

    if (argc < 2 || argc > 3) { usage(name); return 1; }
    source = argv[1];
    if (argc == 3) out = argv[2];
    if (read_source(source, &data, &len)) return 1;

    if (!strcmp(name, "xgcc-1")) {
        int rc = preflight(source, data, len);
        free(data);
        return rc;
    }
    if (!strcmp(name, "xgcc-2")) {
        char generated[4096];
        if (!out) {
            snprintf(generated, sizeof generated, "%s.xobj", source);
            out = generated;
        }
        int rc = write_xobj(source, data, len, out);
        free(data);
        return rc;
    }
    if (!strcmp(name, "xgcc-3")) {
        char generated[4096];
        if (!out) {
            snprintf(generated, sizeof generated, "%s.xgcc.json", source);
            out = generated;
        }
        int rc = manifest(source, len, out);
        free(data);
        return rc;
    }

    fprintf(stderr, "xgcc: unsupported generation binary '%s'\n", name);
    free(data);
    return 1;
}
