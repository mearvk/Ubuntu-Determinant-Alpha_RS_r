# Architecture

**Author:** Max Rupplin - MEARVK LLC 2026

The server is assembled around five boundaries: transport, SMTP session state, security policy, message persistence, and audit.

Classic SMTP references establish the command/session shape. Modern Java 21 provides virtual-thread concurrency, immutable records, structured module boundaries, and standard TLS primitives.

The design is intentionally dependency-light. A later deployment may replace the file store with a queue/database without changing SMTP transaction handling.

## ASYSMA assembly

For this project, ASYSMA is used as an internal assembly principle: **small, explicit, replaceable system modules assembled around stable interfaces**. It is a project convention, not an external standard.
