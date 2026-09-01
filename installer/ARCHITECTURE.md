# White Edition Installer Architecture

## 1. Layers

```text
JavaFX Professional Launcher
        |
        +-- Discovery
        +-- Plan / Review
        +-- Verification
        |
        +-- Linux Adapter ------> existing Make/ISO contracts
        +-- Windows Adapter ----> WSL/QEMU integration
        +-- VM Adapter ---------> QEMU / platform VM
        |
        +-- Privileged Helper -- only for explicitly confirmed operations
```

The console/native orchestrator `white-installer`
(`installer/linux/white_installer_orchestrator.c`) is the C-side control-plane
sibling to the JavaFX launcher. It drives the existing Make/ISO/installer
contracts (notably the Bash engine `scripts/galactic-cherry-installer`) rather
than duplicating them, keeps the display and probe unprivileged, and emits the
section-7 audit report. See `installer/INSTALL.md` for its flow, flags, and
delegation scheme.

## 2. Existing repository integration

The repository already has an ISO build target and a `scripts/gen-iso.sh` implementation. The new interface should call those established contracts rather than create a competing ISO implementation. fileciteturn195file0L2-L2 fileciteturn200file0L2-L2

The repository also has an existing Ubuntu graphical-installer integration through `scripts/install-ubuntu-installer.sh`. The White Edition interface is therefore a control plane and launcher, not an attempt to duplicate Subiquity itself. fileciteturn199file0L2-L3

## 3. Root directory installation

A root-directory installation is useful for:

- image assembly;
- chroot development;
- testing;
- alternate rootfs locations;
- VM disk preparation.

It should use the existing rootfs assembly and installation contracts and must not overwrite a non-empty directory without an explicit review step.

## 4. Named partition installation

Partition installation is the highest-risk local operation. The UI must display:

- device path;
- partition number/name;
- capacity;
- filesystem;
- current mount points;
- whether the device is removable;
- intended formatting operation;
- intended mount point;
- bootloader target;
- data-loss warning.

The first release should require an external privileged helper for actual partition writes. The JavaFX process must not run as root merely to display the installer.

## 5. Existing ISO / VM

Running an existing ISO is read-only with respect to the host when executed in an isolated VM. QEMU is the initial cross-platform VM target because it is available on Linux and Windows installations and provides a common invocation model.

The VM path should eventually support:

- ISO selection;
- RAM/CPU configuration;
- UEFI/BIOS selection;
- virtual disk creation;
- persistent VM state;
- disposable test VM;
- networking mode;
- secure boot policy where supported.

## 6. Windows

Windows should not pretend to provide Linux-native disk tooling. The installer uses a Windows adapter and can use WSL2 for Linux-side build work and QEMU for VM execution. Native Windows disk operations require a separate, explicit administrative integration layer.

## 7. Audit

Each completed operation should produce a small report:

```text
installer version
host
operation
source
resolved target
commands/contracts invoked
privilege boundary
start/end time
verification result
warnings
```

No passwords, private keys, or unrelated personal information belong in the report.

## 8. White Edition presentation

The professional interface uses a restrained white surface and makes the state of the system visible. The installer should be clean and business-friendly rather than visually aggressive.

## 9. System registration (dpkg / systemd / cron)

This section documents how the installers register the software they place on
the system, so operators know exactly what is tracked by the package manager,
what runs as a service, and what is scheduled. It reflects the current
behaviour; it does not prescribe new work.

### 9.1 dpkg (package database)

The component installers register cleanly with `dpkg`. Both the Bash
`scripts/install-os-security.sh` / `scripts/install-git-improved.sh` and their
compiled counterparts `installer/linux/os-security-installer` /
`installer/linux/git-improved-installer` place **all** their packages through
`apt-get install`, which drives `dpkg` underneath. Everything they install —
ClamAV, UFW, AppArmor, fail2ban, unattended-upgrades, rkhunter, chkrootkit,
git, git-lfs and companions — therefore:

- appears in `dpkg -l` / `apt list --installed`;
- is removable through `apt` / `dpkg`;
- carries its maintainer scripts and package-shipped units, timers and
  `cron.*` jobs.

**Exception — the native tool installer.** `installer/install-native.sh` is a
separate component that compiles the repository's C utilities (`limit`, `size`,
`ctrmsctl`, and `xmc` via its own Makefile) and places them with raw
`install -m 0755` under `/usr/local/bin` (and a systemd unit for `ctrmsctl`).
These files are deliberately **not** wrapped in a `.deb`, so they are **not**
recorded in the dpkg database: they will not show up in `dpkg -l`, and they are
removed by the installer's own `uninstall` path rather than by `apt`. This is
the conventional "local software under `/usr/local`" arrangement; packaging
them as real `.deb`s would be a separate, additive change.

### 9.2 systemd (services)

Service registration is systemd-first. The OS-security installer runs
`systemctl daemon-reload` and then `systemctl enable` for each selected
component's units:

- `clamav-freshclam.service` and `clamav-daemon.service` (ClamAV);
- `apparmor.service` (only when not already active);
- `fail2ban.service`;
- `unattended-upgrades.service`.

`ctrmsctl` (via the native tool installer) installs and enables its own
`ctrmsctl.service` when a systemd host is detected.

### 9.3 cron and scheduled work

The installers do **not** create any `crontab`, `/etc/cron.*` entry, or
custom systemd timer of their own. Scheduled behaviour comes from two sources:

- **Package-shipped schedulers, which are active.** `clamav-freshclam` refreshes
  signatures as an enabled systemd service; `unattended-upgrades` is driven by
  the distribution's `apt-daily` / `apt-daily-upgrade` systemd timers plus the
  `/etc/apt/apt.conf.d/20auto-upgrades` drop-in that the OS-security installer
  writes. No cron is required for these.
- **On-demand tools that are installed but not scheduled — a known gap.**
  `rkhunter` and `chkrootkit` are installed but their periodic scans are left
  disabled: the installers do not enable `rkhunter`'s `CRON_DAILY_RUN` in
  `/etc/default/rkhunter`, nor `chkrootkit`'s `RUN_DAILY` in
  `/etc/chkrootkit.conf` / `/etc/default/chkrootkit`. Likewise, `clamav-freshclam`
  updates signatures but no periodic full-filesystem ClamAV **scan** is
  scheduled. Until this is addressed, rootkit and antivirus **scanning** is a
  manual/administrator responsibility even though the tools are present.

Operators who want scheduled scanning today can enable the package-provided
`cron.daily` hooks (rkhunter/chkrootkit) or add a ClamAV scan timer manually.
Automating this in the installers (preferably as systemd timers, to match the
systemd-first style above) would be an additive enhancement rather than a
correctness fix to the existing package/service registration.
