# frangemont-postmail-ps — Byte-Level Package Safety Inspection Daemon

**Edition:** Galactic Cherry Marvell 98  
**Install:** Default (basic userland)  
**Memory Grain:** 2 (Safety Space)  
**License:** GPL-2.0

## Purpose

`frangemont-postmail-ps` is a daemon that inspects bytes at every stage of the package installation lifecycle. It provides heuristic safety analysis of source code, binary content, and package structure — catching dangerous patterns before they reach the running system.

## Four Inspection Stages

| Stage | When | Hook | Blocking? |
|-------|------|------|-----------|
| 1 — IN-FLIGHT | During download | inotify on `/var/cache/apt/archives/partial/` | No (advisory) |
| 2 — AT-REST | After download, before install | `DPkg::Pre-Invoke` | Yes (HOLD/REJECT) |
| 3 — PRE-COPY | Before dpkg unpacks | Socket command | Yes (TOCTOU verify) |
| 4 — POST-INSTALL | After installation | `DPkg::Post-Invoke` | Mandatory, always runs |

## Five Concern Axes

| Axis | What It Checks | Examples |
|------|---------------|----------|
| STRUCTURAL | File format, permissions, embedded secrets | Private keys, world-writable, SUID |
| BEHAVIORAL | Runtime danger patterns | exec(), system(), LD_PRELOAD, setuid |
| KERNEL | Kernel-mode interface access | /dev/mem, insmod, CAP_SYS_MODULE |
| MEMORY | Shared memory and injection | ptrace, process_vm_writev, shm_open |
| PROVENANCE | Source trust and signing | GPG signatures, repository origin |

## Scoring & Verdicts

| Score | Verdict | Action |
|-------|---------|--------|
| 0-99 | CLEAR | Silent pass, no delay |
| 100-299 | NOTICE | Log to registry |
| 300-599 | CONCERN | Log + notify admin |
| 600-799 | HOLD | Pause install, Grade 3+ to continue |
| 800+ | REJECT | Block install, Grade 7+ to override |

## Integration with System Building Blocks

| Component | Integration |
|-----------|-------------|
| HPM | Network pattern awareness — correlates suspicious downloads |
| EPERM | Trusted/Genius class users exempt from HOLD (never REJECT) |
| Arena Pool | Memory pressure awareness — large packages assessed for arena impact |
| NEGAMANE | Checks if install would overwrite immutable-branded files |
| JVM Resource Loader | Content validation patterns (banned calls, banned includes) |
| MySQL Registry | Audit trail — all inspections recorded |
| sudo_gate | Grade-aware override for HOLD (3+) and REJECT (7+) |
| ClamAV | Cross-checks flagged files with antivirus signatures |
| Dave | Exports findings for system-wide intelligence awareness |
| Chat | Notifies ops-team on HOLD/REJECT verdicts |

## Usage

```bash
# Daemon mode (default — started by systemd on boot)
systemctl status frangemont-postmail-ps

# One-shot scan modes:
frangemont-postmail-ps --scan /path/to/file.deb
frangemont-postmail-ps --scan-atrest
frangemont-postmail-ps --scan-postinstall nginx

# Socket query:
echo "STATUS" | socat - UNIX-CONNECT:/run/frangemont-postmail-ps.sock
echo "SCAN-DEB /var/cache/apt/archives/htop_3.2.2-2_amd64.deb" | \
    socat - UNIX-CONNECT:/run/frangemont-postmail-ps.sock
```

## Example Output

```
$ frangemont-postmail-ps --scan /var/cache/apt/archives/htop_3.2.2-2_amd64.deb

/var/cache/apt/archives/htop_3.2.2-2_amd64.deb: CLEAR (score 20)
  Structural: 0  Behavioral: 0  Kernel: 0  Memory: 0  Provenance: 20
```

```
$ frangemont-postmail-ps --scan suspicious-package_1.0_amd64.deb

suspicious-package_1.0_amd64.deb: CONCERN (score 410)
  Structural: 80  Behavioral: 140  Kernel: 130  Memory: 40  Provenance: 20
  Concerns:
    [KERNEL +80] Direct physical memory access: /dev/mem
    [KERNEL +50] Broad admin capability: CAP_SYS_ADMIN
    [BEHAVIORAL +50] Direct syscall exec: execve(
    [BEHAVIORAL +40] Process execution: exec(
    [BEHAVIORAL +50] Set user ID: setuid(
    [MEMORY +40] Executable memory mapping: PROT_EXEC
    [STRUCTURAL +80] Private key in package!: -----BEGIN PRIVATE
```

## Installation (Automatic)

Installed automatically during OS image creation via `scripts/install-userland.sh`. The daemon is enabled on first boot.

```bash
# Manual install (if building from source):
cd tools/frangemont
make
sudo make install
sudo systemctl enable --now frangemont-postmail-ps
```

## Files

```
tools/frangemont/frangemont_postmail_ps.c    - Daemon source (~750 lines)
tools/frangemont/frangemont-postmail-ps.conf - Configuration
tools/frangemont/frangemont-postmail-ps.service - Systemd unit
tools/frangemont/frangemont-apt-hook         - APT hook bridge script
tools/frangemont/98frangemont-pre            - APT pre-invoke config
tools/frangemont/99frangemont-post           - APT post-invoke config
tools/frangemont/Makefile                    - Build/install
tools/frangemont/README.md                   - This documentation
```

## Admin

- **Socket:** `/run/frangemont-postmail-ps.sock`
- **Log:** `/var/log/frangemont/inspections.log`
- **PID:** `/run/frangemont-postmail-ps.pid`
- **Config:** `/etc/frangemont-postmail-ps.conf`

## Design Philosophy

The daemon is not adversarial toward packages. It is a **careful reader**:

- Packages that contain normal code pass silently (zero friction for 95% of installs)
- Source code with system-touching patterns gets flagged proportionally
- Kernel-mode access patterns receive the highest scrutiny
- The system learns what is normal for each package over time
- HOLD and REJECT are rare — they represent genuine safety concerns
- Grade-aware overrides ensure competent admins can proceed when needed
- Post-install scanning is mandatory and cannot be bypassed

The goal is to know what entered the system, when, how dangerous it appears, and to give the admin a clear picture — not to prevent legitimate administration.
