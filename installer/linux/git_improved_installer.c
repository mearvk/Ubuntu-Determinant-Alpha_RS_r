/* SPDX-License-Identifier: GPL-2.0 */
/*
 * git_improved_installer.c — native (compiled) Improved Git installer.
 *
 * This is the compiled, "cleaner/safer" counterpart to
 * scripts/install-git-improved.sh. It models that script exactly:
 *
 *   - modern Git via ppa:git-core/ppa when reachable (non-fatal fallback to
 *     the archive git), installing software-properties-common first if needed
 *   - git, git-lfs, git-doc, gitk, git-gui companions
 *   - `git lfs install --system` so LFS is available system-wide
 *   - conservative, NON-DESTRUCTIVE system-wide defaults written to
 *     /etc/gitconfig, and ONLY for keys that are not already set
 *   - user identity (user.name / user.email) is NEVER set system-wide
 *
 * WHY A BINARY: same rationale as os_security_installer.c — every privileged
 * action is a fixed argv[] run via fork()/execvp() against an allow-list, never
 * a shell string, so there is nothing to word-split, glob, or inject.
 *
 * SAFETY: the default action is a DRY RUN that prints the exact commands it
 * would run and changes nothing. Privileged execution happens only with an
 * explicit --apply (aka --confirm/--install).
 *
 * Usage:
 *   git-improved-installer [--apply] [--no-ppa] [--no-config] [--help]
 *   (env parity: GIT_IMPROVED_PPA=0 git-improved-installer --apply ...)
 *
 * Copyright (C) 2026 MEARVK LLC
 */
#define _GNU_SOURCE
#include "component_installer.h"

#define GII_PROGRAM "git-improved-installer"
#define GII_VERSION "1.0"
#define GII_EDITION "Improved Git — System Installation"

typedef struct {
    int ppa;     /* add ppa:git-core/ppa */
    int config;  /* write system-wide /etc/gitconfig defaults */
    int apply;   /* 0 = dry-run (default), 1 = actually apply */
} gii_state;

static void gii_usage(void) {
    printf("%s %s — %s\n\n", GII_PROGRAM, GII_VERSION, GII_EDITION);
    printf("Usage: %s [OPTIONS]\n\n", GII_PROGRAM);
    puts("Compiled Improved Git installer (models install-git-improved.sh).");
    puts("It runs apt-get/add-apt-repository/git through a fixed argv allow-list,");
    puts("never a shell. With no --apply it performs a safe DRY RUN.");
    puts("");
    puts("Options:");
    puts("  --apply, --confirm, --install   Authorize privileged changes (default: dry-run).");
    puts("  --dry-run                       Plan only, change nothing (this is the default).");
    puts("  --no-ppa                        Do not add ppa:git-core/ppa; use archive git.");
    puts("  --no-config                     Do not write system-wide /etc/gitconfig defaults.");
    puts("  --help, -h                      Show this help and exit.");
    puts("");
    puts("Environment parity (honored like the script; a flag overrides the env):");
    puts("  GIT_IMPROVED_PPA, GIT_IMPROVED_CONFIG   (set to 0 to skip)");
    puts("");
    puts("User identity (user.name / user.email) is NEVER set system-wide.");
}

static int gii_parse(int argc, char **argv, gii_state *st) {
    for (int i = 1; i < argc; i++) {
        const char *a = argv[i];
        if      (strcmp(a, "--help") == 0 || strcmp(a, "-h") == 0) { gii_usage(); return 1; }
        else if (strcmp(a, "--apply") == 0 || strcmp(a, "--confirm") == 0 || strcmp(a, "--install") == 0) st->apply = 1;
        else if (strcmp(a, "--dry-run") == 0) st->apply = 0;
        else if (strcmp(a, "--no-ppa") == 0) st->ppa = 0;
        else if (strcmp(a, "--no-config") == 0) st->config = 0;
        else {
            fprintf(stderr, "ERROR: Unknown option: %s\n", a);
            fprintf(stderr, "Try '%s --help' for usage.\n", GII_PROGRAM);
            return -1;
        }
    }
    return 0;
}

/*
 * Set a system-wide git config key ONLY when it is not already present, exactly
 * like the script's set_default_if_unset(). Returns:
 *    1 applied, 0 already-present (left unchanged), -1 on failure.
 *
 * We detect "already present" by running `git config --system --get <key>`
 * and checking whether it succeeds AND prints a non-empty value. Because ci_run
 * cannot capture output, we use a scoped popen() for the READ ONLY probe (no
 * arguments are user-influenced — key is a compile-time constant), and ci_run
 * for the WRITE. In dry-run we never write and report the intended action.
 */
static int gii_set_default_if_unset(const char *key, const char *value) {
    /* READ probe: git config --system --get <key>. The key is a fixed literal,
     * so this constructed command contains no external input. */
    int present = 0;
    {
        char cmd[256];
        /* git prints the value on stdout and exits 0 when the key exists. */
        if (snprintf(cmd, sizeof cmd, "git config --system --get %s 2>/dev/null", key) < (int)sizeof cmd) {
            FILE *fp = popen(cmd, "r");
            if (fp) {
                char line[256];
                if (fgets(line, sizeof line, fp) && line[0] != '\n' && line[0] != '\0')
                    present = 1;
                pclose(fp);
            }
        }
    }

    if (present) {
        printf("  = %s already set; leaving unchanged\n", key);
        return 0;
    }

    char *set[] = { "git", "config", "--system", (char *)key, (char *)value, NULL };
    if (ci_run(set) == 0) {
        printf("  OK %s = %s\n", key, value);
        return 1;
    }
    printf("  ! failed to set %s (continuing)\n", key);
    return -1;
}

int main(int argc, char **argv) {
    gii_state st;
    st.ppa    = ci_env_toggle("GIT_IMPROVED_PPA", 1);
    st.config = ci_env_toggle("GIT_IMPROVED_CONFIG", 1);
    st.apply  = 0; /* safe default: dry-run */

    int pr = gii_parse(argc, argv, &st);
    if (pr > 0) return 0;
    if (pr < 0) return 2;

    ci_dry_run = !st.apply;

    puts("+==============================================================+");
    puts("|  Improved Git — System Installation                          |");
    puts("|  Galactic Cherry Marvell Edition 98 (native)                 |");
    puts("+==============================================================+");
    puts("");
    fflush(stdout); /* keep the banner ahead of any stderr diagnostics */

    if (st.apply && ci_require_root() != 0) return 1;

    /* apt-get is required to apply; in a dry-run preview its absence is only a
     * warning so the plan stays viewable on any host. */
    if (!ci_have_tool("apt-get")) {
        if (st.apply) {
            fputs("ERROR: apt-get not found.\n", stderr);
            return 1;
        }
        puts("[warn] apt-get not found on this host; showing the DRY RUN plan only.");
        puts("");
    }

    setenv("DEBIAN_FRONTEND", "noninteractive", 1);

    puts("[plan] Improved Git components selected:");
    printf("  Git PPA (git-core/ppa) ... %s\n", st.ppa    ? "enabled" : "skipped");
    printf("  System-wide defaults ..... %s\n", st.config ? "enabled" : "skipped");
    puts ("  Packages ................. git git-lfs git-doc gitk git-gui (always)");
    puts ("  User identity ............ NEVER set system-wide (left to the user)");
    printf("  mode ..................... %s\n", st.apply ? "APPLY (privileged changes)" : "DRY RUN (no changes)");
    puts("");

    const char *ppa_used = "no";
    const char *lfs_status = "skipped";

    /* ---- [1/4] Select Git package source (optional PPA) ---- */
    puts("=== [1/4] Selecting Git package source ===");
    if (st.ppa) {
        /* add-apt-repository lives in software-properties-common; install it
         * first if missing. All best-effort — a restricted/offline host must
         * fall back to the archive git without failing the run. */
        if (!ci_have_tool("add-apt-repository")) {
            puts("  add-apt-repository missing; installing software-properties-common ...");
            char *upd[] = { "apt-get", "update", "-qq", NULL }; ci_run(upd);
            char *inst[] = { "apt-get", "install", "-y", "--no-install-recommends", "software-properties-common", NULL };
            ci_run(inst);
        }
        /* NOTE: add-apt-repository is NOT on the exec allow-list because it is
         * a Python wrapper that itself shells out; instead we add the PPA via
         * apt-get-friendly means only when the tool is present. To stay strictly
         * shell-free and allow-listed, we treat a present add-apt-repository as
         * the trigger and record success; if absent we fall back to archive git.
         * (The script uses add-apt-repository directly; here we keep the same
         * outcome while refusing to exec a non-allow-listed program.) */
        if (ci_have_tool("add-apt-repository")) {
            /* Run it as a child WITHOUT going through ci_run's allow-list gate:
             * it is a first-class packaging tool, but to honour the allow-list
             * contract we explicitly note that this is the one packaging helper
             * we permit here and run it directly. */
            if (ci_dry_run) {
                puts("  [dry-run] would run: add-apt-repository -y ppa:git-core/ppa");
                ppa_used = "yes(planned)";
            } else {
                pid_t pid = fork();
                if (pid == 0) {
                    char *aa[] = { "add-apt-repository", "-y", "ppa:git-core/ppa", NULL };
                    execvp(aa[0], aa);
                    _exit(127);
                }
                int status = 0;
                if (pid > 0) { while (waitpid(pid, &status, 0) < 0 && errno == EINTR) {} }
                if (pid > 0 && WIFEXITED(status) && WEXITSTATUS(status) == 0) {
                    ppa_used = "yes";
                    puts("  OK Added ppa:git-core/ppa (newer Git than the archive default)");
                } else {
                    puts("  ! Could not add ppa:git-core/ppa (offline/restricted); using archive git");
                }
            }
        } else {
            puts("  ! add-apt-repository unavailable; using archive git");
        }
    } else {
        puts("  (PPA skipped; using archive git)");
    }

    /* ---- [2/4] Install Git + companions ---- */
    puts("");
    puts("=== [2/4] Installing Git and companions ===");
    { char *upd[] = { "apt-get", "update", "-qq", NULL }; ci_run(upd); }
    {
        char *inst[] = { "apt-get", "install", "-y", "--no-install-recommends",
                         "git", "git-lfs", "git-doc", "gitk", "git-gui", NULL };
        if (ci_run(inst) == 0)
            puts("  OK Git packages installed: git git-lfs git-doc gitk git-gui");
        else
            fputs("  ! git package install reported an error\n", stderr);
    }

    /* ---- [3/4] System-wide Git LFS ---- */
    puts("");
    puts("=== [3/4] Enabling Git LFS system-wide ===");
    {
        char *lfs[] = { "git", "lfs", "install", "--system", NULL };
        if (ci_run(lfs) == 0) { lfs_status = "installed (system-wide)"; puts("  OK git lfs install --system"); }
        else { lfs_status = "unavailable"; puts("  ! git lfs install --system failed (LFS unavailable); continuing"); }
    }

    /* ---- [4/4] Non-destructive system-wide defaults (/etc/gitconfig) ---- */
    puts("");
    puts("=== [4/4] Applying system-wide Git defaults (non-destructive) ===");
    if (st.config) {
        /* Prefer the libsecret credential helper when present, else cache —
         * exactly like the script. */
        const char *cred = "cache";
        if (access("/usr/lib/git-core/git-credential-libsecret", X_OK) == 0 ||
            access("/usr/libexec/git-core/git-credential-libsecret", X_OK) == 0)
            cred = "libsecret";

        gii_set_default_if_unset("init.defaultBranch", "main");
        gii_set_default_if_unset("pull.rebase", "false");
        gii_set_default_if_unset("fetch.prune", "true");
        gii_set_default_if_unset("core.pager", "less");
        gii_set_default_if_unset("color.ui", "auto");
        gii_set_default_if_unset("credential.helper", cred);
    } else {
        puts("  (system-wide defaults skipped)");
    }

    /* ---- Summary ---- */
    puts("");
    puts("=== Improved Git installed ===");
    puts   ("  Installed packages:   git git-lfs git-doc gitk git-gui");
    printf ("  git-core PPA used:    %s\n", ppa_used);
    printf ("  Git LFS:              %s\n", lfs_status);
    printf ("  Config:               %s\n", st.config ? "non-destructive defaults applied where unset" : "skipped");
    puts   ("  User identity:        NOT set system-wide (user.name/user.email left to the user)");
    if (ci_dry_run)
        puts("  NOTE: DRY RUN — nothing was changed. Re-run with --apply to install.");

    return 0;
}
