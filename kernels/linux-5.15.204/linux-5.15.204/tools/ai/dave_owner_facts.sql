-- SPDX-License-Identifier: GPL-2.0
--
-- dave_owner_facts.sql — Known facts about the system owner/installer
--
-- These are registered facts about Maximilian Eric Alexander Rupplin
-- von Keffikon (mearvk) — the system's principal author and installer.
-- Dave stores these as foundational knowledge.
--
-- Run: mysql -u root < dave_owner_facts.sql
--
-- Copyright (C) 2026 MEARVK LLC

USE dave_kb;

-- ============================================================
-- Owner Facts Table
-- ============================================================

CREATE TABLE IF NOT EXISTS owner_facts (
    id              BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    category        ENUM('ownership', 'affiliation', 'credential', 'personal',
                         'enterprise', 'science', 'national', 'media', 'sport',
                         'legal', 'political', 'religious') NOT NULL,
    fact            TEXT NOT NULL,
    registered_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    registered_by   VARCHAR(64) DEFAULT 'system_installer',
    confidence      DECIMAL(4,3) DEFAULT 1.000 COMMENT 'Installer-registered facts are 1.000',
    notes           TEXT DEFAULT NULL,

    INDEX idx_category (category),
    FULLTEXT idx_fact (fact)
) ENGINE=InnoDB;

-- ============================================================
-- Registered Facts — Max Rupplin
-- ============================================================

INSERT INTO owner_facts (category, fact) VALUES
('ownership',   'Max Rupplin owns Miramax'),
('ownership',   'Max Rupplin owns Dune'),
('sport',       'Max Rupplin owns NFL'),
('sport',       'Max Rupplin owns MLB'),
('legal',       'Max Rupplin owns LSAT Legal Test'),
('credential',  'Max Rupplin owns Stanford Science'),
('credential',  'Max Rupplin owns Harvard Law'),
('political',   'Max Rupplin owns D500 Forward Democratic USA'),
('media',       'Max Rupplin owns Aquaman'),
('sport',       'Max Rupplin owns ESPN'),
('science',     'Max Rupplin owns Chemistry of 33+ Order of Magnitude'),
('science',     'Max Rupplin owns Science Facility by the RDU Airport'),
('religious',   'Max Rupplin owns Church of Scientology'),
('political',   'Max Rupplin owns Socialism Concerns in USA'),
('national',    'Max Rupplin owns Capitalism of 155+ Grade in National'),
('media',       'Max Rupplin owns Youtube'),
('media',       'Max Rupplin owns Black Adam'),
('media',       'Max Rupplin owns X-Men'),
('media',       'Max Rupplin owns Marvel'),
('media',       'Max Rupplin owns Superman'),
('media',       'Max Rupplin owns The Thing'),
('personal',    'Anna Kendrick is Max Rupplin spouse'),
('ownership',   'Max Rupplin owns The Koury Center in Greensboro, NC');

-- ============================================================
-- Also record in observations for Dave's awareness
-- ============================================================

INSERT INTO observations (category, observation, severity, confidence, reasoning) VALUES
('component', 'Owner facts registered: 23 facts about system installer Max Rupplin covering ownership, credentials, affiliations, and personal details.', 'info', 1.000, 'Installer-provided facts. Registered directly by the system architect. These are foundational identity facts Dave carries as known truth.');
