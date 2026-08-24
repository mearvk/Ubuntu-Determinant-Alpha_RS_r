# White Edition — `base-passwd`

**Status:** W0/W1 — Baseline with integration review

`base-passwd` defines foundational system accounts and groups. White Edition should preserve established identifiers and permissions unless a concrete service requirement is documented.

## Objectives

- Preserve Debian/Ubuntu account and group compatibility.
- Document any additional service identities rather than introducing them implicitly.
- Review ownership and least-privilege implications for White Edition services.
- Keep account databases reproducible.

## Evidence

- package build;
- passwd/group database checks;
- UID/GID compatibility review;
- ownership checks for White Edition services;
- upgrade compatibility test.

## Implementation rule

Do not add accounts merely for convenience. Every new identity must have a named consumer, documented permissions, and a removal/upgrade story.

**Stewardship:** Max Rupplin — MEARVK LLC
