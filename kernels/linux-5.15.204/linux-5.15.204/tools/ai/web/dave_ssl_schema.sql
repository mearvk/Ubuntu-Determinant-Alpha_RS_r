-- SPDX-License-Identifier: GPL-2.0
--
-- dave_ssl_schema.sql — MySQL schema for Dave's SSL/TLS certificate intelligence
--
-- Dave stores public keys, certificate chains, and monitors key changes
-- for fiduciary purposes. He understands site identity through cryptography.
--
-- Run: mysql -u root < dave_ssl_schema.sql
--
-- Copyright (C) 2026 MEARVK LLC

USE dave_kb;

-- ============================================================
-- SSL Certificates: Public keys and cert metadata for monitored sites
-- ============================================================

CREATE TABLE IF NOT EXISTS ssl_certificates (
    id                      BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    hostname                VARCHAR(255) NOT NULL,
    port                    INT UNSIGNED NOT NULL DEFAULT 443,
    subject                 VARCHAR(1024) DEFAULT NULL,
    issuer                  VARCHAR(1024) DEFAULT NULL,
    not_before              DATETIME DEFAULT NULL,
    not_after               DATETIME DEFAULT NULL,
    pubkey_hash             CHAR(64) NOT NULL COMMENT 'SHA-256 of public key (DER)',
    cert_hash               CHAR(64) NOT NULL COMMENT 'SHA-256 of full certificate (DER)',
    pubkey_path             VARCHAR(512) DEFAULT NULL COMMENT 'Path to stored PEM public key',
    cert_path               VARCHAR(512) DEFAULT NULL COMMENT 'Path to stored PEM certificate',
    chain_path              VARCHAR(512) DEFAULT NULL COMMENT 'Path to stored PEM chain',
    fetched_at              TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    -- Change detection
    previous_pubkey_hash    CHAR(64) DEFAULT NULL COMMENT 'Previous public key hash',
    key_changed             BOOLEAN DEFAULT FALSE,
    key_change_detected_at  TIMESTAMP NULL,
    check_count             INT UNSIGNED DEFAULT 1,

    -- Monitoring
    monitor_enabled         BOOLEAN DEFAULT TRUE,
    check_interval_hrs      INT UNSIGNED DEFAULT 24,
    last_verified           TIMESTAMP NULL,

    -- Fiduciary classification
    fiduciary_class         ENUM('critical', 'important', 'standard', 'informational')
                            DEFAULT 'standard',
    fiduciary_notes         TEXT DEFAULT NULL COMMENT 'Why this site matters fiduciarily',

    INDEX idx_hostname (hostname),
    INDEX idx_expiry (not_after),
    INDEX idx_key_changed (key_changed),
    INDEX idx_monitor (monitor_enabled, check_interval_hrs),
    INDEX idx_fiduciary (fiduciary_class)
) ENGINE=InnoDB;

-- ============================================================
-- Site Authentication Awareness: What Dave understands about site access
-- ============================================================

CREATE TABLE IF NOT EXISTS site_auth_awareness (
    id                      BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    hostname                VARCHAR(255) NOT NULL,
    url                     VARCHAR(4096) DEFAULT NULL,

    -- Authentication understanding
    requires_registration   BOOLEAN DEFAULT NULL COMMENT 'Does site require account creation?',
    requires_login          BOOLEAN DEFAULT NULL COMMENT 'Does site require login for content?',
    requires_payment        BOOLEAN DEFAULT NULL COMMENT 'Does site require payment/subscription?',
    requires_credit_card    BOOLEAN DEFAULT NULL COMMENT 'Does registration need credit card?',
    has_free_tier           BOOLEAN DEFAULT NULL COMMENT 'Is there free access?',
    has_paywall             BOOLEAN DEFAULT NULL COMMENT 'Is content behind a paywall?',
    membership_type         ENUM('free', 'freemium', 'paid', 'enterprise', 'invitation',
                                 'public', 'government') DEFAULT NULL,

    -- SSL/TLS understanding
    uses_https              BOOLEAN DEFAULT TRUE,
    tls_version             VARCHAR(16) DEFAULT NULL COMMENT 'e.g. TLSv1.3',
    cipher_suite            VARCHAR(128) DEFAULT NULL,
    key_exchange            VARCHAR(64) DEFAULT NULL COMMENT 'e.g. X25519, ECDH P-256',
    certificate_issuer      VARCHAR(255) DEFAULT NULL COMMENT 'CA that issued cert',
    hsts_enabled            BOOLEAN DEFAULT NULL COMMENT 'HTTP Strict Transport Security',
    ocsp_stapling           BOOLEAN DEFAULT NULL COMMENT 'OCSP stapling present?',

    -- Dave's assessment
    dave_trust_level        ENUM('verified', 'trusted', 'neutral', 'caution', 'untrusted')
                            DEFAULT 'neutral',
    dave_notes              TEXT DEFAULT NULL,
    last_assessed           TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    INDEX idx_host (hostname),
    INDEX idx_trust (dave_trust_level),
    INDEX idx_membership (membership_type),
    UNIQUE KEY uk_hostname (hostname)
) ENGINE=InnoDB;

-- ============================================================
-- Key Rotation Log: History of public key changes
-- ============================================================

CREATE TABLE IF NOT EXISTS key_rotation_log (
    id                      BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    hostname                VARCHAR(255) NOT NULL,
    detected_at             TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    old_pubkey_hash         CHAR(64) NOT NULL,
    new_pubkey_hash         CHAR(64) NOT NULL,
    old_cert_hash           CHAR(64) DEFAULT NULL,
    new_cert_hash           CHAR(64) DEFAULT NULL,
    old_issuer              VARCHAR(1024) DEFAULT NULL,
    new_issuer              VARCHAR(1024) DEFAULT NULL,
    old_expiry              DATETIME DEFAULT NULL,
    new_expiry              DATETIME DEFAULT NULL,
    rotation_type           ENUM('scheduled_renewal', 'key_rotation', 'ca_change',
                                 'unexpected', 'revocation') DEFAULT 'unexpected',
    dave_assessment         TEXT DEFAULT NULL COMMENT 'Dave analysis of why key changed',
    alert_sent              BOOLEAN DEFAULT FALSE,

    INDEX idx_host (hostname),
    INDEX idx_detected (detected_at),
    INDEX idx_type (rotation_type)
) ENGINE=InnoDB;

-- ============================================================
-- Default fiduciary sites Dave should monitor
-- ============================================================

INSERT IGNORE INTO ssl_certificates (hostname, port, pubkey_hash, cert_hash,
    monitor_enabled, fiduciary_class, fiduciary_notes) VALUES
('github.com', 443, 'pending_first_fetch', 'pending_first_fetch', TRUE, 'critical',
 'Primary code repository platform. Source of truth for Max Rupplin projects.'),
('api.github.com', 443, 'pending_first_fetch', 'pending_first_fetch', TRUE, 'critical',
 'GitHub API endpoint. Used for Dave public voice and repository monitoring.'),
('raw.githubusercontent.com', 443, 'pending_first_fetch', 'pending_first_fetch', TRUE, 'important',
 'Raw content delivery for GitHub files. Used for source code reading.');

-- ============================================================
-- Default site authentication awareness
-- ============================================================

INSERT IGNORE INTO site_auth_awareness
    (hostname, requires_registration, requires_login, requires_payment,
     requires_credit_card, has_free_tier, membership_type, uses_https,
     dave_trust_level, dave_notes)
VALUES
('github.com', TRUE, FALSE, FALSE, FALSE, TRUE, 'freemium', TRUE, 'verified',
 'Free for public repos. Paid tiers for private repos and enterprise. Registration requires email. No credit card for free tier.'),
('news.ycombinator.com', FALSE, FALSE, FALSE, FALSE, TRUE, 'public', TRUE, 'trusted',
 'Hacker News. Fully public. Registration optional for commenting. No payment.'),
('stackoverflow.com', FALSE, FALSE, FALSE, FALSE, TRUE, 'public', TRUE, 'trusted',
 'Public Q&A. Registration optional for asking/answering. Free.'),
('en.wikipedia.org', FALSE, FALSE, FALSE, FALSE, TRUE, 'public', TRUE, 'verified',
 'Wikipedia. Fully public, no registration needed to read. Donation-funded.');

-- ============================================================
-- View: Certificates expiring soon
-- ============================================================

CREATE OR REPLACE VIEW expiring_certificates AS
SELECT hostname, not_after,
       DATEDIFF(not_after, NOW()) AS days_left,
       fiduciary_class, key_changed
FROM ssl_certificates
WHERE monitor_enabled = TRUE
  AND not_after IS NOT NULL
  AND DATEDIFF(not_after, NOW()) < 30
ORDER BY days_left ASC;

-- ============================================================
-- View: Fiduciary ledger (current state of all monitored keys)
-- ============================================================

CREATE OR REPLACE VIEW fiduciary_ledger AS
SELECT hostname, port, fiduciary_class,
       pubkey_hash, cert_hash,
       not_after,
       DATEDIFF(not_after, NOW()) AS days_left,
       key_changed, check_count,
       fetched_at AS last_fetched
FROM ssl_certificates
WHERE monitor_enabled = TRUE
ORDER BY fiduciary_class, hostname;
