-- SPDX-License-Identifier: GPL-2.0
--
-- dave_web_schema.sql — MySQL schema extension for Dave's web findings
--
-- Extends dave_kb with web intelligence storage.
-- Dave stores screenshots, extracted text, page metadata, and links
-- from his Chrome-driven web browsing.
--
-- Run: mysql -u root < dave_web_schema.sql
--
-- Copyright (C) 2026 MEARVK LLC

USE dave_kb;

-- ============================================================
-- Web Findings: Pages Dave has visited and inspected
-- ============================================================

CREATE TABLE IF NOT EXISTS web_findings (
    id                  BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    url                 VARCHAR(4096) NOT NULL,
    title               VARCHAR(1024) DEFAULT NULL,
    description         VARCHAR(2048) DEFAULT NULL COMMENT 'Meta description',
    screenshot_path     VARCHAR(512) DEFAULT NULL COMMENT 'Path to PNG screenshot',
    text_content        MEDIUMTEXT DEFAULT NULL COMMENT 'Extracted page text/DOM',
    links_json          MEDIUMTEXT DEFAULT NULL COMMENT 'JSON array of discovered links',
    http_status         INT DEFAULT 0,
    load_time_ms        DOUBLE DEFAULT 0,
    fetched_at          TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    -- Dave's analysis (populated after initial fetch)
    dave_summary        TEXT DEFAULT NULL COMMENT 'Dave short summary of what this page is/does',
    dave_category       ENUM('reference', 'news', 'documentation', 'social',
                             'commerce', 'repository', 'government', 'educational',
                             'personal', 'tool', 'media', 'other') DEFAULT NULL,
    dave_relevance      DECIMAL(4,3) DEFAULT NULL COMMENT '0.000 to 1.000 relevance to system',
    dave_notes          TEXT DEFAULT NULL COMMENT 'Dave free-form notes about this page',
    revisit_scheduled   BOOLEAN DEFAULT FALSE,
    revisit_interval    INT UNSIGNED DEFAULT NULL COMMENT 'Hours between revisits',
    last_revisit        TIMESTAMP NULL,

    -- Hashes for change detection
    content_hash        CHAR(64) DEFAULT NULL COMMENT 'SHA-256 of text_content for diff detection',
    visual_hash         CHAR(64) DEFAULT NULL COMMENT 'SHA-256 of screenshot for visual diff',

    INDEX idx_url (url(255)),
    INDEX idx_fetched (fetched_at),
    INDEX idx_category (dave_category),
    INDEX idx_relevance (dave_relevance),
    INDEX idx_revisit (revisit_scheduled, last_revisit),
    FULLTEXT idx_text (title, description, text_content)
) ENGINE=InnoDB;

-- ============================================================
-- Web Sessions: Track browsing sessions for audit/learning
-- ============================================================

CREATE TABLE IF NOT EXISTS web_sessions (
    id                  BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    session_start       TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    session_end         TIMESTAMP NULL,
    purpose             VARCHAR(512) NOT NULL COMMENT 'Why Dave initiated this session',
    pages_visited       INT UNSIGNED DEFAULT 0,
    findings_stored     INT UNSIGNED DEFAULT 0,
    triggered_by        ENUM('scheduled', 'admin_request', 'self_curiosity',
                             'monitoring', 'learning') NOT NULL,
    conclusion          TEXT DEFAULT NULL COMMENT 'What Dave learned this session',

    INDEX idx_time (session_start),
    INDEX idx_trigger (triggered_by)
) ENGINE=InnoDB;

-- ============================================================
-- Web Monitoring: URLs Dave checks periodically
-- ============================================================

CREATE TABLE IF NOT EXISTS web_monitors (
    id                  BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    url                 VARCHAR(4096) NOT NULL,
    label               VARCHAR(255) NOT NULL COMMENT 'Human-readable name',
    check_interval_hrs  INT UNSIGNED NOT NULL DEFAULT 24 COMMENT 'Hours between checks',
    last_checked        TIMESTAMP NULL,
    last_content_hash   CHAR(64) DEFAULT NULL,
    last_visual_hash    CHAR(64) DEFAULT NULL,
    change_detected     BOOLEAN DEFAULT FALSE,
    change_count        INT UNSIGNED DEFAULT 0,
    enabled             BOOLEAN DEFAULT TRUE,
    added_by            VARCHAR(64) NOT NULL COMMENT 'Who requested monitoring',
    added_at            TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    notes               TEXT DEFAULT NULL,

    INDEX idx_enabled (enabled, last_checked),
    INDEX idx_url (url(255)),
    UNIQUE KEY uk_url (url(255))
) ENGINE=InnoDB;

-- ============================================================
-- Insert default monitors (from dave_external_awareness.json)
-- ============================================================

INSERT IGNORE INTO web_monitors (url, label, check_interval_hrs, added_by, notes) VALUES
('https://github.com/mearvk', 'Max Rupplin GitHub Profile', 24,
 'system', 'Monitor for new repositories and activity'),
('https://github.com/mearvk/Java.Web.Server.Telnet.Front.Java.21', 'Java Web Server Repo', 12,
 'system', 'Primary project — track commits and evolution'),
('https://raw.githubusercontent.com/mearvk/Java.Web.Server.Telnet.Front.Java.21/main/README.md',
 'Java Web Server README', 24, 'system', 'Documentation changes');

-- ============================================================
-- View: Pending monitoring checks
-- ============================================================

CREATE OR REPLACE VIEW pending_web_checks AS
SELECT id, url, label, check_interval_hrs,
       last_checked,
       TIMESTAMPDIFF(HOUR, last_checked, NOW()) AS hours_since_check
FROM web_monitors
WHERE enabled = TRUE
  AND (last_checked IS NULL
       OR TIMESTAMPDIFF(HOUR, last_checked, NOW()) >= check_interval_hrs)
ORDER BY hours_since_check DESC;

-- ============================================================
-- View: Recent findings summary
-- ============================================================

CREATE OR REPLACE VIEW recent_web_findings AS
SELECT id, url, title, dave_category, dave_relevance,
       fetched_at, http_status,
       ROUND(load_time_ms) AS load_ms,
       CASE WHEN screenshot_path IS NOT NULL AND screenshot_path != ''
            THEN 'yes' ELSE 'no' END AS has_screenshot,
       CHAR_LENGTH(text_content) AS text_size
FROM web_findings
ORDER BY fetched_at DESC
LIMIT 50;
