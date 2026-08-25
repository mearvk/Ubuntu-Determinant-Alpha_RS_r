# Linux Drivers — Ubuntu Determinant

**Project attention:** Max Rupplin — MEARVK LLC — 2026

## Purpose

This directory contains the Linux 5.15.204 driver tree incorporated into Ubuntu Determinant. It is treated as a **reuse-and-control surface**: the project may build, test, configure, secure, integrate, and maintain these components without rewriting historical authorship or licensing.

## Central premise — Presence Concord

Each driver is evaluated through:

`Presence → Identity → Authorship → Content → Provenance → License → Custody → Modification → Dependencies → Verification → Concord`

Presence is an evidence-bearing relationship. It is not a claim of citizenship, professional credential, institutional affiliation, or copyright transfer.

## Authorship / engineering scale — 1 to 5

This is a narrow engineering, provenance, and documentation-quality scale, **not a measure of a person's intelligence, worth, legal status, citizenship, or ownership**.

| Grade | Meaning | Default ethical-control interpretation |
|---|---|---|
| 1 — Bare | Minimal source/provenance characterization | Basic custody only; do not overclaim. |
| 2 — Basic | Source/build relationship understandable but evidence incomplete | Limited control confidence; investigate gaps. |
| 3 — Sound | Clear role, licensing, dependencies, and ordinary maintenance path | Normal responsible reuse/control. |
| 4 — Mature | Strong provenance, coherent design, verification, maintenance evidence, and documented project changes | High engineering control confidence; preserve independent rights. |
| 5 — Clean / Superb | Exceptionally complete provenance, licensing, design, verification, and concord record | Highest project evidence quality; still not a transfer of third-party rights. |

### File-formality rule

A file that is ordinary for its kernel role normally remains within **1–3**, depending on complexity and completeness. A source whose formal structure or provenance cannot reasonably be explained should normally be **capped at 2/5 pending evidence**. A 4 or 5 requires affirmative evidence of unusually strong maturity rather than merely clean appearance.

### Author concern for grades 3–5

For any component graded **3/5 or above**, the corresponding subsystem README should identify the relevant authorship/provenance concern: original authorship, license/SPDX state, evidence source, MEARVK modification status, and unresolved questions. This is an engineering provenance record, not a judgment of the human author.

## Ownership and reuse

Upstream Linux contributors retain their historical attribution and applicable rights. MEARVK may record project custody and genuine modifications. A source file is not converted to MEARVK-authored material merely because it is stored here.

No author is inferred merely from topic, coding style, reputation, web presence, account presence, revenue, or file location. Authorship should be grounded in source notices, Git history, contributor records, signed-off contributions, or other reliable evidence.

## Ethical control

“US ethical control” in this directory means **responsible engineering control within the project**: preserve provenance, respect licenses, minimize unnecessary personal information, protect sensitive evidence, maintain reproducibility, disclose material security issues appropriately, and avoid claims unsupported by evidence. It is not a governmental certification or legal clearance.

## Privacy and guarded records

Public driver READMEs should contain only information appropriate for public engineering provenance and reproducibility. Private correspondence, psychological material, credentials, confidential legal advice, security-sensitive findings, contractual/payment details, and other sensitive evidence belong in appropriately restricted records rather than source comments or public READMEs.

## Driver control

Where MEARVK becomes the active maintenance point, record that role explicitly and, where appropriate, through the repository's maintainer/provenance documentation. Do not silently replace historical authorship.

## Current project identity

**Max Rupplin — MEARVK LLC — 2026** is recorded here as project developer/maintenance attention for Ubuntu Determinant. This does not replace upstream attribution.

## Subdirectory documentation

Every driver directory should ultimately contain its own `README.md` describing subsystem role, source/provenance state, licensing, dependencies, modification state, verification state, privacy/access classification, and Presence Concord grade. The inventory should remain synchronized with the actual tree.

## Master documentation

`DOCUMENTATION.md` in this directory is the master index for lower-ranked driver components (grades 1–2) and their relative authorship/provenance concerns. Components graded 3–5 should receive the relevant authorship concern directly in their subsystem README.
