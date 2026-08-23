# Total Native Moderator

**Total** is the native C implementation of the project's moderator layer. It is designed to run above the Linux kernel and below ordinary userland policy, with optional controlled cooperation with SecureJDK 28 and Graal.

## Three-tier proving model

Total participates in a three-tier proving surface:

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

The tiers are logically aware of one another while retaining separate authority. Ground establishes operating-system facts, Total converts evidence into resource and policy decisions, and Top supplies managed-runtime semantics and application evidence.

See `markdown/THREE_TIER.md` for the complete proving-surface model.

## Evidence surface

Total is designed to accept a variable set of controlled evidence inputs at startup. A deployment may expose **3 through 1000 input channels**, depending on configuration, hardware, policy, and service profile.

Potential inputs include process/thread state, memory pressure, allocation observations, executable/library descriptors, package metadata, JVM/Graal runtime events, trusted software descriptors, signed configuration, filesystem provenance, service lifecycle events, application self-description, cgroup/PSI observations, integrity measurements, resource requests, and diagnostic/test evidence.

Evidence follows the conceptual path:

`input → normalization → provenance → validation → policy → action → observation → retained evidence`

An input is not trusted merely because it exists. Its source and provenance determine what it may influence.

## Position

```text
Applications / userland
        │
        │ controlled interface
        ▼
SecureJDK 28 / Graal
        │
        │ Proffer / JVM assistance
        ▼
      Total
 native C/C++ moderator
        │
        │ OS interfaces
        ▼
Linux kernel / VM / scheduler / security
```

Total is **not a replacement for the kernel**, Linux virtual memory, `malloc`, `free`, or the JVM garbage collector. Its initial role is observation, admission accounting, policy coordination, and controlled resource moderation. Strong intervention should be added only behind explicit policy, authorization, and tests.

## Root service function

The functions of Total are inward and main: they drive toward the service rather than becoming unrelated application logic.

The common root function is:

`observe → understand → admit → serve → measure → correct`

Related functions should be **memmerable**: implementations in Ground, Total, and Top should remain recognizable as implementations of the same root operation even when their local mechanisms differ.

## The manager

Total provides the middle-tier manager in three related senses:

- **manager** — policy and coordination;
- **manager** — the native service performing the work;
- **memory manager** — memory footprint, admission, accounting, pressure, and safe release/reclamation coordination.

The manager observes and mediates; it does not silently seize ownership of arbitrary application allocations.

## Initial native implementation

The first native skeleton provides:

- a C ABI in `include/total.h`;
- Linux `/proc/self/status` memory observation;
- configurable soft/hard memory limits;
- admission accounting for managed reservations;
- a long-running moderator process;
- a configuration file at `/etc/total/total.conf` by convention;
- an example configuration;
- a small standalone `Makefile`.

The current implementation intentionally does **not** seize ownership of arbitrary application allocations. Applications remain governed by their normal allocator and the operating system. This gives Total a safe foundation on which future memory-pressure, JVM-assistance, application-descriptor, and service-management policies can be built.

## Installation model

A future package should install approximately:

```text
/usr/bin/total
/etc/total/total.conf
/usr/lib/.../SecureJDK-28 integration
/usr/lib/.../Graal integration
```

System-wide installation may require root/administrator privileges. Boot integration should eventually use the host's native service manager, normally systemd on Linux, rather than embedding boot behavior into the executable itself.

## Configuration

See `total.conf.example`. Configuration is intentionally simple during the bootstrap phase. A future schema can be versioned and expanded for application policies, trusted software descriptors, JVM/Graal cooperation, memory-pressure thresholds, service priorities, desktop application treatment, provenance requirements, audit/telemetry policy, and capability restrictions.

## Trusted application treatment

Total may eventually recognize installed software through **trusted descriptors, package metadata, signatures, provenance, and explicit administrator policy**. A display name or brand alone is not sufficient evidence.

This permits an application and its assisting software—for example a database service, helper process, launcher, runtime component, or protection service—to be represented as a related software group without blindly trusting a string such as `mysql`.

The preferred model is:

```text
package identity
   + signer/provenance
   + executable identity
   + dependency metadata
   + administrator policy
          ↓
   trusted software descriptor
          ↓
   Total treatment profile
```

## JVM and native execution paths

The intended default for supported Java software is:

```text
Java application
      ↓
SecureJDK 28 / Graal
      ↓
JVM profiler / Proffer interface
      ↓
Total policy assistance
      ↓
Linux
```

Software that does not participate in the supported JVM path may continue to execute through the ordinary OS memory manager:

```text
native application
      ↓
libc / allocator
      ↓
Linux VM
```

Total should not silently impose JVM assumptions on native applications.

## Variance

Minor implementation variance between tiers, platforms, or service versions is permitted where it does not violate root invariants. This intentional **color** lets the framework remain practical across a future Linux ecosystem without requiring identical implementations everywhere.

Material variance must be surfaced as evidence and versioned policy. Variance must not silently alter authority, provenance, memory-safety guarantees, or proof meaning.

## Future Linux framework

The Linux implementation is deliberately designed as a foundation for a larger system. Future modules can add cgroup-aware memory moderation, PSI/memory-pressure observation, process/service grouping, systemd integration, eBPF-assisted observation where appropriate, secure IPC with SecureJDK/Graal, signed policy bundles, application lifecycle treatment, controlled reclamation/throttling, provenance-aware software identity, boot-time initialization, and administrator/user capability separation.

The architectural goal is a **grand, future Linux framework without making the bootstrap daemon itself grandiose**: the native core should remain small, auditable, deterministic, and explicit about what authority it has.

## Security boundary

Total is privileged infrastructure. It therefore follows least privilege, explicit authorization, bounded observation, fail-safe defaults, and auditable policy as design requirements.

Observation does not imply authorization; software identity is not inferred from branding alone; memory intervention requires explicit policy; userland exceptions must be capability-controlled; SecureJDK/Graal cooperation must use an authenticated interface; and malformed configuration must fail closed rather than invent policy.

## Status

This directory is the **native bootstrap implementation**. It is an architectural foundation, not yet a production kernel-integrated memory-management replacement. The next engineering phase should add tests, systemd packaging, secure IPC, cgroup integration, and a formal policy schema before enabling stronger intervention.
