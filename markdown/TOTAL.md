# Total — Proffer Moderator Layer

## Status

**Experimental architecture / design specification**

`Total` is the proposed moderator layer for the Ubuntu.Determinant.Beta.Restricted SecureJDK/Graal system. It is designed to sit **between the operating-system kernel and ordinary userland applications** while remaining a privileged system component rather than an ordinary application runtime.

The name **Total** refers to its intended system-wide view of runtime resources, memory footprint, application treatment, provenance, and runtime policy. It does not mean unrestricted authority: Total must operate within explicit OS privilege, security, provenance, and authorization boundaries.

## Architectural Position

The intended stack is:

```text
┌──────────────────────────────────────────────┐
│ Userland applications                        │
│ Java / native / desktop / services           │
└──────────────────────┬───────────────────────┘
                       │ controlled interface
┌──────────────────────▼───────────────────────┐
│ Total — Proffer Moderator                    │
│ privileged runtime / memory / policy layer   │
└──────────────────────┬───────────────────────┘
                       │ kernel interfaces
┌──────────────────────▼───────────────────────┐
│ Operating-system kernel                      │
│ process / virtual memory / scheduling / IPC  │
└──────────────────────────────────────────────┘
```

Total runs **on top of the kernel**, not inside the kernel. It is therefore not a replacement for the kernel's fundamental memory manager, scheduler, VM subsystem, or security mechanisms. It is a privileged supervisory layer that coordinates with those mechanisms.

Userland applications should not automatically receive direct access to Total's privileged interfaces. A narrowly defined exception path may be provided for approved runtimes, administrators, diagnostics, or explicitly authorized applications.

## Native Implementation

Total is a **native C/C++ executable and service**, even though its conceptual interface is a **Proffer of Java** and it ships with the Java runtime environment.

The intended relationship is:

```text
SecureJDK 28 / Graal
        │
        │ Proffer vocabulary + runtime integration
        ▼
      Total
        │
        │ native C/C++
        ▼
 operating-system interfaces
        │
        ▼
     kernel
```

The native implementation is deliberate. Memory-management supervision, process observation, resource accounting, and early-boot integration should not depend on the availability of a higher-level Java process for their fundamental operation.

## Installation and Boot

Total is intended to ship as part of the **SecureJDK 28 and Graal distribution family** rather than as an unrelated desktop utility.

Installation may require:

- root privileges on Unix-like systems;
- administrator privileges on Windows;
- installation of a signed/trusted system service;
- registration of the service with the operating system;
- creation of a protected configuration location;
- creation of restricted logs/state storage.

When enabled, Total may load during OS boot or service initialization. Exact boot ordering is platform-specific. Total must not assume that all userland services are available when it starts.

A failure of Total must have a declared fail-safe behavior. It should not silently convert an unavailable moderator into unrestricted authority or block the OS indefinitely merely because the moderator is unavailable.

## Memory Footprint Management

A primary Total responsibility is **memory-footprint management and observation**.

The layer can supervise application memory behavior around mechanisms such as:

- `malloc` / `free`;
- C/C++ allocation families;
- Java heap allocation;
- native allocations associated with JVM processes;
- mapped memory;
- committed versus reserved virtual memory;
- allocation growth;
- reclamation and pressure;
- process-level working-set behavior;
- memory limits and declared budgets.

Total does **not** replace `malloc`, `free`, the JVM garbage collector, or the kernel virtual-memory manager. Instead, it establishes a higher-level accounting and policy boundary around them.

The intended relationship is:

```text
application allocation
        ↓
allocator / JVM
        ↓
OS virtual memory
        ↓
kernel
        ↑
Total observation / policy / moderation
```

Total should prefer measurement and bounded intervention over opaque rewriting of allocator behavior.

## Memory Pressure and Treatment

Total may maintain a per-process or per-runtime resource profile containing information such as:

```text
identity
runtime family
provenance
memory budget
current footprint
peak footprint
allocation pressure
mapped-memory pressure
policy state
exception state
```

A treatment may then be applied when a declared threshold is crossed.

Examples include:

- recording an allocation-pressure event;
- notifying the runtime;
- requesting ordinary reclamation;
- applying a configured memory ceiling;
- reducing optional caches;
- changing a declared process policy;
- escalating to an administrator or system policy;
- terminating a process only when an explicit OS policy authorizes that action.

Total should not invent hidden penalties or infer personal characteristics from application behavior.

## Configuration

Total is primarily configuration-driven.

A conceptual configuration may look like:

```text
[total]
enabled = true
mode = supervised
boot = true

[memory]
default_budget = auto
pressure_policy = moderate
native_tracking = true
java_tracking = true

[java]
default_runtime = securejdk-28
profiler_policy = proffer

graal_integration = enabled

[applications]
trusted_descriptors = /etc/total/descriptors
brand_inference = conservative
unknown_policy = os-default

[security]
require_provenance = true
require_signature = true
userland_direct_access = false
admin_override = true
```

The exact file format remains to be selected. A versioned schema should be used so that policy changes are explicit and reproducible.

## Desktop Application Treatment

Total has a special treatment model for desktop applications and their **assistive or companion software**.

A desktop product may be accompanied by related software that is not the original branded application itself. Examples can include:

- databases;
- background services;
- helper processes;
- launchers;
- runtime agents;
- update services;
- plugin hosts;
- protection or integrity components;
- native support libraries.

Total should be able to represent these relationships without assuming that every executable with a similar name is part of the same product.

The intended model is a **software relationship graph**:

```text
Brand / Product
      │
      ├── primary application
      ├── helper
      ├── service
      ├── database
      ├── runtime
      └── protection component
```

## Trusted Software Descriptors

Brand and product association should be inferred only from **known, trusted descriptors** and corroborating evidence.

Potential evidence can include:

- signed executable metadata;
- package-manager provenance;
- publisher identity;
- code-signing certificate;
- package coordinates;
- installation manifest;
- known runtime descriptors;
- verified file paths;
- declared service relationships;
- cryptographic hashes;
- administrator configuration.

A name alone is not sufficient evidence of identity.

Total should use a confidence model rather than silently converting uncertain inference into fact:

```text
trusted evidence
      ↓
relationship candidate
      ↓
confidence / provenance
      ↓
policy decision
```

Unknown or conflicting software should remain **unknown** until sufficient trusted evidence exists.

## Java Runtime Preference

Software installed under the SecureJDK/Graal family may, where compatible and configured, run under the **Java runtime's Total-aware profiling and moderation path**.

Conceptually:

```text
installed program
      ↓
recognized runtime / descriptor
      ↓
SecureJDK 28 / Graal
      ↓
Total-aware profiler
      ↓
application execution
```

The phrase **"purring brand of the JVM profiler"** is treated here as project vocabulary for a smooth, low-friction runtime profiling path: the preferred execution path should be quiet, continuous, and minimally disruptive when the application is trusted and within policy.

This is a policy goal, not a claim that profiling can be invisible to the security boundary or that applications should lose control of their own documented semantics.

## OS-Default Execution

Applications that do not qualify for the Java/Graal/Total-aware path may run through the normal OS memory manager and native process model.

The default decision should be conservative:

```text
trusted + compatible
        → Total/JVM-aware path

unknown / incompatible
        → OS-default path

explicitly restricted
        → declared restriction policy
```

Total must never require an application to masquerade as Java software in order to receive ordinary OS execution.

## Premium Product Quality

Total is intended as a **premium SecureJDK/Graal product-quality component**. "Premium" means engineering quality and integrated support rather than arbitrary privileged behavior.

The design should follow established best practices for:

- least privilege;
- explicit authorization;
- memory safety;
- deterministic configuration;
- signed updates;
- auditability;
- rollback;
- provenance;
- compatibility;
- bounded resource usage;
- secure failure behavior;
- testability;
- platform-specific service integration.

The project phrase **"best of known software tradeables as structure for INT"** is therefore interpreted as a design requirement to make resource, security, compatibility, and performance tradeoffs explicit rather than hidden inside the moderator.

## Proffer Interface

Total is a natural native implementation of the project's Proffer model.

A Total decision can be represented conceptually as:

```text
subject
origin
reason
capability
trust-domain
policy
authorization
resource state
provenance
integrity
disposition
```

For example:

```text
Proffer:
  subject: process-1234
  origin: signed-package
  reason: memory-pressure
  capability: request-reclamation
  trust-domain: desktop-application
  policy: moderate
  authorization: system-policy
  resource: 1.8 GiB / 2.0 GiB budget
  provenance: verified
  integrity: verified
  disposition: notify-runtime
```

The Proffer is a decision record and interface concept. It should not itself become an unrestricted capability token.

## Access Boundary

Total is intentionally **not strictly available to ordinary userland programs**.

The default boundary is:

```text
kernel
  ↕
Total
  ↕ restricted system interfaces
approved runtime / service
  ↕
user applications
```

Applications may receive limited information through approved APIs, but privileged Total controls should remain protected.

Exceptions should be explicit, such as:

- SecureJDK/Graal runtime integration;
- administrator diagnostics;
- signed system management utilities;
- explicitly authorized service accounts;
- controlled debugging interfaces.

## Safety and Security Principles

Total should follow these rules:

1. **Observation does not imply authorization.**
2. **Software identity requires trusted evidence.**
3. **Unknown software remains unknown rather than being assigned a brand by guesswork.**
4. **Memory pressure is a resource condition, not a judgment about a person.**
5. **A product relationship is not established solely by a shared name.**
6. **Kernel authority remains distinct from Total authority.**
7. **Total cannot silently grant capabilities to applications.**
8. **Configuration and policy versions must be attributable.**
9. **Privileged actions require an explicit authorization path.**
10. **Failure behavior must be bounded and documented.**

## Relationship to SecureJDK 28 and Graal

Total is intended to be distributed alongside SecureJDK 28 and Graal as an integrated system-quality component.

SecureJDK provides the protected Java runtime direction.

Graal provides compiler/runtime analysis and reachability capabilities.

Total provides the native OS-facing moderator layer that can observe and coordinate resource policy outside the Java heap itself.

Together:

```text
             SecureJDK 28
                  │
             Java semantics
                  │
             Graal analysis
                  │
        ┌─────────▼─────────┐
        │       Total       │
        │ Proffer moderator │
        └─────────┬─────────┘
                  │
             OS interfaces
                  │
                kernel
```

The components should remain modular. Total should not be made a hidden prerequisite for every Java execution unless the installed product configuration explicitly enables that mode.

## Implementation Roadmap

The initial implementation should proceed in bounded stages:

### Phase 1 — Native skeleton

- C/C++ daemon/service;
- configuration parser;
- PID/process registry;
- secure logging;
- versioned state;
- platform detection.

### Phase 2 — Memory observation

- process memory accounting;
- native allocation telemetry where available;
- Java process identification;
- pressure thresholds;
- bounded notification interface.

### Phase 3 — SecureJDK/Graal integration

- runtime registration;
- Proffer exchange;
- profiler hooks;
- Java/Graal descriptor support;
- controlled exception interface.

### Phase 4 — Desktop relationship graph

- trusted descriptors;
- package provenance;
- publisher/signature verification;
- companion-process relationships;
- conservative brand inference.

### Phase 5 — Production hardening

- privilege minimization;
- signed configuration/policy where appropriate;
- fuzzing;
- malformed-descriptor tests;
- resource exhaustion tests;
- service restart behavior;
- upgrade/rollback tests;
- security review.

## Current Status

Total is currently a **design-level architectural component**. This document defines its intended position and responsibilities but does not claim that a production-ready Total executable already exists.

The next implementation should begin with the native service skeleton and a narrowly scoped memory-observation API before introducing automated treatment policies.

## Design Principle

> **Total moderates the system; it does not become the system.**

It exists to provide a privileged, attributable, resource-aware Proffer layer between kernel facilities and the broad world of userland software while preserving ordinary OS execution as the safe fallback.
