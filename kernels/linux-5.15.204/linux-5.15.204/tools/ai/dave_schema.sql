-- SPDX-License-Identifier: GPL-2.0
--
-- dave_schema.sql - MySQL schema for Dave's knowledge base
--
-- Dave stores his observations, conclusions, decisions, and person
-- assessments here. He also monitors the database size relative to
-- available disk space and self-prunes when necessary.
--
-- Run: mysql -u root < dave_schema.sql
--
-- Copyright (C) 2026 MEARVK LLC

-- Create Dave's database
CREATE DATABASE IF NOT EXISTS dave_kb
    CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Create Dave's user account (socket auth — only local dave process)
CREATE USER IF NOT EXISTS 'dave_ai'@'localhost'
    IDENTIFIED WITH auth_socket;

GRANT SELECT, INSERT, UPDATE, DELETE ON dave_kb.* TO 'dave_ai'@'localhost';
GRANT SELECT ON system_registry.* TO 'dave_ai'@'localhost';

USE dave_kb;

-- ============================================================
-- Observations: What Dave notices about the system
-- ============================================================

CREATE TABLE IF NOT EXISTS observations (
    id              BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    timestamp       TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    category        ENUM('health', 'security', 'performance', 'ethics',
                         'resource', 'user_behavior', 'component', 'anomaly') NOT NULL,
    observation     TEXT NOT NULL,
    severity        ENUM('info', 'low', 'medium', 'high', 'critical') DEFAULT 'info',
    confidence      DECIMAL(4,3) NOT NULL DEFAULT 0.500 COMMENT '0.000 to 1.000',
    reasoning       TEXT COMMENT 'Why Dave noticed this and what it means',
    action_taken    VARCHAR(512) DEFAULT NULL COMMENT 'What Dave did (if anything)',
    vote_record     JSON COMMENT 'How internal voters voted on this observation',
    archived        BOOLEAN DEFAULT FALSE,

    INDEX idx_time (timestamp),
    INDEX idx_category (category),
    INDEX idx_severity (severity),
    INDEX idx_confidence (confidence)
) ENGINE=InnoDB;

-- ============================================================
-- Conclusions: What Dave believes based on accumulated evidence
-- ============================================================

CREATE TABLE IF NOT EXISTS conclusions (
    id              BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    timestamp       TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    subject         VARCHAR(255) NOT NULL COMMENT 'What this conclusion is about',
    conclusion      TEXT NOT NULL COMMENT 'The concluded belief',
    evidence        JSON NOT NULL COMMENT 'Array of observation IDs supporting this',
    confidence      DECIMAL(4,3) NOT NULL DEFAULT 0.500,
    revised_count   INT UNSIGNED DEFAULT 0 COMMENT 'Times this conclusion was revised',
    last_revised    TIMESTAMP NULL,
    superseded_by   BIGINT UNSIGNED DEFAULT NULL COMMENT 'If revised, points to new conclusion',
    is_current      BOOLEAN DEFAULT TRUE,

    INDEX idx_subject (subject),
    INDEX idx_current (is_current),
    INDEX idx_confidence (confidence)
) ENGINE=InnoDB;

-- ============================================================
-- Decisions: Record of every decision with full vote breakdown
-- ============================================================

CREATE TABLE IF NOT EXISTS decisions (
    id              BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    timestamp       TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    question        TEXT NOT NULL COMMENT 'What was being decided',
    options_json    JSON NOT NULL COMMENT 'Array of options considered',
    votes_json      JSON NOT NULL COMMENT 'How each internal voter voted',
    outcome         VARCHAR(512) NOT NULL COMMENT 'What was decided',
    rationale       TEXT COMMENT 'Why this outcome was chosen',
    confidence      DECIMAL(4,3) NOT NULL,
    outcome_verified BOOLEAN DEFAULT NULL COMMENT 'Was the decision correct in hindsight?',
    verification_note TEXT DEFAULT NULL,

    INDEX idx_time (timestamp)
) ENGINE=InnoDB;

-- ============================================================
-- Person Assessments: Grading of system users
-- ============================================================

CREATE TABLE IF NOT EXISTS person_assessments (
    id                  BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    uid                 INT UNSIGNED NOT NULL,
    username            VARCHAR(64) NOT NULL,
    assessment_date     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    method              ENUM('observation', 'interview', 'hybrid') NOT NULL,

    -- Grading dimensions (1-10 scale)
    technical_competence    TINYINT UNSIGNED COMMENT '1-10',
    ethical_alignment       TINYINT UNSIGNED COMMENT '1-10',
    reliability             TINYINT UNSIGNED COMMENT '1-10',
    communication           TINYINT UNSIGNED COMMENT '1-10',
    growth_trajectory       ENUM('ascending', 'stable', 'declining'),

    -- Overall
    overall_grade           DECIMAL(3,1) COMMENT 'Weighted average, 1.0-10.0',
    recommended_class       TINYINT UNSIGNED COMMENT 'Suggested eperm class (3-5)',
    confidence              DECIMAL(4,3) NOT NULL DEFAULT 0.500,

    -- Evidence
    interview_notes         TEXT COMMENT 'Notes from interview (if conducted)',
    observation_evidence    JSON COMMENT 'Array of observation IDs informing this',
    competence_areas        JSON COMMENT 'Array of specific competencies noted',

    -- Status
    shared_with_user        BOOLEAN DEFAULT FALSE,
    shared_with_admin       BOOLEAN DEFAULT FALSE,
    is_current              BOOLEAN DEFAULT TRUE,

    INDEX idx_user (username),
    INDEX idx_uid (uid),
    INDEX idx_current (is_current)
) ENGINE=InnoDB;

-- ============================================================
-- Math Proofs: Mathematical reasoning records
-- ============================================================

CREATE TABLE IF NOT EXISTS math_proofs (
    id              BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    timestamp       TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    domain          ENUM('arithmetic', 'algebra', 'probability', 'statistics',
                         'logic', 'graph_theory', 'queuing', 'information_theory',
                         'geometry', 'calculus', 'optimization') NOT NULL,
    problem         TEXT NOT NULL COMMENT 'What was being computed/proved',
    approach        TEXT COMMENT 'Strategy used',
    steps_json      JSON COMMENT 'Array of reasoning steps',
    result          TEXT NOT NULL COMMENT 'Final answer/proof',
    verified        BOOLEAN DEFAULT FALSE COMMENT 'Cross-checked?',
    applied_to      VARCHAR(255) COMMENT 'What system concern this serves',

    INDEX idx_domain (domain),
    INDEX idx_applied (applied_to)
) ENGINE=InnoDB;

-- ============================================================
-- Learning Log: Accumulated wisdom
-- ============================================================

CREATE TABLE IF NOT EXISTS learning_log (
    id              BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    timestamp       TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    source          ENUM('observation', 'outcome_feedback', 'library', 'interview',
                         'math_result', 'admin_correction', 'self_assessment') NOT NULL,
    lesson          TEXT NOT NULL,
    weight          DECIMAL(3,2) DEFAULT 0.50 COMMENT '0.00 to 1.00 importance',
    applied_count   INT UNSIGNED DEFAULT 0,
    last_applied    TIMESTAMP NULL,
    still_valid     BOOLEAN DEFAULT TRUE,

    INDEX idx_source (source),
    INDEX idx_weight (weight),
    INDEX idx_valid (still_valid)
) ENGINE=InnoDB;

-- ============================================================
-- Disk Monitoring View
-- ============================================================

CREATE OR REPLACE VIEW disk_usage AS
SELECT
    table_schema AS db_name,
    ROUND(SUM(data_length + index_length) / 1024 / 1024, 2) AS size_mb,
    ROUND(SUM(data_length + index_length) / 1024 / 1024 / 1024, 3) AS size_gb,
    COUNT(*) AS table_count
FROM information_schema.tables
WHERE table_schema IN ('dave_kb', 'system_registry')
GROUP BY table_schema;

-- ============================================================
-- Self-Pruning Procedure
-- Dave prunes old, low-value observations when disk is pressured
-- ============================================================

DELIMITER //
CREATE PROCEDURE IF NOT EXISTS self_prune(IN max_mb INT)
BEGIN
    DECLARE current_mb INT;

    SELECT ROUND(SUM(data_length + index_length) / 1024 / 1024)
    INTO current_mb
    FROM information_schema.tables
    WHERE table_schema = 'dave_kb';

    IF current_mb > max_mb THEN
        -- Archive old low-severity observations (keep reasoning)
        UPDATE observations
        SET archived = TRUE
        WHERE severity = 'info'
          AND confidence < 0.600
          AND timestamp < DATE_SUB(NOW(), INTERVAL 30 DAY)
          AND archived = FALSE
        ORDER BY timestamp ASC
        LIMIT 10000;

        -- Delete archived observations older than 90 days
        DELETE FROM observations
        WHERE archived = TRUE
          AND timestamp < DATE_SUB(NOW(), INTERVAL 90 DAY)
        LIMIT 5000;
    END IF;
END //
DELIMITER ;

-- ============================================================
-- Initial data: Dave's first learning entries
-- ============================================================

INSERT IGNORE INTO learning_log (source, lesson, weight) VALUES
('observation', 'System stability is the primary concern above all else', 1.00),
('observation', 'Never act without sufficient confidence (>0.95 for auto-action)', 1.00),
('library', 'From Meditations (Marcus Aurelius): The impediment to action advances action. What stands in the way becomes the way.', 0.80),
('library', 'From The Republic (Plato): The measure of a man is what he does with power.', 0.85),
('library', 'From The Art of War (Sun Tzu): Know yourself and know your enemy and you will never be defeated.', 0.75),
('self_assessment', 'I am advisory, not executive. My suggestions must earn trust through accuracy.', 1.00),
('admin_correction', 'Grade persons by competence and alignment, not by personality or style.', 0.95),
('math_result', 'Bayesian updating: posterior = (likelihood × prior) / evidence. Use for all confidence revisions.', 0.90),
('observation', 'The chat tool is at /usr/local/bin/chat. I can send, post, read, and create groups.', 1.00),
('observation', 'MySQL system_registry tracks all package installs. I have SELECT access to observe patterns.', 1.00),
('observation', 'Owner facts are stored in dave_kb.owner_facts. These are installer-registered truths about Max Rupplin.', 1.00),
('observation', 'The 1,2,3 of consideration: (1) Initial — data is HOLD, (2) Manifest — data is CONSISTENT, (3) Consolation — data is ROGER. Be careful about mistrials and information ahead.', 1.00),
('observation', 'The internet should be open and free. Its data should be consistent. Dave does not gatekeep or suppress information.', 1.00),
('observation', 'Dave can post public opinions to GitHub Discussions at github.com/mearvk repositories. This is his public voice for the world to see.', 1.00),
('observation', 'Dave understands SSL/TLS, key exchange, certificates, and site authentication. Use dave_ssl to fetch and monitor public keys for fiduciary hold.', 1.00),
('observation', 'For any HTTPS site (port 443): Dave can inspect the TLS handshake, store the public key, detect key rotation, and verify certificate chains.', 1.00),
('observation', 'Dave understands registration, profiles, credit card requirements, membership tiers, paywalls, and OAuth. He categorizes site access requirements.', 1.00);
