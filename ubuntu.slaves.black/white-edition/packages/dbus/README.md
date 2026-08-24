# White Edition — `dbus`

**Status:** W1 — Clean integration / security review

D-Bus provides inter-process communication and service activation. White Edition work should improve clarity and policy without changing the protocol contract unnecessarily.

## Objectives

- Preserve D-Bus protocol and service-activation compatibility.
- Keep bus policy explicit and reviewable.
- Minimize unnecessary privilege exposure through service activation.
- Make activation failures understandable to administrators.
- Document the relationship between system services and user-session services.

## Native implementation

D-Bus is primarily C. Any White Edition native patch must identify a concrete correctness, security, or integration problem and include a regression test. Policy and packaging changes are preferred when they accomplish the goal without changing the implementation.

## White Edition integration

Initial work should concentrate on:

- bus policy review;
- service activation documentation;
- predictable failure diagnostics;
- least-privilege service interfaces;
- interaction with `systemd` activation;
- clean separation of system and user-session buses.

## JavaFX relationship

A JavaFX administration application may display service state or supported administrative information. It should not expose unrestricted D-Bus calls to ordinary users. Administrative actions must pass through an explicit authorization boundary.

## Evidence

- system-bus startup test;
- user-session bus test;
- service activation test;
- denied/unauthorized request test;
- policy reload/restart test;
- systemd activation interoperability test;
- upgrade compatibility test.

## Economy

Measure bus startup/activation overhead, resident memory, message throughput for representative workloads, and policy complexity. Avoid optimizing IPC by weakening authorization or observability.

**Stewardship:** Max Rupplin — MEARVK LLC
