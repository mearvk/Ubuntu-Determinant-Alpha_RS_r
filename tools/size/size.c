/*
 * size - fast recursive directory size reporter.
 *
 * Reports the logical byte size of every regular file beneath each supplied
 * directory. Directory entries themselves are not counted. Symbolic links
 * are not followed on POSIX systems. Windows reparse points are not followed
 * so junctions do not cause recursive cycles.
 */
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
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

#define SIZE_VERSION "1.00"

static uint64_t add_u64(uint64_t a, uint64_t b) {
    if (UINT64_MAX - a < b) return UINT64_MAX;
    return a + b;
}

static void print_human(uint64_t bytes) {
    static const char *units[] = {"B", "KiB", "MiB", "GiB", "TiB", "PiB"};
    double value = (double)bytes;
    size_t unit = 0;
    while (value >= 1024.0 && unit < 5) {
        value /= 1024.0;
        ++unit;
    }
    if (unit == 0) printf("%" PRIu64 " B", bytes);
    else printf("%.2f %s", value, units[unit]);
}

#ifdef _WIN32

static uint64_t scan_path(const wchar_t *path, int *ok) {
    WIN32_FILE_ATTRIBUTE_DATA attr;
    if (!GetFileAttributesExW(path, GetFileExInfoStandard, &attr)) {
        fwprintf(stderr, L"size: cannot stat '%ls' (error %lu)\n", path, GetLastError());
        *ok = 0;
        return 0;
    }

    if (!(attr.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY)) {
        ULARGE_INTEGER n;
        n.HighPart = attr.nFileSizeHigh;
        n.LowPart = attr.nFileSizeLow;
        return n.QuadPart;
    }

    if (attr.dwFileAttributes & FILE_ATTRIBUTE_REPARSE_POINT) return 0;

    size_t len = wcslen(path);
    wchar_t *pattern = malloc((len + 3) * sizeof(wchar_t));
    if (!pattern) { fwprintf(stderr, L"size: out of memory\n"); *ok = 0; return 0; }
    wcscpy(pattern, path);
    if (len && path[len - 1] != L'\\' && path[len - 1] != L'/') wcscat(pattern, L"\\");
    wcscat(pattern, L"*");

    WIN32_FIND_DATAW fd;
    HANDLE h = FindFirstFileW(pattern, &fd);
    free(pattern);
    if (h == INVALID_HANDLE_VALUE) {
        fwprintf(stderr, L"size: cannot enumerate '%ls' (error %lu)\n", path, GetLastError());
        *ok = 0;
        return 0;
    }

    uint64_t total = 0;
    do {
        if (wcscmp(fd.cFileName, L".") == 0 || wcscmp(fd.cFileName, L"..") == 0) continue;
        size_t plen = wcslen(path), nlen = wcslen(fd.cFileName);
        wchar_t *child = malloc((plen + nlen + 2) * sizeof(wchar_t));
        if (!child) { *ok = 0; break; }
        wcscpy(child, path);
        if (plen && path[plen - 1] != L'\\' && path[plen - 1] != L'/') wcscat(child, L"\\");
        wcscat(child, fd.cFileName);
        total = add_u64(total, scan_path(child, ok));
        free(child);
    } while (FindNextFileW(h, &fd));

    FindClose(h);
    return total;
}

static int run_one(const char *input) {
    int needed = MultiByteToWideChar(CP_UTF8, 0, input, -1, NULL, 0);
    if (needed <= 0) { fprintf(stderr, "size: invalid path: %s\n", input); return 1; }
    wchar_t *wide = malloc((size_t)needed * sizeof(wchar_t));
    if (!wide) { fprintf(stderr, "size: out of memory\n"); return 1; }
    MultiByteToWideChar(CP_UTF8, 0, input, -1, wide, needed);
    int ok = 1;
    uint64_t total = scan_path(wide, &ok);
    printf("%s: %" PRIu64 " bytes (", input, total);
    print_human(total);
    printf(")\n");
    free(wide);
    return ok ? 0 : 1;
}

#else

static uint64_t scan_path(const char *path, int *ok) {
    struct stat st;
    if (lstat(path, &st) != 0) {
        fprintf(stderr, "size: cannot stat '%s': %s\n", path, strerror(errno));
        *ok = 0;
        return 0;
    }
    if (S_ISREG(st.st_mode)) return st.st_size > 0 ? (uint64_t)st.st_size : 0;
    if (!S_ISDIR(st.st_mode)) return 0;

    DIR *dir = opendir(path);
    if (!dir) {
        fprintf(stderr, "size: cannot open '%s': %s\n", path, strerror(errno));
        *ok = 0;
        return 0;
    }

    uint64_t total = 0;
    struct dirent *entry;
    while ((entry = readdir(dir)) != NULL) {
        if (strcmp(entry->d_name, ".") == 0 || strcmp(entry->d_name, "..") == 0) continue;
        size_t plen = strlen(path), nlen = strlen(entry->d_name);
        int separator = plen > 0 && path[plen - 1] != '/';
        char *child = malloc(plen + (size_t)separator + nlen + 1);
        if (!child) {
            fprintf(stderr, "size: out of memory\n");
            *ok = 0;
            break;
        }
        memcpy(child, path, plen);
        size_t p = plen;
        if (separator) child[p++] = '/';
        memcpy(child + p, entry->d_name, nlen + 1);
        total = add_u64(total, scan_path(child, ok));
        free(child);
    }
    closedir(dir);
    return total;
}

static int run_one(const char *path) {
    int ok = 1;
    uint64_t total = scan_path(path, &ok);
    printf("%s: %" PRIu64 " bytes (", path, total);
    print_human(total);
    printf(")\n");
    return ok ? 0 : 1;
}

#endif

int main(int argc, char **argv) {
    if (argc == 2 && (strcmp(argv[1], "--version") == 0 || strcmp(argv[1], "-V") == 0)) {
        printf("size %s\n", SIZE_VERSION);
        return 0;
    }
    if (argc == 2 && (strcmp(argv[1], "--help") == 0 || strcmp(argv[1], "-h") == 0)) {
        printf("usage: size PATH [PATH ...]\n");
        printf("Reports the recursive logical size of regular files beneath each path.\n");
        return 0;
    }
    if (argc < 2) {
        fprintf(stderr, "usage: size PATH [PATH ...]\n");
        return 2;
    }

    int rc = 0;
    for (int i = 1; i < argc; ++i) {
        int one = run_one(argv[i]);
        if (one != 0) rc = one;
    }
    return rc;
}
