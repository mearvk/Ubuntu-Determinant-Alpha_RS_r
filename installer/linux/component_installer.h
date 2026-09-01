/* SPDX-License-Identifier: GPL-2.0 */
/*
 * component_installer.h — shared helpers for the native component-installer
 * ELFs (os-security-installer, git-improved-installer).
 *
 * These binaries are the compiled, "cleaner/safer" front doors that model the
 * scripts/install-os-security.sh and scripts/install-git-improved.sh install
 * components. They follow the same architecture as white_installer_orchestrator.c:
 *
 *   - They are control planes, not shells. Every privileged action is executed
 *     as a fixed argv[] via fork()/execvp() against an ALLOW-LISTED set of
 *     programs (apt-get, systemctl, ufw, git, dpkg-reconfigure). No shell
 *     string is ever constructed, so word-splitting / globbing / injection /
 *     `set -e` footguns simply do not exist.
 *   - Default action is a safe DRY RUN (plan/preview only). Nothing privileged
 *     runs until the caller explicitly authorizes it (--apply / --confirm).
 *   - Behaviour mirrors the .sh exactly: same root check, same package sets,
 *     same per-component toggles (as real CLI flags AND the original env
 *     variables), same idempotent/non-destructive semantics, same
 *     plan -> apply -> verify flow and summary block.
 *
 * Copyright (C) 2026 MEARVK LLC
 */
#ifndef COMPONENT_INSTALLER_H
#define COMPONENT_INSTALLER_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <errno.h>
#include <sys/types.h>
#include <sys/wait.h>

/* ------------------------------------------------------------------ */
/* Allow-list of programs a component installer is permitted to run.   */
/* Anything not on this list is refused before exec, so the binary can */
/* never be coerced into launching an arbitrary program.               */
/* ------------------------------------------------------------------ */
static const char *const CI_ALLOWED_PROGRAMS[] = {
    "apt-get",
    "systemctl",
    "ufw",
    "git",
    "dpkg-reconfigure",
    "aa-enabled",
    NULL,
};

static int ci_program_allowed(const char *prog) {
    for (int i = 0; CI_ALLOWED_PROGRAMS[i]; i++)
        if (strcmp(prog, CI_ALLOWED_PROGRAMS[i]) == 0) return 1;
    return 0;
}

/* Global dry-run gate. When non-zero, ci_run() only prints the command it
 * WOULD execute and returns success without touching the system. */
static int ci_dry_run = 1;

/* Print a fixed argv[] the way a shell would show it, for plan/audit lines. */
static void ci_print_argv(const char *tag, char *const argv[]) {
    fputs(tag, stdout);
    for (int i = 0; argv[i]; i++) {
        fputc(' ', stdout);
        fputs(argv[i], stdout);
    }
    fputc('\n', stdout);
}

/*
 * ci_run — execute one allow-listed program with a FIXED argument vector.
 *
 * argv[0] is the program name (looked up on PATH via execvp). The command is
 * never passed through a shell, so none of its arguments are re-interpreted.
 * Returns the child's exit status (0 == success), or -1 if the program is not
 * allow-listed or could not be spawned. In dry-run mode it prints and returns 0.
 */
static int ci_run(char *const argv[]) {
    if (!argv || !argv[0]) return -1;
    if (!ci_program_allowed(argv[0])) {
        fprintf(stderr, "  ! refused: '%s' is not on the installer allow-list\n", argv[0]);
        return -1;
    }

    if (ci_dry_run) {
        ci_print_argv("  [dry-run] would run:", argv);
        return 0;
    }

    ci_print_argv("  [exec]", argv);

    pid_t pid = fork();
    if (pid < 0) {
        perror("fork");
        return -1;
    }
    if (pid == 0) {
        /* child */
        execvp(argv[0], argv);
        /* only reached on failure */
        fprintf(stderr, "  ! exec failed for '%s': %s\n", argv[0], strerror(errno));
        _exit(127);
    }

    int status = 0;
    while (waitpid(pid, &status, 0) < 0) {
        if (errno != EINTR) { perror("waitpid"); return -1; }
    }
    if (WIFEXITED(status)) return WEXITSTATUS(status);
    return -1;
}

/* Return non-zero if a program is discoverable on PATH (like `command -v`).
 * This uses execvp semantics via a fork of `env`-free lookup: we simply try to
 * stat each PATH entry. Kept dependency-free and shell-free. */
static int ci_have_tool(const char *tool) {
    const char *path = getenv("PATH");
    if (!path || !*path) path = "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin";
    char buf[4096];
    if (snprintf(buf, sizeof buf, "%s", path) >= (int)sizeof buf) return 0;
    char *save = NULL;
    for (char *dir = strtok_r(buf, ":", &save); dir; dir = strtok_r(NULL, ":", &save)) {
        char full[4352];
        if (snprintf(full, sizeof full, "%s/%s", dir, tool) >= (int)sizeof full) continue;
        if (access(full, X_OK) == 0) return 1;
    }
    return 0;
}

/* Read a boolean env toggle the same way the .sh does: default 1 (ON); the
 * string "0" turns it OFF. Any other value (or unset) leaves the default. */
static int ci_env_toggle(const char *name, int dflt) {
    const char *v = getenv(name);
    if (!v || !*v) return dflt;
    if (strcmp(v, "0") == 0) return 0;
    if (strcmp(v, "1") == 0) return 1;
    return dflt;
}

/* Enforce the root requirement shared by both installers. Returns 0 if root,
 * or prints the same message the scripts use and returns non-zero otherwise. */
static int ci_require_root(void) {
    if (geteuid() != 0) {
        fputs("ERROR: Must run as root (or in chroot during OS install)\n", stderr);
        return 1;
    }
    return 0;
}

#endif /* COMPONENT_INSTALLER_H */
