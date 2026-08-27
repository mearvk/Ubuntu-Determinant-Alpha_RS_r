/*
 * xmc integrated driver.
 * Copyright (C) 2026 MEARVK LLC
 * SPDX-License-Identifier: GPL-2.0 WITH Classpath-exception-2.0
 *
 * The driver deliberately avoids shell interpretation. Child processes are
 * executed with explicit argv vectors and filesystem work is performed with
 * native POSIX APIs where practical.
 */
#ifndef _GNU_SOURCE
#define _GNU_SOURCE 1
#endif
#include "xmc-version.h"
#include "xmc-os-register.h"
#include <errno.h>
#include <fcntl.h>
#include <limits.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/wait.h>
#include <unistd.h>
#ifndef PATH_MAX
#define PATH_MAX 4096
#endif

static void usage(const char *p) {
    fprintf(stderr, "usage: %s [--version] [xmc-options] SOURCE.java\n", p);
}

static int run(char *const argv[]) {
    pid_t pid = fork();
    if (pid < 0) { perror("xmc: fork"); return 1; }
    if (pid == 0) {
        execv(argv[0], argv);
        perror(argv[0]);
        _exit(127);
    }
    int status = 0;
    if (waitpid(pid, &status, 0) < 0) { perror("xmc: waitpid"); return 1; }
    if (WIFEXITED(status)) return WEXITSTATUS(status);
    if (WIFSIGNALED(status)) {
        fprintf(stderr, "xmc: child terminated by signal %d\n", WTERMSIG(status));
    }
    return 1;
}

static int sha256_file(const char *path, char out[65]) {
    int pipefd[2];
    if (pipe(pipefd) != 0) { perror("xmc: pipe"); return -1; }
    pid_t pid = fork();
    if (pid < 0) { close(pipefd[0]); close(pipefd[1]); perror("xmc: fork"); return -1; }
    if (pid == 0) {
        char *const argv[] = { (char *)"sha256sum", (char *)path, NULL };
        if (dup2(pipefd[1], STDOUT_FILENO) < 0) _exit(126);
        close(pipefd[0]); close(pipefd[1]);
        execvp(argv[0], argv);
        _exit(127);
    }
    close(pipefd[1]);
    size_t n = 0;
    while (n < 64) {
        ssize_t r = read(pipefd[0], out + n, 64 - n);
        if (r < 0) { if (errno == EINTR) continue; close(pipefd[0]); waitpid(pid, NULL, 0); return -1; }
        if (r == 0) break;
        n += (size_t)r;
    }
    close(pipefd[0]);
    int status = 0;
    if (waitpid(pid, &status, 0) < 0 || !WIFEXITED(status) || WEXITSTATUS(status) != 0 || n < 64) return -1;
    out[64] = '\0';
    return 0;
}

static int find_source(int argc, char **argv) {
    for (int i = argc - 1; i >= 1; --i) if (argv[i][0] != '-') return i;
    return -1;
}

static int is_java(const char *p) {
    const char *d = strrchr(p, '.');
    return d && strcmp(d, ".java") == 0;
}

static int exists_exec(const char *p) {
    struct stat st;
    return stat(p, &st) == 0 && S_ISREG(st.st_mode) && access(p, X_OK) == 0;
}

static int join_path(char *out, size_t cap, const char *dir, const char *name) {
    if (!out || !dir || !name || cap == 0) return -1;
    size_t a = strlen(dir), b = strlen(name);
    size_t sep = (a && dir[a - 1] != '/') ? 1u : 0u;
    if (a > cap - 1 || b > cap - 1 - a - sep) return -1;
    memcpy(out, dir, a);
    if (sep) out[a++] = '/';
    memcpy(out + a, name, b + 1);
    return 0;
}

static int append_suffix(char *out, size_t cap, const char *base, const char *suffix) {
    if (!out || !base || !suffix || cap == 0) return -1;
    size_t a = strlen(base), b = strlen(suffix);
    if (a > cap - 1 || b > cap - 1 - a) return -1;
    memcpy(out, base, a);
    memcpy(out + a, suffix, b + 1);
    return 0;
}

int main(int argc, char **argv) {
    if (argc == 2 && (!strcmp(argv[1], "--version") || !strcmp(argv[1], "-V"))) {
        printf("xmc %s\n", XMC_VERSION);
        return 0;
    }
    if (argc < 2) { usage(argv[0]); return 2; }

    char self[PATH_MAX];
    ssize_t n = readlink("/proc/self/exe", self, sizeof self - 1);
    if (n <= 0 || n >= (ssize_t)sizeof self - 1) {
        fprintf(stderr, "xmc: cannot locate integrated compiler directory\n"); return 1;
    }
    self[n] = '\0';
    char *slash = strrchr(self, '/');
    if (!slash) return 1;
    *slash = '\0';

    char core[PATH_MAX], packer[PATH_MAX], launcher[PATH_MAX], bootstrap[PATH_MAX];
    if (join_path(core, sizeof core, self, "xmc-core") ||
        join_path(packer, sizeof packer, self, "asysma_pack") ||
        join_path(launcher, sizeof launcher, self, "xmc-asysma-launcher.sh") ||
        join_path(bootstrap, sizeof bootstrap, self, "asysma-bootstrap")) {
        fprintf(stderr, "xmc: compiler installation path is too long\n"); return 1;
    }

    int source_index = find_source(argc, argv);
    if (source_index < 0) { usage(argv[0]); return 2; }
    const char *source = argv[source_index];

    char **core_argv = calloc((size_t)argc + 1, sizeof *core_argv);
    if (!core_argv) { perror("xmc: calloc"); return 1; }
    core_argv[0] = core;
    for (int i = 1; i < argc; ++i) core_argv[i] = argv[i];
    core_argv[argc] = NULL;

    fprintf(stdout, "xmc %s: integrated ASYSMA mode\n", XMC_VERSION);
    int rc = run(core_argv);
    free(core_argv);
    if (rc != 0) {
        fprintf(stderr, "xmc: compiler core failed; ASYSMA composition skipped\n"); return rc;
    }
    if (!is_java(source)) {
        fprintf(stdout, "xmc: ASYSMA composition currently requires a Java entry source; .xclass retained\n");
        return 0;
    }
    if (!exists_exec(bootstrap)) {
        fprintf(stderr, "xmc: self-contained ASYSMA bootstrap is not built: %s\n", bootstrap); return 1;
    }

    char base[PATH_MAX];
    if (snprintf(base, sizeof base, "%s", source) >= (int)sizeof base) {
        fprintf(stderr, "xmc: source path is too long\n"); return 1;
    }
    char *dot = strrchr(base, '.');
    if (dot) *dot = '\0';

    char xclass[PATH_MAX], asysma[PATH_MAX], desktop[PATH_MAX];
    if (append_suffix(xclass, sizeof xclass, base, ".xclass") ||
        append_suffix(asysma, sizeof asysma, base, ".asysma") ||
        append_suffix(desktop, sizeof desktop, base, ".asysma.desktop")) {
        fprintf(stderr, "xmc: output path is too long\n"); return 1;
    }

    char class_name[PATH_MAX];
    const char *leaf = strrchr(base, '/');
    if (snprintf(class_name, sizeof class_name, "%s", leaf ? leaf + 1 : base) >= (int)sizeof class_name) {
        fprintf(stderr, "xmc: class name is too long\n"); return 1;
    }

    char icon[PATH_MAX];
    if (join_path(icon, sizeof icon, self, "xmc-icon.svg")) {
        fprintf(stderr, "xmc: icon path is too long\n"); return 1;
    }
    char icon_sha[65] = "unavailable";
    (void)sha256_file(icon, icon_sha);

    char *pack_argv[] = {
        packer, (char *)"--output", asysma, (char *)"--entry", (char *)"JAVA",
        (char *)"--java", class_name, (char *)"--xclass", xclass,
        (char *)"--bootstrap", bootstrap, (char *)"--icon", icon,
        (char *)"--icon-sha256", icon_sha, NULL
    };
    rc = run(pack_argv);
    if (rc != 0) {
        fprintf(stderr, "xmc: .xclass succeeded but ASYSMA composition failed\n"); return rc;
    }

    FILE *d = fopen(desktop, "w");
    if (!d) { perror(desktop); return 1; }
    fprintf(d,
        "[Desktop Entry]\nType=Application\nName=%s (ASYSMA)\n"
        "Comment=Run the compiled ASYSMA application\nIcon=xmc-asysma\n"
        "Exec=%s %%U\nTerminal=false\nMimeType=application/x-asysma;\n"
        "Categories=Development;\nStartupNotify=true\n", class_name, launcher);
    if (fclose(d) != 0) { perror(desktop); return 1; }

    if (xmc_register_asysma(desktop, class_name, icon, asysma) != 0)
        fprintf(stderr, "xmc: warning: unable to register application/x-asysma with the user desktop environment\n");
    else
        fprintf(stdout, "xmc: registered application/x-asysma for the current user\n");

    printf("xmc: %s.xclass\n", class_name);
    printf("xmc: %s.asysma\n", class_name);
    printf("xmc: %s.asysma.desktop\n", class_name);
    printf("xmc: icon SHA-256 %s\n", icon_sha);
    return 0;
}
