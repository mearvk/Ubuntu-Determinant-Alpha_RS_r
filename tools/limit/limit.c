/* limit: read-only cross-platform local binary metadata inventory. */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#ifdef _WIN32
#include <windows.h>
#include <sys/stat.h>
#else
#include <dirent.h>
#include <sys/stat.h>
#include <unistd.h>
#endif

#define LIMIT_VERSION "1.00"
#define PATH_CAP 4096

static const char *base_name(const char *p) {
    const char *a = strrchr(p, '/');
#ifdef _WIN32
    const char *b = strrchr(p, '\\');
    if (b && (!a || b > a)) a = b;
#endif
    return a ? a + 1 : p;
}

static int binary_magic(const char *path) {
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

static void print_time_value(time_t t) {
    char buf[64];
    struct tm tmv;
#ifdef _WIN32
    localtime_s(&tmv, &t);
#else
    localtime_r(&t, &tmv);
#endif
    if (strftime(buf, sizeof buf, "%Y-%m-%d %H:%M:%S %z", &tmv)) printf("%s", buf);
    else printf("unavailable");
}

static void inspect(const char *path) {
    struct stat st;
    if (stat(path, &st) != 0 || !S_ISREG(st.st_mode)) return;
#ifndef _WIN32
    if (!binary_magic(path) && !(st.st_mode & S_IXUSR)) return;
#else
    if (!binary_magic(path)) return;
#endif
    printf("binary=%s\npath=%s\nsize=%lld\n", base_name(path), path, (long long)st.st_size);
    printf("created=unavailable");
#ifndef _WIN32
    printf("; modified=");
    print_time_value(st.st_mtime);
#endif
    printf("\n");
    printf("edition=unavailable\nversion=unavailable\ncompany=unavailable\nfiduciary=unavailable\n");
    printf("metadata_source=portable-filesystem-scan\n---\n");
}

#ifndef _WIN32
static int scan_directory(const char *dir) {
    DIR *d = opendir(dir);
    struct dirent *e;
    char path[PATH_CAP];
    if (!d) { perror(dir); return 1; }
    while ((e = readdir(d)) != NULL) {
        if (!strcmp(e->d_name, ".") || !strcmp(e->d_name, "..")) continue;
        int n = snprintf(path, sizeof path, "%s/%s", dir, e->d_name);
        if (n > 0 && (size_t)n < sizeof path) inspect(path);
    }
    closedir(d);
    return 0;
}
#else
static int scan_directory(const char *dir) {
    char pattern[PATH_CAP];
    WIN32_FIND_DATAA fd;
    HANDLE h;
    snprintf(pattern, sizeof pattern, "%s\\*", dir);
    h = FindFirstFileA(pattern, &fd);
    if (h == INVALID_HANDLE_VALUE) { fprintf(stderr, "cannot scan %s\n", dir); return 1; }
    do {
        char path[PATH_CAP];
        if (!strcmp(fd.cFileName, ".") || !strcmp(fd.cFileName, "..")) continue;
        if (fd.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY) continue;
        snprintf(path, sizeof path, "%s\\%s", dir, fd.cFileName);
        inspect(path);
    } while (FindNextFileA(h, &fd));
    FindClose(h);
    return 0;
}
#endif

int main(int argc, char **argv) {
    const char *dir = ".";
    if (argc > 1 && (!strcmp(argv[1], "--version") || !strcmp(argv[1], "-V"))) {
        printf("limit %s\n", LIMIT_VERSION); return 0;
    }
    if (argc > 1) dir = argv[1];
    if (argc > 2) { fprintf(stderr, "usage: %s [directory]\n", argv[0]); return 2; }
    printf("limit %s\ndirectory=%s\nplatform=%s\n---\n", LIMIT_VERSION, dir,
#ifdef _WIN32
           "Windows"
#elif defined(__APPLE__)
           "macOS"
#else
           "Linux/Unix"
#endif
    );
    return scan_directory(dir);
}
