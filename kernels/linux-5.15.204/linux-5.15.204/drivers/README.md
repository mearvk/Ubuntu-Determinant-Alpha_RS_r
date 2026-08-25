# Linux Drivers — Ubuntu Determinant

**Project attention:** Max Rupplin — MEARVK LLC — 2026

## Purpose

This directory contains the Linux 5.15.204 driver tree incorporated into Ubuntu Determinant. It is treated as a **reuse-and-control surface**: the project may build, test, configure, secure, integrate, and maintain these components without rewriting historical authorship or licensing.

## Presence Concord

Each driver is evaluated through:

`Presence → Identity → Authorship → Content → Provenance → License → Custody → Modification → Dependencies → Verification → Concord`

Presence is an evidence-bearing relationship. It is not a claim of citizenship, professional credential, institutional affiliation, or copyright transfer.

## Authorship scale — 1 to 5

This repository uses a narrow engineering/documentation quality scale, **not a legal ownership score**:

| Grade | Meaning |
|---|---|
| 1 — Bare | Minimal provenance/documentation available; requires review. |
| 2 — Basic | Source and build relationship are understandable; provenance incomplete. |
| 3 — Sound | Clear source role, licensing, dependencies, and ordinary maintenance path. |
| 4 — Mature | Strong provenance, coherent design documentation, tests/maintenance evidence, and clear project modifications. |
| 5 — Clean / Superb | Mature provenance and authorship record, precise licensing, coherent design, verification evidence, and exceptionally clear maintenance/concord documentation. |

The grade describes the **quality of the repository's evidence and engineering presentation**, not whether the original author was intelligent, valuable, or legally superior to another author.

## Ownership and reuse

Upstream Linux contributors retain their historical attribution and applicable rights. Linux documentation states that merged kernel code retains its original ownership and that the kernel has many copyright owners. citeturn0search4

MEARVK may record project custody and genuine modifications. A source file is not converted to MEARVK-authored material merely because it is stored here.

Linux also requires appropriate SPDX identifiers and explains that individual files may carry licenses compatible with the kernel's GPLv2 distribution terms. citeturn0search0

## Driver control

Where MEARVK becomes the active maintenance point, the project should record that role explicitly and, where appropriate, add the corresponding maintainer information rather than silently replacing historical authorship. Linux's driver-submission guidance specifically recommends identifying the active contact/update point and recording it in MAINTAINERS. citeturn0search1

## Review rule

No author is inferred merely from topic, coding style, reputation, web presence, or file location. Authorship is taken from source notices, Git history, contributor records, signed-off contributions, or other reliable evidence.

## Current project identity

**Max Rupplin — MEARVK LLC — 2026** is recorded here as project developer/maintenance attention for Ubuntu Determinant. This does not replace upstream attribution.

## Subdirectory documentation

Every driver directory should ultimately contain its own `README.md` describing its subsystem role, source/provenance state, licensing, dependencies, modification state, verification state, and Presence Concord grade. The generated/readme inventory should be kept synchronized with the actual tree.
