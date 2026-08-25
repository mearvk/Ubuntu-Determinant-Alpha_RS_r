# THINAUDIT — Thin Audit Size Envelope

**Project:** Ubuntu Determinant  
**Edition:** Ubuntu White Edition  
**Project attention:** Max Rupplin — MEARVK LLC — 2026  
**Status:** Design estimate / probabilistic engineering note

## 1. Purpose

The thin audit is the compact inspection and control footprint associated with the `.asysma` Java control plane and its native adapters. It is intended to be small enough to operate as a practical product unit while carrying the identity, capability, stability, security, OS-layer, variance, and event-assessment fittings described by `NATIVE.md`.

The objective is **not** to make a full operating system fit inside the audit. The objective is to make the audit a small, portable control envelope that can inspect a substantially larger host.

## 2. Java program size premise

For planning purposes, a conventional Java application may be considered to occupy roughly **2–25 MB** for the application artifact and immediate program resources in a modest implementation. This is a planning range, not a universal Java size standard; dependencies, JavaFX, packaging, native libraries, debugging symbols, and the selected runtime can make the distribution considerably larger.

The distinction is:

```text
application code
      ≠
complete Java runtime
      ≠
complete installer distribution
      ≠
operating system
```

## 3. Thin-audit envelope

A reasonable first design target is therefore:

```text
Core Java / `.asysma` application       2–25 MB
Native adapters + descriptors           ~2–20 MB
Audit rules / manifests / metadata      ~1–10 MB
Logging / verification / reporting      ~1–10 MB
Safety margin                            2–3 ×
------------------------------------------------
Initial thin-audit planning envelope   ~12–195 MB
```

The upper end is intentionally conservative. A production package containing a bundled Java runtime, JavaFX, platform adapters, certificates, firmware utilities, VM tooling, or recovery components may exceed this envelope and should be measured as a separate distribution class.

## 4. Safety ratio

The design uses a **2–3× safety ratio** over the measured minimum audit footprint.

```text
minimum measured footprint × 2  = preferred safety floor
minimum measured footprint × 3  = generous safety envelope
```

The ratio provides room for:

- versioned metadata;
- diagnostic logs;
- temporary files;
- integrity manifests;
- platform-specific adapters;
- rollback information;
- compatibility data;
- future OS capability descriptors;
- modest growth without immediate repartitioning or repackaging.

The ratio is a packaging/resource-planning rule, **not a security guarantee**.

## 5. Product-envelope classes

| Class | Approximate purpose | Planning size |
|---|---|---:|
| Micro audit | Identification and read-only host inspection | 5–25 MB |
| Thin audit | Full `.asysma` control/audit contract | 25–75 MB |
| Professional audit | JavaFX UI, adapters, reports, broader compatibility | 75–200 MB |
| Installer bundle | Audit + Java runtime + JavaFX + installation tooling | 200 MB–1+ GB |
| Native OS image | Kernel/rootfs/initramfs/firmware/installer | Separate measurement |

These are engineering envelopes rather than fixed product specifications.

## 6. Why the audit remains thin

The audit should **query the host rather than carry the host**.

```text
small audit
    ↓
OS identity
    ↓
capability discovery
    ↓
stability assessment
    ↓
security / privilege assessment
    ↓
AI-runtime / accelerator observation
    ↓
variance and compatibility model
    ↓
structured report
```

The audit does not need to duplicate the kernel, filesystem, package database, or desktop environment merely to understand them.

## 7. Relationship to the 2 GB native-shim premise

`NATIVE.md` uses approximately 2 GB as a preliminary planning envelope for a modest native Linux environment. `THINAUDIT.md` is deliberately much smaller:

```text
Thin audit       ≈ MB-scale control envelope
Native shim      ≈ GB-scale operating environment
```

They are therefore different product layers and should not be conflated.

## 8. Probabilistic nature

The 2–25 MB Java application estimate and the resulting audit envelopes are **probabilistic planning assumptions**. Actual size depends on:

- Java version;
- JVM distribution;
- JavaFX inclusion;
- compression;
- native libraries;
- platform targets;
- cryptographic material;
- diagnostic verbosity;
- AI/accelerator descriptors;
- installer integration;
- VM tooling;
- filesystem and packaging format.

The project should eventually replace estimates with measured release artifacts.

## 9. Measurement contract

For each release record:

```text
application bytes
runtime bytes
JavaFX bytes
native adapter bytes
metadata bytes
logging allowance
temporary-space allowance
compressed package size
installed footprint
2× envelope
3× envelope
```

A build should fail its packaging review if it unexpectedly exceeds the declared envelope without a documented reason.

## 10. Safety and security distinction

Size margin is not equivalent to security margin. A 3× storage allowance does not imply 3× stronger security.

Security should instead be measured through:

- privilege minimization;
- authenticated operations;
- input validation;
- capability checks;
- isolation;
- integrity verification;
- safe failure;
- rollback/recovery;
- auditability.

## 11. Final premise

**Keep the thin audit genuinely thin. Treat 2–25 MB as a reasonable planning range for a modest Java application, not a universal standard. Give the resulting audit a 2–3× capacity envelope for operational growth. Keep the audit separate from the GB-scale native operating environment. Measure every release, and never confuse storage headroom with security assurance.**
