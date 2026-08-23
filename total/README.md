# Total Native Moderator

**Total** is the native C implementation of the project's moderator layer. It runs above Linux kernel facilities and below ordinary userland policy, with controlled cooperation from SecureJDK 28 and Graal.

## First-edition native architecture

```text
                 TOP
        SecureJDK 28 / Graal
       managed semantics
                │
       authenticated evidence
                ▼
              MIDDLE
               Total
        native moderation
                │
       kernel / OS evidence
                ▼
              GROUND
       Linux kernel / hardware
```

The tiers are logically aware of one another while retaining separate authority. Ground establishes operating-system facts, Total mediates evidence/resource policy, and Top supplies managed-runtime and application semantics.

See `markdown/THREE_TIER.md` for the full proving-surface model.

## Evidence surface

Total accepts a variable set of controlled evidence inputs at startup. A deployment may expose **3 through 1000 input channels**, depending on configuration, hardware, policy, and service profile.

Evidence follows:

`input → normalization → provenance → validation → policy → action → observation → retained evidence`

The existence of an input is not proof of truth. Source, provenance, validation, authorization, and policy determine what an input may influence.

## Native interfaces — first edition

```text
total/include/total_domain.h  → domain/evidence vocabulary
total/include/total_policy.h  → versioned policy-provider ABI
total/include/total_input.h   → bounded startup input registry
```

The input registry supports a configured capacity from **3 through 1000** using caller-owned storage in the bootstrap layer.

See `total/include/README.md` for ABI notes.

### Evidence is not authority

A validated evidence record crossed the native validation boundary; it does **not** automatically authorize a transaction, service, person, or policy action.

```text
evidence → validation/provenance → policy provider → explicit decision → Total action
```

The privileged native layer verifies mechanisms and enforces explicit policy. It does not invent social or business authority.

## Domain-service adapters

Total supports a common architectural surface for banking, hospitality/hotels, regulated adult services, and other regulated commerce:

`identify → describe → authorize → transact → observe → retain → audit`

The domain application remains responsible for its business semantics. Total supplies evidence, provenance, resource policy, and controlled mediation.

For regulated adult services, applicable evidence may include legally required eligibility verification, provider authorization, consent state where the application records it, licensing, jurisdictional restrictions, payment provenance, and audit evidence. **Consent must never be inferred from payment, identity, presence, or prior behavior.**

See `markdown/DOMAIN_SERVICES.md`.

## Versioned policy boundary

`total_policy.h` defines the first policy-provider ABI without embedding jurisdiction-specific law into the privileged core. The context carries a policy identifier, version, jurisdiction, and evaluation time; decisions are `DENY`, `ALLOW`, or `REVIEW`.

Production policy providers will eventually require authenticated policy bundles, capability scopes, provenance, compatibility checks, and audit references.

## Input multiplexer

```text
startup configuration → 3 … 1000 input slots → normalized evidence → validation/provenance → policy
```

The 1000-input figure is an architectural ceiling for this interface, not a recommendation that every deployment activate every source.

## Root service and manager

The common root function is:

`observe → understand → admit → serve → measure → correct`

Related functions should be **memmerable** across Ground, Total, and Top: recognizably the same root operation despite different local mechanisms.

Total is the middle-tier **manager / manager / memory manager** for policy coordination, native service execution, memory footprint, admission, accounting, pressure, and safe release/reclamation coordination.

## Memory direction

The intended progression is:

`observe → account → admit → pressure → release`

The first edition remains conservative: observe/account first, then add stronger intervention only behind explicit policy, tests, capability controls, and OS primitives such as cgroups and PSI.

Total is not a replacement for Linux virtual memory, `malloc`, `free`, or JVM garbage collection.

## Trusted software descriptors

Software identity should derive from trusted descriptors, package metadata, signatures, executable identity, dependency metadata, provenance, and administrator policy. Branding alone is insufficient.

```text
package + signer + executable + dependencies + administrator policy
                              ↓
                   trusted software descriptor
                              ↓
                    Total treatment profile
```

This permits database services, helpers, launchers, runtime components, payment processors, protection systems, and related software to be treated as a group without treating a familiar name as proof.

## JVM and native paths

Supported Java software may use:

```text
Java → SecureJDK 28 / Graal → Proffer/JVM interface → Total → Linux
```

Native applications may continue through the ordinary allocator and VM path. Total must not silently impose JVM assumptions on native applications.

Future SecureJDK/Graal IPC must be authenticated and capability-limited. A Java assertion is evidence, not privileged authority.

## Tests

`total/tests/total_domain_test.c` is the first native fixture, documented in `total/tests/README.md`.

Current coverage includes valid evidence, missing provenance, failed integrity, and expired evidence. Future coverage should include registry boundaries, malformed input, duplicate IDs, concurrency, ownership/lifetime, cryptographic provenance, policy providers, and authenticated JVM IPC.

Passing these tests is **not production certification**.

## Installation and configuration

A future package may install `/usr/bin/total`, `/etc/total/total.conf`, and SecureJDK/Graal integration. System-wide installation may require administrator privileges. Boot integration should use the host's native service manager, normally systemd.

Configuration should eventually cover input sources, trusted software descriptors, policy providers, JVM/Graal cooperation, memory thresholds, service priorities, application treatment, provenance, audit/telemetry, and capabilities.

## Variance and color

Minor implementation variance is permitted when root invariants remain intact. This intentional **color** supports portability without demanding identical implementations everywhere. Material variance must be surfaced as evidence and versioned policy.

## Security boundary

Total is privileged infrastructure and therefore follows least privilege, explicit authorization, bounded observation, data minimization, fail-safe defaults, and auditable policy.

Observation does not imply authorization. Memory intervention requires explicit policy. Userland exceptions must be capability-controlled. SecureJDK/Graal cooperation must be authenticated. Malformed configuration must fail closed.

## First-edition status

**Implemented:**

- common domain/evidence C vocabulary;
- versioned policy ABI definition;
- bounded 3–1000 input registry;
- initial domain evidence tests;
- native interface documentation;
- domain-service architecture.

**Still to implement:**

- production policy-provider implementation;
- cryptographic provenance;
- formal input-source adapters;
- authenticated IPC;
- cgroup/PSI memory controls;
- SecureJDK/Graal bridge;
- systemd packaging;
- broader CI/integration testing.

The distinction is deliberate: **specified does not mean implemented, and implemented does not mean production-certified.**
