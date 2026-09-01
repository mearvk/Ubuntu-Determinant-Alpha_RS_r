# Ubuntu White Edition — Professional Installer

**Project:** Ubuntu Determinant  
**Edition:** Ubuntu White Edition  
**Project attention:** Max Rupplin — MEARVK LLC — 2026

## Purpose

`installer/` is the master installation interface for Ubuntu White Edition and the repository's recent native tools. It keeps the JavaFX control surface separate from platform-specific native installation work.

## Master installation

The current native tool set is maintained by `installer/install-manifest.txt` and includes:

- `xmc` — XMC compiler and ASYSMA packaging path;
- `limit` — executable identity/metadata inspection;
- `size` — recursive logical filesystem-size measurement;
- `ctrmsctl` — read-only disk/filesystem observation service;
- GCC source download/extraction helpers.

Use the platform master installer:

```text
Linux:   ./installer/install-all.sh
Windows: .\installer\install-all.ps1
macOS:   ./installer/install-all-macos.sh
```

The master installer first invokes the native installer for the host. When Java and Maven are available, it also builds the JavaFX installer package.

### Native installers

```text
installer/install-native.sh
installer/install-native.ps1
installer/install-native-macos.sh
```

These compile the repository's native C utilities locally. XMC is built through its own `tools/xmc/Makefile`, preserving its multi-binary contract (`xmc`, `xmc-core`, `asysma_pack`, and related launcher/assets) rather than treating `xmc-driver.c` as a standalone executable. The XMC Makefile explicitly defines the integrated compiler/package installation targets. fileciteturn79file0L2-L2

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

The launcher is Java/JavaFX-oriented. The master install scripts build the native inspection/observation utilities first and then build the JavaFX package when its toolchain is available.

The installer should use a small JavaFX launcher and delegate privileged/platform-specific work to explicit adapters rather than embedding shell commands throughout the GUI.

```text
JavaFX Launcher
    |
    +-- Host Detector
    +-- Native Tool Installer
    +-- XMC / ASYSMA Adapter
    +-- Limit / Size Inspection
    +-- CTRMS Observation Adapter
    +-- ISO Builder Adapter
    +-- Rootfs Adapter
    +-- Partition Adapter
    +-- VM Adapter
    +-- Verification / Audit
```

## Security boundary

The JavaFX process should normally run unprivileged. Operations requiring root/administrator access must cross a small, auditable helper boundary.

The GUI must not execute arbitrary user-entered shell strings. All operations should use typed arguments and allow-listed commands.

`limit`, `size`, and the CTRMS observation surface remain read-only inspection/measurement functions. `ctrmsctl` may install its systemd service when running on a systemd host, but the service itself is an observation component rather than an authorization mechanism.

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

## Existing build integration

The existing ISO and Ubuntu installer paths remain the established image/provisioning contracts. This master installer adds the recent native-tool installation layer rather than silently replacing those paths.

## Native install binaries (installer/linux)

`installer/linux/` holds three committed native ELF binaries that support the install path. Consistent with the framing above, the orchestrator adds a smooth front door and delegates to the established contracts rather than replacing them.

- `white-installer`: the smooth-install orchestrator ELF and default front door. It runs a seven-stage guided flow (PROBE, PREVIEW read-only, COMPONENTS, TARGET, CONFIRM, DELEGATE, AUDIT) with checkbox and command-line component selection. It is a control plane that delegates to `scripts/galactic-cherry-installer` rather than reimplementing disk or package logic, runs unprivileged, and defaults to a safe dry-run. This is the headline new binary.
- `desktop_install_probe`: the existing Step-1 discovery and bootstrap probe. It locates the clone and the install set, previews and performs dry-run discovery, and can carry out an explicit install. It already exists and is listed here for context.
- `nxtt`: the NXTT uninstaller helper ELF.

These build from `installer/linux/Makefile`:

```text
make -C installer/linux all
```

A portable static build of the orchestrator is available for the live ISO and minimal environments:

```text
make -C installer/linux white-installer-static
```

See [`INSTALL.md`](INSTALL.md) for detailed usage.

## Project reference

**Max Rupplin — MEARVK LLC — 2026** records project-level development and maintenance attention. Upstream kernel, Ubuntu, GCC, Java, JavaFX, QEMU, and other third-party attribution remains governed by their applicable licenses and provenance.
