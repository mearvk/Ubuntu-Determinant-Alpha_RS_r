# White Edition — `systemd`

**Status:** W2 — Quality improvement target

`systemd` is a central service, boot, session, logging, and resource-management boundary. White Edition changes must be conservative, observable, and reversible.

## Objectives

- Make service lifecycle and dependency ordering predictable.
- Preserve upstream service semantics unless a concrete White Edition requirement exists.
- Improve failure diagnostics and recovery documentation.
- Apply resource controls deliberately rather than globally imposing arbitrary limits.
- Keep privileges and service identities explicit.
- Ensure boot-time behavior can be tested without relying solely on a successful graphical session.

## Native implementation

`systemd` is primarily C. Native source changes should address a demonstrated reliability, security, or integration requirement. A source patch must include a focused regression test and avoid creating a permanent White Edition fork of upstream behavior without strong justification.

## White Edition integration

The preferred first changes are configuration, unit policy, packaging, tests, and documentation. Candidate areas include:

- service ordering;
- dependency failure reporting;
- safe restart behavior;
- resource accounting;
- journal retention policy;
- predictable administrative interfaces.

## JavaFX relationship

A White Edition JavaFX administration application may inspect service state and expose safe administrative operations. It must use supported service-management interfaces and must not bypass `systemd`'s transaction and privilege model.

## Evidence

- boot to multi-user target;
- service start/stop/restart tests;
- dependency failure tests;
- permission and privilege tests;
- journal/logging verification;
- resource-accounting smoke tests;
- recovery from failed service activation;
- upgrade compatibility test.

## Economy

Measure boot contribution, resident memory, process/service activation cost, journal growth, and CPU overhead where material. Optimization must not reduce diagnosability or service correctness.

## Promotion condition

W2 remains the working grade until evidence demonstrates the proposed behavior. Material changes to service orchestration or process supervision require W3 review.

**Stewardship:** Max Rupplin — MEARVK LLC
