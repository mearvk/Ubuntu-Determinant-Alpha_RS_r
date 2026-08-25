# Repository Completion Audit — PARAGRAPHS

Date: 2026-08-24

## Purpose

This document records the reasoning from the repository inspection before implementation work continues. The objective is to identify projects that appear to have begun from a design/specification and then stopped before the implementation, build integration, tests, or operational completion caught up with the design.

## Current architectural reading

The repository is not merely a collection of unrelated experiments. Its README describes a common systems direction spanning SecureJDK/Graal, native C/C++, operating-system state, memory, process state, provenance, policy, UTF-4088, and JPIX. The central architectural statement is a three-tier model: Ground establishes operating-system facts; Total provides the native middle layer; Top supplies managed-runtime and application semantics. The README explicitly describes Total as a conservative bootstrap rather than a finished replacement for Linux memory management or JVM garbage collection. fileciteturn25file0L2-L2

## First concrete completion signal: Total

Total is the clearest example of a project that began with a fairly complete design and has a smaller implementation underneath it. Its documentation specifies a 3–1000 input registry, evidence normalization/provenance/validation, a policy-provider boundary, memory observation, future cgroup/PSI controls, authenticated JVM/Graal cooperation, and systemd packaging. It also explicitly lists several of those pieces as still to be implemented. fileciteturn14file0L2-L2

The native interface layer is real: `total_domain.h`, `total_policy.h`, and `total_input.h` define separate domain, policy, and input concepts. The interfaces deliberately keep evidence separate from authority. fileciteturn3file0L2-L2 fileciteturn4file0L2-L2 fileciteturn5file0L2-L2

The implementation is bootstrap-level: the architecture described by the documentation still needs to be reconciled with the complete source/build/test path. The documented first-edition status explicitly says that production policy providers, cryptographic provenance, formal input-source adapters, authenticated IPC, cgroup/PSI memory controls, the SecureJDK/Graal bridge, systemd packaging, and broader CI/integration testing remain future work. fileciteturn2file0L2-L2

## Important Total build-completeness finding

The public headers already establish a concrete API surface, including a versioned policy ABI and a caller-owned 3–1000 input registry. fileciteturn4file0L2-L2 fileciteturn5file0L2-L2 The next practical Total completion task should therefore reconcile the declared public API, source files, test fixtures, and Makefile rather than adding more architecture. The build should compile every intended implementation unit and explicitly build/run the native tests.

## Kernel investigation

The repository's top-level build identifies Linux 5.15.204 as the kernel target and provides dedicated targets for normal kernel compilation, a project defconfig, menuconfig, modules, installation, and a standalone x86_64 assembly pass. fileciteturn6file0L2-L2 This indicates that the kernel is intended to be a real buildable foundation rather than only a design document.

A direct lookup for a literal `kernel/README.md` did not resolve. The build instead points to `kernels/linux-5.15.204/linux-5.15.204`. This path must be resolved directly before claiming that the kernel source is complete. The audit should verify:

1. the kernel source tree is actually present and complete;
2. `galactic_cherry_defconfig` exists and produces a valid configuration;
3. every claimed kernel extension has source, Kconfig/Makefile integration, and tests where appropriate;
4. the ordinary kbuild path is authoritative and the standalone assembly target does not create conflicting objects;
5. modules, firmware expectations, initramfs, and rootfs installation agree on the same kernel version;
6. a QEMU boot test reaches userspace and produces a useful serial log.

If the kernel source is absent or external, the documentation should say so clearly and identify the exact dependency instead of presenting the Ground tier as a completed local kernel.

## Userland investigation

The userland README describes a broad set of components: Ubuntu Base, X11, wallpapers, OpenJDK 28, boot JDK 27, Chromium, NitroWebExpress/JWSTF, Darling, DRM, IntelliJ Community, Java, JDesk, Semeru OpenJDK 8, and Wine. It also describes a shared JavaFX management GUI intended to provide a consistent user-facing layer. fileciteturn8file0L2-L2

This is a substantial integration surface. The likely completion gaps are therefore:

- source/build manifests that name components but do not yet produce installable artifacts;
- installers whose target paths differ from the Makefile/rootfs layout;
- GUI launchers whose applications do not yet have stable executable contracts;
- Java/JDK overlays that require a reproducible bootstrap sequence;
- compatibility layers that have source but no tested runtime contract;
- service packages that are documented but not wired into systemd/rootfs/ISO assembly.

The shared GUI is a particularly useful integration point because it can become the human-facing inventory of what is actually installed versus merely specified. It should report status rather than imply successful installation.

## Build-system concern

The top-level Makefile is ambitious and useful. It defines kernel, assembly, userland, X11, wallpapers, tools, rootfs, initramfs, GRUB, and ISO assembly targets, and it documents a full-build sequence. fileciteturn6file0L2-L2 A completion pass should reconcile every declared target against the actual tree: detect targets with no source/build recipe, source directories without targets, and targets whose paths or dependencies have drifted.

Warnings are currently suppressible by default. For development and CI, a strict mode should run with warnings enabled and should not hide compiler diagnostics. Silent output can remain a convenience mode, but it should never be the only quality gate.

## Completion classification

For every top-level project, record:

`project | design present | source present | build target | tests | install target | runtime test | status | blocker`

Use four states:

1. **Designed + implemented + built/tested** — candidate for hardening.
2. **Designed + partially implemented** — candidate for a source/build/test completion pass.
3. **Designed + documentation only** — candidate for a minimal reference implementation or an explicit research-specification status.
4. **Historical/experimental/deprecated** — preserve provenance but do not accidentally treat as active production code.

## Definition of complete

A subsystem should be marked complete for this repository milestone only when its source/design files exist; its build entry point exists; the build succeeds on the declared host/toolchain or a documented blocker is recorded; its install/package path is tested; its runtime or self-test succeeds where applicable; dependencies and ownership boundaries are explicit; failures are observable and actionable; and documentation distinguishes implemented behavior from future design.

## Recommended completion order

The clean dependency order is:

`tree classification → kernel/Ground resolution → userland project inventory → design/source gap detection → build/test reconciliation → source completion → CI verification → documentation/status update`

The repository already contains extensive architecture documentation. The higher-value operation is to connect each design to executable source, tests, build targets, installation, and reproducible evidence rather than adding another broad conceptual layer.

The kernel should be audited first because it is the Ground layer. Then Total and the userland assembly should be checked against that kernel contract. This produces a clean dependency order instead of attempting to complete unrelated projects simultaneously.
