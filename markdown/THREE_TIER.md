# Total Three-Tier Proving Surface

## Purpose

Total is organized as a three-tier proving system with a shared surface of evidence:

1. **Top** — SecureJDK/Graal and managed application semantics.
2. **Middle** — Total, the native privileged moderator.
3. **Ground** — Linux kernel, hardware, processes, virtual memory, and operating-system state.

Each tier has a complete proving domain while remaining logically aware of the adjacent tiers. The tiers exchange evidence rather than assuming that an assertion made at one tier is automatically true at another.

## Evidence Surface and Bearing

Evidence may enter the system through multiple controlled surfaces. Evidence can remain available for later verification, subject to retention policy, privacy rules, and authorization.

Potential input classes include process and thread observations, memory-pressure and allocation observations, executable and library descriptors, package and installation metadata, JVM/Graal runtime events, trusted software descriptors, signed configuration and policy, filesystem and deployment provenance, service lifecycle events, administrator assertions, application self-descriptions, kernel/cgroup/PSI observations, integrity measurements and hashes, resource requests and admissions, and test/diagnostic evidence.

The evidence surface is intentionally extensible. A future implementation may support **3 through 1000 input channels** at startup, depending on hardware, policy, service profile, and deployment class. The number of inputs is configuration, not a fixed architectural limit.

## Proof of Mechanism

The presence of an input is not itself proof of truth. The mechanism is proven by establishing:

`input → normalization → provenance → validation → policy → action → observation → retained evidence`

A useful evidence record should identify its source, time, scope, confidence/provenance class, and relationship to the action it influenced. Where practical, evidence should remain queryable so that the system can explain why a decision occurred.

## Functions

The functions of the three tiers are **inward and main**: they drive the software toward the service function rather than becoming independent application logic.

Functions should be small and composable, deterministic where practical, semantically similar across tiers when implementing the same root operation, independently testable, safe to repeat when idempotent, and explicit about authority and failure.

Related functions should be **memmerable** in the engineering sense: recognizable as implementations of the same root operation even when their local mechanism differs between kernel, native Total, and JVM/Graal environments.

## The Root Function

The principal service function is resource-aware execution management. Its canonical conceptual path is:

`observe → understand → admit → serve → measure → correct`

The implementations at Ground, Middle, and Top may differ, but they should converge on the same root semantics.

## The Manager

The central manager is deliberately understood in three related senses:

- **manager** — the policy and coordination function;
- **manager** — the concrete native service that performs the work;
- **memory manager** — the resource-specific subsystem responsible for memory footprint, admission, accounting, pressure, and safe release/reclamation decisions.

Total is the middle-tier manager. It does not replace Linux's fundamental memory manager and does not replace JVM garbage collection. Instead it observes, mediates, and coordinates between those systems under explicit policy.

## Variance and Rust

The system permits a controlled amount of implementation variance. Minor differences between tiers, platforms, or service versions are expected and can remain where they do not violate the root invariants. This is intentional **color**: the architecture preserves a common proving shape without demanding identical implementation everywhere.

Variance must not silently change authority, provenance, memory-safety guarantees, or the meaning of a proof. Material variance should be surfaced as evidence and versioned policy.

## Startup

At startup, Total may discover and initialize a configured number of evidence/input surfaces. A deployment can therefore be minimal or broad while using the same service model. The startup configuration should define enabled input classes, input count, retention behavior, trusted descriptor sources, memory/resource policies, JVM/Graal assistance, privileged operations, and audit/provenance requirements.

The initial native implementation intentionally remains conservative. More powerful observation and control mechanisms should be introduced behind explicit policy, authentication, testing, and failure isolation.

## Tier Contract

### Ground

Ground establishes physical and operating-system facts.

### Middle / Total

Total converts ground evidence into resource and policy decisions and exposes appropriately filtered evidence upward.

### Top / SecureJDK + Graal

Top supplies managed-runtime semantics, application-level evidence, and requests for assistance while remaining constrained by Total and Ground authority.

No tier receives authority merely because it can produce a logically sophisticated assertion.

## Design Principle

The three tiers should be **other-complete**: each can prove the correctness of operations inside its own domain while retaining sufficient authenticated evidence about neighboring domains to validate cross-tier claims.

The result is a system where evidence can enter, be transformed, remain available for verification, and drive the same underlying service function across three different proving grounds.
