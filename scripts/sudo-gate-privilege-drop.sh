#!/bin/bash
# =============================================================================
# sudo-gate-privilege-drop.sh — Install-grade privilege drop system
#
# Ubuntu Determinant Alpha RS — Galactic Cherry Marvell Edition 98
# Copyright (C) 2026 MEARVK LLC
# Author: Maximilian Eric Alexander Rupplin von Keffikon
#
# CONCEPT: Programs that require elevated privileges (grade 7/8) to INSTALL
# should thereafter run at low privilege (grade 1/2) during normal operation.
#
# This implements "install high, run low" — a security pattern where:
#   - Installation requires sudo_gate grade 7 or 8 (system-level access)
#   - After installation, the program is REGISTERED in a privilege manifest
#   - The registered runtime grade (1 or 2) is enforced by sudo_gate
#   - The program CANNOT re-escalate without going through the full gate
#
# Usage:
#   scripts/sudo-gate-privilege-drop.sh install <rootfs_dir>
#
# =============================================================================

set -euo pipefail

ROOTFS_DIR="${1:-build/rootfs}"
ACTION="${2:-install}"

GATE_CONF_DIR="/etc/sudo_gate.d"
GATE_MANIFEST="/etc/sudo_gate.d/privilege-drop.conf"
GATE_RUNTIME="/usr/local/lib/sudo_gate"

log() {
    echo "  [PRIV-DROP] $*"
}

install_privilege_drop() {
    log "Installing sudo_gate privilege drop system..."

    # --- Configuration directory ---
    install -d -m 0755 "${ROOTFS_DIR}${GATE_CONF_DIR}"
    install -d -m 0755 "${ROOTFS_DIR}${GATE_RUNTIME}"

    # --- Privilege drop manifest ---
    # This is the registry of programs with install/runtime grade separation
    cat > "${ROOTFS_DIR}${GATE_MANIFEST}" <<'EOF'
# =============================================================================
# sudo_gate privilege-drop.conf — Install-Grade / Runtime-Grade Manifest
#
# Programs listed here were installed at an elevated sudo_gate grade (7/8)
# but run at a reduced grade (1/2) during normal operation.
#
# FORMAT:
#   program_path | install_grade | runtime_grade | installed_by | date | notes
#
# RULES:
#   - install_grade: the gate level REQUIRED to install/update the program
#   - runtime_grade: the gate level the program operates at post-install
#   - The program CANNOT escalate beyond runtime_grade without re-authorization
#   - Re-installation or updates require the original install_grade
#   - Entries are immutable once written (append-only log)
#
# ENFORCEMENT:
#   sudo_gate checks this manifest before executing registered programs.
#   If a program is listed with runtime_grade=2 and someone tries to use it
#   at grade 6+, sudo_gate blocks the operation and demands re-authorization
#   at the original install_grade.
#
# =============================================================================
# program_path                    | install | runtime | installed_by | date       | notes
# -------------------------------|---------|---------|--------------|------------|------------------
/usr/local/bin/wine              | 7       | 2       | system       | 2026-08-08 | Windows compat layer
/usr/local/bin/wine64            | 7       | 2       | system       | 2026-08-08 | Wine 64-bit
/usr/local/bin/wineserver        | 7       | 2       | system       | 2026-08-08 | Wine server
/usr/local/bin/winecfg           | 7       | 1       | system       | 2026-08-08 | Wine config (read-only)
/usr/local/bin/wineboot          | 7       | 2       | system       | 2026-08-08 | Wine prefix init
/usr/local/bin/regedit           | 7       | 2       | system       | 2026-08-08 | Wine registry editor
/usr/local/bin/msiexec           | 7       | 2       | system       | 2026-08-08 | Wine MSI installer
/usr/local/bin/winexec           | 7       | 2       | system       | 2026-08-08 | Wine CLI wrapper
/usr/local/bin/darling           | 8       | 2       | system       | 2026-08-08 | macOS compat layer
/usr/local/bin/darling-shell     | 8       | 2       | system       | 2026-08-08 | Darling shell
/usr/local/bin/macexec           | 8       | 2       | system       | 2026-08-08 | Darling CLI wrapper
/usr/local/sbin/chkrootkit       | 8       | 2       | system       | 2026-08-08 | Rootkit detector
/usr/local/bin/rkhunter          | 8       | 2       | system       | 2026-08-08 | Rootkit Hunter
/usr/sbin/clamd                  | 7       | 2       | system       | 2026-08-08 | ClamAV daemon
/usr/bin/clamscan                | 7       | 1       | system       | 2026-08-08 | ClamAV scanner
/usr/sbin/mysqld                 | 7       | 2       | system       | 2026-08-08 | MySQL server
/usr/bin/mysql                   | 7       | 1       | system       | 2026-08-08 | MySQL client
EOF
    chmod 0644 "${ROOTFS_DIR}${GATE_MANIFEST}"

    # --- Privilege drop enforcement library ---
    cat > "${ROOTFS_DIR}${GATE_RUNTIME}/privilege_drop.sh" <<'LIBSH'
#!/bin/bash
# =============================================================================
# privilege_drop.sh — Runtime enforcement for install-grade privilege drop
#
# Sourced by sudo_gate to enforce the privilege-drop manifest.
# Programs that installed at grade 7/8 run at grade 1/2 thereafter.
# =============================================================================

PRIV_DROP_CONF="/etc/sudo_gate.d/privilege-drop.conf"
PRIV_DROP_LOG="/var/log/sudo_gate_privilege_drop.log"

# Check if a command is in the privilege-drop manifest
# Returns: 0 if found (sets RUNTIME_GRADE), 1 if not found
check_privilege_drop() {
    local cmd_path="$1"
    local requested_grade="${2:-0}"

    [ ! -f "$PRIV_DROP_CONF" ] && return 1

    # Resolve full path
    if [[ "$cmd_path" != /* ]]; then
        cmd_path=$(command -v "$cmd_path" 2>/dev/null || echo "$cmd_path")
    fi

    # Search manifest
    while IFS='|' read -r prog install_g runtime_g installer date notes; do
        # Skip comments and empty lines
        [[ "$prog" =~ ^[[:space:]]*# ]] && continue
        [[ -z "$prog" ]] && continue

        # Trim whitespace
        prog=$(echo "$prog" | xargs)
        install_g=$(echo "$install_g" | xargs)
        runtime_g=$(echo "$runtime_g" | xargs)

        if [[ "$cmd_path" == "$prog" ]]; then
            export PRIV_DROP_INSTALL_GRADE="$install_g"
            export PRIV_DROP_RUNTIME_GRADE="$runtime_g"

            # If the requested grade exceeds runtime grade, BLOCK
            if [[ "$requested_grade" -gt "$runtime_g" ]]; then
                log_privilege_drop_violation "$cmd_path" "$requested_grade" "$runtime_g" "$install_g"
                return 2  # Violation
            fi
            return 0  # Found, within bounds
        fi
    done < "$PRIV_DROP_CONF"

    return 1  # Not in manifest
}

# Log a privilege escalation attempt
log_privilege_drop_violation() {
    local cmd="$1" requested="$2" allowed="$3" install_req="$4"
    local timestamp
    timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ" 2>/dev/null || date)
    local user="${USER:-$(whoami)}"

    local msg="[${timestamp}] VIOLATION: ${user} attempted grade ${requested} on '${cmd}' (max runtime: ${allowed}, re-install requires: ${install_req})"

    echo "$msg" >> "$PRIV_DROP_LOG" 2>/dev/null || true
    logger -t sudo_gate -p auth.warning "$msg" 2>/dev/null || true
}

# Display the privilege drop enforcement message
show_privilege_drop_block() {
    local cmd="$1" runtime_grade="$2" install_grade="$3"

    cat >&2 <<EOF

╔══════════════════════════════════════════════════════════════════════╗
║  SUDO GATE: Privilege Drop Enforcement                               ║
╠══════════════════════════════════════════════════════════════════════╣
║                                                                      ║
║  Program: ${cmd}
║                                                                      ║
║  This program was installed at GRADE ${install_grade} but runs at GRADE ${runtime_grade}.
║                                                                      ║
║  ┌─────────────────────────────────────────────────────────────┐    ║
║  │  INSTALL grade: ${install_grade} (required for install/update/reconfig)  │    ║
║  │  RUNTIME grade: ${runtime_grade} (maximum for normal operation)          │    ║
║  └─────────────────────────────────────────────────────────────┘    ║
║                                                                      ║
║  You are attempting to use this program at a grade higher than its   ║
║  registered runtime level. This is BLOCKED.                          ║
║                                                                      ║
║  To re-authorize at the install grade:                               ║
║    sudo touch system gate-reauth ${cmd}
║                                                                      ║
║  To run within allowed bounds:                                       ║
║    sudo ${cmd}   (grade ${runtime_grade}, normal operation)
║                                                                      ║
╚══════════════════════════════════════════════════════════════════════╝

EOF
}

# Register a new program in the privilege-drop manifest
# Called during installation (requires current grade >= install_grade)
register_privilege_drop() {
    local program="$1"
    local install_grade="${2:-7}"
    local runtime_grade="${3:-2}"
    local installer="${4:-$(whoami)}"
    local date_now
    date_now=$(date +"%Y-%m-%d" 2>/dev/null || echo "unknown")
    local notes="${5:-registered by privilege-drop system}"

    # Verify caller has sufficient grade
    # (This should be called from within a grade 7/8 context)

    # Append to manifest
    printf "%-40s | %-7s | %-7s | %-12s | %-10s | %s\n" \
        "$program" "$install_grade" "$runtime_grade" "$installer" "$date_now" "$notes" \
        >> "$PRIV_DROP_CONF"

    echo "[PRIV-DROP] Registered: $program (install=$install_grade, runtime=$runtime_grade)"
}

# List all programs under privilege-drop
list_privilege_drops() {
    echo ""
    echo "╔══════════════════════════════════════════════════════════════════╗"
    echo "║  Privilege Drop Registry                                         ║"
    echo "╠══════════════════════════════════════════════════════════════════╣"
    printf "║  %-38s │ Install │ Runtime ║\n" "Program"
    echo "╠══════════════════════════════════════════════════════════════════╣"

    while IFS='|' read -r prog install_g runtime_g installer date notes; do
        [[ "$prog" =~ ^[[:space:]]*# ]] && continue
        [[ -z "$prog" ]] && continue
        prog=$(echo "$prog" | xargs)
        install_g=$(echo "$install_g" | xargs)
        runtime_g=$(echo "$runtime_g" | xargs)
        printf "║  %-38s │    %s    │    %s    ║\n" "$prog" "$install_g" "$runtime_g"
    done < "$PRIV_DROP_CONF"

    echo "╚══════════════════════════════════════════════════════════════════╝"
    echo ""
}

export -f check_privilege_drop 2>/dev/null || true
export -f register_privilege_drop 2>/dev/null || true
export -f list_privilege_drops 2>/dev/null || true
LIBSH
    chmod 0555 "${ROOTFS_DIR}${GATE_RUNTIME}/privilege_drop.sh"

    # --- C header for sudo_gate integration ---
    cat > "${ROOTFS_DIR}${GATE_RUNTIME}/privilege_drop.h" <<'HEADER'
/*
 * privilege_drop.h — Install-grade privilege drop for sudo_gate
 *
 * Programs installed at grade 7/8 run at grade 1/2 thereafter.
 * Include this header in sudo_gate.c to enable enforcement.
 *
 * Copyright (C) 2026 MEARVK LLC
 * License: GPL-2.0
 */

#ifndef PRIVILEGE_DROP_H
#define PRIVILEGE_DROP_H

#define PRIV_DROP_CONF "/etc/sudo_gate.d/privilege-drop.conf"
#define PRIV_DROP_LOG  "/var/log/sudo_gate_privilege_drop.log"
#define MAX_LINE_LEN   512
#define MAX_PATH_LEN   256

/*
 * Privilege drop entry structure
 */
struct priv_drop_entry {
    char program[MAX_PATH_LEN];
    int  install_grade;
    int  runtime_grade;
    char installed_by[64];
    char date[16];
    char notes[128];
};

/*
 * Check if a command has a privilege-drop registration.
 *
 * Returns:
 *   0  - not found in manifest (no restriction)
 *   1  - found, within runtime grade bounds (allow)
 *   -1 - found, EXCEEDS runtime grade (BLOCK)
 *
 * If found, fills 'entry' with the manifest data.
 */
static int check_priv_drop(const char *cmd_path, int requested_grade,
                           struct priv_drop_entry *entry)
{
    FILE *fp;
    char line[MAX_LINE_LEN];
    char prog[MAX_PATH_LEN];
    int install_g, runtime_g;

    fp = fopen(PRIV_DROP_CONF, "r");
    if (!fp)
        return 0;  /* No manifest = no restriction */

    while (fgets(line, sizeof(line), fp)) {
        /* Skip comments and empty lines */
        if (line[0] == '#' || line[0] == '\n' || line[0] == '\r')
            continue;

        /* Parse: program | install_grade | runtime_grade | ... */
        if (sscanf(line, " %255[^|] | %d | %d", prog, &install_g, &runtime_g) >= 3) {
            /* Trim trailing whitespace from program path */
            char *end = prog + strlen(prog) - 1;
            while (end > prog && (*end == ' ' || *end == '\t'))
                *end-- = '\0';

            if (strcmp(prog, cmd_path) == 0) {
                fclose(fp);

                if (entry) {
                    strncpy(entry->program, prog, MAX_PATH_LEN - 1);
                    entry->install_grade = install_g;
                    entry->runtime_grade = runtime_g;
                }

                /* Check if requested grade exceeds runtime allowance */
                if (requested_grade > runtime_g)
                    return -1;  /* BLOCK: exceeds runtime grade */

                return 1;  /* ALLOW: within bounds */
            }
        }
    }

    fclose(fp);
    return 0;  /* Not in manifest */
}

/*
 * Print the privilege-drop enforcement block message.
 */
static void print_priv_drop_block(const struct priv_drop_entry *entry,
                                  int requested_grade)
{
    fprintf(stderr,
        "\n"
        "╔══════════════════════════════════════════════════════════════╗\n"
        "║  SUDO GATE: Privilege Drop Enforcement                      ║\n"
        "╠══════════════════════════════════════════════════════════════╣\n"
        "║  Program: %-48s║\n"
        "║                                                              ║\n"
        "║  INSTALL grade: %d (required for install/update)             ║\n"
        "║  RUNTIME grade: %d (maximum for normal operation)            ║\n"
        "║  REQUESTED:     %d (BLOCKED — exceeds runtime grade)         ║\n"
        "║                                                              ║\n"
        "║  This program was installed at an elevated grade but runs    ║\n"
        "║  at a reduced privilege level for daily operation.           ║\n"
        "║                                                              ║\n"
        "║  To re-authorize:                                           ║\n"
        "║    sudo touch system gate-reauth %s\n"
        "║                                                              ║\n"
        "╚══════════════════════════════════════════════════════════════╝\n"
        "\n",
        entry->program,
        entry->install_grade,
        entry->runtime_grade,
        requested_grade,
        entry->program);
}

/*
 * Log a privilege-drop violation to syslog and file.
 */
static void log_priv_drop_violation(const struct priv_drop_entry *entry,
                                    int requested_grade, const char *username)
{
    FILE *logfp;
    time_t now;
    char timebuf[32];

    time(&now);
    strftime(timebuf, sizeof(timebuf), "%Y-%m-%dT%H:%M:%SZ", gmtime(&now));

    /* Syslog */
    syslog(LOG_AUTH | LOG_WARNING,
           "privilege_drop: VIOLATION user=%s cmd=%s requested=%d runtime_max=%d install_req=%d",
           username, entry->program, requested_grade,
           entry->runtime_grade, entry->install_grade);

    /* File log */
    logfp = fopen(PRIV_DROP_LOG, "a");
    if (logfp) {
        fprintf(logfp, "[%s] VIOLATION: user=%s cmd=%s "
                "requested_grade=%d runtime_max=%d install_required=%d\n",
                timebuf, username, entry->program,
                requested_grade, entry->runtime_grade, entry->install_grade);
        fclose(logfp);
    }
}

#endif /* PRIVILEGE_DROP_H */
HEADER
    chmod 0444 "${ROOTFS_DIR}${GATE_RUNTIME}/privilege_drop.h"

    # --- CLI tool: sudo_gate_drop ---
    cat > "${ROOTFS_DIR}/usr/local/bin/sudo_gate_drop" <<'TOOL'
#!/bin/bash
# =============================================================================
# sudo_gate_drop — Manage the privilege-drop registry
#
# Usage:
#   sudo_gate_drop list              — Show all registered programs
#   sudo_gate_drop check <program>   — Check a program's grade levels
#   sudo_gate_drop register <prog> <install_grade> <runtime_grade> [notes]
#   sudo_gate_drop reauth <program>  — Re-authorize at install grade (interactive)
#
# =============================================================================

source /usr/local/lib/sudo_gate/privilege_drop.sh 2>/dev/null || {
    echo "ERROR: privilege_drop.sh not found"; exit 1
}

case "${1:-}" in
    list|ls)
        list_privilege_drops
        ;;
    check)
        if [ -z "${2:-}" ]; then
            echo "Usage: sudo_gate_drop check <program_path>"
            exit 1
        fi
        prog="${2}"
        # Resolve path
        [[ "$prog" != /* ]] && prog=$(command -v "$prog" 2>/dev/null || echo "$prog")
        
        check_privilege_drop "$prog" 0
        case $? in
            0)
                echo "Program: $prog"
                echo "  Install grade: ${PRIV_DROP_INSTALL_GRADE}"
                echo "  Runtime grade: ${PRIV_DROP_RUNTIME_GRADE}"
                echo "  Status: REGISTERED (runs at grade ${PRIV_DROP_RUNTIME_GRADE})"
                ;;
            1)
                echo "Program: $prog"
                echo "  Status: NOT REGISTERED (no privilege drop, unrestricted)"
                ;;
        esac
        ;;
    register|reg)
        if [ -z "${2:-}" ] || [ -z "${3:-}" ] || [ -z "${4:-}" ]; then
            echo "Usage: sudo_gate_drop register <program> <install_grade> <runtime_grade> [notes]"
            echo "  Example: sudo_gate_drop register /usr/local/bin/myapp 7 2 'Custom app'"
            exit 1
        fi
        register_privilege_drop "${2}" "${3}" "${4}" "$(whoami)" "${5:-manual registration}"
        ;;
    reauth)
        if [ -z "${2:-}" ]; then
            echo "Usage: sudo_gate_drop reauth <program>"
            exit 1
        fi
        prog="${2}"
        [[ "$prog" != /* ]] && prog=$(command -v "$prog" 2>/dev/null || echo "$prog")
        
        check_privilege_drop "$prog" 0
        if [ $? -eq 0 ]; then
            echo ""
            echo "Re-authorization requested for: $prog"
            echo "  Install grade required: ${PRIV_DROP_INSTALL_GRADE}"
            echo ""
            echo "To re-authorize, use the appropriate gate:"
            if [ "${PRIV_DROP_INSTALL_GRADE}" = "8" ]; then
                echo "  sudo touch system gate <command using $prog>"
            else
                echo "  sudo touch system <command using $prog>"
            fi
            echo ""
            echo "This grants ONE-TIME elevated execution."
            echo "The program returns to grade ${PRIV_DROP_RUNTIME_GRADE} after completion."
        else
            echo "Program not in privilege-drop registry: $prog"
        fi
        ;;
    help|--help|-h)
        echo "sudo_gate_drop — Privilege Drop Registry Manager"
        echo ""
        echo "Commands:"
        echo "  list                          Show all registered programs"
        echo "  check <program>              Check a program's privilege levels"
        echo "  register <prog> <ig> <rg>    Register a program (install/runtime grade)"
        echo "  reauth <program>             Show re-authorization instructions"
        echo ""
        echo "Concept:"
        echo "  Programs install at grade 7/8 (elevated, system-level access)"
        echo "  Programs RUN at grade 1/2 (restricted, safe daily operation)"
        echo "  Cannot escalate without full gate re-authorization"
        ;;
    *)
        echo "Usage: sudo_gate_drop {list|check|register|reauth|help}"
        echo "Try: sudo_gate_drop help"
        exit 1
        ;;
esac
TOOL
    chmod 0755 "${ROOTFS_DIR}/usr/local/bin/sudo_gate_drop"

    log "Privilege drop system installed:"
    log "  - Config: ${GATE_CONF_DIR}/privilege-drop.conf"
    log "  - Library: ${GATE_RUNTIME}/privilege_drop.sh"
    log "  - C Header: ${GATE_RUNTIME}/privilege_drop.h"
    log "  - CLI tool: /usr/local/bin/sudo_gate_drop"
    log ""
    log "Registered programs (install → runtime):"
    log "  wine, wine64, wineserver, winecfg  (7 → 2)"
    log "  darling, darling-shell             (8 → 2)"
    log "  chkrootkit, rkhunter              (8 → 2)"
    log "  clamd, clamscan, mysqld, mysql     (7 → 1/2)"
}

main() {
    echo ""
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║  sudo_gate Privilege Drop — Install High, Run Low            ║"
    echo "║  Galactic Cherry Marvell Edition 98                          ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo ""
    log "Target: ${ROOTFS_DIR}"
    echo ""

    install_privilege_drop

    echo ""
    log "════════════════════════════════════════════════════════════════"
    log "Privilege drop system installed."
    log ""
    log "How it works:"
    log "  1. Programs install at grade 7 or 8 (elevated)"
    log "  2. After install, they are REGISTERED with a runtime grade"
    log "  3. Normal operation runs at grade 1 or 2 (safe)"
    log "  4. Cannot escalate without full gate re-authorization"
    log ""
    log "Commands:"
    log "  sudo_gate_drop list         — See all registered programs"
    log "  sudo_gate_drop check wine   — Check Wine's privilege levels"
    log "  sudo_gate_drop reauth wine  — Re-authorize for elevated use"
    log "════════════════════════════════════════════════════════════════"
}

main "$@"
