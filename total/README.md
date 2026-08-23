# Total Native Moderator

**Total** is the native C implementation of the project's moderator layer. It is designed to run above the Linux kernel and below ordinary userland policy, with optional controlled cooperation with SecureJDK 28 and Graal.

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

System-wide installation may require root/administrator privileges. Boot integration should eventually use the host's native service manager (for Linux, normally systemd) rather than embedding boot behavior into the executable itself.

## Configuration

See `total.conf.example`. Configuration is intentionally simple during the bootstrap phase. A future schema can be versioned and expanded for:

- application policies;
- trusted software descriptors;
- JVM/Graal cooperation;
- memory-pressure thresholds;
- service priorities;
- desktop application treatment;
- provenance requirements;
- audit/telemetry policy;
- capability restrictions.

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

## Future Linux framework

The Linux implementation is deliberately designed as a foundation for a larger system. Future modules can add:

- cgroup-aware memory moderation;
- PSI/memory-pressure observation;
- process and service grouping;
- systemd integration;
- eBPF-assisted observation where appropriate;
- secure IPC with SecureJDK/Graal;
- signed policy bundles;
- application lifecycle treatment;
- controlled reclamation and throttling;
- provenance-aware software identity;
- boot-time initialization;
- administrator/user capability separation.

The architectural goal is a **grand, future Linux framework without making the bootstrap daemon itself grandiose**: the native core should remain small, auditable, deterministic, and explicit about what authority it has.

## Security boundary

Total is privileged infrastructure. It therefore follows least privilege, explicit authorization, bounded observation, fail-safe defaults, and auditable policy as design requirements.

In particular:

- observation does not imply authorization;
- software identity is not inferred from branding alone;
- memory intervention requires explicit policy;
- userland exceptions must be capability-controlled;
- SecureJDK/Graal cooperation must use an authenticated interface;
- malformed configuration must fail closed rather than invent policy.

## Status

This directory is the **native bootstrap implementation**. It is an architectural foundation, not yet a production kernel-integrated memory-management replacement. The next engineering phase should add tests, systemd packaging, secure IPC, cgroup integration, and a formal policy schema before enabling stronger intervention.
