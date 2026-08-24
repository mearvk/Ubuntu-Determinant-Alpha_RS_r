# White Edition — `audit`

**Status:** W2 — Security observability review

Linux Audit provides security event recording and accountability information. White Edition should seek useful observability without producing an unmanageable volume of noise.

## Objectives

- Establish a documented baseline audit policy.
- Capture security-relevant events with sufficient context for investigation.
- Avoid redundant or excessively broad rules.
- Make retention and rotation behavior predictable.
- Preserve audit evidence across ordinary service restarts where supported.

## Native implementation

Audit contains native components, but initial White Edition work should prioritize policy, packaging, configuration, and testing. Native `.c` changes require a specific correctness or security requirement.

## Evidence

- audit daemon startup test;
- rule-load verification;
- representative login/permission/process events;
- AppArmor/systemd interaction review;
- rotation/retention test;
- overload/noise review;
- recovery after service restart.

## Economy

Measure event volume, disk growth, CPU overhead, memory use, and useful-event ratio. More logging is not automatically better security.

**Stewardship:** Max Rupplin — MEARVK LLC
