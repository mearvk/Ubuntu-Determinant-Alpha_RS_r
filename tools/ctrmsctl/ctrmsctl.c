/*
 * ctrmsctl - cautious filesystem observation service.
 *
 * This service indexes filesystem metadata only. It does not read file
 * contents, execute discovered commands, infer an intelligence score, or
 * claim that a filename is trustworthy. Linux systemd integration is the
 * primary service target; the source remains ordinary C.
 */
#define _GNU_SOURCE
#include <dirent.h>
#include <errno.h>
#include <fcntl.h>
#include <inttypes.h>
#include <limits.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/inotify.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>

#ifndef PATH_MAX
#define PATH_MAX 4096
#endif

#define CTRMS_VERSION "1.00"
#define EVENT_BUF_LEN (64 * (sizeof(struct inotify_event) + NAME_MAX + 1))

static const char *root_dir = "/";
static const char *state_dir = "/var/lib/ctrmsctl";
static const char *index_file = "/var/lib/ctrmsctl/index.tsv";
static uint64_t file_count = 0;
static uint64_t directory_count = 0;
static uint64_t total_bytes = 0;

static void usage(const char *p) {
    printf("ctrmsctl %s\n", CTRMS_VERSION);
    printf("usage: %s [--root PATH] [--index PATH] [--state PATH]\n", p);
    printf("       %s find [NAME]\n", p);
    printf("       %s search TEXT\n", p);
    printf("       %s locate PATH\n", p);
    printf("       %s status\n", p);
}

static int is_hidden_or_system_noise(const char *name) {
    return name && (!strcmp(name, ".") || !strcmp(name, ".."));
}

static void scan_tree(const char *path, FILE *out) {
    DIR *d = opendir(path);
    if (!d) return;
    directory_count++;
    struct dirent *ent;
    while ((ent = readdir(d)) != NULL) {
        if (is_hidden_or_system_noise(ent->d_name)) continue;
        char child[PATH_MAX];
        int n = snprintf(child, sizeof(child), "%s/%s", path, ent->d_name);
        if (n < 0 || (size_t)n >= sizeof(child)) continue;
        struct stat st;
        if (lstat(child, &st) != 0) continue;
        if (S_ISDIR(st.st_mode)) {
            scan_tree(child, out);
        } else if (S_ISREG(st.st_mode)) {
            file_count++;
            total_bytes += (uint64_t)st.st_size;
            if (out) fprintf(out, "%s\t%" PRIuMAX "\t%o\t%lld\n", child,
                             (uintmax_t)st.st_size, (unsigned)(st.st_mode & 07777),
                             (long long)st.st_mtime);
        }
    }
    closedir(d);
}

static int write_snapshot(void) {
    if (mkdir(state_dir, 0755) != 0 && errno != EEXIST) return 1;
    FILE *out = fopen(index_file, "w");
    if (!out) return 1;
    file_count = directory_count = total_bytes = 0;
    fprintf(out, "# ctrmsctl %s metadata index; path\\tsize\\tmode\\tmtime\n", CTRMS_VERSION);
    scan_tree(root_dir, out);
    fclose(out);
    printf("files=%" PRIu64 " directories=%" PRIu64 " bytes=%" PRIu64 " index=%s\n",
           file_count, directory_count, total_bytes, index_file);
    return 0;
}

static int query_index(const char *mode, const char *needle) {
    FILE *f = fopen(index_file, "r");
    if (!f) { perror(index_file); return 1; }
    char line[PATH_MAX + 128];
    while (fgets(line, sizeof(line), f)) {
        if (line[0] == '#') continue;
        char *tab = strchr(line, '\t');
        if (tab) *tab = '\0';
        int match = 0;
        if (!strcmp(mode, "find")) {
            const char *base = strrchr(line, '/');
            match = strstr(base ? base + 1 : line, needle) != NULL;
        } else if (!strcmp(mode, "locate")) {
            match = strstr(line, needle) != NULL;
        } else {
            match = strstr(line, needle) != NULL;
        }
        if (match) puts(line);
    }
    fclose(f);
    return 0;
}

static int monitor_events(void) {
    int fd = inotify_init1(IN_NONBLOCK);
    if (fd < 0) { perror("inotify"); return 1; }
    int wd = inotify_add_watch(fd, root_dir,
        IN_CREATE | IN_MOVED_TO | IN_DELETE | IN_MOVED_FROM | IN_CLOSE_WRITE);
    if (wd < 0) { perror("inotify_add_watch"); close(fd); return 1; }
    char buf[EVENT_BUF_LEN];
    printf("ctrmsctl %s monitoring %s (metadata only)\n", CTRMS_VERSION, root_dir);
    for (;;) {
        ssize_t len = read(fd, buf, sizeof(buf));
        if (len < 0) { if (errno == EAGAIN || errno == EINTR) { usleep(250000); continue; } break; }
        for (char *p = buf; p < buf + len;) {
            struct inotify_event *ev = (struct inotify_event *)p;
            const char *kind = (ev->mask & (IN_CREATE | IN_MOVED_TO)) ? "new" :
                               (ev->mask & (IN_DELETE | IN_MOVED_FROM)) ? "removed" : "changed";
            printf("event=%s name=%s\n", kind, ev->len ? ev->name : root_dir);
            p += sizeof(*ev) + ev->len;
        }
    }
    inotify_rm_watch(fd, wd);
    close(fd);
    return 1;
}

int main(int argc, char **argv) {
    for (int i = 1; i < argc; ++i) {
        if (!strcmp(argv[i], "--root") && i + 1 < argc) root_dir = argv[++i];
        else if (!strcmp(argv[i], "--index") && i + 1 < argc) index_file = argv[++i];
        else if (!strcmp(argv[i], "--state") && i + 1 < argc) state_dir = argv[++i];
    }
    if (argc == 1) return write_snapshot();
    if (!strcmp(argv[1], "--version")) { puts("ctrmsctl " CTRMS_VERSION); return 0; }
    if (!strcmp(argv[1], "status")) return write_snapshot();
    if (!strcmp(argv[1], "find") || !strcmp(argv[1], "search") || !strcmp(argv[1], "locate")) {
        if (argc < 3) { usage(argv[0]); return 2; }
        return query_index(argv[1], argv[2]);
    }
    if (!strcmp(argv[1], "monitor")) return monitor_events();
    usage(argv[0]);
    return 2;
}
