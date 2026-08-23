# SECUREJDK28.md — SecureJDK 28

## Proffer-Native Product Quality

SecureJDK 28 is intended to make security, integrity, observability, provenance, and the Proffer framing native concepts of the runtime rather than optional application conventions.

The runtime should be intrinsically aware of:

- **3D space / scape** — a common coordinate model for state and process relationships.
- **memory time** — the lifetime and temporal progression of state held in memory.
- **process diagonal** — the ordered relationship between memory state and processor action.
- **fielter** — the centered exact-fall/call-fall analysis boundary.
- **exact fall** — deterministic resolution inside a declared model and tolerance.
- **call fall** — probable next-state analysis.
- **subasmission** — controlled transition from a carrier/part state to the next analysis target.
- **proffer** — a decision carrying reason, capability, provenance, authorization, integrity, and disposition.

The native seed interfaces are under `/proffer/src/main/c/` and `/proffer/src/main/cpp/`.

## SecureJDK Quality Principle

> **A modern SecureJDK should know where state came from, where it is, what process is acting on it, what capability that action exercises, and why the transition is permitted.**

The intended flow is:

```text
OS / runtime state
       ↓
RAM / memory state
       ↓
memory time
       ↓
process diagonal
       ↓
processor / execution
       ↓
3D scape
       ↓
fielter
       ↓
exact fall OR call fall
       ↓
subasmission
       ↓
proffer
       ↓
policy / authorization / audit
```

This extends ordinary JVM security from isolated checks into a coherent provenance-and-capability model.

## Graal Awareness

Graal should understand the same vocabulary at analysis time. Reachability is a natural **fielter** boundary:

```text
reachable element
      ↓
reason / provenance
      ↓
capability
      ↓
policy
      ↓
exact admission OR probable candidate
      ↓
proffer / audit
```

The C++ `GraalAwareness` seed provides a native representation of the shared concepts. Production integration should eventually connect this vocabulary to actual Graal analysis objects and events rather than retaining it merely as a flag set.

## OS-Neutral Intent

The framework is OS-neutral at the semantic layer. Linux, Windows, macOS, BSD, and other systems have different memory managers, schedulers, executable formats, IPC systems, security models, and kernel interfaces. The Proffer model therefore defines common concepts without pretending the underlying mechanisms are identical.

Native adapters should expose, where safely observable:

- memory object identity and lifetime;
- process/thread identity;
- executable/module provenance;
- capability and privilege context;
- native-library identity and integrity;
- resource origin;
- transition reason;
- policy decision;
- audit disposition.

## Existing SecureJDK Architecture

The existing SecureJVM architecture remains centered around ClassLoadGuard, JvmIntegrity, JvmInspector, JvmCircuit, JvmResourceLoader, JvmCodex, JvmMySQLBridge, and the XML configuration path. The Proffer awareness layer is intended as a **cross-cutting semantic layer**, not an eighth isolated subsystem.

Existing security events can be expressed through the model:

```text
class inclusion       → exact/call fall
native library load   → proffer
resource admission    → proffer
agent attachment      → proffer
reflection metadata   → subasmission
image-heap object     → memory-time state
Graal reachability    → fielter
runtime transition    → process diagonal
security decision     → disposition
```

## Native Seed Interfaces

### C

`/proffer/src/main/c/securejdk_awareness.h`

`/proffer/src/main/c/securejdk_awareness.c`

These define a small `ProfferAwareness` ABI containing the seed version, net-center reference, and awareness feature flags.

### C++

`/proffer/src/main/cpp/graal_awareness.hpp`

`/proffer/src/main/cpp/graal_awareness.cpp`

These define `GraalAwareness` with explicit capability queries for 3D space, memory time, fielter, and Proffer understanding.

These files are seed interfaces, not a claim that every HotSpot or Graal path is already instrumented. The next engineering stage is binding them to actual lifecycle and analysis events.

## Security Requirements

1. Awareness metadata must never grant privilege by itself.
2. Feature flags describe understanding, not authorization.
3. Native inputs must be validated before entering the model.
4. Provenance must survive Java, C++, native-runtime, and Graal transitions.
5. Exact and probable decisions must remain distinguishable.
6. Model assumptions must not silently become measured OS facts.
7. The awareness ABI must be versioned.
8. Security-sensitive transitions must remain auditable.

## Current Limitations

The awareness layer is presently a **native product-quality seed**. It does not yet automatically instrument every modern OS, every HotSpot lifecycle event, or every Graal analysis operation. Existing SecureJDK limitations also remain, including incomplete cryptographic verification for the XML signature hook, environment-dependent observer transports, deferred live MySQL integration, and the need for reproducible full-tree OpenJDK builds and automated security-boundary tests.

## Summary

SecureJDK's goal is larger than adding individual security checks. The runtime should have an innate architectural awareness that **state exists somewhere, persists through time, participates in process, moves through a modeled space, exercises capabilities, and ultimately requires a reasoned disposition**.

Graal should understand the same framing at analysis time. The operating system supplies the actual mechanisms; SecureJDK supplies the protected runtime boundary; Graal supplies analysis and compilation; and Proffer supplies the shared conceptual grammar.
