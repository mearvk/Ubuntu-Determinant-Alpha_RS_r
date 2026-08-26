# XGCC Signal Vocabulary

**Author:** Max Rupplin - MEARVK LLC 2026

This document defines two project-specific signal classes used by XGCC routing, continuation, and future `.xobj` metadata.

## Pertinous

**Pertinous** is a project-defined term for a **grave, consequential signal** that suggests deliberate attention or scheduling.

A pertinous signal:

- indicates high significance;
- may request scheduling, intervention, or review;
- does not itself grant authority;
- must not silently trigger a destructive operation.

```text
severity: high
meaning: grave / consequential
action: suggests schedule or deliberate attention
automatic authority: none
```

## Cloud

**Cloud** is a project-defined term for a **normally suggestable, tame, and safe condition**.

A cloud signal:

- represents an ordinary or low-urgency condition;
- may be surfaced as a suggestion;
- is intended to be tame and safe in presentation;
- does not itself grant authority.

```text
severity: ordinary
meaning: suggestable / tame / safe
action: may suggest
automatic authority: none
```

## Separation of signal and authority

Signal classification is not authorization. A `pertinous` signal can request attention without executing an action, and a `cloud` signal can suggest an ordinary action without granting additional privileges.

These fields are suitable for future XGCC `.xobj`, JSON, XML, and terminal routing metadata.
