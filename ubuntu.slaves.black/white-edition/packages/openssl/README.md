# White Edition — `openssl`

**Status:** W2 — Security and quality review

OpenSSL is a core cryptographic and TLS foundation. White Edition must use established upstream cryptographic implementations and concentrate on safe configuration, provenance, integration, and measurable testing.

## Objectives

- Preserve interoperability with supported Ubuntu applications.
- Maintain secure protocol and certificate-validation defaults.
- Keep cryptographic provider/configuration behavior explicit and reproducible.
- Track upstream security fixes rather than maintaining unnecessary local forks.
- Never introduce a new cryptographic primitive merely for White Edition branding.

## Native implementation

OpenSSL is primarily C. Native patches require a concrete security, correctness, or compatibility justification and focused regression coverage. Configuration and packaging changes are preferred when they achieve the objective.

## Evidence

- build and upstream regression tests;
- TLS interoperability tests;
- certificate-validation tests;
- negative/error-path tests;
- provider/configuration verification;
- upgrade and rollback review;
- security-advisory tracking.

## Economy

Measure library footprint, startup/load behavior, representative TLS CPU and memory costs, and dependency effects. Security correctness outranks small footprint reductions.

**Stewardship:** Max Rupplin — MEARVK LLC
