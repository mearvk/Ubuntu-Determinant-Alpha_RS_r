# Ubuntu White Edition — Professional Installer

**Project:** Ubuntu Determinant  
**Edition:** Ubuntu White Edition  
**Project attention:** Max Rupplin — MEARVK LLC — 2026

## Purpose

`installer/` is the native professional installation interface for Ubuntu White Edition. It is designed to run from an existing Linux installation, from Windows with a supported Linux/virtualization backend, or inside a virtual machine.

The interface is deliberately separate from the existing Galactic Cherry installer scripts. The repository already has an ISO-generation path and an Ubuntu graphical installer integration; this layer provides a clean, white, JavaFX control surface over those capabilities rather than duplicating their low-level implementation. The existing top-level build already exposes `rootfs`, `initramfs`, `grub`, and `iso` assembly stages. fileciteturn195file0L2-L2

## Operating modes

| Mode | Function | Destructive authority |
|---|---|---|
| Build ISO | Assemble an ISO using the repository build contract | None beyond build output |
| Root-directory install | Install an already-built root filesystem into a selected directory | Explicit directory only |
| Named-partition install | Prepare/mount a user-selected partition and install | Requires explicit confirmation and elevated helper |
| Run existing ISO | Launch an ISO without installing | None |
| Virtual machine | Boot an ISO through QEMU/Hyper-V/WSL-compatible path | VM-scoped |
| Inspect | Detect host, ISO, rootfs, partitions, VM tools | Read-only |

Partition operations must never be inferred from a directory name. The UI must display the exact device, filesystem, mount state, and intended operation before elevation.

## Professional launcher

The launcher is Java/JavaFX-oriented. The current repository already contains Java build infrastructure and a boot JDK 27 tree, while the Java userland documentation identifies the project's Java source/build environment. fileciteturn196file0L2-L2

The installer should therefore use a small JavaFX launcher and delegate privileged/platform-specific work to explicit adapters rather than embedding shell commands throughout the GUI.

```text
JavaFX Launcher
    |
    +-- Host Detector
    +-- ISO Builder Adapter
    +-- Rootfs Adapter
    +-- Partition Adapter
    +-- VM Adapter
    +-- Windows/WSL Adapter
    +-- Verification / Audit
```

## White interface

The visual standard is intentionally restrained:

- white primary surface;
- dark neutral text;
- restrained gray borders;
- clear status indicators;
- large, readable primary actions;
- no decorative security claims;
- explicit destructive-action warnings;
- keyboard accessibility;
- no hidden elevation.

## Existing build integration

The existing repository already provides `scripts/gen-iso.sh`, which creates a hybrid BIOS/UEFI ISO from the assembled root filesystem and validates kernel/initramfs prerequisites. The professional installer should invoke that established contract rather than silently implementing a second ISO builder. fileciteturn200file0L2-L2

The existing `scripts/install-ubuntu-installer.sh` also provides a full Ubuntu Desktop Provision/Subiquity installer integration. It remains an existing implementation and is not silently replaced by this JavaFX control layer. fileciteturn199file0L2-L3

## Security boundary

The JavaFX process should normally run unprivileged. Operations requiring root/administrator access must cross a small, auditable helper boundary.

The GUI must not execute arbitrary user-entered shell strings. All operations should use typed arguments and allow-listed commands.

## State model

```text
DISCOVER
  -> PLAN
  -> REVIEW
  -> CONFIRM
  -> ELEVATE (only when required)
  -> EXECUTE
  -> VERIFY
  -> REPORT
```

No install operation should jump directly from discovery to execution.

## Project reference

**Max Rupplin — MEARVK LLC — 2026** records project-level development and maintenance attention. Upstream kernel, Ubuntu, Java, JavaFX, QEMU, and other third-party attribution remains governed by their applicable licenses and provenance.
