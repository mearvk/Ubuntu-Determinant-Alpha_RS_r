# Ubuntu White Edition — Ring A Foundation Package Matrix

**Max Rupplin — MEARVK LLC**

## Purpose

This document begins the orderly package-by-package integration of Ubuntu 22.04.3 LTS into the Ubuntu White Edition quality model. Ring A contains the packages that establish package management, basic execution, trust, boot, service management, and core operating-system behavior.

The upstream Ubuntu source archive remains authoritative for provenance. White Edition work is an overlay: a controlled change, patch, test, and documentation layer. No package should be silently rewritten or represented as an upstream change.

## Status Vocabulary

- **W0 — Baseline:** retain upstream without a White Edition delta.
- **W1 — Clean integration:** packaging, documentation, build, presentation, or integration improvement.
- **W2 — Quality improvement:** tested reliability, security, usability, or operational improvement.
- **W3 — Architectural change:** material behavioral or dependency change requiring dedicated review.
- **HOLD:** do not integrate until evidence, licensing, compatibility, or testing is sufficient.

A grade applies to the proposed White Edition delta, not as a judgment that upstream is generally good or bad.

## Ring A Matrix

| Package family | Initial grade | Primary review | Expected White Edition work | Evidence required |
|---|---|---|---|---|
| `base-files` | W1 | identity, filesystem layout, release metadata | clean White Edition identity and documented local paths | package build + filesystem checks |
| `base-passwd` | W0/W1 | system users/groups | preserve Debian/Ubuntu compatibility; document any added service identities | package build + account database checks |
| `bash` | W1 | shell behavior and startup | predictable defaults, documentation, safe integration | shell regression tests |
| `coreutils` | W0/W1 | fundamental utilities | preserve upstream semantics; improve integration only where evidence exists | upstream tests + White Edition smoke tests |
| `dpkg` | W2 | package database and transaction integrity | diagnostics, failure clarity, reproducibility, recovery documentation | package transaction tests |
| `apt` | W2 | repository trust and package transactions | trusted-source defaults, clearer diagnostics, deterministic configuration | install/upgrade/rollback tests |
| `debootstrap` | W1 | base-system construction | reproducible White Edition bootstrap path | clean bootstrap test |
| `glibc` | W1 | ABI, locale, runtime compatibility | conservative hardening/integration review; no unnecessary ABI changes | ABI + runtime regression suite |
| `gcc` / `binutils` | W1 | native build foundation | reproducible build configuration and documented toolchain baseline | compiler/linker smoke builds |
| `systemd` | W2 | boot/service lifecycle | service ordering, diagnostics, resource policy, conservative defaults | boot + service integration tests |
| `dbus` | W1 | IPC and service activation | service policy documentation and predictable diagnostics | IPC/service tests |
| `openssl` | W2 | cryptographic runtime | use established primitives, safe defaults, provider/configuration review | crypto regression + interoperability tests |
| `ca-certificates` | W2 | trust anchors | provenance, update process, deterministic trust-store handling | trust-store verification |
| `apparmor` | W2 | mandatory access controls | policy review and application-specific profiles where justified | profile enforcement tests |
| `audit` | W2 | security event recording | useful baseline audit policy without unnecessary noise | event-generation tests |
| `cryptsetup` | W2 | storage encryption | safe defaults and documented recovery behavior | encrypted-volume tests |
| `grub2` | W2 | boot integrity and configuration | deterministic configuration and documented recovery path | boot-image tests |
| Linux kernel family | W2/W3 | kernel baseline, modules, hardening | explicit configuration baseline and measurable hardening changes | kernel build + boot + hardware smoke tests |

## Review Order

### A1 — Package Management

Begin with `dpkg` and `apt`. The White Edition should first establish a trustworthy method for installing, upgrading, removing, verifying, and recovering packages. No cosmetic changes should outrank transaction integrity.

### A2 — Runtime Foundation

Review `base-files`, `base-passwd`, `bash`, `coreutils`, and `glibc`. These packages define much of the ordinary userland contract and should remain close to upstream unless a concrete White Edition requirement exists.

### A3 — Service Foundation

Review `systemd` and `dbus`, including service ordering, failure behavior, logging, permissions, and resource behavior.

### A4 — Trust Foundation

Review `openssl`, `ca-certificates`, `apparmor`, and `audit`. Cryptographic behavior should use established upstream primitives and APIs. White Edition should concentrate on configuration, integration, policy, provenance, and testing rather than inventing replacement cryptography.

### A5 — Storage and Boot

Review `cryptsetup`, `grub2`, and the kernel family. These changes require explicit recovery procedures because failures can affect whether a system starts or whether data remains accessible.

## Package Change Record

For each package that moves beyond W0, create a package-specific directory using this model:

```text
white-edition/
└── packages/
    └── <package>/
        ├── README.md
        ├── rationale.md
        ├── status.md
        ├── patches/
        ├── tests/
        └── THEORETICAL.md
```

`THEORETICAL.md` is required when the change depends materially on mathematics, security assumptions, formal policy, cryptography, or another explicit theoretical model.

## Economy Measurements

For each Ring A package, the eventual matrix should record, where measurable:

- source footprint;
- installed footprint;
- dependency count;
- build time;
- startup or activation cost;
- memory use;
- runtime CPU cost;
- package transaction cost;
- security significance;
- maintenance burden;
- user-facing complexity.

The goal is **quality per unit of system complexity**, not minimum source size.

## Promotion Rule

A package may move from proposal to an integrated White Edition delta only when:

1. the upstream version is recorded;
2. the proposed change is narrow and explicit;
3. licensing and provenance are understood;
4. compatibility impact is documented;
5. a test or verification procedure exists;
6. rollback is possible;
7. the resulting behavior is documented.

## Initial Principle

The first Ring A pass should make the operating system **more predictable before making it more distinctive**. Once the baseline is stable and measurable, distinctive White Edition improvements can be introduced one package family at a time.

---

**Reference:** `WHITE-EDITION-PACKAGE-STANDARD.md`

**Project:** Ubuntu Determinant / Ubuntu White Edition

**Stewardship:** Max Rupplin — MEARVK LLC
