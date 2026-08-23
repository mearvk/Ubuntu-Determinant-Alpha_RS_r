# SECUREJDK28.md — SecureJDK 28

## Overview

**SecureJDK 28** is the repository's modified OpenJDK 28 variant, implemented as a native HotSpot-oriented security and observability layer over the OpenJDK 28 development source. The project keeps the standard OpenJDK runtime model while adding explicit controls around class loading, native-library integrity, configuration loading, runtime inspection, observer access, resource ingestion, resident module registration, and database-oriented operational telemetry.

The repository identifies the implementation as **SecureJVM / SecureJDK 28**, with the current configuration identifying the edition as **Galactic Cherry Marvell Edition 98**. The checked-in configuration makes `.xclass` the preferred class representation and `.class` the fallback representation, and enables the principal SecureJVM modules by default.

The implementation is intended to be understood as a coordinated set of HotSpot extensions rather than as a conventional Java library. The central integration point is the JVM startup/configuration path: `arguments.cpp` includes the SecureJVM components `xmlConfigReader`, `jvmIntegrity`, `jvmInspector`, `jvmCircuit`, `jvmResourceLoader`, `jvmCodex`, and `jvmMySQLBridge`.

## Architecture

At a high level, SecureJDK 28 adds seven cooperating subsystems:

1. **ClassLoadGuard** — grades classes and applies global/per-grade quantity limits.
2. **JvmIntegrity** — checks startup/runtime integrity, native-library authorization, agent attachment, pointer alignment, and allocation-ratio discipline.
3. **JvmInspector** — records class-load history and provides authorization-aware class, native, code, frame, and history inspection.
4. **JvmCircuit** — supplies a tiered observer channel for JVM telemetry, reports, and multi-JVM grading concepts.
5. **JvmResourceLoader** — provides permission-gated loading and validation for native/configuration resources.
6. **JvmCodex** — maintains an in-resident registry of carefully installed modules and their operational metadata.
7. **JvmMySQLBridge** — records meaningful database-oriented interactions and computes an operand-weight model.

A separate **XML configuration reader** connects the checked-in `jvm-config.xml` to the normal JVM argument/property machinery. The configuration reader validates ownership and write permissions, rejects symlinks, limits file size, rejects DTD/external-entity constructs, parses a fixed schema, and feeds flags/properties/classpath entries through existing `Arguments` mechanisms.

## OpenJDK 28 Base and Build Model

The repository contains a native-source fetch/overlay workflow for OpenJDK 28. `fetch-openjdk-native.sh` performs a sparse checkout of native OpenJDK source, retaining C, C++, headers, and assembly sources for the selected HotSpot and native module paths. The Java build Makefile identifies the base as OpenJDK 28 Early Access Build 8 for Linux x64 and provides two primary paths: fetching a prebuilt JDK or building from the included source.

For source builds, the Makefile applies `userland/openjdk/jdk-src/src/` as a native overlay onto the full OpenJDK source tree before running `configure` and `make images`. The normal installation target places the resulting JDK under `/usr/lib/jvm/jdk-28` and installs the SecureJVM XML configuration into both the JDK `conf` directory and `/etc/jvm-config.xml` when those destinations are available.

## Class Loading Controls

`ClassLoadGuard` introduces an eight-level class-grade vocabulary: **Ungraded, Substitute, Gainer, Inheritor, Builder, Archetype, Manager, and Main**. Grade detection can use a lightweight `ClassGrade:` marker in bytecode and otherwise falls back to class-name heuristics such as `Manager`, `Controller`, `Builder`, `Factory`, `Impl`, `Cache`, `Registry`, `Proxy`, and related naming patterns.

The default configuration establishes a global maximum of **5,000 classes** and grade-specific ceilings: Main unlimited, Manager 100, Archetype 200, Builder 150, Inheritor 500, Gainer 300, Substitute 200, and Ungraded 2,000. The configured policy is `warn`, meaning that a quantity violation is recorded but does not by itself refuse the class. The implementation also supports soft and hard policies, with the hard policy capable of refusing a load.

JDK-internal namespaces such as `java/`, `jdk/`, `sun/`, `javax/`, `com/sun/`, `org/xml/`, and `org/w3c/` receive special handling in the class-load gate.

## Integrity Guardian

`JvmIntegrity` is the native integrity boundary. Its threat model explicitly covers `LD_PRELOAD` interposition, unauthorized `dlopen()` libraries, late JVMTI attachment, tracing, allocator manipulation, and suspicious allocation sizing.

At startup it initializes two canaries, checks `LD_PRELOAD`, checks `/proc/self/status` for `TracerPid`, and locks agent attachment by default. Native libraries are authorized through a strict path/name menu. The implementation recognizes controlled JDK/system library locations and known JDK library names; an unauthorized library load is rejected and counted as a violation.

The allocation discipline is expressed as **1:1 or 1:2** request-to-actual allocation ratios, with alignment to an explicit grid. `validate_alloc_size()` accepts aligned 1:1 or 1:2 results and records suspicious non-grid/fractional results as integrity violations. Returned pointers are also checked for minimum alignment and obviously invalid low addresses.

The integrity watchdog can re-check canaries, tracing state, process mappings, and environment state. This makes integrity a continuing runtime property rather than a one-time startup decision.

## Secure Configuration and `.xclass`

The checked-in `userland/openjdk/jvm-config.xml` defines SecureJVM version 28 and makes **`.xclass` the primary format**, with ordinary `.class` files as fallback. The configured search order gives `.xclass` priority 1 and `.class` priority 2. Watched `.xclass` locations include `/opt/jvm/xclasses/`, `/etc/jvm/xclasses/`, and a per-user location.

The configuration also enables metadata feeds into ClassLoadGuard, IntegrityGuardian, ObserverCircuit, MemoryProxy, SystemCodex, and INTLoader.

The XML reader is deliberately minimal rather than dependent on a general-purpose XML library. It validates ownership, rejects world-writable files, rejects unsafe group ownership, requires regular files, uses `O_NOFOLLOW`, enforces a maximum file size, rejects DTD/ENTITY/SYSTEM constructs, parses the fixed `jvm-config` schema, and applies flags through `Arguments::parse_argument()`.

One important implementation note is that the XML signature field is presently a **validation hook rather than cryptographic verification**: the reader recognizes `sha256:` syntax, but the current implementation contains a TODO for actually hashing and comparing the signed content. The documentation therefore should not describe XML signatures as fully enforced until that code is completed.

## Pause-Frame Inspector

`JvmInspector` maintains a class-load history from JVM inception, including class name, loader, load time, sequence number, bytecode size, native-method presence, and whether the class belongs to the JDK.

Three operator grades are defined:

- **Local (1):** application-class inspection with restricted views.
- **National (2):** broader class/JDK inspection, but no full code view.
- **International (3):** native-frame and JIT/code inspection.

Inspection views include class structure, native backing, stack-frame information, compiled/interpreted code, and historical load information. The inspector can also operate in a pause-and-inspect model with resume, quarantine, halt, and pending verdict states.

The implementation constructs technical frames from `InstanceKlass`, including superclass, interfaces, fields, methods, native-method counts, instance size, modifiers, source file, and historical load sequence. Native inspection can identify resolved native entry points and associated dynamic-library symbols when available.

## Observer Grade Circuit

`JvmCircuit` defines the main JVM circuit plus three observer levels. Observer sessions carry circuit level, role, identity, authority, connection time, and socket information. The system defines reporting grades from A through F and a linked-JVM model for system-wide grading.

The intended interfaces include SSH, a disabled-by-default telnet path, and a Unix-domain socket. The checked-in implementation currently makes the Unix socket the most concrete local transport: it attempts to create `/var/run/jvm-circuit-<pid>.sock` with owner-only permissions when the runtime environment permits it.

The SSH path is currently represented as listener readiness and a TODO for launching a real SSH listener; therefore the documentation treats SSH as an architectural interface rather than claiming that a complete SSH server is already embedded in HotSpot.

Observer telemetry covers class loads, GC events, thread events, security events, and integrity violations. Higher circuit levels add inspection, reports, grading, linking, chain grading, and archival concepts.

## Secure Resource Loader

`JvmResourceLoader` provides a permission-gated resource pipeline:

**identify → validate → permission → appropriate → register**

The supported native/configuration types are C, assembly, C++ headers, JSON, and XML. Permission grades are:

| Grade | Access |
|---|---|
| 1 — Application | JSON and XML |
| 2 — Trusted | JSON, XML, HPP |
| 3 — System | JSON, XML, HPP, C, assembly |
| 4 — Kernel | All types, unrestricted/bypass level |

Validation is type-specific. C content checks for dangerous process execution/dynamic-loading patterns; assembly rejects ELF interpreter injection and certain execution paths; C++ headers are checked for guards and JVM-shadowing macros; JSON is bounded by size and nesting constraints and rejects embedded script markers; XML rejects DTD, ENTITY, and SYSTEM constructs and has a nesting limit.

Loaded resources are inventoried with path, type, size, SHA-256 field, loader identity/grade, load time, status, and managed content. Secure file reads reject non-regular files and world-writable files and apply per-type size ceilings.

## System Codex

`JvmCodex` is an in-resident module registry. Entries contain identity, size, shape, color, functionality, rigor, improvement information, installer grade, installer identity, installation time, active state, and optional embedded code.

The registry defines installer grades from User III through Normal VI++, and code visibility is separated from basic metadata access. Installer IV+ is required to register, withdraw, or reactivate entries. The `ICodexAware` interface supplies a vocabulary for neighboring modules to report identity, altitude, relevance, operational timing, resource-conservation state, novelty handling, and signal-destiny reacquisition.

The codex should be understood as a metadata/registry architecture. It is not itself a replacement for ordinary dynamic linking or Java class loading.

## MySQL Operand Bridge

`JvmMySQLBridge` provides the JVM-side model for meaningful database interactions. Its records identify the interaction type, hand type, identity, authority, target table/field, description, timestamp, acknowledgment state, and computed weight.

Touch types are **Concern, Direct Touch, Schedule, and Orient**. Hand types are **International, Technical, Orientar, and Realtor**. Each interaction is assigned four dimensions — **title, earned, money, and pocket** — which are combined into a composite score.

The current C++ implementation establishes the bridge state and JVM-side accounting semantics. It explicitly notes that a production MySQL connection would call `mysql_real_connect()` with TLS and that the actual client-library integration occurs at link time. Consequently, the current source should be described as the bridge/semantics layer, not as proof that a live MySQL connection is already established in every build.

## Default SecureJVM Configuration

The current XML configuration enables the major SecureJVM modules by default and establishes representative runtime policy:

- 4 GiB maximum heap and 512 MiB initial heap.
- G1 GC with a 200 ms pause target.
- Tiered compilation enabled.
- Native-memory tracking enabled.
- Heap dumps enabled for out-of-memory conditions.
- ClassLoadGuard global ceiling of 5,000.
- Integrity checks including preload detection, library authorization, late-agent lock, ptrace monitoring, and 1:1/1:2 allocation discipline.
- Pause inspector enabled.
- Observer circuit with SSH enabled in configuration, telnet disabled, and Unix socket enabled.
- Resource validation enabled.
- System Codex enabled.
- MySQL bridge configured for localhost port 3306 with TLS intent.
- Memory Proxy budgets for RAM, disk rates, descriptors, CPU, threads, and children.
- Four-tier INT loading order and recycling.
- XML configuration ownership, world-writable, symlink, size, and DTD protections.

## Integration Path

The SecureJDK 28 integration path is intentionally centralized around JVM startup and runtime services:

```text
                       OpenJDK 28 / HotSpot
                                |
                        Arguments / startup
                                |
             +------------------+------------------+
             |                  |                  |
        XML Config          Integrity         Class Loading
             |                  |                  |
       flags/properties   JvmIntegrity      ClassLoadGuard
             |                  |                  |
             +-----------+------+----------+-------+
                         |                 |
                    Runtime services      |
                         |                 |
       +-----------------+-----------------+----------------+
       |                 |                 |                |
   Inspector          Circuit         Resource Loader     Codex
       |                 |                 |                |
       +-----------------+-----------------+----------------+
                         |
                    MySQL Bridge
```

The important design characteristic is that these modules are not merely external monitoring tools. They are written as native HotSpot components and are included directly by the JVM argument-processing implementation, allowing them to participate in JVM lifecycle and runtime state.

## Security Posture and Current Limitations

SecureJDK 28 should currently be described as an **active development implementation**, not as a finished security certification. Several components contain explicit TODOs, placeholders, or environment-dependent interfaces.

Most notably:

- XML SHA-256 signature recognition exists, but cryptographic verification is not yet implemented.
- The JvmCircuit SSH path currently logs listener readiness rather than launching a complete SSH server.
- The MySQL bridge contains JVM-side connection semantics while leaving actual client-library connection integration to link time.
- Some observer/network operations are deliberately deferred during build/bootstrap contexts.
- The class-load policy defaults to `warn`, so the configured ceiling does not automatically become a hard security boundary.
- The repository's native-source overlay is a partial OpenJDK source set; a complete reproducible build still depends on the corresponding full OpenJDK 28 source tree and compatible boot JDK/toolchain.

These limitations are important because they distinguish **implemented architecture and source-level controls** from **fully deployed, independently verified security guarantees**.

## Build and Maintenance

The normal source workflow is:

1. Obtain the OpenJDK 28 source tree expected by the repository.
2. Populate `userland/openjdk/jdk-src/` with the native overlay.
3. Use `userland/java/Makefile` and `make build-from-source` with a suitable boot JDK.
4. The Makefile copies the native overlay into the full source tree before configuration/build.
5. Install the generated JDK with `make install-from-source` and an explicit `DESTDIR`.
6. Install or verify `jvm-config.xml` in the JDK `conf` directory and `/etc` as appropriate.

The native-source fetch script records its provenance as OpenJDK 28 development-trunk native source and intentionally limits the fetched content to native source formats and selected HotSpot/JDK native directories.

## Summary

**SecureJDK 28 is a modified OpenJDK 28/HotSpot implementation whose central idea is to make security, integrity, inspection, resource admission, and operational awareness explicit native JVM services.** The implementation combines class-load grading, native-library and allocation integrity checks, authorized inspection, observer circuits, permission-gated resource loading, an in-resident codex, XML-driven startup configuration, and database-oriented interaction accounting.

The result is best viewed as a **security-oriented JVM research/development branch** with a substantial native architecture already represented in source. The repository's next maturity steps are conventional engineering ones: complete the remaining transport and cryptographic integrations, connect every declared subsystem into the corresponding HotSpot lifecycle hooks, build the full source tree reproducibly, add automated tests for each security boundary, and independently validate the resulting runtime behavior.

---

**Source basis:** SecureJVM/OpenJDK 28 native overlay and configuration currently present under `userland/openjdk/`, including `jvmIntegrity`, `jvmInspector`, `jvmCircuit`, `jvmResourceLoader`, `jvmCodex`, `jvmMySQLBridge`, `xmlConfigReader`, `ClassLoadGuard`, `jvm-config.xml`, the native-source fetch script, and the OpenJDK 28 build Makefile.

**License context:** The modified native sources identify GPL-2.0 with Classpath Exception licensing, while upstream OpenJDK components retain their upstream notices and licensing terms.
