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

## 2. Thin-metal Java premise

The second assumption is that Java should operate as a **thin professional runtime layer above a modest native operating system**, rather than requiring a large general-purpose desktop environment merely to launch the installer.

Conceptually:

```text
hardware
  ↓
modest native OS / Linux shim
  ↓
JDK / Java 21 runtime
  ↓
JavaFX professional launcher
  ↓
White Edition Installer
  ↓
ISO / root / partition / VM operations
```

Java therefore acts as the portable control-plane layer while the native OS remains responsible for hardware access, process isolation, filesystems, networking, privilege boundaries, boot services, and virtualization interfaces.

## 3. Why this is desirable

A thin Java layer provides:

- a common professional installer interface;
- predictable application behavior across Linux and Windows hosts;
- separation between UI logic and privileged native operations;
- a reusable control plane for ISO creation and inspection;
- a path toward running the installer inside a virtual machine;
- a smaller native dependency surface than a complete desktop stack.

The installer should detect its host rather than assume that the host is itself Ubuntu.

## 4. Probabilistic status

These are **probabilistic engineering premises** rather than claims of completed implementation:

| Premise | Current confidence | Required evidence |
|---|---|---|
| A modest Linux native environment can be kept near a 2 GB planning envelope | Moderate | Reproducible image-size measurements and boot tests |
| Java 21 can serve as a thin control-plane runtime | High | Runtime launch, JavaFX startup, and representative installer operations |
| The same Java installer architecture can operate on Linux and Windows | Moderate–High | Native adapter tests on both platforms |
| The installer can run inside a VM | High | QEMU/Hyper-V/other supported VM validation |
| The installer can safely write a named partition | Conditional | Privileged native implementation, device validation, destructive-operation confirmation, and recovery testing |
| The installer can create a complete production ISO | Conditional | End-to-end ISO build, BIOS/UEFI boot, filesystem, installer, and post-install tests |

## 5. Concernability

The primary concerns are not Java itself but the **native boundary** around it:

```text
Java UI
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
- ISO verification;
- firmware mode;
- VM device exposure;
- network acquisition;
- interrupted installation;
- rollback and recovery;
- untrusted ISO input.

The GUI must never treat a detected device as permission to modify it. Discovery and authorization are separate stages.

## 6. Native adapter contract

The Java layer should communicate through a narrow, testable native contract:

```text
HostDiscovery
IsoDiscovery
IsoBuild
InstallPlan
PrivilegeRequest
PartitionInspection
InstallExecution
VmLaunch
Verification
Report
```

The Java layer owns presentation, workflow state, validation, and user confirmation. The native adapter owns platform-specific execution.

## 7. Linux and Windows

### Linux

Linux is the natural first native target because the repository already contains the kernel, root filesystem, initramfs, boot, and ISO construction layers. The installer should use existing project tooling rather than duplicate it.

### Windows

Windows should provide a native launcher/adapter capable of discovering an existing ISO and invoking an approved virtualization or installation pathway. Direct physical-disk operations should remain explicitly privileged and should not be hidden behind a convenience button.

## 8. Virtual machine operation

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

## 9. Measurement rule

The 2 GB premise must eventually become a measured engineering result. Record at least:

- compressed ISO size;
- uncompressed root filesystem size;
- kernel size;
- initramfs size;
- firmware size;
- Java runtime size;
- JavaFX/runtime dependencies;
- installer size;
- free operational space;
- peak RAM during installation;
- installed disk footprint.

## 10. Final design principle

**Keep the native platform modest. Keep Java thin. Keep privileged operations explicit. Measure rather than assume. Use the VM as the safe proving ground. Treat the 2 GB figure as an engineering hypothesis until reproducibly demonstrated.**
