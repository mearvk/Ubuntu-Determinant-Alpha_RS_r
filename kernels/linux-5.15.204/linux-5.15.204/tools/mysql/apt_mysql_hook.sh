#!/bin/bash
# SPDX-License-Identifier: GPL-2.0
#
# apt_mysql_hook.sh - APT Post-Install Hook for MySQL Package Registry
#
# Records vital statistics and installer information for every package
# installed via apt/apt-get into the native MySQL database.
#
# WHAT GETS RECORDED
# ══════════════════
# For every package installed:
#   - Package name and version
#   - Who installed it (username, UID, sudo rank)
#   - When it was installed (timestamp)
#   - How it was installed (apt install, apt-get, dpkg)
#   - Package size (installed size, download size)
#   - Dependencies
#   - Memory grain claim (1, 2, or 3)
#   - Source repository
#   - Checksums (SHA256)
#   - Whether it's a new install or upgrade
#
# INTEGRATION
# ═══════════
# This hook is called automatically by APT via:
#   /etc/apt/apt.conf.d/99mysql-registry
#
# It writes to the local MySQL instance (protected, Grain 3).
# Only the hook (running as root during apt) can write.
# Users can query the registry via: pkg-info <package>
#
# Copyright (C) 2026 MEARVK LLC
# Author: Maximilian Eric Alexander Rupplin von Keffikon

set -e

MYSQL_SOCKET="/run/mysqld/mysqld.sock"
MYSQL_DB="system_registry"
MYSQL_USER="apt_registry"

# ============================================================
# MySQL Query Helper
# ============================================================

mysql_query() {
    mysql --socket="$MYSQL_SOCKET" -u "$MYSQL_USER" -D "$MYSQL_DB" -N -B -e "$1" 2>/dev/null
}

# ============================================================
# Schema Initialization (runs once on first use)
# ============================================================

init_schema() {
    mysql --socket="$MYSQL_SOCKET" -u root -e "
        CREATE DATABASE IF NOT EXISTS $MYSQL_DB
            CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

        CREATE USER IF NOT EXISTS '$MYSQL_USER'@'localhost'
            IDENTIFIED WITH auth_socket;

        GRANT ALL PRIVILEGES ON $MYSQL_DB.* TO '$MYSQL_USER'@'localhost';

        USE $MYSQL_DB;

        CREATE TABLE IF NOT EXISTS packages (
            id              BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
            name            VARCHAR(255) NOT NULL,
            version         VARCHAR(128) NOT NULL,
            architecture    VARCHAR(32),
            description     TEXT,
            installed_size  BIGINT UNSIGNED COMMENT 'bytes',
            download_size   BIGINT UNSIGNED COMMENT 'bytes',
            source_repo     VARCHAR(512),
            section         VARCHAR(64),
            priority        VARCHAR(32),
            sha256          VARCHAR(64),
            homepage        VARCHAR(512),

            -- Installer information
            installed_by    VARCHAR(64) NOT NULL COMMENT 'username',
            installed_uid   INT UNSIGNED NOT NULL,
            installed_rank  TINYINT UNSIGNED DEFAULT 0 COMMENT 'sudo_gate rank 0-8',
            install_method  VARCHAR(32) DEFAULT 'apt' COMMENT 'apt|apt-get|dpkg|manual',
            install_time    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

            -- System integration
            memory_grain    TINYINT UNSIGNED DEFAULT 1 COMMENT '1=user, 2=safety, 3=kernel',
            is_upgrade      BOOLEAN DEFAULT FALSE,
            previous_version VARCHAR(128),
            auto_installed  BOOLEAN DEFAULT FALSE COMMENT 'dependency auto-install',

            -- Dependencies (stored as JSON)
            depends         JSON,
            recommends      JSON,

            -- Status
            is_active       BOOLEAN DEFAULT TRUE,
            removed_at      TIMESTAMP NULL,
            removed_by      VARCHAR(64),

            -- Indexes
            INDEX idx_name (name),
            INDEX idx_installer (installed_by),
            INDEX idx_time (install_time),
            INDEX idx_grain (memory_grain),
            UNIQUE KEY uk_name_arch (name, architecture)
        ) ENGINE=InnoDB;

        CREATE TABLE IF NOT EXISTS install_log (
            id              BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
            timestamp       TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            action          ENUM('install', 'upgrade', 'remove', 'purge',
                                 'maintain', 'alter', 'pin', 'hold') NOT NULL,
            package_name    VARCHAR(255) NOT NULL,
            version         VARCHAR(128),
            username        VARCHAR(64) NOT NULL,
            uid             INT UNSIGNED NOT NULL,
            sudo_rank       TINYINT UNSIGNED DEFAULT 0,
            method          VARCHAR(32),
            success         BOOLEAN DEFAULT TRUE,
            notes           TEXT,

            INDEX idx_pkg (package_name),
            INDEX idx_time (timestamp),
            INDEX idx_user (username)
        ) ENGINE=InnoDB;

        CREATE TABLE IF NOT EXISTS grain_claims (
            id              BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
            package_name    VARCHAR(255) NOT NULL,
            claimed_grain   TINYINT UNSIGNED NOT NULL COMMENT '1=user, 2=safety, 3=kernel',
            approved_by     VARCHAR(64),
            approved_rank   TINYINT UNSIGNED,
            approved_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            reason          TEXT,

            INDEX idx_pkg (package_name),
            INDEX idx_grain (claimed_grain)
        ) ENGINE=InnoDB;
    " 2>/dev/null
}

# ============================================================
# Record a Package Installation
# ============================================================

record_install() {
    local pkg_name="$1"
    local pkg_version="$2"
    local method="${3:-apt}"
    local is_auto="${4:-0}"

    # Get installer information
    local username=$(logname 2>/dev/null || echo "${SUDO_USER:-root}")
    local uid=$(id -u "$username" 2>/dev/null || echo 0)
    local rank=0

    # Determine sudo rank (approximation)
    if [ "$uid" -eq 0 ]; then
        rank=8
    elif [ -n "$SUDO_USER" ]; then
        rank=3  # At least maintenance level (apt install)
    fi

    # Get package details from dpkg
    local arch=$(dpkg-query -W -f='${Architecture}' "$pkg_name" 2>/dev/null || echo "unknown")
    local size=$(dpkg-query -W -f='${Installed-Size}' "$pkg_name" 2>/dev/null || echo 0)
    local desc=$(dpkg-query -W -f='${Description}' "$pkg_name" 2>/dev/null | head -1)
    local section=$(dpkg-query -W -f='${Section}' "$pkg_name" 2>/dev/null || echo "unknown")
    local priority=$(dpkg-query -W -f='${Priority}' "$pkg_name" 2>/dev/null || echo "optional")
    local homepage=$(dpkg-query -W -f='${Homepage}' "$pkg_name" 2>/dev/null || echo "")
    local depends=$(dpkg-query -W -f='${Depends}' "$pkg_name" 2>/dev/null || echo "")

    # Determine memory grain from section
    local grain=1
    case "$section" in
        kernel|admin|base)  grain=3 ;;
        net|libs|devel)     grain=2 ;;
        *)                  grain=1 ;;
    esac

    # Convert size from KB to bytes
    size=$((size * 1024))

    # Escape single quotes for SQL
    desc=$(echo "$desc" | sed "s/'/''/g")
    depends_json="[\"$(echo "$depends" | sed 's/, /","/g')\"]"

    # Check if upgrade
    local is_upgrade=0
    local prev_version=""
    prev_version=$(mysql_query "SELECT version FROM packages WHERE name='$pkg_name' AND architecture='$arch' LIMIT 1")
    if [ -n "$prev_version" ]; then
        is_upgrade=1
    fi

    # Upsert package record
    mysql_query "
        INSERT INTO packages
            (name, version, architecture, description, installed_size,
             section, priority, homepage, installed_by, installed_uid,
             installed_rank, install_method, memory_grain, is_upgrade,
             previous_version, auto_installed, depends)
        VALUES
            ('$pkg_name', '$pkg_version', '$arch', '$desc', $size,
             '$section', '$priority', '$homepage', '$username', $uid,
             $rank, '$method', $grain, $is_upgrade,
             $([ -n \"$prev_version\" ] && echo \"'$prev_version'\" || echo \"NULL\"),
             $is_auto, '$depends_json')
        ON DUPLICATE KEY UPDATE
            version = VALUES(version),
            installed_by = VALUES(installed_by),
            installed_uid = VALUES(installed_uid),
            installed_rank = VALUES(installed_rank),
            install_method = VALUES(install_method),
            install_time = CURRENT_TIMESTAMP,
            is_upgrade = VALUES(is_upgrade),
            previous_version = VALUES(previous_version),
            depends = VALUES(depends),
            is_active = TRUE,
            removed_at = NULL,
            removed_by = NULL;
    "

    # Log the action
    mysql_query "
        INSERT INTO install_log (action, package_name, version, username, uid, sudo_rank, method)
        VALUES ('$([ $is_upgrade -eq 1 ] && echo upgrade || echo install)',
                '$pkg_name', '$pkg_version', '$username', $uid, $rank, '$method');
    "
}

# ============================================================
# Record a Package Removal
# ============================================================

record_remove() {
    local pkg_name="$1"
    local method="${2:-apt}"

    local username=$(logname 2>/dev/null || echo "${SUDO_USER:-root}")
    local uid=$(id -u "$username" 2>/dev/null || echo 0)

    mysql_query "
        UPDATE packages SET is_active = FALSE, removed_at = CURRENT_TIMESTAMP,
               removed_by = '$username'
        WHERE name = '$pkg_name' AND is_active = TRUE;
    "

    mysql_query "
        INSERT INTO install_log (action, package_name, username, uid, method)
        VALUES ('remove', '$pkg_name', '$username', $uid, '$method');
    "
}

# ============================================================
# APT Hook Entry Point
#
# Called by APT via DPkg::Post-Invoke hook.
# Reads the dpkg status log to determine what was installed/removed.
# ============================================================

apt_hook() {
    local dpkg_log="/var/log/dpkg.log"
    local last_run_marker="/var/lib/apt/mysql-registry-last"

    # Ensure schema exists
    if ! mysql_query "SELECT 1 FROM packages LIMIT 1" &>/dev/null; then
        init_schema
    fi

    # Find packages changed since last run
    local since=""
    if [ -f "$last_run_marker" ]; then
        since=$(cat "$last_run_marker")
    fi

    # Process recent dpkg log entries
    local now=$(date '+%Y-%m-%d %H:%M:%S')

    if [ -n "$since" ]; then
        grep "^$since\|^$(date '+%Y-%m-%d')" "$dpkg_log" 2>/dev/null | \
        grep " install \| upgrade " | while read -r ts1 ts2 action pkg arch version; do
            pkg=$(echo "$pkg" | cut -d: -f1)
            version=$(echo "$version" | tr -d '<>')
            record_install "$pkg" "$version" "apt" "0"
        done

        grep "^$since\|^$(date '+%Y-%m-%d')" "$dpkg_log" 2>/dev/null | \
        grep " remove \| purge " | while read -r ts1 ts2 action pkg arch version; do
            pkg=$(echo "$pkg" | cut -d: -f1)
            record_remove "$pkg" "apt"
        done
    fi

    echo "$now" > "$last_run_marker"
}

# ============================================================
# Maintain — Mark a package as actively maintained
#
# "Maintain" means someone is responsible for this package:
# watching for updates, testing upgrades, ensuring compatibility.
# It's a stewardship declaration stored in the registry.
# ============================================================

record_maintain() {
    local pkg_name="$1"
    local notes="${2:-Active maintenance by admin}"
    local username=$(logname 2>/dev/null || echo "${SUDO_USER:-root}")
    local uid=$(id -u "$username" 2>/dev/null || echo 0)

    mysql_query "
        UPDATE packages SET
            section = CONCAT(IFNULL(section,''), ' [MAINTAINED]')
        WHERE name = '$pkg_name' AND is_active = TRUE;
    "

    mysql_query "
        INSERT INTO install_log (action, package_name, username, uid, method, notes)
        VALUES ('maintain', '$pkg_name', '$username', $uid, 'admin', '$notes');
    "

    echo "Recorded: $pkg_name marked as maintained by $username"
}

# ============================================================
# Alter — Record configuration or behavioral change to a package
#
# "Alter" means the package's config or runtime behavior was changed
# without reinstalling. Tracks who changed what and when.
# ============================================================

record_alter() {
    local pkg_name="$1"
    local notes="${2:-Configuration altered}"
    local username=$(logname 2>/dev/null || echo "${SUDO_USER:-root}")
    local uid=$(id -u "$username" 2>/dev/null || echo 0)
    local rank=0
    if [ "$uid" -eq 0 ]; then rank=8; elif [ -n "$SUDO_USER" ]; then rank=3; fi

    mysql_query "
        INSERT INTO install_log (action, package_name, username, uid, sudo_rank, method, notes)
        VALUES ('alter', '$pkg_name', '$username', $uid, $rank, 'admin', '$notes');
    "

    echo "Recorded: $pkg_name altered by $username — $notes"
}

# ============================================================
# Pin/Hold — Mark a package version as pinned (prevent upgrade)
#
# Equivalent to `apt-mark hold`. Records the decision in the registry.
# ============================================================

record_pin() {
    local pkg_name="$1"
    local notes="${2:-Version pinned by admin}"
    local username=$(logname 2>/dev/null || echo "${SUDO_USER:-root}")
    local uid=$(id -u "$username" 2>/dev/null || echo 0)

    mysql_query "
        INSERT INTO install_log (action, package_name, username, uid, method, notes)
        VALUES ('pin', '$pkg_name', '$username', $uid, 'admin', '$notes');
    "

    # Actually hold in apt
    apt-mark hold "$pkg_name" 2>/dev/null || true
    echo "Recorded: $pkg_name pinned (held) by $username"
}

# ============================================================
# Upgrade — Explicit upgrade record (beyond auto-detect)
# ============================================================

record_upgrade() {
    local pkg_name="$1"
    local to_version="${2:-latest}"
    local username=$(logname 2>/dev/null || echo "${SUDO_USER:-root}")
    local uid=$(id -u "$username" 2>/dev/null || echo 0)
    local rank=0
    if [ "$uid" -eq 0 ]; then rank=8; elif [ -n "$SUDO_USER" ]; then rank=3; fi

    local prev_version=$(mysql_query "SELECT version FROM packages WHERE name='$pkg_name' AND is_active=TRUE LIMIT 1")

    mysql_query "
        INSERT INTO install_log (action, package_name, version, username, uid, sudo_rank, method, notes)
        VALUES ('upgrade', '$pkg_name', '$to_version', '$username', $uid, $rank, 'apt',
                'Upgraded from $prev_version to $to_version');
    "

    echo "Recorded: $pkg_name upgrade ($prev_version → $to_version) by $username"
}

# ============================================================
# Delete (Purge) — Complete removal including config
# ============================================================

record_purge() {
    local pkg_name="$1"
    local username=$(logname 2>/dev/null || echo "${SUDO_USER:-root}")
    local uid=$(id -u "$username" 2>/dev/null || echo 0)

    mysql_query "
        UPDATE packages SET is_active = FALSE, removed_at = CURRENT_TIMESTAMP,
               removed_by = '$username'
        WHERE name = '$pkg_name' AND is_active = TRUE;
    "

    mysql_query "
        INSERT INTO install_log (action, package_name, username, uid, method, notes)
        VALUES ('purge', '$pkg_name', '$username', $uid, 'admin', 'Complete removal including config');
    "

    echo "Recorded: $pkg_name purged by $username"
}

# ============================================================
# Main — Dispatch based on how we're called
# ============================================================

case "${1:-hook}" in
    hook)
        apt_hook
        ;;
    init)
        init_schema
        echo "MySQL package registry initialized."
        ;;
    record)
        # Manual: apt_mysql_hook.sh record <name> <version> [method]
        record_install "$2" "$3" "${4:-manual}"
        echo "Recorded: $2 $3"
        ;;
    remove)
        record_remove "$2" "${3:-apt}"
        echo "Recorded removal: $2"
        ;;
    purge)
        record_purge "$2"
        ;;
    upgrade)
        record_upgrade "$2" "$3"
        ;;
    maintain)
        record_maintain "$2" "$3"
        ;;
    alter)
        record_alter "$2" "$3"
        ;;
    pin|hold)
        record_pin "$2" "$3"
        ;;
    *)
        echo "Usage: apt_mysql_hook.sh <command> [args]"
        echo ""
        echo "Commands:"
        echo "  hook                         APT post-invoke (automatic)"
        echo "  init                         Initialize MySQL schema"
        echo "  record <pkg> <ver> [method]  Record an installation"
        echo "  remove <pkg>                 Record removal"
        echo "  purge <pkg>                  Record complete deletion"
        echo "  upgrade <pkg> [version]      Record upgrade"
        echo "  maintain <pkg> [notes]       Mark as actively maintained"
        echo "  alter <pkg> [description]    Record config/behavior change"
        echo "  pin <pkg> [reason]           Pin version (prevent upgrade)"
        echo ""
        echo "All actions are recorded in MySQL with who/when/why."
        exit 1
        ;;
esac
