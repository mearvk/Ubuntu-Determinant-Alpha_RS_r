#define _POSIX_C_SOURCE 200809L

#include <dirent.h>
#include <errno.h>
#include <limits.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <unistd.h>

static int exists(const char *path) {
    struct stat st;
    return stat(path, &st) == 0;
}

static int is_dir(const char *path) {
    struct stat st;
    return stat(path, &st) == 0 && S_ISDIR(st.st_mode);
}

static int run_command(const char *command) {
    printf("[run] %s\n", command);
    fflush(stdout);
    return system(command);
}

static int find_install_set(const char *repo, char *out, size_t out_size) {
    const char *candidates[] = {
        "installer/install-manifest.txt",
        "installer/install-all.sh",
        "installer/install-native.sh",
        "installer/README.md"
    };

    for (size_t i = 0; i < sizeof(candidates) / sizeof(candidates[0]); ++i) {
        int n = snprintf(out, out_size, "%s/%s", repo, candidates[i]);
        if (n > 0 && (size_t)n < out_size && exists(out)) {
            return 0;
        }
    }
    return -1;
}

static int find_repo(char *out, size_t out_size) {
    const char *home = getenv("HOME");
    const char *candidates[] = {
        ".",
        "./Ubuntu.Determinant.Beta.Restricted",
        "~/src/Ubuntu.Determinant.Beta.Restricted"
    };
    char expanded[PATH_MAX];

    (void)candidates;

    if (is_dir(".git")) {
        if (realpath(".", out) != NULL) return 0;
    }

    if (is_dir("Ubuntu.Determinant.Beta.Restricted/.git")) {
        if (realpath("Ubuntu.Determinant.Beta.Restricted", out) != NULL) return 0;
    }

    if (home != NULL) {
        snprintf(expanded, sizeof(expanded), "%s/src/Ubuntu.Determinant.Beta.Restricted", home);
        if (is_dir(expanded) && is_dir("/dev/null")) {
            if (realpath(expanded, out) != NULL) return 0;
        }
    }

    return -1;
}

static int clone_repo(const char *destination) {
    char command[PATH_MAX + 256];
    snprintf(command, sizeof(command),
             "git clone --depth 1 https://github.com/mearvk/Ubuntu.Determinant.Beta.Restricted.git '%s'",
             destination);
    return run_command(command);
}

int main(int argc, char **argv) {
    char repo[PATH_MAX];
    char install_set[PATH_MAX];
    const char *home = getenv("HOME");
    int do_install = argc > 1 && strcmp(argv[1], "--install") == 0;

    puts("Ubuntu Determinant — Linux Desktop Install Probe");
    puts("Step 1: locate the Git clone, then locate the primed install set.");

    if (find_repo(repo, sizeof(repo)) != 0) {
        if (home == NULL) {
            fputs("[error] HOME is not set; cannot select a clone destination.\n", stderr);
            return 2;
        }
        snprintf(repo, sizeof(repo), "%s/src/Ubuntu.Determinant.Beta.Restricted", home);
        printf("[info] Git clone not found.\n[info] Clone target: %s\n", repo);
        if (clone_repo(repo) != 0) {
            fputs("[error] Git clone failed. No installation action was taken.\n", stderr);
            return 3;
        }
    }

    printf("[ok] Git clone: %s\n", repo);

    if (find_install_set(repo, install_set, sizeof(install_set)) != 0) {
        fputs("[error] No recognized installer set was found.\n", stderr);
        return 4;
    }

    printf("[ok] Install set: %s\n", install_set);
    printf("[ok] Profile preview: %s/installer/DESKTOP_PREVIEW_STEP_1.md\n", repo);

    if (!do_install) {
        puts("[dry-run] Repository and install set found; nothing was installed.");
        puts("[dry-run] Run with --install to execute installer/install-native.sh when present.");
        return 0;
    }

    char native_script[PATH_MAX];
    snprintf(native_script, sizeof(native_script), "%s/installer/install-native.sh", repo);
    if (!exists(native_script)) {
        fputs("[error] Native Linux installer is not present.\n", stderr);
        return 5;
    }

    printf("[install] Executing: %s\n", native_script);
    return run_command("/bin/sh -c 'exec \"$1\"' sh");
}
