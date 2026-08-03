#!/bin/bash
# ═══════════════════════════════════════════════════════════════════════════════════
# NitroWebExpress™ — Dictionary™ Database Setup
# Defines all rare, new, or system-specific terms used across NWE and the OS.
# SAFE: Uses CREATE IF NOT EXISTS. Never drops or overwrites existing data.
# Installer Tech ID: Max Rupplin
# ═══════════════════════════════════════════════════════════════════════════════════
set -e

echo "[*] Creating nwe_dictionary database..."

mysql -u root -e "
CREATE DATABASE IF NOT EXISTS nwe_dictionary;
USE nwe_dictionary;

-- ───────────────────────────────────────────────────────────────────────
-- Terms: the core dictionary entries
-- ───────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS terms (
    id INT AUTO_INCREMENT PRIMARY KEY,
    term VARCHAR(128) NOT NULL UNIQUE,
    pronunciation VARCHAR(128),
    part_of_speech ENUM('noun', 'verb', 'adjective', 'adverb', 'concept', 'system', 'protocol', 'module', 'person', 'place') DEFAULT 'noun',
    definition TEXT NOT NULL,
    etymology VARCHAR(512),
    usage_example TEXT,
    related_module VARCHAR(64),
    domain VARCHAR(64),
    first_appearance VARCHAR(256),
    is_system_term BOOLEAN DEFAULT TRUE,
    is_published BOOLEAN DEFAULT TRUE,
    author VARCHAR(128) DEFAULT 'Max Rupplin',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_term (term),
    INDEX idx_domain (domain),
    INDEX idx_module (related_module),
    INDEX idx_pos (part_of_speech)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ───────────────────────────────────────────────────────────────────────
-- Domains: categorical groupings of terms
-- ───────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS domains (
    id INT AUTO_INCREMENT PRIMARY KEY,
    domain_name VARCHAR(64) NOT NULL UNIQUE,
    description VARCHAR(256),
    color VARCHAR(16),
    term_count INT DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ───────────────────────────────────────────────────────────────────────
-- Revisions: immutable edit history
-- ───────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS term_revisions (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    term_id INT NOT NULL,
    old_definition TEXT,
    new_definition TEXT,
    revised_by VARCHAR(128) DEFAULT 'Max Rupplin',
    revised_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_term (term_id),
    FOREIGN KEY (term_id) REFERENCES terms(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ───────────────────────────────────────────────────────────────────────
-- Cross-references: term relationships
-- ───────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS cross_references (
    id INT AUTO_INCREMENT PRIMARY KEY,
    from_term_id INT NOT NULL,
    to_term_id INT NOT NULL,
    relationship ENUM('synonym', 'antonym', 'related', 'parent', 'child', 'see_also', 'contrast') DEFAULT 'related',
    UNIQUE KEY uk_ref (from_term_id, to_term_id),
    FOREIGN KEY (from_term_id) REFERENCES terms(id),
    FOREIGN KEY (to_term_id) REFERENCES terms(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ═══════════════════════════════════════════════════════════════════════
-- SEED DOMAINS
-- ═══════════════════════════════════════════════════════════════════════
INSERT IGNORE INTO domains (domain_name, description, color) VALUES
    ('Spectrum', 'SpectrumTandem and TandemEquals terminology', '#cc0000'),
    ('Kernel', 'Linux kernel module and system-level terms', '#f59e0b'),
    ('Ethics', 'White Ethics, moral philosophy, system values', '#22c55e'),
    ('Intelligence', 'Dave, AI, reasoning, cognitive systems', '#3b82f6'),
    ('Security', 'HPM, ClamAV, rootkit, encryption terms', '#ef4444'),
    ('Protocol', 'EPMP, NWE TCP, network terminology', '#8b5cf6'),
    ('Identity', 'User classes, nnet, permissions, grading', '#06b6d4'),
    ('Filesystem', 'NEGAMANE, branding, immutability concepts', '#ec4899'),
    ('Module', 'NWE module-specific terminology', '#f97316'),
    ('Architecture', 'System design, build, structure terms', '#6366f1'),
    ('Mathematics', 'Simplex, matrix, curve, computational terms', '#14b8a6'),
    ('Medical', 'System health, diagnostics, certification', '#84cc16');

-- ═══════════════════════════════════════════════════════════════════════
-- SEED TERMS — Rare, new, or system-specific
-- ═══════════════════════════════════════════════════════════════════════
INSERT IGNORE INTO terms (term, pronunciation, part_of_speech, definition, etymology, usage_example, related_module, domain, first_appearance, author) VALUES

-- Spectrum / TandemEquals terms
('dolyene', 'DOL-ee-een', 'noun',
 'The spectrum of int discipline; the graphical representation of term usage frequency across radix conditions and spelling variants.',
 'Coined for NWE SpectrumTandem. Origin: synthesis of \"dolly\" (gentle movement) + \"-ene\" (substance/essence).',
 'The dolyene of \"spectrum\" shows 95% usage in lowercase, 70% in title case.',
 'SpectrumTandem', 'Spectrum', 'SpectrumTandem v1.0 (July 2026)', 'Max Rupplin'),

('saimptom', 'SAME-tom', 'noun',
 'A choice where both ends are not yet obvious to the chooser. A symptom of decision where the resolution has not collapsed. Merely a choice, but not both ends apparent.',
 'Portmanteau of \"same\" + \"symptom\". Both sides look the same until resolution.',
 'The career saimptom resolved after 12 answers revealed the mono mind was hiding the lateral option.',
 'TandemEquals', 'Spectrum', 'TandemEquals kernel module v1.0 (Aug 2026)', 'Max Rupplin'),

('stereo mind', 'STAIR-ee-oh mind', 'concept',
 'The balanced, two-channel perception that sees real choices and province wisdoms simultaneously. Contrast: mono mind (collapsed single-track thinking that sees only one path).',
 'Audio metaphor. Stereo = two channels. Mono = one channel. Applied to cognitive state.',
 'After 12 answers, TandemEquals restored stereo mind — both career paths were now simultaneously visible.',
 'TandemEquals', 'Spectrum', 'TandemEquals kernel module v1.0 (Aug 2026)', 'Max Rupplin'),

('province wisdom', 'PROV-ince WIZ-dom', 'noun',
 'Wisdom specific to your situation — your province of life. Not universal truth but YOUR truth for YOUR context. Hidden by overconfidence because overconfidence insists on universal answers.',
 'Province = local territory. Wisdom that applies HERE, to YOU, NOW.',
 'Province wisdom: \"In Durham, the lateral career path IS the main path. The straight path is noise here.\"',
 'TandemEquals', 'Spectrum', 'TandemEquals kernel module v1.0 (Aug 2026)', 'Max Rupplin'),

('equal noise', 'EE-kwul noyz', 'noun',
 'The residual ambiguity that remains after saimptom resolution. Made visible and equalized so the person can see what they were dismissing. Not random — it is the other channel that mono mind hid.',
 'What the unkind mind calls \"noise\" is actually valid signal from the other channel.',
 'Equal noise of 420/1000 means 42% genuine ambiguity remains — both options still have real merit.',
 'TandemEquals', 'Spectrum', 'TandemEquals kernel module v1.0 (Aug 2026)', 'Max Rupplin'),

('tandem pass', 'TAN-dem pass', 'noun',
 'The bidirectional matrix computation where each row i sums matrix[i][j] * matrix[j][i]. Consideration × consequence evaluated in lockstep. Produces the choice/noise separation.',
 'Tandem = together. Pass = single traversal. The matrix reads forward AND backward simultaneously.',
 'The tandem pass showed axis 17 as dominant — career creativity scored highest bidirectionally.',
 'TandemEquals', 'Mathematics', 'TandemEquals kernel module v1.0 (Aug 2026)', 'Max Rupplin'),

('radix', 'RAY-dix', 'noun',
 'The root or base form of a term from which spelling variants derive. In SpectrumTandem, the radix anchors a word family.',
 'Latin: radix = root.',
 'Radix \"doly\" anchors: dolyene, Dolyene, DOLYENE, dolyenic.',
 'SpectrumTandem', 'Spectrum', 'SpectrumTandem v1.0 (July 2026)', 'Max Rupplin'),

-- Kernel / System terms
('negamane', 'NEG-ah-mah-nay', 'noun',
 'An immutable filesystem brand. Once applied, a path cannot be altered, deleted, or created into. Only Grade 7+ admin can release. Permanent protective treatment.',
 'Portmanteau suggesting negation of maneuvering — cannot be manipulated.',
 'negamane /home/user/important/ brands the directory as permanently immutable.',
 'Kernel', 'Filesystem', 'Ubuntu Determinant Alpha RS Edition 98 (2026)', 'Max Rupplin'),

('sudo_gate', 'SOO-doh gate', 'system',
 'An 8-level graded privilege system. Standard sudo for grades 1-6. \"touch system\" for grade 7 (critical). \"touch system gate\" for grade 8 (irreversible). Friction proportional to danger.',
 'sudo (superuser do) + gate (controlled passage). The gate IS the friction.',
 'sudo touch system gate dd if=/dev/zero of=/dev/sda requires explicit gate acknowledgment.',
 'Kernel', 'Security', 'Ubuntu Determinant Alpha RS Edition 98 (2026)', 'Max Rupplin'),

('epmp', 'E-P-M-P', 'protocol',
 'Extended Port Multiplexing Protocol. Service on TCP port 64444 that routes traffic to extended ports beyond 2^16 (up to 30 quintillion). Supports DH/RSA handshake and encrypted/raw/hybrid modes.',
 'Extended Port Multiplexing Protocol. Acronym.',
 'EPMP frame header: 42 bytes. Magic: 0x45504D50.',
 'Kernel', 'Protocol', 'Ubuntu Determinant Alpha RS Edition 98 (2026)', 'Max Rupplin'),

('hpm', 'H-P-M', 'system',
 'Heuristic Port Monitor. Three-stage security pipeline (Protocol Framing → Behavioral Heuristics → Response Graphing) for all ports with safety scoring at each stage.',
 'Heuristic Port Monitor. Acronym.',
 'HPM detected a NULL scan pattern — stealth probe blocked at pipe 2.',
 'Kernel', 'Security', 'Ubuntu Determinant Alpha RS Edition 98 (2026)', 'Max Rupplin'),

-- Ethics / Philosophy terms
('white ethics', 'wyte ETH-iks', 'concept',
 'A system-level presence covering the software in a careful aura of elegance and future. Properties: careful, brave, heuristic, elegant, future-facing, calming. The installer grade certifies ethical standing.',
 'White = purity of intent. Ethics = system of moral principle.',
 'During the glow cycle, the system radiates white ethics — the creatures feel calmed.',
 'Kernel', 'Ethics', 'Ubuntu Determinant Alpha RS Edition 98 (2026)', 'Max Rupplin'),

('glow cycle', 'gloh SY-kul', 'noun',
 'A 2-hour period (every 8-36 hours, naturally timed) when the system asserts its health, ethics, and forward presence. The system glows white. Ethics remain active between cycles.',
 'The periodic heartbeat of the White Ethics system.',
 'cat /proc/white_ethics/glow → ◉ GLOWING WHITE. The system is careful.',
 'Kernel', 'Ethics', 'Ubuntu Determinant Alpha RS Edition 98 (2026)', 'Max Rupplin'),

-- Intelligence terms
('palladium grooves', 'pah-LAY-dee-um groovz', 'system',
 'PalladiumGrooves III: Social characterizability scoring in Pi ratio to TandemEquals. 132 groove channels (Pi × 42). Scores -50 to +50. Catches output from TandemEquals choice/noise vectors.',
 'Palladium = precious, stable element. Grooves = channels of analysis.',
 'PalladiumGrooves scored +32 characterizability — outward guesses are socially legible.',
 'TandemEquals', 'Intelligence', 'Ubuntu Determinant Alpha RS Edition 98 (Aug 2026)', 'Max Rupplin'),

('mill matter', 'mill MAT-er', 'noun',
 'PalladiumGrooves IV concept: raw intellectual processables ingested from upstream modules. The mill identifies INT advantages, replaces similars with easier equivalents, and produces forward vectors.',
 'Mill = processing grinder. Matter = substance to be worked.',
 'Mill matter from TandemEquals showed 3 processables ready for advancement (forward score > 80).',
 'TandemEquals', 'Intelligence', 'Ubuntu Determinant Alpha RS Edition 98 (Aug 2026)', 'Max Rupplin'),

('rebate certificate', 'REE-bayt ser-TIF-ih-kit', 'noun',
 'RebateCertificates VIII: identifies longs that look like unnecessaries, checks moral equations, produces Save Me clearances. Cost: 2.25x standard lifetime INT and drift. Costs do NOT reciprocate.',
 'Rebate = return of excess cost. Certificate = formal clearance document.',
 'Rebate certificate issued: the long was indeed unnecessary. Person cleared at no moral cost.',
 'TandemEquals', 'Intelligence', 'Ubuntu Determinant Alpha RS Edition 98 (Aug 2026)', 'Max Rupplin'),

-- Identity / Permission terms
('genius class', 'JEEN-yus klass', 'noun',
 'Permission Class 5. Works freely FOR the system. Not an audit item. Has graduated from auditor class. Supreme-tier access logged for institutional record only.',
 'Genius = exceptional innate capacity. Class = permission tier.',
 'Genius class users bypass DAC entirely. Their work is transparent by nature.',
 'Kernel', 'Identity', 'Ubuntu Determinant Alpha RS Edition 98 (2026)', 'Max Rupplin'),

('trusted class', 'TRUST-ed klass', 'noun',
 'Permission Class 4. Bypasses DAC entirely with light audit trail (access counter). Has established alignment with system integrity. Simple to trace.',
 'Trusted = established reliability. Class = permission tier.',
 'echo \"1000 4 alice\" > /proc/eperm/register — registers alice as Trusted.',
 'Kernel', 'Identity', 'Ubuntu Determinant Alpha RS Edition 98 (2026)', 'Max Rupplin'),

('hobby hole', 'HOB-ee hole', 'noun',
 'A RAM-backed identity space (4-44 MB per user) that grows with adequacy and functional tenure. Part of the nnet identity system.',
 'Hobby = personal interest space. Hole = allocated memory region.',
 'The hobby hole for mearvk grew to 44MB after 3 years of functional tenure.',
 'Kernel', 'Identity', 'Ubuntu Determinant Alpha RS Edition 98 (2026)', 'Max Rupplin'),

-- Module / NWE terms
('strernary', 'STRER-nah-ree', 'noun',
 'The NWE deep inference AI engine. DJL/PyTorch/DistilBERT. Provides ASK, CLASSIFY, TRAIN, RELAY commands. Port 20000 (inference) + Port 2000 (directory).',
 'Coined term. Tri-fold reasoning: structure + ternary + arbitrary.',
 'StrernaryConnector.askHardened() sends trust-aware queries with full metadata.',
 'Strernary', 'Module', 'NitroWebExpress v1.0 (2026)', 'Max Rupplin'),

('cd1 connector', 'see-dee-wun kon-EK-tor', 'system',
 'A circular button (80px desktop / 100px mobile) on every BMA JSP page that opens a floating dialog for TCP protocol interaction. Supports direct port and Strernary routing modes.',
 'CD1 = Connector Dialog 1. First-generation protocol interface button.',
 'Click the CD1 button → select Connect → choose direct port → send STATUS.',
 'Brarner.M.Alete', 'Module', 'Brarner.M.Alete servlets (July 2026)', 'Max Rupplin'),

('memory grain', 'MEM-oh-ree grayn', 'noun',
 'A 3-tier classification for per-user kernel objects: Grain 1 (user space, 4MB, anyone), Grain 2 (safety space, 16MB, sudo 1+), Grain 3 (kernel space, 64MB, sudo 4+). Grains 1-2 bypass secure boot.',
 'Grain = level of fineness/access. Memory = allocated kernel space.',
 'install --grain=2 my_service loads into safety space without triggering secure boot.',
 'Kernel', 'Architecture', 'Ubuntu Determinant Alpha RS Edition 98 (2026)', 'Max Rupplin'),

-- Architecture terms
('simplex', 'SIM-pleks', 'noun',
 'In TandemEquals: the traced path from perception through cognition and modulation to expression. A single traversal through all four layers. Simplex value = integrated signal strength.',
 'Mathematical: a simplex is the simplest polytope in any dimension. Here: simplest complete path.',
 'Control curve \"Focus→Decision\" has simplex value 0.88 — strong traversal.',
 'TandemEquals', 'Mathematics', 'TandemEquals web module (Aug 2026)', 'Max Rupplin'),

('control curve', 'kon-TROHL kurv', 'noun',
 'A complete path through the 4-layer modulator: perception → cognition → modulation → expression. Maps one intake signal through processing and shaping to final output. Measured by simplex value and stability.',
 'Control = governed/directed. Curve = the trajectory through layer space.',
 'The \"Data→Logic→Output\" control curve has 0.98 stability — highly consistent.',
 'TandemEquals', 'Mathematics', 'TandemEquals web module (Aug 2026)', 'Max Rupplin'),

('int discipline', 'int DIS-ih-plin', 'noun',
 'The integer classification system governing term ordering and spectral weight within SpectrumTandem. Each term has an int discipline index determining its position in the dolyene.',
 'Int = integer (mathematical). Discipline = ordered system of classification.',
 'The int discipline of \"dolyene\" is 1 — primary position in its own spectrum.',
 'SpectrumTandem', 'Spectrum', 'SpectrumTandem v1.0 (July 2026)', 'Max Rupplin');
"

echo "[OK] nwe_dictionary database ready."
echo "     4 tables: terms, domains, term_revisions, cross_references"
echo "     12 domains seeded. 25 terms defined."
echo "     Installer Tech ID: Max Rupplin"
