/*
 * muntutils_fs.c - C11 filesystem walk, size measurement, and artifact
 * classification core for the muntutils tool.
 *
 * Mirrors the portable engineering pattern of tools/size/size.c: POSIX
 * lstat/opendir/readdir traversal that does not follow symbolic links, a
 * _WIN32 branch using native Unicode enumeration APIs that does not follow
 * reparse points, saturating uint64 summation, and an IEC human-readable
 * size formatter. The C++ engine calls into this core through the extern "C"
 * API declared in muntutils_fs.h.
 *
 * Provenance: part of the MEARVK Ubuntu.Determinant.Beta.Restricted tool set.
 * The provenance framing identifies build origin only. It is not a legal
 * ownership, fiduciary, or execution authorization claim.
 *
 * Program based on Science at NCSU - Max Rupplin - MEARVK LLC 2026.
 */
#ifndef _WIN32
#ifndef _DEFAULT_SOURCE
#define _DEFAULT_SOURCE
#endif
#endif

#include "muntutils_fs.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <inttypes.h>

#ifdef _WIN32
#include <windows.h>
#include <wchar.h>
#else
#include <dirent.h>
#include <sys/stat.h>
#include <unistd.h>
#endif

uint64_t mu_add_u64(uint64_t a, uint64_t b) {
    if (UINT64_MAX - a < b) return UINT64_MAX;
    return a + b;
}

char *mu_human(uint64_t bytes, char *buf, size_t buflen) {
    static const char *units[] = {"B", "KiB", "MiB", "GiB", "TiB", "PiB"};
    double value = (double)bytes;
    size_t unit = 0;
    while (value >= 1024.0 && unit < 5) {
        value /= 1024.0;
        ++unit;
    }
    if (unit == 0) snprintf(buf, buflen, "%" PRIu64 " B", bytes);
    else snprintf(buf, buflen, "%.2f %s", value, units[unit]);
    return buf;
}

/* Return the lower-cased extension (including the dot) or NULL. */
static const char *find_ext(const char *path) {
    const char *dot = NULL;
    const char *p;
    for (p = path; *p; ++p) {
        if (*p == '/' || *p == '\\') dot = NULL;
        else if (*p == '.') dot = p;
    }
    return dot;
}

static int ext_is(const char *ext, const char *want) {
    size_t i;
    if (!ext) return 0;
    for (i = 0; ext[i] && want[i]; ++i) {
        char c = ext[i];
        if (c >= 'A' && c <= 'Z') c = (char)(c - 'A' + 'a');
        if (c != want[i]) return 0;
    }
    return ext[i] == '\0' && want[i] == '\0';
}

/* Best-effort executable magic sniff (ELF, PE, Mach-O). */
static int has_binary_magic(const char *path) {
    FILE *f = fopen(path, "rb");
    unsigned char b[4] = {0};
    size_t n;
    if (!f) return 0;
    n = fread(b, 1, sizeof b, f);
    fclose(f);
    if (n >= 2 && b[0] == 'M' && b[1] == 'Z') return 1; /* PE */
    if (n >= 4 && b[0] == 0x7f && b[1] == 'E' && b[2] == 'L' && b[3] == 'F') return 1; /* ELF */
    if (n >= 4 && ((b[0] == 0xcf && b[1] == 0xfa && b[2] == 0xed && b[3] == 0xfe) ||
                   (b[0] == 0xfe && b[1] == 0xed && b[2] == 0xfa && b[3] == 0xcf) ||
                   (b[0] == 0xca && b[1] == 0xfe && b[2] == 0xba && b[3] == 0xbe))) return 1; /* Mach-O */
    return 0;
}

mu_category mu_classify(const char *path) {
    const char *ext = find_ext(path);
    if (ext_is(ext, ".c") || ext_is(ext, ".cc") || ext_is(ext, ".cpp") ||
        ext_is(ext, ".cxx") || ext_is(ext, ".c++") ||
        ext_is(ext, ".h") || ext_is(ext, ".hpp") || ext_is(ext, ".hxx") ||
        ext_is(ext, ".hh") || ext_is(ext, ".ipp") || ext_is(ext, ".inl")) {
        return MU_CAT_SOURCE;
    }
    if (ext_is(ext, ".so") || ext_is(ext, ".dll") || ext_is(ext, ".a") ||
        ext_is(ext, ".o") || ext_is(ext, ".obj") || ext_is(ext, ".dylib") ||
        ext_is(ext, ".lib") || ext_is(ext, ".exe")) {
        return MU_CAT_ARTIFACT;
    }
    /* Extensionless or unknown files: treat as an artifact if they carry an
     * executable magic number. Otherwise leave them uncategorized. */
    if (has_binary_magic(path)) return MU_CAT_ARTIFACT;
    return MU_CAT_OTHER;
}

/* Join dir + name into a freshly allocated path using sep. Returns NULL on
 * allocation failure. */
static char *join_path(const char *dir, const char *name, char sep) {
    size_t dlen = strlen(dir), nlen = strlen(name);
    int need_sep = dlen > 0 && dir[dlen - 1] != sep;
    char *out = malloc(dlen + (size_t)need_sep + nlen + 1);
    size_t p;
    if (!out) return NULL;
    memcpy(out, dir, dlen);
    p = dlen;
    if (need_sep) out[p++] = sep;
    memcpy(out + p, name, nlen + 1);
    return out;
}

static void account(mu_stats *stats, mu_category cat, uint64_t bytes) {
    switch (cat) {
    case MU_CAT_SOURCE:
        stats->source.files = mu_add_u64(stats->source.files, 1);
        stats->source.bytes = mu_add_u64(stats->source.bytes, bytes);
        break;
    case MU_CAT_ARTIFACT:
        stats->artifact.files = mu_add_u64(stats->artifact.files, 1);
        stats->artifact.bytes = mu_add_u64(stats->artifact.bytes, bytes);
        break;
    default:
        stats->other.files = mu_add_u64(stats->other.files, 1);
        stats->other.bytes = mu_add_u64(stats->other.bytes, bytes);
        break;
    }
}

#ifdef _WIN32

static wchar_t *widen(const char *utf8) {
    int needed = MultiByteToWideChar(CP_UTF8, 0, utf8, -1, NULL, 0);
    wchar_t *wide;
    if (needed <= 0) return NULL;
    wide = malloc((size_t)needed * sizeof(wchar_t));
    if (!wide) return NULL;
    MultiByteToWideChar(CP_UTF8, 0, utf8, -1, wide, needed);
    return wide;
}

static void measure_dir_w(const wchar_t *dir, const char *utf8_dir, mu_stats *stats) {
    size_t len = wcslen(dir);
    wchar_t *pattern = malloc((len + 3) * sizeof(wchar_t));
    WIN32_FIND_DATAW fd;
    HANDLE h;
    if (!pattern) { stats->ok = 0; return; }
    wcscpy(pattern, dir);
    if (len && dir[len - 1] != L'\\' && dir[len - 1] != L'/') wcscat(pattern, L"\\");
    wcscat(pattern, L"*");
    h = FindFirstFileW(pattern, &fd);
    free(pattern);
    if (h == INVALID_HANDLE_VALUE) { stats->ok = 0; return; }
    do {
        char child_utf8[4096];
        int mb;
        if (wcscmp(fd.cFileName, L".") == 0 || wcscmp(fd.cFileName, L"..") == 0) continue;
        mb = WideCharToMultiByte(CP_UTF8, 0, fd.cFileName, -1, NULL, 0, NULL, NULL);
        if (mb <= 0) { stats->ok = 0; continue; }
        {
            char *name_utf8 = malloc((size_t)mb);
            char *cpath;
            if (!name_utf8) { stats->ok = 0; continue; }
            WideCharToMultiByte(CP_UTF8, 0, fd.cFileName, -1, name_utf8, mb, NULL, NULL);
            cpath = join_path(utf8_dir, name_utf8, '\\');
            free(name_utf8);
            if (!cpath) { stats->ok = 0; continue; }
            (void)child_utf8;
            if (fd.dwFileAttributes & FILE_ATTRIBUTE_REPARSE_POINT) {
                free(cpath);
                continue; /* do not follow reparse points */
            }
            if (fd.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY) {
                wchar_t *wchild = widen(cpath);
                if (wchild) { measure_dir_w(wchild, cpath, stats); free(wchild); }
                else stats->ok = 0;
            } else {
                ULARGE_INTEGER n;
                n.HighPart = fd.nFileSizeHigh;
                n.LowPart = fd.nFileSizeLow;
                account(stats, mu_classify(cpath), (uint64_t)n.QuadPart);
            }
            free(cpath);
        }
    } while (FindNextFileW(h, &fd));
    FindClose(h);
}

int mu_measure_tree(const char *path, mu_stats *stats) {
    wchar_t *wide;
    WIN32_FILE_ATTRIBUTE_DATA attr;
    memset(stats, 0, sizeof *stats);
    stats->ok = 1;
    wide = widen(path);
    if (!wide) { stats->ok = 0; return 1; }
    if (!GetFileAttributesExW(wide, GetFileExInfoStandard, &attr)) {
        free(wide);
        stats->ok = 0;
        return 1;
    }
    if (attr.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY) {
        measure_dir_w(wide, path, stats);
    } else {
        ULARGE_INTEGER n;
        n.HighPart = attr.nFileSizeHigh;
        n.LowPart = attr.nFileSizeLow;
        account(stats, mu_classify(path), (uint64_t)n.QuadPart);
    }
    free(wide);
    return stats->ok ? 0 : 1;
}

/* Enumerate source files, tracking the relative path from the walk root. */
static int enum_dir_w(const wchar_t *dir, const char *utf8_dir, const char *rel,
                      mu_source_cb cb, void *user, int *stop) {
    size_t len = wcslen(dir);
    wchar_t *pattern = malloc((len + 3) * sizeof(wchar_t));
    WIN32_FIND_DATAW fd;
    HANDLE h;
    int rc = 0;
    if (!pattern) return 1;
    wcscpy(pattern, dir);
    if (len && dir[len - 1] != L'\\' && dir[len - 1] != L'/') wcscat(pattern, L"\\");
    wcscat(pattern, L"*");
    h = FindFirstFileW(pattern, &fd);
    free(pattern);
    if (h == INVALID_HANDLE_VALUE) return 1;
    do {
        int mb;
        if (*stop) break;
        if (wcscmp(fd.cFileName, L".") == 0 || wcscmp(fd.cFileName, L"..") == 0) continue;
        if (fd.dwFileAttributes & FILE_ATTRIBUTE_REPARSE_POINT) continue;
        mb = WideCharToMultiByte(CP_UTF8, 0, fd.cFileName, -1, NULL, 0, NULL, NULL);
        if (mb <= 0) { rc = 1; continue; }
        {
            char *name_utf8 = malloc((size_t)mb);
            char *cpath, *crel;
            if (!name_utf8) { rc = 1; continue; }
            WideCharToMultiByte(CP_UTF8, 0, fd.cFileName, -1, name_utf8, mb, NULL, NULL);
            cpath = join_path(utf8_dir, name_utf8, '\\');
            crel = (rel && rel[0]) ? join_path(rel, name_utf8, '/') : join_path("", name_utf8, '/');
            free(name_utf8);
            if (!cpath || !crel) { free(cpath); free(crel); rc = 1; continue; }
            if (fd.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY) {
                wchar_t *wchild = widen(cpath);
                if (wchild) { if (enum_dir_w(wchild, cpath, crel, cb, user, stop)) rc = 1; free(wchild); }
                else rc = 1;
            } else if (mu_classify(cpath) == MU_CAT_SOURCE) {
                const char *r = crel;
                if (r[0] == '/') ++r;
                if (cb(cpath, r, user) != 0) *stop = 1;
            }
            free(cpath);
            free(crel);
        }
    } while (FindNextFileW(h, &fd));
    FindClose(h);
    return rc;
}

int mu_enumerate_sources(const char *root, mu_source_cb cb, void *user) {
    wchar_t *wide;
    WIN32_FILE_ATTRIBUTE_DATA attr;
    int stop = 0, rc;
    wide = widen(root);
    if (!wide) return 1;
    if (!GetFileAttributesExW(wide, GetFileExInfoStandard, &attr)) { free(wide); return 1; }
    if (attr.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY) {
        rc = enum_dir_w(wide, root, "", cb, user, &stop);
    } else {
        rc = 0;
        if (mu_classify(root) == MU_CAT_SOURCE) {
            const char *base = strrchr(root, '\\');
            const char *b2 = strrchr(root, '/');
            if (b2 && (!base || b2 > base)) base = b2;
            base = base ? base + 1 : root;
            cb(root, base, user);
        }
    }
    free(wide);
    return rc;
}

#else /* POSIX */

static void measure_dir(const char *path, mu_stats *stats) {
    DIR *dir = opendir(path);
    struct dirent *entry;
    if (!dir) { stats->ok = 0; return; }
    while ((entry = readdir(dir)) != NULL) {
        char *child;
        struct stat st;
        if (strcmp(entry->d_name, ".") == 0 || strcmp(entry->d_name, "..") == 0) continue;
        child = join_path(path, entry->d_name, '/');
        if (!child) { stats->ok = 0; continue; }
        if (lstat(child, &st) != 0) {
            stats->ok = 0;
            free(child);
            continue;
        }
        if (S_ISDIR(st.st_mode)) {
            measure_dir(child, stats);
        } else if (S_ISREG(st.st_mode)) {
            uint64_t bytes = st.st_size > 0 ? (uint64_t)st.st_size : 0;
            account(stats, mu_classify(child), bytes);
        }
        /* Symbolic links and other special files are not followed or counted. */
        free(child);
    }
    closedir(dir);
}

int mu_measure_tree(const char *path, mu_stats *stats) {
    struct stat st;
    memset(stats, 0, sizeof *stats);
    stats->ok = 1;
    if (lstat(path, &st) != 0) { stats->ok = 0; return 1; }
    if (S_ISDIR(st.st_mode)) {
        measure_dir(path, stats);
    } else if (S_ISREG(st.st_mode)) {
        uint64_t bytes = st.st_size > 0 ? (uint64_t)st.st_size : 0;
        account(stats, mu_classify(path), bytes);
    }
    return stats->ok ? 0 : 1;
}

static int enum_dir(const char *path, const char *rel, mu_source_cb cb,
                    void *user, int *stop) {
    DIR *dir = opendir(path);
    struct dirent *entry;
    int rc = 0;
    if (!dir) return 1;
    while ((entry = readdir(dir)) != NULL) {
        char *child, *crel;
        struct stat st;
        if (*stop) break;
        if (strcmp(entry->d_name, ".") == 0 || strcmp(entry->d_name, "..") == 0) continue;
        child = join_path(path, entry->d_name, '/');
        crel = (rel && rel[0]) ? join_path(rel, entry->d_name, '/')
                               : join_path("", entry->d_name, '/');
        if (!child || !crel) { free(child); free(crel); rc = 1; continue; }
        if (lstat(child, &st) != 0) {
            rc = 1;
        } else if (S_ISDIR(st.st_mode)) {
            const char *r = crel;
            if (r[0] == '/') ++r;
            if (enum_dir(child, r, cb, user, stop)) rc = 1;
        } else if (S_ISREG(st.st_mode) && mu_classify(child) == MU_CAT_SOURCE) {
            const char *r = crel;
            if (r[0] == '/') ++r;
            if (cb(child, r, user) != 0) *stop = 1;
        }
        free(child);
        free(crel);
    }
    closedir(dir);
    return rc;
}

int mu_enumerate_sources(const char *root, mu_source_cb cb, void *user) {
    struct stat st;
    int stop = 0;
    if (lstat(root, &st) != 0) return 1;
    if (S_ISDIR(st.st_mode)) {
        return enum_dir(root, "", cb, user, &stop);
    }
    if (S_ISREG(st.st_mode) && mu_classify(root) == MU_CAT_SOURCE) {
        const char *base = strrchr(root, '/');
        base = base ? base + 1 : root;
        cb(root, base, user);
    }
    return 0;
}

#endif
