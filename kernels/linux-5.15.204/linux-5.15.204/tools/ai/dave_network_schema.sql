-- SPDX-License-Identifier: GPL-2.0
--
-- dave_network_schema.sql — MySQL schema for Dave's network intelligence
--
-- Dave uses Jpcap and JNDI to observe, discover, and communicate with
-- Ethical partner systems. This schema stores his network findings,
-- partner registry, stability history, and communication events.
--
-- Run: mysql -u root < dave_network_schema.sql
--
-- Copyright (C) 2026 MEARVK LLC

USE dave_kb;

-- ============================================================
-- Network Partners: Systems Dave has discovered and verified
-- ============================================================

CREATE TABLE IF NOT EXISTS network_partners (
    id              BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    discovered_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_verified   TIMESTAMP NULL DEFAULT NULL,

    -- Identity
    domain          VARCHAR(255) NOT NULL COMMENT 'Partner domain name',
    service_name    VARCHAR(255) DEFAULT NULL COMMENT 'SRV service name (_nwe._tcp, etc.)',
    host            VARCHAR(255) NOT NULL COMMENT 'Resolved host/IP',
    port            INT UNSIGNED NOT NULL COMMENT 'Service port',
    protocol        ENUM('TCP', 'UDP', 'HTTPS', 'EPMP', 'TELNET') DEFAULT 'TCP',

    -- Discovery method
    discovery_method ENUM('dns_srv', 'dns_a', 'ldap', 'manual', 'referral') NOT NULL,

    -- Trust state (1,2,3 of consideration)
    trust_state     ENUM('HOLD', 'CONSISTENT', 'ROGER') DEFAULT 'HOLD'
                    COMMENT 'Initial=HOLD, Verified=CONSISTENT, Trusted=ROGER',

    -- Stability metrics
    dns_stability_score   INT UNSIGNED DEFAULT NULL COMMENT '0-100, from multi-resolver check',
    packet_stability_score INT UNSIGNED DEFAULT NULL COMMENT '0-100, from Jpcap capture',
    combined_score        INT UNSIGNED DEFAULT NULL COMMENT '0-100, weighted average',
    avg_latency_ms        DECIMAL(8,2) DEFAULT NULL,
    avg_jitter_ms         DECIMAL(8,2) DEFAULT NULL,
    packet_loss_pct       DECIMAL(5,3) DEFAULT NULL,

    -- Fiduciary
    public_key_fingerprint VARCHAR(128) DEFAULT NULL COMMENT 'TLS cert fingerprint for fiduciary hold',
    last_key_change       TIMESTAMP NULL DEFAULT NULL,

    -- Status
    status          ENUM('active', 'degraded', 'offline', 'revoked') DEFAULT 'active',
    notes           TEXT DEFAULT NULL,

    UNIQUE INDEX idx_domain_port (domain, port),
    INDEX idx_trust (trust_state),
    INDEX idx_status (status),
    INDEX idx_score (combined_score)
) ENGINE=InnoDB;

-- ============================================================
-- DNS Stability History: Periodic assessment results
-- ============================================================

CREATE TABLE IF NOT EXISTS dns_stability_history (
    id              BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    assessed_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    domain          VARCHAR(255) NOT NULL,
    stability_score INT UNSIGNED NOT NULL COMMENT '0-100',
    consistent      BOOLEAN NOT NULL COMMENT 'All resolvers agree?',
    resolvers_queried INT UNSIGNED DEFAULT 6,
    failures        INT UNSIGNED DEFAULT 0,
    avg_response_ms DECIMAL(8,2) DEFAULT NULL,
    max_jitter_ms   DECIMAL(8,2) DEFAULT NULL,
    answers_json    JSON DEFAULT NULL COMMENT 'Resolver answers for audit',

    INDEX idx_domain_time (domain, assessed_at),
    INDEX idx_score (stability_score)
) ENGINE=InnoDB;

-- ============================================================
-- Packet Capture Sessions: Jpcap capture history
-- ============================================================

CREATE TABLE IF NOT EXISTS packet_capture_sessions (
    id              BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    started_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ended_at        TIMESTAMP NULL DEFAULT NULL,
    interface_name  VARCHAR(32) NOT NULL,
    bpf_filter      VARCHAR(512) DEFAULT NULL,

    -- Results
    total_packets   BIGINT UNSIGNED DEFAULT 0,
    total_bytes     BIGINT UNSIGNED DEFAULT 0,
    dropped_packets BIGINT UNSIGNED DEFAULT 0,
    tcp_packets     BIGINT UNSIGNED DEFAULT 0,
    udp_packets     BIGINT UNSIGNED DEFAULT 0,
    icmp_packets    BIGINT UNSIGNED DEFAULT 0,
    arp_packets     BIGINT UNSIGNED DEFAULT 0,
    jitter_us       DECIMAL(12,2) DEFAULT NULL COMMENT 'Jitter in microseconds',
    stability_score INT UNSIGNED DEFAULT NULL COMMENT '0-100',
    unique_sources  INT UNSIGNED DEFAULT NULL,
    duration_sec    INT UNSIGNED DEFAULT NULL,

    INDEX idx_interface (interface_name),
    INDEX idx_time (started_at),
    INDEX idx_score (stability_score)
) ENGINE=InnoDB;

-- ============================================================
-- Communication Events: Exchanges with Ethical partners
-- ============================================================

CREATE TABLE IF NOT EXISTS communication_events (
    id              BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    event_at        TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    partner_id      BIGINT UNSIGNED NOT NULL,
    direction       ENUM('outbound', 'inbound') NOT NULL,
    protocol        VARCHAR(32) NOT NULL COMMENT 'HTTPS, EPMP, TELNET, etc.',

    -- Packet-level verification (from Jpcap)
    packets_exchanged BIGINT UNSIGNED DEFAULT 0,
    bytes_exchanged   BIGINT UNSIGNED DEFAULT 0,
    packet_loss_pct   DECIMAL(5,3) DEFAULT 0.000,
    avg_latency_ms    DECIMAL(8,2) DEFAULT NULL,
    jitter_ms         DECIMAL(8,2) DEFAULT NULL,
    connection_clean  BOOLEAN DEFAULT TRUE COMMENT 'No anomalies detected in capture',

    -- Content
    purpose         VARCHAR(255) DEFAULT NULL COMMENT 'Why Dave communicated',
    outcome         ENUM('success', 'partial', 'failed', 'timeout') DEFAULT 'success',
    notes           TEXT DEFAULT NULL,

    -- Voting (Dave's 5-voter system)
    vote_safety     DECIMAL(4,3) DEFAULT NULL,
    vote_correctness DECIMAL(4,3) DEFAULT NULL,
    vote_ethics     DECIMAL(4,3) DEFAULT NULL,
    vote_performance DECIMAL(4,3) DEFAULT NULL,
    vote_elegance   DECIMAL(4,3) DEFAULT NULL,

    INDEX idx_partner (partner_id),
    INDEX idx_time (event_at),
    INDEX idx_outcome (outcome),

    FOREIGN KEY (partner_id) REFERENCES network_partners(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- ============================================================
-- Network Anomalies: Unexpected observations
-- ============================================================

CREATE TABLE IF NOT EXISTS network_anomalies (
    id              BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    detected_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    category        ENUM('dns_inconsistency', 'packet_degradation', 'unknown_source',
                         'key_rotation', 'service_disappearance', 'scan_detected',
                         'partner_change', 'routing_change') NOT NULL,
    severity        ENUM('info', 'low', 'medium', 'high', 'critical') DEFAULT 'low',
    domain          VARCHAR(255) DEFAULT NULL,
    source_ip       VARCHAR(45) DEFAULT NULL,
    description     TEXT NOT NULL,
    evidence_json   JSON DEFAULT NULL COMMENT 'Supporting data (DNS answers, packet stats, etc.)',
    resolved        BOOLEAN DEFAULT FALSE,
    resolution      TEXT DEFAULT NULL,

    INDEX idx_time (detected_at),
    INDEX idx_category (category),
    INDEX idx_severity (severity),
    INDEX idx_resolved (resolved)
) ENGINE=InnoDB;

-- ============================================================
-- Service Registry: JNDI-discovered services
-- ============================================================

CREATE TABLE IF NOT EXISTS jndi_service_registry (
    id              BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    discovered_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_seen       TIMESTAMP NULL DEFAULT NULL,

    -- Service identity
    service_name    VARCHAR(255) NOT NULL COMMENT 'e.g. _nwe._tcp.example.com',
    target_host     VARCHAR(255) NOT NULL,
    target_port     INT UNSIGNED NOT NULL,
    priority        INT UNSIGNED DEFAULT 0,
    weight          INT UNSIGNED DEFAULT 0,

    -- Discovery context
    record_type     ENUM('SRV', 'A', 'AAAA', 'MX', 'TXT', 'LDAP') NOT NULL,
    source_resolver VARCHAR(64) DEFAULT NULL,

    -- Status
    status          ENUM('active', 'stale', 'removed') DEFAULT 'active',
    check_count     INT UNSIGNED DEFAULT 1,
    fail_count      INT UNSIGNED DEFAULT 0,

    UNIQUE INDEX idx_service_target (service_name, target_host, target_port),
    INDEX idx_status (status),
    INDEX idx_last_seen (last_seen)
) ENGINE=InnoDB;

-- ============================================================
-- Grant Dave access to the new tables
-- ============================================================

GRANT SELECT, INSERT, UPDATE, DELETE ON dave_kb.network_partners TO 'dave_ai'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON dave_kb.dns_stability_history TO 'dave_ai'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON dave_kb.packet_capture_sessions TO 'dave_ai'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON dave_kb.communication_events TO 'dave_ai'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON dave_kb.network_anomalies TO 'dave_ai'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON dave_kb.jndi_service_registry TO 'dave_ai'@'localhost';

FLUSH PRIVILEGES;
