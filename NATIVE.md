# NATIVE — Native Shim and Thin Java Runtime Premise

**Project:** Ubuntu Determinant  
**Edition:** Ubuntu White Edition  
**Project attention:** Max Rupplin — MEARVK LLC — 2026  
**Status:** Design premise / probabilistic engineering note

## 1. Native Linux shim premise

The first working assumption is that a **modest Linux native shim** can be treated as approximately **2 GB in thin-system terms** when considering the practical footprint of the minimal operating environment, native support, installer/runtime dependencies, and room for operational tooling.

This is a **design estimate, not a fixed specification**. A bootable kernel, initramfs, firmware, device support, filesystem tooling, installer, libraries, diagnostics, and desktop/runtime components can move the actual footprint substantially.

The useful engineering concept is therefore:

```text
modest Linux base
    + native hardware shim
    + required runtime facilities
    ≈ thin native platform
```

The 2 GB figure should be treated as a planning envelope until an actual image is built, measured, boot-tested, and profiled across supported hardware.

## 2. Thin-metal Java premise and native `.asysma` control plane

The second assumption is that Java should operate as a **thin professional runtime layer above a modest native operating system**, rather than requiring a large general-purpose desktop environment merely to launch the installer.

The design additionally proposes a native Java executable/control artifact named:

```text
.asysma
```

`.asysma` is a **project-defined execution concept**, not a claim that Java or the operating system currently recognizes this extension as a standard executable format. Its purpose is to describe a single, controlled Java entry point that establishes the connection between the Java control plane and the host operating system.

Conceptually:

```text
hardware
  ↓
modest native OS / Linux shim
  ↓
OS / kernel inspection boundary
  ↓
Java `.asysma` control entry
  ↓
JDK / Java 21 runtime
  ↓
JavaFX professional launcher
  ↓
White Edition Installer
```

The `.asysma` entry point should be capable of determining, through supported operating-system interfaces:

- operating-system family;
- operating-system version;
- kernel version where applicable;
- architecture;
- runtime availability;
- relevant stability/health indicators;
- privilege state;
- available system resources;
- supported native facilities;
- virtualization capability;
- installer compatibility.

It should use documented APIs, standard interfaces, and narrowly scoped native adapters rather than attempting arbitrary kernel memory access.

### Single-connection principle

The preferred design is one **well-defined system connection** from the Java control plane to the host abstraction layer. That connection should expose a stable capability model rather than a collection of uncontrolled commands.

```text
.asysma
   │
   └── Host/System Contract
          ├── identity
          ├── version
          ├── stability
          ├── capabilities
          ├── resources
          ├── processes
          ├── storage
          ├── filesystem
          ├── temporary storage
          ├── security
          └── virtualization
```

The contract should then resolve the correct platform-specific implementation for Linux, Windows, or another supported host.

### Desktop and terminal

The same `.asysma` control artifact should be usable from:

```text
Desktop launcher
Terminal / shell
Installer environment
Virtual machine
Recovery environment (where supported)
```

The graphical launcher is therefore a presentation layer over the same system contract rather than a second implementation of operating-system control.

## 3. OS-layer awareness

The control plane should understand the host as layers rather than as one undifferentiated object:

```text
Application / Desktop
        ↓
Runtime / Services
        ↓
System libraries
        ↓
Kernel interfaces
        ↓
Drivers
        ↓
Hardware / firmware
```

The system contract should record the **depth and traversal required** for an operation. A request that can be fulfilled through a documented user-space API should not descend into a kernel interface merely because deeper access exists.

### Organization versus reorganization

A control request should distinguish:

- **organization:** inspect, classify, query, load, start, stop, or configure through an existing supported interface;
- **reorganization:** modify system structure, replace components, rewrite configuration, alter partitions, change boot state, or otherwise change the host's standard organization.

Reorganization requires stronger authorization, validation, transaction planning, and recovery handling than ordinary organization.

## 4. OS variance model

The `.asysma` control plane should represent command variance explicitly. The same logical operation may require different native implementations:

```text
logical operation
      ↓
capability check
      ↓
OS / version / architecture
      ↓
native implementation
      ↓
verification
```

The Java layer should not assume that a Linux command, Windows command, filesystem layout, service model, process API, or security model exists unchanged on another operating system.

A platform adapter should report:

```text
supported
supported-with-conditions
unsupported
requires-privilege
requires-reorganization
unsafe-without-confirmation
```

## 5. Memory and process control

The system contract should provide controlled operations for ordinary operating-system resource management, subject to host permissions:

```text
memory inquiry
process discovery
process load/start
process stop/unload
temporary-file discovery
temporary-file cleanup
filesystem inquiry
storage inquiry
```

The Java control plane should request these operations through the native contract rather than directly manipulating kernel state.

For destructive or privileged actions, the native adapter must enforce authorization and return a structured result. The Java UI should display the consequence before execution.

## 6. Database and persistent-state awareness

The installer/control plane may encounter databases, package databases, configuration stores, service registries, caches, and other persistent state.

It should therefore distinguish:

```text
read-only inspection
transactional modification
reorganization
replacement
removal
```

A database or persistent store should not be modified merely because it is reachable. The operation must identify ownership/context, required privilege, consistency requirements, backup/recovery expectations, and the relevant OS interface.

## 7. Rider model

A **rider** is a runtime or control layer operating *on top of* an operating system. Java is the rider in this design; Linux or Windows remains the underlying operating system.

```text
Rider: Java / JavaFX / `.asysma`
              ↓
Operating System: Linux / Windows
              ↓
Kernel and native facilities
              ↓
Hardware
```

The rider must not be confused with the OS itself. It may request OS services, but the OS retains authority over process isolation, memory, devices, filesystems, security, and kernel execution.

This distinction is important when the rider changes the system: **a Java request to alter Linux is an OS modification request, not Java becoming Linux.**

## 8. Security and Desktop variants

The same control contract should support variants such as:

- terminal-only operation;
- desktop installer;
- recovery environment;
- VM operation;
- restricted user operation;
- privileged installation operation.

The security profile should be explicit. A desktop UI is not itself a privilege boundary.

## 9. Native adapter contract

The Java layer should communicate through a narrow, testable native contract:

```text
HostDiscovery
OsIdentity
KernelIdentity
StabilityAssessment
CapabilityDiscovery
ResourceInspection
IsoDiscovery
IsoBuild
InstallPlan
PrivilegeRequest
PartitionInspection
FilesystemInspection
ProcessControl
TemporaryStorageControl
PersistentStateInspection
InstallExecution
VmLaunch
Verification
Report
```

The Java layer owns presentation, workflow state, validation, and user confirmation. The native adapter owns platform-specific execution.

## 10. Linux and Windows

### Linux

Linux is the natural first native target because the repository already contains the kernel, root filesystem, initramfs, boot, and ISO construction layers. The installer should use existing project tooling rather than duplicate it.

### Windows

Windows should provide a native launcher/adapter capable of discovering an existing ISO and invoking an approved virtualization or installation pathway. Direct physical-disk operations should remain explicitly privileged and should not be hidden behind a convenience button.

## 11. Virtual machine operation

A VM is an important safety and development target because it allows the installer and generated ISO to be exercised without immediately modifying physical storage.

Preferred development sequence:

```text
build
  ↓
verify ISO
  ↓
launch VM
  ↓
install to virtual disk
  ↓
boot installed system
  ↓
verify
  ↓
only then consider physical media
```

## 12. Probabilistic OS eventuring and AI maturity assessment

The `.asysma` system should treat **entering or inspecting an operating system as an evidence-gathering event**, not as an assumption that the host has a known level of capability or maturity.

The term **eventuring** here means a controlled sequence of observation and capability tests performed through supported interfaces:

```text
enter observation boundary
        ↓
identify OS / version / kernel
        ↓
measure stability and capabilities
        ↓
observe security and privilege boundaries
        ↓
identify installed/runtime AI-related facilities
        ↓
classify evidence and uncertainty
        ↓
adapt the control plan
```

### System-control grain

The control plane should estimate the **grain** at which it can safely operate:

| Grain | Meaning |
|---|---|
| G0 | Identification only. No modification. |
| G1 | User-space observation and ordinary queries. |
| G2 | Controlled user-space operations through documented APIs. |
| G3 | Privileged service, storage, process, or configuration operations. |
| G4 | System reorganization such as boot, partition, or core-component changes. |
| G5 | Recovery/replacement operations requiring exceptional authorization and verification. |

The observed grain is **probabilistic** until capability tests establish what the host actually permits. A detected capability is not itself authorization to exercise it.

### AI maturity awareness

The `.asysma` layer may inspect for **observable AI-related maturity**, but should not attempt to infer intelligence, consciousness, human qualities, or psychological status from a machine.

Relevant observable signals may include:

- installed AI/ML runtimes;
- hardware acceleration interfaces;
- GPU/NPU/accelerator availability;
- model-serving services;
- inference APIs;
- supported compute frameworks;
- sandboxing and permission boundaries around AI services;
- local versus remote model interfaces;
- resource quotas;
- logging and audit capabilities;
- update and rollback mechanisms;
- declared system integration points.

The result should be a **technical maturity profile**, not a judgment about the operating system as a person or intelligent entity.

### AI-event adaptation

If AI-related components or events are detected, the control plane should adapt according to evidence and constraints:

```text
not detected
    → ordinary OS profile

detected but unidentified
    → constrained observation

detected and identified
    → capability-specific profile

detected with privileged integration
    → stronger authorization and audit

detected with uncertain behavior
    → isolate / observe / do not assume
```

The system should preserve the distinction between:

```text
AI capability
AI event
AI service
AI hardware
AI policy
AI security boundary
```

One does not prove the others.

### Grace and constraint model

Every adaptive decision should carry:

```text
instance
capability
confidence
constraint
required privilege
allowed action
fallback
verification
```

This permits graceful degradation when the host lacks a capability or presents an unfamiliar architecture.

## 13. Probabilistic status

These are **probabilistic engineering premises** rather than claims of completed implementation:

| Premise | Current confidence | Required evidence |
|---|---|---|
| A modest Linux native environment can be kept near a 2 GB planning envelope | Moderate | Reproducible image-size measurements and boot tests |
| Java 21 can serve as a thin control-plane runtime | High | Runtime launch, JavaFX startup, and representative installer operations |
| A `.asysma` entry point can provide a single controlled system-contract boundary | Moderate | Native adapter prototype, capability enumeration, Linux/Windows tests |
| OS/version/kernel/stability discovery can be performed through supported interfaces | High | Host probes with reproducible results and negative tests |
| System-control grain can be estimated from observable host capabilities | Moderate | Cross-platform capability tests and privilege-boundary tests |
| AI-related OS maturity can be described from observable technical evidence | Moderate | Reproducible inventory, service/interface discovery, and hardware/runtime tests |
| AI events can be safely accommodated through capability/constraint profiles | Conditional | Event simulation, isolation tests, policy tests, and recovery tests |
| The same Java installer architecture can operate on Linux and Windows | Moderate–High | Native adapter tests on both platforms |
| The installer can run inside a VM | High | QEMU/Hyper-V/other supported VM validation |
| The installer can safely write a named partition | Conditional | Privileged native implementation, device validation, destructive-operation confirmation, and recovery testing |
| The installer can create a complete production ISO | Conditional | End-to-end ISO build, BIOS/UEFI boot, filesystem, installer, and post-install tests |

## 14. Concernability

The primary concerns are not Java itself but the **native boundary** around it:

```text
Java `.asysma`
  ↕
Host/System Contract
  ↕
privileged adapter
  ↕
OS facilities
  ↕
block device / bootloader / VM / firmware
```

Particular attention is required for:

- root/Administrator escalation;
- raw block-device access;
- partition selection;
- filesystem creation;
- bootloader installation;
- process termination;
- temporary-file deletion;
- persistent-state modification;
- ISO verification;
- firmware mode;
- VM device exposure;
- network acquisition;
- AI-service discovery and isolation;
- unexpected AI-related processes or services;
- interrupted installation;
- rollback and recovery;
- untrusted ISO input.

The GUI must never treat a detected device or AI capability as permission to modify or invoke it. **Discovery, capability, authorization, execution, and verification are separate stages.**

## 15. Measurement rule

The 2 GB premise must eventually become a measured engineering result. Record at least:

- compressed ISO size;
- uncompressed root filesystem size;
- kernel size;
- initramfs size;
- firmware size;
- Java runtime size;
- JavaFX/runtime dependencies;
- `.asysma` launcher/control-plane size;
- installer size;
- free operational space;
- peak RAM during installation;
- installed disk footprint;
- OS capability-detection results;
- AI-runtime/hardware detection results where applicable;
- false-positive and false-negative rates for capability classification.

## 16. Final design principle

**Keep the native platform modest. Keep Java thin. Give the Java rider one controlled system-contract connection. Let that contract understand OS/version, kernel, stability, capabilities, resource and process operations, persistence, security, layer depth, and observable AI-related maturity. Treat entry into an OS as probabilistic evidence gathering. Distinguish capability from authorization, event from interpretation, and AI integration from claims about intelligence. Keep organization distinct from reorganization. Keep privileged operations explicit. Measure rather than assume. Use the VM as the safe proving ground. Treat the 2 GB figure, `.asysma` architecture, system-control grain, and AI-event adaptation model as engineering hypotheses until reproducibly demonstrated.**
