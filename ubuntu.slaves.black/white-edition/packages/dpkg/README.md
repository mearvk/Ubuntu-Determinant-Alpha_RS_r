# White Edition — `dpkg`

## Status

**W2 — Quality improvement target**

`dpkg` is the local package database and package transaction foundation. White Edition work therefore emphasizes integrity, recoverability, diagnostics, and reproducibility.

## White Edition objectives

- Preserve package database integrity.
- Make interrupted and failed operations understandable and recoverable.
- Maintain compatibility with Debian/Ubuntu package metadata and maintainer-script conventions.
- Improve diagnostic clarity without hiding the underlying transaction state.
- Keep provenance and package identity recoverable at every stage.
- Avoid unnecessary changes to package semantics.

## GUI relationship

`dpkg` remains a system transaction engine rather than a GUI application. A separate userland administration interface may inspect package state and initiate supported operations, but it must not bypass `dpkg`'s transaction model.

## Required evidence

- clean build against the recorded Ubuntu baseline;
- install/upgrade/remove smoke tests;
- package database consistency checks;
- interrupted transaction and recovery tests;
- malformed package metadata tests;
- maintainer-script failure-path tests;
- concurrent-operation behavior review;
- no-regression check for dependency and status queries.

## Resource economy

Record package database size, transaction duration, process behavior, and memory use where material. Integrity has priority over micro-optimization.

## Promotion condition

The package remains W2 until transaction and recovery evidence is recorded. Any change to package database format, transaction architecture, or compatibility contracts requires W3 review.

**Stewardship:** Max Rupplin — MEARVK LLC
