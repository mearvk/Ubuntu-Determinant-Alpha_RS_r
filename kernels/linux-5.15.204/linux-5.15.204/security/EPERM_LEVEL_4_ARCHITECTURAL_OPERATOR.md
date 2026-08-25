# EPERM Level 4 — Architectural Operator Model

**Status:** Architecture/design specification

**Scope:** Ubuntu Determinant kernel, userland, build system, policy layer, and administrative tooling

**Purpose:** Define what a Level 4 (`Trusted`) operator is permitted to use, alter, inspect, connect, and propose across the operating-system architecture.

---

## 1. Meaning of Level 4

Level 4 is an **architectural operator authority**.

A Level 4 operator is trusted to work on the construction and remedy of the system: architecture, design, implementation, integration, diagnosis, testing, and controlled operational change.

The grade is therefore not a statement that the person is infallible, nor should it be interpreted as an unlimited root-equivalent privilege. It is an authorization class for **architectural work**.

The central principle is:

> **Level 4 may alter the parts necessary to remedy, construct, integrate, test, and improve the architecture, subject to scope, provenance, validation, and concordance requirements.**

Level 4 authority should be broad enough that an operator is not prevented from repairing a system merely because the repair crosses an ordinary component boundary. At the same time, the resulting change must remain observable, attributable, reviewable, and reversible where technically possible.

---

# 2. The operating-system pieces

The repository is best understood as a collection of cooperating layers rather than unrelated programs.

```text
                    OPERATOR / ADMINISTRATION
                              |
                 EPERM / POLICY / AUDIT
                              |
        +---------------------+---------------------+
        |                     |                     |
      KERNEL               USERLAND             BUILD
        |                     |                     |
   drivers / VM /       services / GUI /       toolchains /
   security / IPC       desktop / apps         packaging
        |                     |                     |
        +---------- ROOTFS / INITRAMFS -----------+
                              |
                       BOOT / GRUB / EFI
                              |
                         HARDWARE / VM
```

The principal co-parts are:

1. **Hardware and virtualization**
2. **Bootloader and boot artifacts**
3. **Linux kernel**
4. **Kernel security/EPERM**
5. **Kernel modules and drivers**
6. **Kernel IPC, namespaces, cgroups, networking and storage**
7. **Root filesystem**
8. **Initramfs**
9. **systemd/services**
10. **Native userland**
11. **X11/display stack**
12. **JDesk/desktop layer**
13. **Java/OpenJDK**
14. **JavaFX administrative GUI**
15. **Chromium/web layer**
16. **Compatibility layers such as Wine/Darling**
17. **Total/native policy subsystem**
18. **Build system and toolchains**
19. **Installers and packaging**
20. **Tests, evidence, provenance, and documentation**

No part should be considered independently complete if its required concords with these neighboring parts are broken.

---

# 3. Part detail versus concord detail

A **part detail** describes one component internally.

A **concord detail** describes how two or more components agree on an interface, contract, state, or assumption.

For example:

```text
Part detail:
  Linux kernel builds successfully.

Concord detail:
  Kernel version, modules, initramfs, rootfs, bootloader,
  module paths, and userland startup all agree on that kernel.
```

A Level 4 operator may work at either level.

A production-quality architectural change must address both.

---

# 4. Level 4 operator rights

The Level 4 operator may, within the authorized operating environment:

- inspect source, configuration, binaries, logs, interfaces, and build artifacts;
- modify kernel source and configuration;
- modify kernel modules and drivers;
- modify security policy and EPERM implementation;
- modify rootfs assembly;
- modify initramfs construction;
- modify boot configuration and boot artifacts;
- modify native userland;
- modify X11 and desktop integration;
- modify JDesk and its native interfaces;
- modify Java/OpenJDK integration;
- modify the JavaFX administration layer;
- modify service definitions and startup contracts;
- modify build scripts and installation scripts;
- construct tests and diagnostic tooling;
- introduce controlled architectural remedies;
- rebuild affected components;
- run integration and system tests;
- inspect and repair dependency relationships;
- propose or implement changes crossing component boundaries;
- record the rationale and evidence for architectural changes.

These rights describe **operator capability**, not permission to bypass every security mechanism for arbitrary purposes.

---

# 5. Kernel operator surface

The kernel is the Ground layer.

Level 4 may work on:

### 5.1 Kernel configuration

- `Kconfig`
- project defconfig
- architecture configuration
- feature selection
- module selection
- debugging configurations
- security configurations

A configuration change must identify its implementation and test consequence.

### 5.2 Kernel source

The operator may repair:

- scheduler-related code;
- memory management;
- VFS/filesystems;
- networking;
- IPC;
- drivers;
- architecture code;
- kernel interfaces;
- security hooks;
- project-specific subsystems.

The operator should preserve upstream interfaces unless the repository deliberately establishes a documented fork.

### 5.3 Kernel modules

Level 4 may:

- build modules;
- repair module source;
- update module dependencies;
- inspect module loading;
- validate module signatures/policy;
- test load/unload behavior;
- reconcile modules with the target kernel.

---

# 6. EPERM/security operator surface

EPERM is a policy boundary, not merely another application.

Level 4 may:

- inspect authorization policy;
- propose policy changes;
- implement narrowly scoped authorization rules;
- inspect security events;
- add audit information;
- test positive and negative authorization paths;
- repair policy/kernel integration;
- establish emergency remediation procedures.

The Level 4 role does **not** make subjective human classification itself sufficient authority for arbitrary kernel access. The Level 4 grade authorizes architectural work; the implementation should translate that authority into explicit, scoped operator capabilities.

A Level 4 remediation therefore follows:

```text
operator identity
      -> Level 4 architectural authority
      -> requested operation
      -> affected component
      -> policy evaluation
      -> validation requirement
      -> audit/provenance record
      -> implementation
      -> test
      -> concord verification
```

---

# 7. Root filesystem

The rootfs is the concord between kernel services and userland.

Level 4 may alter:

- directory structure;
- installed binaries;
- libraries;
- configuration;
- users/groups;
- service files;
- device expectations;
- package contents;
- Java installations;
- desktop assets;
- launchers.

The operator must preserve the relationship:

```text
package -> installed path -> runtime dependency -> service/application
```

A binary existing in rootfs does not establish that the application is operational.

---

# 8. Initramfs and boot

Level 4 may alter:

- initramfs generation;
- early userspace scripts;
- kernel modules included in initramfs;
- root-device discovery;
- filesystem initialization;
- boot parameters;
- GRUB configuration;
- EFI/boot artifacts where applicable.

Boot changes require boot testing because an apparently local change can prevent the entire operating system from reaching userland.

Required concord:

```text
kernel version
  == module version
  == initramfs module set
  == rootfs expectations
  == bootloader configuration
```

---

# 9. systemd and services

Level 4 may create or repair service definitions, including:

- service units;
- dependencies;
- startup ordering;
- environment configuration;
- socket activation;
- restart behavior;
- resource controls;
- logging;
- shutdown behavior.

A service is complete only when:

```text
binary exists
+ configuration exists
+ service unit exists
+ dependencies resolve
+ startup succeeds
+ health check succeeds
+ shutdown/restart behaves correctly
```

---

# 10. Native userland

Native applications are subordinate to the kernel ABI and rootfs contract.

Level 4 may:

- repair C/C++ implementations;
- alter headers and ABI contracts;
- repair Makefiles;
- introduce tests;
- improve diagnostics;
- change installation paths;
- reconcile runtime dependencies.

The operator must distinguish source-present from buildable and buildable from installed.

Recommended state model:

```text
DESIGNED
SOURCE_PRESENT
BUILDABLE
BUILT
TESTED
PACKAGED
INSTALLED
LAUNCHABLE
INTEGRATED
```

---

# 11. X11 and graphical stack

The X11 stack is a layered dependency graph:

```text
kernel DRM/input
      |
X.Org libraries
      |
X server
      |
X applications / desktop
      |
JDesk / JavaFX GUI
```

Level 4 may alter any layer necessary for an architectural remedy, but changes should record the affected ABI or protocol boundary.

Graphics changes should be tested in a graphical VM/session where practical.

---

# 12. JDesk

JDesk is a bridge between native Linux services and Java desktop applications.

Its concords include:

```text
Linux/X11
   <-> native JNI layer
   <-> Java launcher/application
   <-> JavaFX/desktop management
```

Level 4 may modify native code, JNI interfaces, Java code, launcher behavior, and installation contracts.

JNI changes require both native and Java-side tests.

---

# 13. Java/OpenJDK

The Java layer is both a runtime and a build dependency.

Level 4 may alter:

- bootstrap JDK configuration;
- OpenJDK source overlays;
- build scripts;
- JVM configuration;
- Java runtime installation;
- Java application launchers;
- JavaFX integration.

The important concord is:

```text
bootstrap JDK
 -> build JDK
 -> installed JDK
 -> application runtime
 -> GUI/runtime libraries
```

Each transition must be reproducible.

---

# 14. JavaFX administration GUI

The GUI should represent the actual state of the system rather than infer operational status from filenames.

Level 4 may modify:

- application registry;
- installation controls;
- diagnostics;
- configuration screens;
- service controls;
- build/status reporting;
- policy administration UI;
- operator audit presentation.

The preferred state display is:

```text
SOURCE
BUILDABLE
BUILT
INSTALLED
RUNNING
HEALTHY
```

A missing state must not be presented as success.

---

# 15. Chromium and web layer

Chromium is an external-source, heavyweight build component.

Level 4 may alter its integration, launcher, sandbox configuration, installation, and surrounding userland contracts.

The operator should not silently replace the project's declared Chromium version or source provenance.

Build provenance should identify:

- source revision;
- build toolchain;
- patches;
- build options;
- resulting artifact.

---

# 16. Compatibility layers

Wine and Darling represent compatibility boundaries rather than ordinary native applications.

Level 4 may alter their build and integration contracts but should preserve isolation between:

```text
foreign application model
       |
compatibility layer
       |
Linux ABI/kernel
       |
rootfs
```

A compatibility change should not silently modify unrelated native authorization semantics.

---

# 17. Total and policy services

The Total subsystem is an architectural policy component.

Its interfaces should concord with:

- kernel policy;
- memory/resource accounting;
- native callers;
- evidence/provenance;
- IPC;
- systemd;
- Java/JDK integration where specified.

Level 4 may alter its domain model, policy implementation, native ABI, tests, and integration contracts.

It should remain an explicit policy layer rather than replacing kernel primitives such as the VM, allocator, or JVM garbage collector.

---

# 18. Build system as an operator instrument

The build system is itself part of the architecture.

Level 4 may modify:

- top-level Makefiles;
- component Makefiles;
- toolchain selection;
- compiler flags;
- dependency resolution;
- packaging;
- installation scripts;
- test targets;
- CI.

Every declared build target should correspond to an actual component or be explicitly labeled planned.

The operator should be able to answer:

```text
What does this target build?
Where does it install?
What does it depend on?
What tests prove it?
What other components depend on it?
```

---

# 19. Concords

The principal system concords are:

### Kernel ↔ modules

Module ABI and kernel version must agree.

### Kernel ↔ initramfs

Early boot modules and configuration must match the kernel.

### Kernel ↔ rootfs

Device, filesystem, IPC, networking, and security expectations must agree.

### Rootfs ↔ systemd

Installed service binaries and units must agree.

### systemd ↔ applications

Startup ordering, users, environment, sockets, and dependencies must agree.

### X11 ↔ kernel

DRM/input/display interfaces must agree.

### X11 ↔ JDesk

Native display interfaces and JNI assumptions must agree.

### JDesk ↔ Java

JNI ABI and Java launcher/runtime expectations must agree.

### Java ↔ JavaFX GUI

Runtime version and JavaFX dependencies must agree.

### Chromium ↔ rootfs

Sandbox, libraries, executable paths, and runtime dependencies must agree.

### Total ↔ kernel/userland

Policy ABI, resource accounting, provenance, and administrative semantics must agree.

### Build ↔ installation

The artifact produced must be the artifact installed.

### Documentation ↔ implementation

Documentation must distinguish implemented, tested, experimental, and planned behavior.

---

# 20. Alteration protocol

A Level 4 architectural change should be handled as:

### Step 1 — Identify the part

Name the component being changed.

### Step 2 — Identify neighboring parts

List its direct consumers, providers, build dependencies, runtime dependencies, and policy dependencies.

### Step 3 — State the remedy

Describe what defect, limitation, or architectural opportunity the change addresses.

### Step 4 — Identify the concords

Write down which interfaces or assumptions must remain synchronized.

### Step 5 — Make the smallest coherent change

Change the complete architectural unit rather than producing a partial repair that leaves contradictory states.

### Step 6 — Build

Build the affected part and all directly affected dependents.

### Step 7 — Test

Run unit, integration, negative, and runtime tests appropriate to the boundary.

### Step 8 — Record evidence

Record commit, source revision, build command, test result, and artifact identity.

### Step 9 — Validate concords

Check the neighboring components after the change.

### Step 10 — Promote

Only after validation should the change move into the normal integrated build.

---

# 21. Operator rights by scope

| Scope | Level 4 right | Required concord check |
|---|---|---|
| Documentation | Read/write | README/spec agreement |
| Build scripts | Read/write/execute | Artifact/install agreement |
| Native userland | Read/write/build/test | ABI/runtime |
| Desktop | Read/write/build/test | X11/JDesk/Java |
| Java/JDK | Read/write/build/test | Bootstrap/runtime |
| Services | Create/modify/test | systemd/rootfs |
| Rootfs | Construct/modify/test | kernel/init/service |
| Initramfs | Construct/modify/test | kernel/modules/rootfs |
| Kernel config | Modify/build/test | source/config/boot |
| Kernel source | Modify/build/test | ABI/module/boot |
| Kernel modules | Modify/build/load/test | kernel ABI |
| EPERM policy | Modify/test | credentials/LSM/audit |
| Bootloader | Modify/test | kernel/initramfs/rootfs |
| Provenance | Create/verify | artifact/source identity |
| Production promotion | Propose/execute when authorized | full integration gate |

---

# 22. What Level 4 does not mean

Level 4 does not mean:

- every operation is automatically correct;
- every protected resource is permanently accessible;
- audit can be disabled without record;
- policy changes are invisible;
- source provenance may be discarded;
- tests may be skipped because the operator is trusted;
- security boundaries may be bypassed for convenience;
- an architectural change may be promoted without checking concords.

The purpose of Level 4 is precisely to give the operator enough authority to **repair the boundaries responsibly**.

---

# 23. Concord-first architecture

The repository should eventually treat concords as first-class objects.

A concord record could contain:

```text
concord_id
left_component
right_component
interface
version
required_state
validation_command
last_verified_commit
status
owner
```

For example:

```text
KERNEL-INITRAMFS-001
kernel: 5.15.204
initramfs: matching module set
validation: boot QEMU serial test
status: verified
```

This would let the Level 4 operator work from architectural relationships rather than merely a directory tree.

---

# 24. Architectural remedy model

A Level 4 operator's principal job is not merely to edit files.

It is to move the system from:

```text
observed defect
    -> understood part
    -> understood dependency
    -> understood concord
    -> remedy
    -> implementation
    -> verification
    -> recorded evidence
    -> stable concord
```

That is the intended meaning of **architectural remedy** in the Ubuntu Determinant system.

---

## 25. Final operator principle

> **Level 4 is authority to work across the architecture, not authority to ignore the architecture.**

The Level 4 operator may inspect, construct, alter, test, connect, repair, and propose changes across kernel and userland boundaries when those actions are necessary for architectural work. The system remains responsible for making those actions explicit, scoped, attributable, testable, and concordant with the rest of the operating system.

This document defines the intended interaction model. It does not by itself grant kernel privileges or alter EPERM behavior.