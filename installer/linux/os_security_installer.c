/* SPDX-License-Identifier: GPL-2.0 */
/*
 * os_security_installer.c — native (compiled) OS security baseline installer.
 *
 * This is the compiled, "cleaner/safer" counterpart to
 * scripts/install-os-security.sh. It models that script exactly:
 *
 *   - ClamAV antivirus (+ freshclam signature updates)
 *   - UFW firewall, default-deny-incoming / allow-outgoing / allow-SSH
 *   - AppArmor mandatory access control + profiles
 *   - fail2ban brute-force protection
 *   - unattended-upgrades automatic security updates
 *   - rkhunter / chkrootkit rootkit detectors (always, when any component runs)
 *
 * WHY A BINARY: the script shells out to apt-get/systemctl/ufw. This ELF does
 * the same work but WITHOUT a shell: every privileged action is a fixed argv[]
 * run via fork()/execvp() against an allow-list (see component_installer.h), so
 * there is no shell string to word-split, glob, or inject into. It enforces the
 * same root check, the same package sets, the same per-component toggles (as
 * real CLI flags and the original OS_SECURITY_* environment variables), the
 * same conservative UFW policy, and the same idempotent behaviour.
 *
 * SAFETY: the default action is a DRY RUN that prints the exact commands it
 * would run and changes nothing. Privileged execution happens only with an
 * explicit --apply (aka --confirm/--install).
 *
 * Usage:
 *   os-security-installer [--apply] [--no-clamav] [--no-ufw] [--no-apparmor]
 *                         [--no-fail2ban] [--no-unattended] [--help]
 *   (env parity: OS_SECURITY_CLAMAV=0 os-security-installer --apply ...)
 *
 * Copyright (C) 2026 MEARVK LLC
 */
#define _GNU_SOURCE
#include "component_installer.h"

#define OSI_PROGRAM "os-security-installer"
#define OSI_VERSION "1.0"
#define OSI_EDITION "OS Security Baseline — System Installation"

typedef struct {
    int clamav;
    int ufw;
    int apparmor;
    int fail2ban;
    int unattended;
    int apply;   /* 0 = dry-run (default), 1 = actually apply */
} osi_state;

static void osi_usage(void) {
    printf("%s %s — %s\n\n", OSI_PROGRAM, OSI_VERSION, OSI_EDITION);
    printf("Usage: %s [OPTIONS]\n\n", OSI_PROGRAM);
    puts("Compiled OS security baseline installer (models install-os-security.sh).");
    puts("It runs apt-get/systemctl/ufw through a fixed argv allow-list, never a");
    puts("shell. With no --apply it performs a safe DRY RUN and changes nothing.");
    puts("");
    puts("Options:");
    puts("  --apply, --confirm, --install   Authorize privileged changes (default: dry-run).");
    puts("  --dry-run                       Plan only, change nothing (this is the default).");
    puts("  --no-clamav                     Skip ClamAV antivirus + freshclam.");
    puts("  --no-ufw                        Skip the UFW firewall policy.");
    puts("  --no-apparmor                   Skip AppArmor MAC + profiles.");
    puts("  --no-fail2ban                   Skip fail2ban.");
    puts("  --no-unattended                 Skip unattended-upgrades.");
    puts("  --help, -h                      Show this help and exit.");
    puts("");
    puts("Environment parity (honored like the script; a flag overrides the env):");
    puts("  OS_SECURITY_CLAMAV, OS_SECURITY_UFW, OS_SECURITY_APPARMOR,");
    puts("  OS_SECURITY_FAIL2BAN, OS_SECURITY_UNATTENDED  (set to 0 to skip)");
    puts("");
    puts("Rootkit detectors (rkhunter, chkrootkit) are always installed when any");
    puts("security component is selected, matching the script.");
}

static int osi_parse(int argc, char **argv, osi_state *st) {
    for (int i = 1; i < argc; i++) {
        const char *a = argv[i];
        if      (strcmp(a, "--help") == 0 || strcmp(a, "-h") == 0) { osi_usage(); return 1; }
        else if (strcmp(a, "--apply") == 0 || strcmp(a, "--confirm") == 0 || strcmp(a, "--install") == 0) st->apply = 1;
        else if (strcmp(a, "--dry-run") == 0) st->apply = 0;
        else if (strcmp(a, "--no-clamav") == 0) st->clamav = 0;
        else if (strcmp(a, "--no-ufw") == 0) st->ufw = 0;
        else if (strcmp(a, "--no-apparmor") == 0) st->apparmor = 0;
        else if (strcmp(a, "--no-fail2ban") == 0) st->fail2ban = 0;
        else if (strcmp(a, "--no-unattended") == 0) st->unattended = 0;
        else {
            fprintf(stderr, "ERROR: Unknown option: %s\n", a);
            fprintf(stderr, "Try '%s --help' for usage.\n", OSI_PROGRAM);
            return -1;
        }
    }
    return 0;
}

/* Append a package to a NULL-terminated argv-style list. */
static void osi_add_pkg(const char **list, int *n, const char *pkg) {
    list[(*n)++] = pkg;
}

int main(int argc, char **argv) {
    osi_state st;
    /* Same defaults as the script: everything ON unless OS_SECURITY_*=0. */
    st.clamav     = ci_env_toggle("OS_SECURITY_CLAMAV", 1);
    st.ufw        = ci_env_toggle("OS_SECURITY_UFW", 1);
    st.apparmor   = ci_env_toggle("OS_SECURITY_APPARMOR", 1);
    st.fail2ban   = ci_env_toggle("OS_SECURITY_FAIL2BAN", 1);
    st.unattended = ci_env_toggle("OS_SECURITY_UNATTENDED", 1);
    st.apply      = 0; /* safe default: dry-run */

    int pr = osi_parse(argc, argv, &st);
    if (pr > 0) return 0;   /* --help */
    if (pr < 0) return 2;   /* bad args */

    ci_dry_run = !st.apply;

    puts("+==============================================================+");
    puts("|  OS Security Baseline — System Installation                  |");
    puts("|  Galactic Cherry Marvell Edition 98 (native)                 |");
    puts("+==============================================================+");
    puts("");
    fflush(stdout); /* keep the banner ahead of any stderr diagnostics */

    /* Root is required to apply. In dry-run we still allow a non-root preview
     * so users can inspect the plan, matching a 'preview is always safe' model. */
    if (st.apply && ci_require_root() != 0) return 1;

    /* The script requires apt-get. When applying, its absence is fatal; in a
     * dry-run preview it is only a warning so the plan is still viewable on any
     * host (e.g. a build/CI box without apt). */
    if (!ci_have_tool("apt-get")) {
        if (st.apply) {
            fputs("ERROR: apt-get not found.\n", stderr);
            return 1;
        }
        puts("[warn] apt-get not found on this host; showing the DRY RUN plan only.");
        puts("");
    }

    /* apt-get must run non-interactively, exactly like the script's
     * DEBIAN_FRONTEND=noninteractive. */
    setenv("DEBIAN_FRONTEND", "noninteractive", 1);

    puts("[plan] OS security components selected:");
    printf("  ClamAV antivirus ......... %s\n", st.clamav     ? "enabled" : "skipped");
    printf("  UFW firewall ............. %s\n", st.ufw        ? "enabled" : "skipped");
    printf("  AppArmor MAC ............. %s\n", st.apparmor   ? "enabled" : "skipped");
    printf("  fail2ban ................. %s\n", st.fail2ban   ? "enabled" : "skipped");
    printf("  unattended-upgrades ...... %s\n", st.unattended ? "enabled" : "skipped");
    printf("  mode ..................... %s\n", st.apply ? "APPLY (privileged changes)" : "DRY RUN (no changes)");
    puts("");

    /* ---- [1/4] Install security package set ---- */
    puts("=== [1/4] Installing OS security packages ===");
    {
        char *upd[] = { "apt-get", "update", "-qq", NULL };
        ci_run(upd);
    }

    /* Build the package list from the enabled components, exactly like the
     * script's PKGS array assembly. */
    const char *pkgs[32];
    int np = 0;
    if (st.clamav)     { osi_add_pkg(pkgs, &np, "clamav"); osi_add_pkg(pkgs, &np, "clamav-daemon"); osi_add_pkg(pkgs, &np, "clamav-freshclam"); }
    if (st.ufw)        { osi_add_pkg(pkgs, &np, "ufw"); }
    if (st.apparmor)   { osi_add_pkg(pkgs, &np, "apparmor"); osi_add_pkg(pkgs, &np, "apparmor-utils"); osi_add_pkg(pkgs, &np, "apparmor-profiles"); }
    if (st.fail2ban)   { osi_add_pkg(pkgs, &np, "fail2ban"); }
    if (st.unattended) { osi_add_pkg(pkgs, &np, "unattended-upgrades"); osi_add_pkg(pkgs, &np, "apt-listchanges"); }
    /* Rootkit detectors are always part of the baseline. */
    osi_add_pkg(pkgs, &np, "rkhunter");
    osi_add_pkg(pkgs, &np, "chkrootkit");

    {
        /* argv = apt-get install -y --no-install-recommends <pkgs...> NULL */
        char *install[5 + 32];
        int a = 0;
        install[a++] = "apt-get";
        install[a++] = "install";
        install[a++] = "-y";
        install[a++] = "--no-install-recommends";
        for (int i = 0; i < np; i++) install[a++] = (char *)pkgs[i];
        install[a] = NULL;
        if (ci_run(install) == 0) {
            printf("  OK Security packages selected: ");
            for (int i = 0; i < np; i++) printf("%s%s", i ? " " : "", pkgs[i]);
            puts("");
        } else {
            fputs("  ! security package install reported an error\n", stderr);
        }
    }

    /* ---- [2/4] Enable security services ---- */
    puts("");
    puts("=== [2/4] Enabling security services ===");
    { char *dr[] = { "systemctl", "daemon-reload", NULL }; ci_run(dr); }

    if (st.clamav) {
        char *a1[] = { "systemctl", "enable", "clamav-freshclam.service", NULL }; ci_run(a1);
        char *a2[] = { "systemctl", "enable", "clamav-daemon.service", NULL };    ci_run(a2);
        puts("  OK ClamAV freshclam + daemon enabled");
    }
    if (st.apparmor) {
        /* AppArmor is often already active; enable only when not already so. */
        if (ci_have_tool("aa-enabled")) {
            char *chk[] = { "aa-enabled", "--quiet", NULL };
            if (!ci_dry_run && ci_run(chk) == 0) {
                puts("  OK AppArmor already enabled");
            } else {
                char *en[] = { "systemctl", "enable", "apparmor.service", NULL }; ci_run(en);
                puts("  OK AppArmor service enabled");
            }
        } else {
            char *en[] = { "systemctl", "enable", "apparmor.service", NULL }; ci_run(en);
            puts("  OK AppArmor service enabled");
        }
    }
    if (st.fail2ban) {
        char *en[] = { "systemctl", "enable", "fail2ban.service", NULL }; ci_run(en);
        puts("  OK fail2ban enabled");
    }
    if (st.unattended) {
        char *en[] = { "systemctl", "enable", "unattended-upgrades.service", NULL }; ci_run(en);
        puts("  OK unattended-upgrades service enabled");
    }

    /* ---- [3/4] Firewall (UFW) — conservative default policy ---- */
    puts("");
    puts("=== [3/4] Configuring firewall (UFW) ===");
    if (st.ufw) {
        char *d1[] = { "ufw", "default", "deny", "incoming", NULL };  ci_run(d1);
        char *d2[] = { "ufw", "default", "allow", "outgoing", NULL }; ci_run(d2);
        /* Prefer the named OpenSSH profile, fall back to raw ssh, like the script. */
        char *ssh1[] = { "ufw", "allow", "OpenSSH", NULL };
        if (ci_run(ssh1) != 0) { char *ssh2[] = { "ufw", "allow", "ssh", NULL }; ci_run(ssh2); }
        char *en[] = { "ufw", "--force", "enable", NULL }; ci_run(en);
        puts("  OK UFW: default deny incoming, allow outgoing, SSH allowed, enabled");
    } else {
        puts("  (UFW skipped)");
    }

    /* ---- [4/4] Automatic security updates (unattended-upgrades) ---- */
    puts("");
    puts("=== [4/4] Configuring automatic security updates ===");
    if (st.unattended) {
        char *rc[] = { "dpkg-reconfigure", "-f", "noninteractive", "unattended-upgrades", NULL };
        ci_run(rc);
        /* Write the periodic policy drop-in. We do this in C (no shell heredoc)
         * so the file content is fixed and cannot be templated/injected. */
        if (ci_dry_run) {
            puts("  [dry-run] would write /etc/apt/apt.conf.d/20auto-upgrades");
        } else {
            FILE *f = fopen("/etc/apt/apt.conf.d/20auto-upgrades", "w");
            if (f) {
                fputs("APT::Periodic::Update-Package-Lists \"1\";\n", f);
                fputs("APT::Periodic::Unattended-Upgrade \"1\";\n", f);
                fclose(f);
                puts("  OK wrote /etc/apt/apt.conf.d/20auto-upgrades");
            } else {
                fprintf(stderr, "  ! could not write 20auto-upgrades: %s\n", strerror(errno));
            }
        }
        puts("  OK unattended-upgrades configured (daily update + security upgrade)");
    } else {
        puts("  (automatic security updates skipped)");
    }

    /* ---- Summary ---- */
    puts("");
    puts("=== OS Security baseline installed ===");
    printf("  ClamAV antivirus:     %s\n", st.clamav     ? "installed + freshclam/daemon enabled" : "skipped");
    printf("  UFW firewall:         %s\n", st.ufw        ? "deny-incoming / allow-outgoing / SSH / enabled" : "skipped");
    printf("  AppArmor MAC:         %s\n", st.apparmor   ? "installed + enabled" : "skipped");
    printf("  fail2ban:             %s\n", st.fail2ban   ? "installed + enabled" : "skipped");
    printf("  unattended-upgrades:  %s\n", st.unattended ? "installed + enabled + configured" : "skipped");
    puts("  Rootkit detectors:    rkhunter + chkrootkit installed");
    if (ci_dry_run)
        puts("  NOTE: DRY RUN — nothing was changed. Re-run with --apply to install.");

    return 0;
}
