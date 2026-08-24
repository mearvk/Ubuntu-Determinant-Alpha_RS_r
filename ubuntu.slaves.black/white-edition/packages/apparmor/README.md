# White Edition — `apparmor`

**Status:** W2 — Security policy review

AppArmor provides mandatory access-control policy at the application and service boundary. White Edition policy should be explicit, least-privilege oriented, and evidence-driven.

## Objectives

- Preserve Ubuntu AppArmor compatibility.
- Prefer profiles for clearly identified security boundaries.
- Keep policy changes reviewable and narrowly scoped.
- Avoid broadening permissions merely to make an application start.
- Document complain/enforce mode and the reason for each material rule.

## Native implementation

AppArmor includes native components, but the initial White Edition work should favor policy profiles, packaging, and tests. Native `.c` changes require a concrete enforcement or correctness problem and dedicated regression evidence.

## Evidence

- profile parse/load test;
- expected application behavior under enforcement;
- denied-operation tests;
- profile transition checks;
- update/rollback test;
- audit/log verification;
- review for unnecessary capabilities and filesystem access.

## JavaFX relationship

MEARVK JavaFX applications should receive profiles only when a meaningful security boundary exists. The profile should support the application rather than become a blanket exception to system policy.

## Economy

Measure profile complexity, policy-load overhead, and material application overhead. Prefer simple policies that enforce meaningful boundaries.

**Stewardship:** Max Rupplin — MEARVK LLC
