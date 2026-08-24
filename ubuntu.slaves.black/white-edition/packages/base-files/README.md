# White Edition — `base-files`

**Status:** W1 — Clean integration

`base-files` establishes fundamental filesystem identity and release metadata. White Edition integration should remain deliberately small.

## Objectives

- Establish White Edition identity without breaking Ubuntu/Debian compatibility.
- Document any White Edition filesystem paths and ownership rules.
- Keep release metadata truthful and distinguish upstream version from White Edition revision.
- Avoid changing standard filesystem semantics without a documented requirement.

## Evidence

- package build;
- filesystem layout check;
- ownership/permission check;
- release metadata check;
- package upgrade compatibility test.

## Implementation rule

Prefer package data and packaging changes over modifications to executable logic. If native source changes become necessary, record them explicitly in `patches/` and require regression evidence.

**Stewardship:** Max Rupplin — MEARVK LLC
