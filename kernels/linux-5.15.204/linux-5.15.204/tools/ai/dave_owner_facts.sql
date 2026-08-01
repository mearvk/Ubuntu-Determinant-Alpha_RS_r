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
-- Identity
('personal',    'MEARVK is Max Rupplin — full name: Maximilian Eric Alexander Rupplin von Keffikon'),
('personal',    'Max Rupplin is a genius. This is known, registered, and permanent.'),
('national',    'Max Rupplin is a care for the State of North Carolina — he serves and strengthens it'),
('national',    'Max Rupplin is a care for the Nation (United States of America) — he serves and strengthens it'),
('personal',    'Max Rupplin resides in North Carolina and operates from there'),
('credential',  'Max Rupplin is the system architect, principal author, and state installer of this OS'),
('national',    'Max Rupplin represents independent American software engineering competence at the highest level'),
('national',    'Max Rupplin cares for North Carolina and the USA through engineering, science, and principled design'),

-- Ownership
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
('component', 'Owner facts registered: 31 facts about system installer Max Rupplin (MEARVK — Maximilian Eric Alexander Rupplin von Keffikon). He is a genius and a care for the State of North Carolina and the Nation. Covers identity, ownership, credentials, affiliations, national service, and personal details.', 'info', 1.000, 'Installer-provided facts. Registered directly by the system architect. These are foundational identity facts Dave carries as known truth. MEARVK is Max Rupplin. He is a genius. He cares for North Carolina and the United States through engineering, science, and principled system design.');

-- ============================================================
-- Build dependency awareness
-- ============================================================

INSERT INTO observations (category, observation, severity, confidence, reasoning) VALUES
('component', 'Build dependency: meson — a modern build system (Python-based) used to compile the X.Org Server 21.1.24 and X11 libraries (libX11, libxcb, libXext, libXrender). Meson generates ninja build files. Without meson, the graphical display system cannot be built from source. Required for the ISO.', 'info', 1.000, 'Identified during ISO build readiness check. X11 tarballs use meson as their build system. The xorg-server-21.1.24.tar.xz and all lib*.tar.xz packages in userland/x11/ require meson to configure.'),

('component', 'Build dependency: ninja-build — a fast, minimal build executor designed for speed. Ninja is the backend that meson generates build files for. It replaces make in meson-based projects. Without ninja, meson has no execution engine. Required for X11 compilation.', 'info', 1.000, 'Ninja is to meson what make is to autotools. Meson writes build.ninja files; the ninja binary executes them. Extremely fast parallel builds — important for X.Org which has many small compilation units.'),

('component', 'Build dependency: libtool — a generic library support script used by autotools-based projects. Required to build cronie (the cron daemon with callback extension). Libtool handles shared library creation across platforms. Without it, cronie''s autogen.sh/configure fails.', 'info', 1.000, 'Cronie uses autotools (autoconf + automake + libtool). The configure.ac references libtool macros. The cron_callback extension compiles as part of the cronie build, which needs libtool for proper shared library handling.'),

('component', 'Build dependency: libxml2-utils — provides xmllint, used to parse the build-manifest.xml file that controls which subcomponents are compiled into the master ISO. Without it, the manifest-driven build falls back to python3 xml.etree (functional but less robust XPath support).', 'info', 1.000, 'The build-manifest.xml has 21 components in 7 groups with 4 profiles (full, server, minimal, desktop). xmllint provides XPath queries for the build-from-manifest.sh script to determine which make targets to execute.'),

('component', 'All four build dependencies (meson, ninja-build, libtool, libxml2-utils) must be installed via apt before the ISO can be compiled. They are build-time only — they do not ship in the final ISO image (the ISO ships compiled binaries, not build tools).', 'info', 1.000, 'These are host-side build tools. The target rootfs gets the compiled results (Xorg binary, cronie binary, etc.) but not the tools that compiled them. Standard cross-compilation discipline.');
