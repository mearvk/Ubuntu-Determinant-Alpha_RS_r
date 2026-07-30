-- SPDX-License-Identifier: GPL-2.0
--
-- file_integrity_schema.sql - MySQL schema for offline file integrity baseline
--
-- Password-protected database storing SHA-256 hashes of all system-critical
-- files. Designed for maximum coverage with append-only semantics.
-- Re-baselining requires Grade 7+ (sudo touch system).
--
-- Architecture:
--   - No flat files to tamper — all baselines live in MySQL
--   - MySQL itself runs in Memory Grain 3 (invisible, no ptrace, no core dumps)
--   - Write access requires authentication; read access is separate
--   - Audit trail on every baseline modification
--   - Append-only design: old baselines preserved for forensic comparison
--
-- Run: mysql -u root -p < file_integrity_schema.sql
--
-- Copyright (C) 2026 MEARVK LLC

-- ============================================================
-- Database
-- ============================================================

CREATE DATABASE IF NOT EXISTS file_integrity
    CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE file_integrity;

-- ============================================================
-- User Management
-- ============================================================

-- Read-only verifier: used by integrity-check tool during scans
-- Password generated at install time, stored in /etc/integrity/verify.conf (0400 root)
CREATE USER IF NOT EXISTS 'integrity_verify'@'localhost'
    IDENTIFIED BY 'PLACEHOLDER_VERIFY_PASSWORD';

-- Writer: used only during baseline capture (build time or re-baseline)
-- Password generated at install time, stored in /etc/integrity/admin.conf (0400 root)
CREATE USER IF NOT EXISTS 'integrity_writer'@'localhost'
    IDENTIFIED BY 'PLACEHOLDER_WRITER_PASSWORD';

-- Grants: verify can only SELECT; writer can INSERT but NOT UPDATE or DELETE
GRANT SELECT ON file_integrity.* TO 'integrity_verify'@'localhost';
GRANT SELECT, INSERT ON file_integrity.* TO 'integrity_writer'@'localhost';

-- Only root can UPDATE/DELETE (re-baseline operations, Grade 7+)
-- Root already has full privileges via mysql system grants

FLUSH PRIVILEGES;

-- ============================================================
-- Core Table: file_baseline
-- ============================================================
-- One row per file per baseline generation. Maximum coverage means
-- we store EVERYTHING about the file that could indicate tampering.

CREATE TABLE IF NOT EXISTS file_baseline (
    id              BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    baseline_id     INT UNSIGNED NOT NULL COMMENT 'Which baseline generation this belongs to',
    file_path       VARCHAR(4096) NOT NULL COMMENT 'Absolute path on the target system',
    file_type       ENUM('regular', 'symlink', 'directory', 'device', 'pipe', 'socket') NOT NULL DEFAULT 'regular',

    -- Content integrity
    sha256          CHAR(64) NOT NULL COMMENT 'SHA-256 hash of file contents',
    sha512          CHAR(128) DEFAULT NULL COMMENT 'SHA-512 for critical files (double verification)',
    file_size       BIGINT UNSIGNED NOT NULL COMMENT 'Size in bytes',

    -- Metadata integrity
    permissions     CHAR(4) NOT NULL COMMENT 'Octal mode (e.g. 0755)',
    owner_uid       INT UNSIGNED NOT NULL,
    owner_gid       INT UNSIGNED NOT NULL,
    owner_name      VARCHAR(64) NOT NULL,
    group_name      VARCHAR(64) NOT NULL,

    -- Timestamps (for drift detection)
    mtime           BIGINT NOT NULL COMMENT 'Modification time (epoch nanoseconds)',
    ctime           BIGINT NOT NULL COMMENT 'Change time (epoch nanoseconds)',

    -- ELF/binary metadata (for executable files)
    is_elf          BOOLEAN DEFAULT FALSE,
    elf_type        VARCHAR(32) DEFAULT NULL COMMENT 'ET_EXEC, ET_DYN, ET_REL',
    elf_interpreter VARCHAR(256) DEFAULT NULL COMMENT 'Dynamic linker path',
    elf_rpath       VARCHAR(1024) DEFAULT NULL COMMENT 'Embedded RPATH (dangerous if modified)',

    -- Symlink target (for symlinks)
    link_target     VARCHAR(4096) DEFAULT NULL,

    -- Extended attributes
    has_suid        BOOLEAN DEFAULT FALSE,
    has_sgid        BOOLEAN DEFAULT FALSE,
    has_sticky      BOOLEAN DEFAULT FALSE,
    is_immutable    BOOLEAN DEFAULT FALSE COMMENT 'chattr +i or NEGAMANE branded',
    xattrs          JSON DEFAULT NULL COMMENT 'Extended attribute names and values',

    -- Classification
    coverage_class  ENUM(
        'kernel',           -- /boot/vmlinuz, kernel modules, initramfs
        'bootloader',       -- /boot/grub, EFI binaries
        'init',             -- /sbin/init, systemd, rc scripts
        'auth',             -- /etc/passwd, /etc/shadow, /etc/sudoers, PAM
        'crypto',           -- certificates, keys, /etc/ssl
        'security_tool',    -- chkrootkit, rkhunter, clamav binaries
        'network',          -- firewall rules, /etc/hosts, DNS config
        'system_binary',    -- /usr/bin, /usr/sbin, /bin, /sbin
        'shared_library',   -- /lib, /usr/lib (*.so*)
        'kernel_module',    -- /lib/modules/**/*.ko
        'config',           -- /etc/**
        'package_manager',  -- apt, dpkg databases and binaries
        'cron',             -- crontabs, cronie binaries
        'logging',          -- syslog, journald configs and binaries
        'database',         -- mysql binaries and configs (NOT data)
        'ai',               -- dave binaries, capabilities, library
        'custom_tool',      -- sudo_gate, chat, nnet, negamane
        'user_critical'     -- admin-designated critical files
    ) NOT NULL DEFAULT 'system_binary',

    -- Verification priority (higher = checked first, checked more often)
    priority        TINYINT UNSIGNED NOT NULL DEFAULT 50 COMMENT '1-100, 100=highest',

    recorded_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    INDEX idx_baseline (baseline_id),
    INDEX idx_path (file_path(768)),
    INDEX idx_class (coverage_class),
    INDEX idx_priority (priority DESC),
    INDEX idx_sha256 (sha256),
    INDEX idx_suid (has_suid),
    INDEX idx_baseline_path (baseline_id, file_path(768))
) ENGINE=InnoDB
  ROW_FORMAT=COMPRESSED
  COMMENT='File integrity baselines — append-only by design';

-- ============================================================
-- Baseline Generations
-- ============================================================
-- Each time a baseline is captured (build time, or admin re-baseline),
-- a new generation is created. Old generations are preserved.

CREATE TABLE IF NOT EXISTS baseline_generation (
    id              INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by      VARCHAR(64) NOT NULL COMMENT 'Username who triggered baseline',
    created_uid     INT UNSIGNED NOT NULL COMMENT 'UID',
    reason          VARCHAR(512) NOT NULL COMMENT 'Why this baseline was created',
    method          ENUM('build', 'install', 'rebaseline', 'update', 'emergency') NOT NULL,
    file_count      INT UNSIGNED DEFAULT 0 COMMENT 'Number of files in this baseline',
    coverage_bytes  BIGINT UNSIGNED DEFAULT 0 COMMENT 'Total bytes covered',
    system_version  VARCHAR(128) DEFAULT NULL COMMENT 'OS version string at time of capture',
    kernel_version  VARCHAR(64) DEFAULT NULL COMMENT 'uname -r at time of capture',
    is_active       BOOLEAN DEFAULT TRUE COMMENT 'Current baseline for verification',
    superseded_by   INT UNSIGNED DEFAULT NULL COMMENT 'ID of newer baseline (if replaced)',

    INDEX idx_active (is_active),
    INDEX idx_created (created_at)
) ENGINE=InnoDB;

-- ============================================================
-- Verification Results
-- ============================================================
-- Every verification scan stores its results here for audit.

CREATE TABLE IF NOT EXISTS verification_scan (
    id              BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    baseline_id     INT UNSIGNED NOT NULL COMMENT 'Which baseline was used',
    scan_start      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    scan_end        TIMESTAMP NULL,
    scanned_by      VARCHAR(64) NOT NULL COMMENT 'Username who ran the scan',
    scanned_uid     INT UNSIGNED NOT NULL,
    files_checked   INT UNSIGNED DEFAULT 0,
    files_passed    INT UNSIGNED DEFAULT 0,
    files_failed    INT UNSIGNED DEFAULT 0,
    files_missing   INT UNSIGNED DEFAULT 0,
    files_new       INT UNSIGNED DEFAULT 0 COMMENT 'Files on disk not in baseline',
    scan_result     ENUM('clean', 'warning', 'compromised', 'incomplete', 'error') DEFAULT 'incomplete',
    exit_code       TINYINT DEFAULT NULL,

    INDEX idx_baseline (baseline_id),
    INDEX idx_result (scan_result),
    INDEX idx_time (scan_start)
) ENGINE=InnoDB;

-- ============================================================
-- Verification Failures (Detail)
-- ============================================================
-- Individual file mismatches from a scan.

CREATE TABLE IF NOT EXISTS verification_failure (
    id              BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    scan_id         BIGINT UNSIGNED NOT NULL,
    file_path       VARCHAR(4096) NOT NULL,
    failure_type    ENUM(
        'hash_mismatch',        -- SHA-256 changed
        'permission_change',    -- Mode bits changed
        'owner_change',         -- UID/GID changed
        'size_change',          -- File size changed
        'missing',              -- File deleted from disk
        'new_file',             -- File appeared that isn't in baseline
        'link_target_change',   -- Symlink points somewhere different
        'suid_added',           -- SUID bit appeared (privilege escalation)
        'sgid_added',           -- SGID bit appeared
        'immutable_cleared',    -- NEGAMANE/immutable removed
        'elf_interpreter_change', -- Dynamic linker changed (LD_PRELOAD attack)
        'elf_rpath_change',     -- RPATH modified (library injection)
        'xattr_change',         -- Extended attributes modified
        'timestamp_anomaly'     -- mtime/ctime inconsistency
    ) NOT NULL,
    expected_value  VARCHAR(512) NOT NULL COMMENT 'What the baseline says',
    actual_value    VARCHAR(512) NOT NULL COMMENT 'What is on disk now',
    severity        ENUM('info', 'low', 'medium', 'high', 'critical') NOT NULL,
    coverage_class  ENUM('kernel', 'bootloader', 'init', 'auth', 'crypto',
                         'security_tool', 'network', 'system_binary',
                         'shared_library', 'kernel_module', 'config',
                         'package_manager', 'cron', 'logging', 'database',
                         'ai', 'custom_tool', 'user_critical') DEFAULT NULL,
    detected_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    INDEX idx_scan (scan_id),
    INDEX idx_type (failure_type),
    INDEX idx_severity (severity),
    INDEX idx_path (file_path(768)),

    FOREIGN KEY (scan_id) REFERENCES verification_scan(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- ============================================================
-- Audit Trail
-- ============================================================
-- Every administrative action on the integrity database is logged.
-- This table is INSERT-ONLY. Even root cannot DELETE from it
-- (enforced by trigger).

CREATE TABLE IF NOT EXISTS integrity_audit (
    id              BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    action          ENUM('baseline_created', 'baseline_deactivated', 'scan_started',
                         'scan_completed', 'user_created', 'password_rotated',
                         'emergency_rebaseline', 'file_whitelisted',
                         'schema_modified', 'access_denied') NOT NULL,
    performed_by    VARCHAR(64) NOT NULL,
    performed_uid   INT UNSIGNED NOT NULL,
    detail          TEXT,
    timestamp       TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    INDEX idx_time (timestamp),
    INDEX idx_action (action),
    INDEX idx_user (performed_by)
) ENGINE=InnoDB;

-- ============================================================
-- Coverage Paths
-- ============================================================
-- Defines WHICH paths to baseline. Maximum coverage by default.
-- Admin can add more via the integrity-baseline tool.

CREATE TABLE IF NOT EXISTS coverage_paths (
    id              INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    path_pattern    VARCHAR(4096) NOT NULL COMMENT 'Glob or exact path',
    coverage_class  ENUM('kernel', 'bootloader', 'init', 'auth', 'crypto',
                         'security_tool', 'network', 'system_binary',
                         'shared_library', 'kernel_module', 'config',
                         'package_manager', 'cron', 'logging', 'database',
                         'ai', 'custom_tool', 'user_critical') NOT NULL,
    priority        TINYINT UNSIGNED NOT NULL DEFAULT 50,
    include_sha512  BOOLEAN DEFAULT FALSE COMMENT 'Double-hash for extra assurance',
    recursive       BOOLEAN DEFAULT TRUE,
    follow_symlinks BOOLEAN DEFAULT FALSE,
    enabled         BOOLEAN DEFAULT TRUE,
    description     VARCHAR(256) DEFAULT NULL,

    UNIQUE INDEX idx_path (path_pattern(768))
) ENGINE=InnoDB;

-- ============================================================
-- Default Coverage Paths — MAXIMUM COVERAGE
-- ============================================================

INSERT INTO coverage_paths (path_pattern, coverage_class, priority, include_sha512, description) VALUES
-- CRITICAL (priority 100) — these are checked first and use double-hash
('/boot/vmlinuz*',              'kernel',           100, TRUE,  'Kernel images'),
('/boot/initramfs*',            'kernel',           100, TRUE,  'Initramfs images'),
('/boot/System.map*',           'kernel',           100, TRUE,  'Kernel symbol maps'),
('/boot/grub/*',                'bootloader',       100, TRUE,  'GRUB bootloader'),
('/boot/efi/**',                'bootloader',       100, TRUE,  'UEFI boot binaries'),
('/sbin/init',                  'init',             100, TRUE,  'System init'),
('/lib/systemd/systemd',        'init',             100, TRUE,  'Systemd main binary'),
('/etc/shadow',                 'auth',             100, TRUE,  'Password hashes'),
('/etc/sudoers',                'auth',             100, TRUE,  'Sudo policy'),
('/etc/sudoers.d/*',            'auth',             100, TRUE,  'Sudo policy fragments'),
('/etc/pam.d/*',                'auth',             100, TRUE,  'PAM configuration'),
('/usr/bin/sudo',               'auth',             100, TRUE,  'Sudo binary'),
('/usr/bin/su',                 'auth',             100, TRUE,  'Su binary'),
('/usr/local/sbin/sudo_gate',   'auth',             100, TRUE,  'Graded privilege wrapper'),
('/etc/ssl/certs/*',            'crypto',            95, TRUE,  'SSL certificates'),
('/etc/ssl/private/*',          'crypto',           100, TRUE,  'SSL private keys'),

-- SECURITY TOOLS (priority 95) — must not be tampered
('/usr/local/sbin/chkrootkit',  'security_tool',     95, TRUE,  'Rootkit detector'),
('/usr/local/lib/chkrootkit/*', 'security_tool',     95, TRUE,  'chkrootkit helpers'),
('/usr/local/bin/rkhunter',     'security_tool',     95, TRUE,  'Rootkit Hunter'),
('/usr/bin/clamscan',           'security_tool',     95, TRUE,  'ClamAV scanner'),
('/usr/sbin/clamd',             'security_tool',     95, TRUE,  'ClamAV daemon'),
('/usr/bin/freshclam',          'security_tool',     95, TRUE,  'ClamAV updater'),

-- SYSTEM BINARIES (priority 80)
('/usr/bin/*',                  'system_binary',     80, FALSE, 'User binaries'),
('/usr/sbin/*',                 'system_binary',     80, FALSE, 'System binaries'),
('/bin/*',                      'system_binary',     80, FALSE, 'Essential user binaries'),
('/sbin/*',                     'system_binary',     80, FALSE, 'Essential system binaries'),

-- SHARED LIBRARIES (priority 85) — LD_PRELOAD attacks target these
('/lib/x86_64-linux-gnu/*.so*', 'shared_library',    85, FALSE, 'System shared libraries (64-bit)'),
('/usr/lib/x86_64-linux-gnu/*.so*', 'shared_library', 85, FALSE, 'User shared libraries (64-bit)'),
('/lib/*.so*',                  'shared_library',    85, FALSE, 'Root shared libraries'),
('/usr/lib/*.so*',              'shared_library',    85, FALSE, 'Usr shared libraries'),
('/lib/x86_64-linux-gnu/ld-linux-x86-64.so.2', 'shared_library', 100, TRUE, 'Dynamic linker (critical)'),
('/etc/ld.so.preload',          'shared_library',   100, TRUE,  'LD_PRELOAD config (Symbiote vector)'),
('/etc/ld.so.conf',             'shared_library',    90, TRUE,  'Library search paths'),
('/etc/ld.so.conf.d/*',         'shared_library',    90, TRUE,  'Library search path fragments'),

-- KERNEL MODULES (priority 90) — LKM rootkits
('/lib/modules/*/kernel/**/*.ko',   'kernel_module', 90, FALSE, 'Kernel modules'),
('/lib/modules/*/modules.dep',      'kernel_module', 90, FALSE, 'Module dependency map'),
('/lib/modules/*/modules.order',    'kernel_module', 85, FALSE, 'Module load order'),

-- CONFIGURATION (priority 70)
('/etc/passwd',                 'config',            90, FALSE, 'User accounts'),
('/etc/group',                  'config',            90, FALSE, 'Group definitions'),
('/etc/fstab',                  'config',            80, FALSE, 'Filesystem mounts'),
('/etc/hosts',                  'network',           80, FALSE, 'Host resolution'),
('/etc/hostname',               'network',           70, FALSE, 'System hostname'),
('/etc/resolv.conf',            'network',           75, FALSE, 'DNS resolver'),
('/etc/ssh/sshd_config',        'network',           85, TRUE,  'SSH daemon config'),
('/etc/ssh/ssh_host_*',         'crypto',            90, TRUE,  'SSH host keys'),

-- NETWORK/FIREWALL (priority 85)
('/etc/ufw/*',                  'network',           85, FALSE, 'UFW firewall rules'),
('/etc/iptables/*',             'network',           85, FALSE, 'iptables rules'),
('/etc/nftables.conf',          'network',           85, FALSE, 'nftables config'),

-- PACKAGE MANAGER (priority 80) — prevent silent package replacement
('/usr/bin/apt',                'package_manager',   80, FALSE, 'APT binary'),
('/usr/bin/apt-get',            'package_manager',   80, FALSE, 'APT-get binary'),
('/usr/bin/dpkg',               'package_manager',   80, FALSE, 'dpkg binary'),
('/var/lib/dpkg/status',        'package_manager',   75, FALSE, 'dpkg package database'),

-- CRON (priority 80) — persistence mechanism for rootkits
('/etc/crontab',                'cron',              80, FALSE, 'System crontab'),
('/etc/cron.d/*',               'cron',              80, FALSE, 'Cron fragments'),
('/etc/cron.daily/*',           'cron',              75, FALSE, 'Daily cron jobs'),
('/etc/cron.hourly/*',          'cron',              75, FALSE, 'Hourly cron jobs'),
('/var/spool/cron/crontabs/*',  'cron',              80, FALSE, 'User crontabs'),
('/usr/sbin/crond',             'cron',              80, FALSE, 'Cron daemon'),

-- LOGGING (priority 75) — detect log tampering
('/etc/rsyslog.conf',           'logging',           75, FALSE, 'Syslog config'),
('/etc/rsyslog.d/*',            'logging',           75, FALSE, 'Syslog fragments'),

-- DATABASE (priority 85) — MySQL binaries (not data)
('/usr/bin/mysql',              'database',          85, FALSE, 'MySQL client'),
('/usr/sbin/mysqld',            'database',          85, TRUE,  'MySQL server'),
('/usr/bin/pkg-info',           'database',          80, FALSE, 'Package registry tool'),

-- AI / DAVE (priority 80)
('/usr/lib/dave/*',             'ai',                80, FALSE, 'Dave capabilities and schema'),
('/usr/sbin/install_kernel_ai.sh', 'ai',            80, FALSE, 'Dave installer'),

-- CUSTOM TOOLS (priority 85)
('/usr/local/sbin/sudo_gate',   'custom_tool',       85, TRUE,  'Graded privilege system'),
('/usr/bin/chat',               'custom_tool',       75, FALSE, 'Terminal chat'),
('/usr/bin/nnet',               'custom_tool',       75, FALSE, 'Identity query'),
('/usr/local/bin/negamane',     'custom_tool',       80, FALSE, 'Immutability tool'),
('/usr/local/bin/integrity-check', 'custom_tool',    95, TRUE,  'This integrity tool itself');

-- ============================================================
-- Triggers: Protect audit trail from deletion
-- ============================================================

DELIMITER //

CREATE TRIGGER IF NOT EXISTS protect_audit_delete
BEFORE DELETE ON integrity_audit
FOR EACH ROW
BEGIN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'DENIED: integrity_audit is append-only. Deletion not permitted.';
END //

CREATE TRIGGER IF NOT EXISTS protect_audit_update
BEFORE UPDATE ON integrity_audit
FOR EACH ROW
BEGIN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'DENIED: integrity_audit is append-only. Updates not permitted.';
END //

-- Log every new baseline creation
CREATE TRIGGER IF NOT EXISTS audit_baseline_created
AFTER INSERT ON baseline_generation
FOR EACH ROW
BEGIN
    INSERT INTO integrity_audit (action, performed_by, performed_uid, detail)
    VALUES ('baseline_created', NEW.created_by, NEW.created_uid,
            CONCAT('Baseline #', NEW.id, ': ', NEW.reason, ' (', NEW.file_count, ' files)'));
END //

-- Log baseline deactivation
CREATE TRIGGER IF NOT EXISTS audit_baseline_deactivated
BEFORE UPDATE ON baseline_generation
FOR EACH ROW
BEGIN
    IF OLD.is_active = TRUE AND NEW.is_active = FALSE THEN
        INSERT INTO integrity_audit (action, performed_by, performed_uid, detail)
        VALUES ('baseline_deactivated', NEW.created_by, NEW.created_uid,
                CONCAT('Baseline #', OLD.id, ' deactivated, superseded by #', NEW.superseded_by));
    END IF;
END //

DELIMITER ;

-- ============================================================
-- Views for quick queries
-- ============================================================

CREATE OR REPLACE VIEW v_active_baseline AS
SELECT fb.*
FROM file_baseline fb
JOIN baseline_generation bg ON fb.baseline_id = bg.id
WHERE bg.is_active = TRUE;

CREATE OR REPLACE VIEW v_critical_files AS
SELECT file_path, sha256, sha512, permissions, coverage_class, priority
FROM v_active_baseline
WHERE priority >= 90
ORDER BY priority DESC, coverage_class, file_path;

CREATE OR REPLACE VIEW v_suid_files AS
SELECT file_path, sha256, permissions, owner_name, coverage_class
FROM v_active_baseline
WHERE has_suid = TRUE OR has_sgid = TRUE
ORDER BY file_path;

CREATE OR REPLACE VIEW v_recent_failures AS
SELECT vf.file_path, vf.failure_type, vf.severity, vf.expected_value,
       vf.actual_value, vf.detected_at, vs.scanned_by
FROM verification_failure vf
JOIN verification_scan vs ON vf.scan_id = vs.id
WHERE vf.detected_at >= NOW() - INTERVAL 7 DAY
ORDER BY vf.severity DESC, vf.detected_at DESC;

CREATE OR REPLACE VIEW v_coverage_summary AS
SELECT coverage_class,
       COUNT(*) AS file_count,
       SUM(file_size) AS total_bytes,
       AVG(priority) AS avg_priority,
       SUM(CASE WHEN sha512 IS NOT NULL THEN 1 ELSE 0 END) AS double_hashed
FROM v_active_baseline
GROUP BY coverage_class
ORDER BY avg_priority DESC;

-- ============================================================
-- Stored Procedures
-- ============================================================

DELIMITER //

-- Start a new verification scan
CREATE PROCEDURE IF NOT EXISTS start_scan(
    IN p_user VARCHAR(64),
    IN p_uid INT UNSIGNED,
    OUT p_scan_id BIGINT UNSIGNED
)
BEGIN
    DECLARE v_baseline_id INT UNSIGNED;

    SELECT id INTO v_baseline_id FROM baseline_generation
    WHERE is_active = TRUE ORDER BY created_at DESC LIMIT 1;

    IF v_baseline_id IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No active baseline found. Run integrity-baseline first.';
    END IF;

    INSERT INTO verification_scan (baseline_id, scanned_by, scanned_uid)
    VALUES (v_baseline_id, p_user, p_uid);

    SET p_scan_id = LAST_INSERT_ID();

    INSERT INTO integrity_audit (action, performed_by, performed_uid, detail)
    VALUES ('scan_started', p_user, p_uid, CONCAT('Scan #', p_scan_id, ' against baseline #', v_baseline_id));
END //

-- Complete a verification scan
CREATE PROCEDURE IF NOT EXISTS complete_scan(
    IN p_scan_id BIGINT UNSIGNED,
    IN p_passed INT UNSIGNED,
    IN p_failed INT UNSIGNED,
    IN p_missing INT UNSIGNED,
    IN p_new INT UNSIGNED
)
BEGIN
    DECLARE v_result ENUM('clean', 'warning', 'compromised', 'incomplete', 'error');
    DECLARE v_user VARCHAR(64);
    DECLARE v_uid INT UNSIGNED;

    IF p_failed = 0 AND p_missing = 0 THEN
        SET v_result = 'clean';
    ELSEIF p_failed > 10 OR p_missing > 5 THEN
        SET v_result = 'compromised';
    ELSE
        SET v_result = 'warning';
    END IF;

    SELECT scanned_by, scanned_uid INTO v_user, v_uid
    FROM verification_scan WHERE id = p_scan_id;

    UPDATE verification_scan SET
        scan_end = CURRENT_TIMESTAMP,
        files_checked = p_passed + p_failed + p_missing,
        files_passed = p_passed,
        files_failed = p_failed,
        files_missing = p_missing,
        files_new = p_new,
        scan_result = v_result,
        exit_code = CASE WHEN v_result = 'clean' THEN 0
                         WHEN v_result = 'warning' THEN 1
                         ELSE 2 END
    WHERE id = p_scan_id;

    INSERT INTO integrity_audit (action, performed_by, performed_uid, detail)
    VALUES ('scan_completed', v_user, v_uid,
            CONCAT('Scan #', p_scan_id, ': ', v_result,
                   ' (passed=', p_passed, ' failed=', p_failed,
                   ' missing=', p_missing, ' new=', p_new, ')'));
END //

DELIMITER ;

-- ============================================================
-- Statistics: coverage summary at a glance
-- ============================================================

CREATE OR REPLACE VIEW v_system_status AS
SELECT
    (SELECT COUNT(*) FROM baseline_generation WHERE is_active = TRUE) AS active_baselines,
    (SELECT file_count FROM baseline_generation WHERE is_active = TRUE ORDER BY created_at DESC LIMIT 1) AS baseline_file_count,
    (SELECT created_at FROM baseline_generation WHERE is_active = TRUE ORDER BY created_at DESC LIMIT 1) AS baseline_date,
    (SELECT COUNT(*) FROM verification_scan WHERE scan_start >= NOW() - INTERVAL 24 HOUR) AS scans_last_24h,
    (SELECT scan_result FROM verification_scan ORDER BY scan_start DESC LIMIT 1) AS last_scan_result,
    (SELECT COUNT(*) FROM verification_failure WHERE detected_at >= NOW() - INTERVAL 24 HOUR) AS failures_last_24h;
