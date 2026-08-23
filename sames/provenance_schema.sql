PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS artifact (
    artifact_id TEXT PRIMARY KEY,
    release_name TEXT NOT NULL,
    sha256 TEXT NOT NULL,
    artifact_type TEXT NOT NULL,
    created_at_utc TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS observation (
    observation_id INTEGER PRIMARY KEY AUTOINCREMENT,
    artifact_id TEXT NOT NULL REFERENCES artifact(artifact_id),
    observed_at_utc TEXT NOT NULL,
    host_id TEXT NOT NULL,
    actor TEXT NOT NULL,
    source TEXT NOT NULL,
    evidence_ref TEXT NOT NULL,
    FOREIGN KEY (artifact_id) REFERENCES artifact(artifact_id)
);

CREATE TABLE IF NOT EXISTS custody_assertion (
    assertion_id INTEGER PRIMARY KEY AUTOINCREMENT,
    artifact_id TEXT NOT NULL REFERENCES artifact(artifact_id),
    jurisdiction_code TEXT NOT NULL,
    custody_status TEXT NOT NULL CHECK (
        custody_status IN ('claimed', 'observed', 'verified', 'rejected', 'unknown')
    ),
    basis TEXT NOT NULL,
    asserted_at_utc TEXT NOT NULL,
    asserted_by TEXT NOT NULL,
    evidence_ref TEXT NOT NULL,
    review_status TEXT NOT NULL DEFAULT 'unreviewed' CHECK (
        review_status IN ('unreviewed', 'reviewed', 'contested')
    )
);

CREATE TABLE IF NOT EXISTS evidence (
    evidence_ref TEXT PRIMARY KEY,
    evidence_type TEXT NOT NULL,
    sha256 TEXT NOT NULL,
    captured_at_utc TEXT NOT NULL,
    storage_ref TEXT NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_observation_artifact
    ON observation(artifact_id);
CREATE INDEX IF NOT EXISTS idx_custody_artifact
    ON custody_assertion(artifact_id);
CREATE INDEX IF NOT EXISTS idx_custody_jurisdiction
    ON custody_assertion(jurisdiction_code);

-- A row stating jurisdiction_code='US' records an assertion concerning the
-- United States. It is not, by itself, proof of U.S. ownership, origin,
-- custody, governmental authority, or legal title. Those conclusions require
-- independently reviewable evidence.
