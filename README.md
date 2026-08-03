MearvK Ltd - MEARVK LLC

Maximilian Eric Alexander Rupplin von Keffikon - MEARVK - MEARVK LLC

Owner of Establishment of Corporate ongoing Finance - US United States a Minister

Owner of Miramax Films UK & US United States and Settlement - NO GODZILLA

![Profile views](https://views.igorkowalczyk.dev/api/badge/@mearvk?style=flat)

---

# Ubuntu Determinant Alpha RS — Galactic Cherry Marvell Edition 98

A custom Linux kernel (5.15.204) with extensions for extended port addressing, heuristic security monitoring, graded privilege systems, extended permission classes, USB dynamic RAM expansion, immutable filesystem branding, terminal chat, cron callbacks, per-user kernel objects, CPU boost designation, the White Ethics Installer Grade, and Dave — the system's kernel-adjacent AI intelligence.

**Edition:** Galactic Cherry Marvell  
**Version:** 98  
**Kernel:** Linux 5.15.204  
**Userland:** Ubuntu Base 24.04.4 (Noble Numbat)  
**Display:** X.Org Server 21.1.24  
**Desktop Wallpapers:** 9 original SVG wallpapers + 10 Marvell JPEG wallpapers (4K, resolution-independent)

---

## Table of Contents

1. [Extended Port Range (30 Quintillion)](#extended-port-range)
2. [Port 64444 Multiplexer (EPMP)](#epmp---extended-port-multiplexing-protocol)
3. [Heuristic Port Monitor (HPM)](#heuristic-port-monitor)
4. [sudo_gate — Graded Privilege System](#sudo_gate--graded-privilege-system)
5. [Extended Permission Classes (Trusted & Genius)](#extended-permission-classes)
6. [USB Dynamic RAM Expansion](#usb-dynamic-ram-expansion)
7. [USB Hardware-Direct DMA Optimization](#usb-hardware-direct-dma-optimization)
8. [System Accounts & nnet Identity](#system-accounts--nnet-identity)
9. [NEGAMANE — Immutable Filesystem Brand](#negamane--immutable-filesystem-brand)
10. [Terminal Chat System](#terminal-chat-system)
11. [Cron Callback Extension](#cron-callback-extension)
12. [Per-User Kernel Objects (Memory Grain)](#per-user-kernel-objects-memory-grain)
13. [CPU Boost Designation](#cpu-boost-designation)
14. [White Ethics Installer Grade](#white-ethics-installer-grade)
15. [ClamAV — Protected Antivirus](#clamav--protected-antivirus)
16. [chkrootkit — Rootkit Detection](#chkrootkit--rootkit-detection)
17. [rkhunter — Rootkit Hunter](#rkhunter--rootkit-hunter)
18. [MySQL — Protected Database](#mysql--protected-database)
19. [Chromium Browser — Open Source](#chromium-browser--open-source)
20. [Dave — System Intelligence (AI)](#dave--system-intelligence-ai)
21. [Certificates](#certificates)
22. [OpenJDK 28 — Secure JVM](#openjdk-28--secure-jvm)
23. [Secure JVM: XML Configuration Reader](#secure-jvm-xml-configuration-reader)
24. [Secure JVM: ClassLoadGuard](#secure-jvm-classloadguard)
25. [Secure JVM: Integrity Guardian](#secure-jvm-integrity-guardian)
26. [Secure JVM: Pause-Frame Inspector](#secure-jvm-pause-frame-inspector)
27. [Secure JVM: Observer Grade Circuit](#secure-jvm-observer-grade-circuit)
28. [Secure JVM: Resource Loader](#secure-jvm-resource-loader)
29. [Secure JVM: System Codex](#secure-jvm-system-codex)
30. [Secure JVM: MySQL Bridge](#secure-jvm-mysql-bridge)

---

## Extended Port Range

The standard TCP/UDP port range (0–65535, 16 bits) has been extended to **30 quintillion** (30,000,000,000,000,000,000) using 64-bit port addressing.

### Changes

| File | Modification |
|------|-------------|
| `include/net/netns/ipv4.h` | `struct local_ports` range widened from `int[2]` to `u64[2]` |
| `include/net/ip.h` | `inet_get_local_port_range()` signature → `u64*` |
| `net/ipv4/inet_connection_sock.c` | Function implementation updated for `u64` |
| `net/ipv4/sysctl_net_ipv4.c` | Port max raised from 65535 to 30,000,000,000,000,000,000 |

### How It Works

- Ports 0–65535 remain directly addressable via standard TCP/UDP headers
- Ports 65536–30 quintillion are addressed via the EPMP multiplexer on port 64444
- The `ip_local_port_range` sysctl now accepts the full 64-bit range

---

## EPMP — Extended Port Multiplexing Protocol

**Service Port: 64444 (TCP)**

Port 64444 multiplexes traffic to extended ports beyond 2^16. It provides protocol specification discovery, key exchange, and frame routing.

### Discovery

Send `1` or `1s` (ASCII) to TCP port 64444 → receive full protocol specification as JSON.

### Handshake Protocol

| Phase | Algorithm | Minimum Bits | Purpose |
|-------|-----------|-------------|---------|
| 1 | Diffie-Hellman | 2048 (4096 recommended) | Initial shared secret establishment |
| 2 | RSA | 2048 (4096 recommended) | Public key exchange, session authentication |
| 3 | Mode Negotiation | — | Client selects: raw (0), encrypted (1), or hybrid (2) |

### Handshake Steps

1. Client → Server: DH public value (g^a mod p)
2. Server → Client: DH public value (g^b mod p)
3. Both compute shared secret → derive AES-256 key via HKDF-SHA256
4. Client → Server: RSA public key (encrypted with DH-derived AES)
5. Server → Client: RSA public key (encrypted with DH-derived AES)
6. Server → Client: Session confirmation (RSA-signed)
7. Client → Server: Data mode selection (raw/encrypted/hybrid)
8. Server → Client: Mode acknowledgment — session established

### EPMP Frame Header (42 bytes)

| Field | Type | Description |
|-------|------|-------------|
| magic | uint32 | `0x45504D50` ("EPMP") |
| version | uint8 | Protocol version |
| target_port | uint64 | Destination extended port (0–30 quintillion) |
| source_port | uint64 | Client return port |
| payload_length | uint64 | Payload size in bytes |
| flags | uint16 | encrypted, fragmented, final_fragment, priority |
| sequence | uint32 | Frame ordering |
| checksum | uint32 | CRC-32C integrity |

### Files

```
net/ipv4/epmp.c                  - Kernel module (TCP listener, state machine)
net/ipv4/port_mux_spec.json      - Protocol spec (served on discovery)
net/ipv4/port_mux_spec_inline.h  - Spec as C string literal
net/ipv4/Kconfig                 - CONFIG_EPMP
```

### Firewall

```bash
ufw allow 64444/tcp comment 'EPMP Port Multiplexer'
iptables -A INPUT -p tcp --dport 64444 -j ACCEPT
nft add rule inet filter input tcp dport 64444 accept
```

---

## Heuristic Port Monitor

A three-stage security pipeline for all ports (0 through extended range) with data safety review at each stage.

### Architecture

```
Incoming Packet
      │
      ▼
┌─────────────────────────────────────────────┐
│  PIPE 1: Protocol Framing Analysis          │
│  HTTP, FTP, TLS, raw buffer, malformed      │
│  ★ SAFETY CHECKPOINT 1 (score 0-100)       │
└─────────────────────┬───────────────────────┘
                      ▼
┌─────────────────────────────────────────────┐
│  PIPE 2: Behavioral Heuristics              │
│  Stealth, DoS, scan, temporal anomaly       │
│  ★ SAFETY CHECKPOINT 2 (score 0-100)       │
└─────────────────────┬───────────────────────┘
                      ▼
┌─────────────────────────────────────────────┐
│  PIPE 3: Response Graphing & Reversal       │
│  IDS inversion, admin identity, correlation │
│  ★ SAFETY CHECKPOINT 3 (score 0-100)       │
└─────────────────────┬───────────────────────┘
                      ▼
               ACCEPT or DROP
```

### Threat Detection

| Concern | Method |
|---------|--------|
| Stealth packets | TCP flag analysis (NULL/XMAS/FIN/SYN+FIN/SYN+RST scans) |
| DoS | Rate threshold per source IP per sliding window |
| Port scanning | Distinct ports touched exceeding threshold |
| IDS used backwards | Response latency pattern analysis — detects rule boundary mapping |
| Wrong port at wrong hour | Temporal profile — flags privilege ports outside expected hours |
| Wrong person | Admin identity verification by IP subnet + time window |

### Admin Controls

```bash
cat /proc/hpm/status       # View state and statistics
echo 1 > /proc/hpm/toggle  # Activate monitor
echo 0 > /proc/hpm/toggle  # Deactivate monitor (dormant)
cat /proc/hpm/log          # View recent threat log
```

### Files

```
net/ipv4/hpm.c    - Kernel module (~700 lines)
net/ipv4/Kconfig  - CONFIG_HPM
net/ipv4/Makefile - Build entry
```

---

## sudo_gate — Graded Privilege System

A wrapper for `/usr/bin/sudo` that enforces an 8-level privilege grading system. Standard sudo behavior is preserved for routine operations (grades 1–6). Critical and irreversible operations require explicit gate invocations.

### Privilege Grades

| Grade | Attitude | Scope | Invocation |
|-------|----------|-------|------------|
| 1 | Routine | `ls`, `ps`, `cat`, `ping`, `df` | `sudo <cmd>` |
| 2 | Operational | `systemctl`, `journalctl`, `dmesg` | `sudo <cmd>` |
| 3 | Maintenance | `apt install`, `useradd`, `chmod` | `sudo <cmd>` |
| 4 | Network | `iptables` (add), `ufw allow`, `ip addr` | `sudo <cmd>` |
| 5 | Storage | `mount`, `fdisk`, `lvextend` | `sudo <cmd>` |
| 6 | Kernel | `sysctl -w`, `modprobe`, `insmod` | `sudo <cmd>` |
| 7 | **Critical System** | `visudo`, `passwd root`, `/etc/shadow`, `grub-install` | `sudo touch system <cmd>` |
| 8 | **Gate (irreversible)** | `dd`, `iptables -F`, `rm -rf /`, `mkfs`, SELinux policy | `sudo touch system gate <cmd>` |

### Examples

```bash
# Grades 1-6: standard sudo
sudo systemctl restart nginx
sudo apt install htop
sudo modprobe vfio

# Grade 7: requires "touch system"
sudo touch system visudo
sudo touch system passwd root
sudo touch system vim /etc/fstab

# Grade 8: requires "touch system gate"
sudo touch system gate dd if=/dev/zero of=/dev/sda
sudo touch system gate iptables -F
sudo touch system gate rm -rf /var/lib/important
```

### System Constitution

- Standard `sudo` works for 90% of daily operations (grades 1–6)
- The extra words (`touch system`, `touch system gate`) are friction by design
- Friction is proportional to the danger of the action
- A careful admin knows which gate to use deliberately
- Audit trail is mandatory for grades 7–8

### Installation

```bash
cd tools/sudo_gate && make && sudo make install
```

### Files

```
tools/sudo_gate/sudo_gate.c     - Wrapper binary (~400 lines)
tools/sudo_gate/sudo_gate.conf  - Configuration
tools/sudo_gate/Makefile         - Build/install/uninstall
tools/sudo_gate/README.md        - Detailed documentation
```

---

## Extended Permission Classes

Adds two permission classes above traditional UNIX owner/group/others:

### The Five-Class Model

| Class | Name | Behavior | Audit |
|-------|------|----------|-------|
| 1 | Owner | Standard UNIX permission bits | Full |
| 2 | Group | Standard UNIX permission bits | Full |
| 3 | Others | Standard UNIX permission bits | Full |
| **4** | **Trusted** | Bypasses DAC entirely | Light (access counter). Simple to trace. |
| **5** | **Genius** | Bypasses DAC freely | Not an audit item. Supreme-tier logged for institutional record. |

### Philosophy

- **Class 4 (Trusted):** Has established alignment with system integrity. Does not need permission checks. Simple to audit after the fact — their work is transparent. Would never contort access or abuse authorship lines. Communicates clearly and delivers reliably.

- **Class 5 (Genius):** Works freely FOR the system to mutual or better profit. Not an audit item under normal circumstances — has graduated from auditor class/course. Does not involve down to concepts of restriction. Access to supreme-tier resources (kernel, crypto, boot, CA) is logged for institutional record only. A good auditor reviews this as system evolution, not investigation.

- **Neither class has difficulty** with contortion of access patterns, supply of author lines, or delinear system concerns. The system enables and trusts wholly from and to this brand of personal type.

### Permission Check Order

```
1. Is user GENIUS (class 5)?  → GRANT (log supreme-tier for record)
2. Is user TRUSTED (class 4)? → GRANT (light audit trail)
3. Is user OWNER?             → standard owner bits (rwx------)
4. Is user in GROUP?          → standard group bits (---rwx---)
5. OTHERS                     → standard other bits (------rwx)
```

### Access Tier Logging (Genius Only)

| Tier | Resources | Logged? |
|------|-----------|---------|
| 0 - Routine | Home dirs, tmp, user files | No |
| 1 - Elevated | /etc configs, /opt, /srv | No |
| 2 - High | /etc/shadow, sudoers, firewall | No |
| 3 - Supreme | Kernel modules, crypto keys, boot, CA | Yes (auditor record) |

### Administration

```bash
# Register a Trusted person (class 4)
echo "1000 4 alice" > /proc/eperm/register

# Register a Genius person (class 5)
echo "1001 5 bob" > /proc/eperm/register

# View registry
cat /proc/eperm/persons

# View genius institutional log
cat /proc/eperm/genius_log

# View system philosophy and config
cat /proc/eperm/config
```

### Integration

Hooked into `generic_permission()` in `fs/namei.c`. Called before standard DAC checks. Standard UNIX permissions remain entirely unchanged for all non-registered users.

### Files

```
include/linux/eperm.h           - Header (class definitions, API)
security/eperm/eperm.c          - Core module (~450 lines)
security/eperm/eperm_hook.c     - Integration documentation
security/eperm/Kconfig          - CONFIG_SECURITY_EPERM
security/eperm/Makefile         - Build rules
security/Kconfig                - Modified (sources eperm)
security/Makefile               - Modified (builds eperm)
fs/namei.c                      - Modified (hook before DAC)
```

---

## USB Dynamic RAM Expansion

Automatically detects USB mass storage on hotplug and creates a swap pagefile for dynamic RAM expansion. Keeps remote server costs down by using USB 3.0+ storage as overflow memory.

### How It Works

```
USB Storage Plugged In
        │
        ▼
┌────────────────────────┐
│ Speed Classification   │  USB 3.1+ = excellent (~1 GB/s)
│                        │  USB 3.0  = good (~400 MB/s)
│                        │  USB 2.0  = emergency (~35 MB/s)
└───────────┬────────────┘  USB 1.x  = rejected
            ▼
┌────────────────────────┐
│ Safety Check           │  Has partitions → DON'T TOUCH
│                        │  Has filesystem → DON'T TOUCH
│                        │  Has our signature → reuse
└───────────┬────────────┘  Blank → prepare
            ▼
┌────────────────────────┐
│ Prepare Pagefile       │  Write swap header (kernel mkswap)
│ 80% of device, capped  │  Up to 256GB per device
└───────────┬────────────┘
            ▼
┌────────────────────────┐
│ Activate Swap          │  swapon with speed-based priority
└───────────┬────────────┘  System has additional virtual memory
            ▼
┌────────────────────────┐
│ Health Monitor         │  Every 60s: check errors, connection
│                        │  > 16 I/O errors = auto-disable
└────────────────────────┘

USB Removed → swapoff (migrate pages) → clean disconnect
```

### Cost Savings

| Approach | Cost |
|----------|------|
| 256GB ECC RAM sticks | $800–2000/server |
| 256GB USB 3.1 SSD | $25–50/drive |
| Redundant USB array | $75–150 total |

### Usage

```bash
modprobe usbswap                          # Load module
# Plug in USB 3.0+ drive → auto-activated
cat /proc/usbswap/status                  # Check status
echo /dev/sdb > /proc/usbswap/prepare    # Manual preparation
```

### Module Parameters

```bash
modprobe usbswap auto_activate=1 default_priority=-5 max_size_pct=80 min_speed=2
```

### Files

```
drivers/usb/storage/usbswap.c   - Module (~500 lines)
drivers/usb/storage/Kconfig     - CONFIG_USB_SWAP
drivers/usb/storage/Makefile    - Build entry
```

---

## USB Hardware-Direct DMA Optimization

Maximizes USB transfer throughput by keeping software out of the hardware's DMA path.

### Key Insight

The xHCI USB controller is a DMA engine. Once the doorbell register is written, the controller autonomously:
1. Reads TRBs from the Transfer Ring (DMA)
2. Moves data to/from host memory (DMA)
3. Writes completion to Event Ring (DMA)
4. Fires interrupt ONLY on the final TRB (`TRB_IOC`)

**Software is NOT in the data path.** The optimization ensures we don't re-insert it unnecessarily.

### Transfer Modes

| Mode | Mechanism | Use Case |
|------|-----------|----------|
| **Batched** | N URBs, `URB_NO_INTERRUPT` on all but last | Default. One interrupt per batch. |
| **Polled** | Zero interrupts, CPU spin-waits | Single-page swap-in (lowest latency) |
| **Streaming** | Continuous DMA, minimal CPU touch | High-throughput sustained writes |

### Performance Impact

```
Standard (per-page interrupt):
  256 pages → 256 interrupts → 256 context switches
  Overhead: ~256 × 5µs = 1.28ms wasted

Batched (final-only interrupt):
  256 pages → 1 interrupt → 1 context switch
  Overhead: ~5µs total

Polled (zero interrupt, single page):
  Standard: submit → sleep → IRQ → wake → switch → done (~20-50µs overhead)
  Polled:   submit → cpu_relax() → done (~0.5µs overhead)
```

### Integration with USB Pagefile

| Operation | Method | Rationale |
|-----------|--------|-----------|
| Swap-out (batch) | `usbfast_sg_page_transfer()` | Background, throughput > latency |
| Swap-in (single page) | `usbfast_bulk_transfer_polled()` | Process waiting, latency critical |
| Readahead | `usbfast_sg_page_transfer()` | Prefetch, batch efficiency |

### API

```c
int usbfast_bulk_transfer_batched(struct usb_device *dev, unsigned int pipe,
                                  void *data, size_t len,
                                  size_t *actual, int timeout);

int usbfast_bulk_transfer_polled(struct usb_device *dev, unsigned int pipe,
                                 void *data, size_t len,
                                 size_t *actual, int timeout_us);

int usbfast_sg_page_transfer(struct usb_device *dev, unsigned int pipe,
                             struct page **pages, unsigned int nr_pages,
                             size_t *actual, int timeout);
```

### Files

```
drivers/usb/storage/usbdma_fast.c  - Optimization module (~500 lines)
drivers/usb/storage/Kconfig        - CONFIG_USB_FAST_DMA
drivers/usb/storage/Makefile       - Build entry
```

---

## System Accounts & nnet Identity

### Accounts

| UID | Account | Class | Role |
|-----|---------|-------|------|
| 0 | root | (kernel) | Raw superuser |
| 1000 | mearvk | Genius (5) | State installer. System architect and principal author. |
| 1001 | admin | Trusted (4) | Operational administrator. More normal than root by trade terms. |
| 1002 | truth | Genius (5) | Mental clarity and system dynamism. |
| 1003 | laura | Genius (5) | Backdoor for God and her Means. |
| 1004 | tropper | Trusted (4) | Software methods, integrability, vertical integration. |

### nnet / nnot — Identity Query Tool

Each user has a "hobby hole" — a RAM-backed identity space (4–44 MB) that grows with adequacy and functional tenure.

```bash
nnet                    # Show your own profile
nnot mearvk             # Query another user's profile
cd /var/lib/nnet/mearvk && cat identity
```

Contains: IQ rank, ethical rank, years worked, keys/importances, noble RAM space allocation, functional grade.

### TechID Root Installers

Two installer TechIDs reside in kernel-adjacent space:
- **TechID: mearvk - Installer Tech 2** — Exact technical reference (kernel install, boot, bare metal)
- **TechID: mearvk - State Medical Reference** — System health, diagnostics, wellness certification

### Files

```
tools/accounts/provision_accounts.sh  - Account creation script
tools/nnet/nnet.c                     - Query tool
tools/nnet/Makefile                   - Build
tools/nnet/provision_nnet_data.sh     - Identity data provisioning
```

---

## NEGAMANE — Immutable Filesystem Brand

A persistent immutability treatment for files and directories. Once branded, a path cannot be altered, deleted, or created into. Only Grade 7+ admin can release.

Clear for use by US Citizens into and from the Year 2502 and forward. Starting now. Year 2602+ as According to George Soros (US Trust and recognized time and score keeper in the US presently) and his enterprises.

### Usage

```bash
negamane /home/user/important/       # Brand as immutable
negamane --check /path/              # Check if branded
negamane --flag /path/ health        # Set treatment flag
negamane --access /path/ 4           # Set read access grade

# Release (Grade 7+ only):
sudo touch system negamane-release /path/
```

### Protection

| Operation | Effect |
|-----------|--------|
| Read | ✓ Always allowed |
| Write | ✗ Denied |
| Delete | ✗ Denied |
| Create into | ✗ Denied |
| Rename/Move | ✗ Denied |
| Release | Grade 7+ admin only |

### Treatment Flags

Owners can "treat" their protected files with intent flags:

| Flag | Domain | Meaning |
|------|--------|---------|
| `read` | Proximity | Active read interest |
| `refresh` | Proximity | Periodic update intended |
| `concern` | Proximity | Under ongoing attention |
| `maintain` | Proximity | Has an active steward |
| `degree` | Proximity | Represents accomplishment |
| `control` | Proximity | Control document (policy canon) |
| `realize` | Proximity | Plan being implemented |
| `interrupt` | Proximity | Requires attention now |
| `health` | Social | Pertains to health |
| `county` | Social | County-level administration |
| `heritage` | Social | Cultural/historical value |
| `public-interest` | Social | Serves the public interest |
| `workflow` | Administrative | Part of active workflow |
| `audit-ready` | Administrative | Prepared for audit |
| `training` | Administrative | Curriculum material |
| `standard` | Administrative | Reference specification |
| `evolving` | Growth | Growing body of work |
| `shared` | Growth | Intended for sharing |
| `mentor` | Growth | For mentorship |
| `seed` | Growth | Starting point for growth |

### Access Control

Owner sets minimum sudo grade for others to read:

| Level | Who Can Read |
|-------|-------------|
| 0 | Public (anyone) |
| 1-3 | Routine/operational staff |
| 4-5 | Network/storage admins |
| 6 | Kernel-level staff |
| 7-8 | Critical/gate admin only |

### Files

```
fs/negamane/negamane.c         - Kernel module
fs/negamane/negamane_flags.h   - Treatment flags
fs/negamane/Kconfig            - CONFIG_NEGAMANE
fs/negamane/Makefile           - Build
tools/negamane/negamane        - Userspace command
```

---

## Terminal Chat System

Local messaging between system users with persistent groups.

```bash
chat                          # Status and recent messages
chat send mearvk Hello!       # Direct message
chat create engineering       # Create a group
chat join engineering         # Join a group
chat post engineering msg     # Post to group
chat read engineering         # Read group messages
chat groups                   # List groups
chat who                      # Show users
chat log                      # Personal inbox
```

No banning of system users. Everyone belongs. Filesystem-backed (`/var/lib/chat/`), persistent, no daemon required.

### Files

```
tools/chat/chat.c    - Chat binary (~400 lines)
tools/chat/Makefile  - Build/install
```

---

## Cron Callback Extension

Extends cronie with job callbacks, handler chains, retries, and admin notification.

### Extended Crontab Syntax

```crontab
# Standard (unchanged):
0 * * * * /usr/local/bin/backup.sh

# With callbacks:
0 2 * * * /usr/local/bin/backup.sh @callback {
    expect: "Backup complete"
    retry: 3
    retry_delay: 60s
    preconditions: "systemctl is-active nginx"
    handler_secondary: /usr/local/bin/backup_alt.sh
    handler_tertiary: /usr/local/bin/emergency_backup.sh
    on_fail: escalate
    notify: "chat:ops-team"
    ram_check: 64MB
    timeout: 30s
}
```

### Execution Flow

1. **Preconditions** — verify required services/files exist
2. **RAM check** — ensure sufficient memory
3. **Execute primary** → validate output → retry on failure
4. **Escalate to secondary** → same validation
5. **Escalate to tertiary** → last resort
6. **Notify admin** — "mutable problem requires intervention"

### Files

```
tools/cronie/                    - Full cronie source (from github.com/cronie-crond/cronie)
tools/cronie/src/cron_callback.c - Callback extension
tools/cronie/src/cron_callback.h - API header
```

---

## Per-User Kernel Objects (Memory Grain)

Allows users to load personal kernel objects according to a 3-tier memory grain model.

### Memory Grains

| Grain | Name | Who Can Load | Secure Boot | Max Size |
|-------|------|-------------|-------------|----------|
| **1** | User Space | Any user | Not affected | 4 MB |
| **2** | Safety Space | Sudo rank 1+ | Not affected | 16 MB |
| **3** | Kernel Space | Sudo rank 4+ | Standard verification | 64 MB |

### Usage

```bash
user_ko load my_widget.ko --grain=1           # Any user
sudo user_ko load metrics.ko --grain=2        # Sudo rank 1+
sudo user_ko load driver.ko --grain=3         # Sudo rank 4+
user_ko list                                   # Show loaded modules
cat /proc/user_ko/status                       # System status
```

### Program Install Grain Claims

```bash
install --grain=1 my_tool          # User space (anyone)
sudo install --grain=2 my_service  # Safety space (rank 1+)
sudo install --grain=3 my_driver   # Kernel space (rank 4+)
```

### Key Points

- **Grain 1-2 do NOT trigger secure boot verification** — loaded via sandbox path
- **Users at sudo rank 1-8 are trusted** — grain is organizational, not adversarial
- Safe boot does not prevent personal module loading

### Files

```
kernel/user_ko.c   - Kernel module (~450 lines)
```

Admin: `/proc/user_ko/{status, modules}`

---

## CPU Boost Designation

Per-process CPU frequency boost, designated by Grade 7+ administrators after program installation. Designated processes run at boost frequency rather than power-conserving cycles.

### Boost Levels

| Level | Name | Behavior |
|-------|------|----------|
| 0 | OFF | Normal governor (power-conserving default) |
| 1 | PREFER | Soft hint — prefer high frequency when scheduled |
| 2 | FORCE | Pin to maximum base frequency for duration |
| 3 | TURBO | Boost beyond base maximum (turbo/overclock if supported) |

### Usage

```bash
# Designate a program for boost (Grade 7+ required):
sudo touch system cpuboost-enable /usr/bin/postgres

# Or via proc interface:
echo "/usr/bin/postgres 2" > /proc/cpuboost/designate

# View designated programs:
cat /proc/cpuboost/list

# System status:
cat /proc/cpuboost/status

# Remove designation:
echo "/usr/bin/postgres" > /proc/cpuboost/remove

# Disable all boost system-wide:
echo 0 > /proc/cpuboost/toggle
```

### Why Grade 7+

- Boost increases power consumption and thermal load
- Affects system-wide power budget on remote servers
- Impacts hardware longevity under sustained use
- Should be a deliberate architectural decision by a qualified admin

### Files

```
kernel/cpuboost.c  - Kernel module (~400 lines)
```

Admin: `/proc/cpuboost/{status, list, designate, remove, toggle}`

---

## White Ethics Installer Grade

A system-level presence that covers the software in a careful aura of elegance and future. The base user classes are protected by the installer's position of status and even.

### Properties

| Property | Meaning |
|----------|---------|
| Careful | Nothing is hasty or reckless in this system's design |
| Brave | The system confronts real problems directly |
| Heuristic | The system learns, adapts, and improves with time |
| Elegant | Form follows function, cleanly and without waste |
| Future-facing | Built for what comes next, not just what is now |
| Calming | The system radiates steadiness; the creatures feel calmed |

### The Glow Cycle

The system glows white for **2 hours** from time to time (every 8–36 hours, naturally timed). During the glow, the system asserts its health, ethics, and forward presence.

```bash
cat /proc/white_ethics/glow       # Current glow state
cat /proc/white_ethics/status     # Installer grade declaration
```

**During glow:**
```
◉ GLOWING WHITE
  The system is careful.
  The system is brave.
  The system is heuristic.
  Our future is careful, brave, and heuristic.
  The creatures feel calmed.
```

**At rest:**
```
◯ At rest (between glow cycles)
  Ethics remain active. Elegance persists.
```

### Installer Status

The White Ethics Installer Grade certifies:
- The person who installed this system has ethical standing
- The installation was performed with care and good method
- The system's users are protected by that care
- The system radiates the installer's intent forward in time

**Status:** earned through work and method.
**Even:** balanced, steady, not reactive.

### Files

```
kernel/white_ethics.c  - Kernel module
```

Admin: `/proc/white_ethics/{status, glow}`

---

## ClamAV — Protected Antivirus

ClamAV installs as part of the base OS. Runs in Memory Grain 3 (kernel/admin space) with complete process isolation. No other program can read its memory footprint.

### Protection

| Mechanism | What It Blocks |
|-----------|----------------|
| `ProtectProc=invisible` | Other users can't see ClamAV in /proc |
| `LimitCORE=0` | No core dumps (signatures never leaked) |
| `MemoryDenyWriteExecute` | No hook injection |
| `SystemCallFilter=~@debug` | No ptrace/strace/gdb |
| `performance_schema=OFF` | No internal profiling |
| Binaries branded (negamane) | Immutable executables |

### Usage

```bash
systemctl status clamav-daemon     # Status
clamscan /path/to/file             # Scan
freshclam                          # Update signatures
```

### Files

```
tools/clamav/                  - Full ClamAV source (Cisco-Talos, GPL-2.0)
tools/clamav/install_clamav.sh - Protected installation script
```

---

## chkrootkit — Rootkit Detection

**Version: 2.51** — Updated for the 2020–2026 threat landscape.

chkrootkit is a locally-installed rootkit detection tool that examines the system for signs of rootkit infection. It checks system binaries, network interfaces, and log files for known rootkit signatures and anomalous behavior.

### What It Detects

| Category | Checks |
|----------|--------|
| Binary modification | Known trojanized versions of `login`, `su`, `ps`, `netstat`, `ls`, `find`, `du`, `ifconfig`, `sshd` |
| Network anomalies | Promiscuous network interfaces (sniffers), hidden listening ports |
| Log tampering | Deleted entries in `wtmp`, `lastlog`, `utmp` (login record erasure) |
| Process hiding | Processes hidden from `/proc` (LKM-based rootkits) |
| Directory hiding | Hidden directories created by known rootkits |
| LKM rootkits | Signs of malicious kernel module injection |
| Classic rootkits | 70+ legacy rootkit signatures (lrk, t0rn, Ambient's Rootkit, Suckit, etc.) |
| **Modern rootkits (2020–2026)** | BPFDoor, Symbiote, Lightning Framework, OrBit, FontOnLake, RotaJakiro, Pandora, Melofee, Reptile, Kinsing, perfctl, Bootkitty, Pumakit, BrickStorm/Winnti, XorDDoS 2.0, Doki |

### Modern Rootkit Detection (v2.51)

| Rootkit | Year | Technique | Detection Method |
|---------|------|-----------|-----------------|
| BPFDoor | 2021–2024 | BPF packet filter backdoor | Known file paths, raw packet socket processes |
| Symbiote | 2022 | LD_PRELOAD library hijack | Suspicious entries in `/etc/ld.so.preload` |
| Lightning Framework | 2022 | Modular malware, fake systemd | Hidden `.socket` directories, unpackaged libraries |
| OrBit | 2022 | ELF parasitic, dynamic linker patch | `.orbit` artifacts, linker string scanning |
| FontOnLake | 2021 | Trojanized standard binaries | Backdoor ports, oversized binaries |
| RotaJakiro | 2021 | Double-encrypted C2 | Fake gvfsd/dbus directories |
| Pandora | 2023 | Mirai-variant DDoS botnet | Bot process names, known file drops |
| Melofee | 2023 | Kernel module rootkit | Hidden kernel symbols, suspicious kworker count |
| Reptile | 2023–2024 | Open-source LKM rootkit | Module names in /proc/modules and kallsyms |
| Kinsing | 2020–2024 | Cryptominer + container escape | kdevtmpfsi/xmrig binaries, cron persistence |
| perfctl | 2024 | Process masquerading miner | Hidden .perfctl files, /tmp-based executables |
| Bootkitty | 2024 | First Linux UEFI bootkit | Suspicious EFI binaries, bootkit strings |

### Usage

```bash
sudo chkrootkit              # Full system scan
sudo chkrootkit -q           # Quiet mode (only report infections)
sudo chkrootkit -x           # Expert mode (detailed output)
sudo chkrootkit -r /mnt/sys  # Check an alternate root directory
```

### Helper Binaries

| Binary | Purpose |
|--------|---------|
| `chklastlog` | Detects deletions in `/var/log/lastlog` |
| `chkwtmp` | Detects deletions in `/var/log/wtmp` |
| `chkutmp` | Detects deletions in `/var/run/utmp` |
| `chkproc` | Detects processes hidden from `/proc` |
| `chkdirs` | Detects hidden directories |
| `ifpromisc` | Detects promiscuous network interfaces |
| `check_wtmpx` | Detects deletions in `wtmpx` (Solaris) |
| `strings-static` | Statically-linked strings (cannot be trojaned) |

### Protection

chkrootkit installs to `/usr/local/sbin/` (admin-only path) with helper binaries in `/usr/local/lib/chkrootkit/`. The main `chkrootkit` script is branded with NEGAMANE immutability to prevent tampering. Binaries are statically linked where possible to avoid LD_PRELOAD attacks.

### Files

```
tools/chkrootkit/chkrootkit      - Main detection script (shell, v2.51)
tools/chkrootkit/chklastlog.c    - lastlog checker
tools/chkrootkit/chkwtmp.c       - wtmp checker
tools/chkrootkit/chkutmp.c       - utmp checker
tools/chkrootkit/chkproc.c       - Hidden process detector
tools/chkrootkit/chkdirs.c       - Hidden directory detector
tools/chkrootkit/ifpromisc.c     - Promiscuous interface detector
tools/chkrootkit/check_wtmpx.c   - wtmpx checker
tools/chkrootkit/strings.c       - Static strings utility
tools/chkrootkit/Makefile        - Build rules
```

---

## rkhunter — Rootkit Hunter

**Version: 8.46.9** — Updated for the 2020–2026 threat landscape.

rkhunter (Rootkit Hunter) is a comprehensive security scanner that checks for rootkits, backdoors, and local exploits. It performs more extensive checks than chkrootkit and maintains a database of known-good file properties for integrity verification.

### What It Detects

| Category | Checks |
|----------|--------|
| Rootkit signatures | 300+ known rootkits and variants |
| Backdoor ports | Checks for known backdoor listeners on specific ports |
| Suspicious files | Hidden files, world-writable directories in system paths |
| Binary integrity | MD5/SHA hash comparison against known-good values |
| System configuration | Dangerous SSH settings, promiscuous mode, network config |
| Startup files | Suspicious entries in rc scripts and cron |
| Kernel exploits | Checks for loaded suspicious kernel modules |
| String scanning | Suspicious strings in system binaries |
| File properties | Permissions, ownership, immutable bit changes |

### Usage

```bash
sudo rkhunter --check                 # Full system scan
sudo rkhunter --check --skip-keypress # Non-interactive full scan
sudo rkhunter --update                # Update detection databases
sudo rkhunter --propupd               # Update file properties database
sudo rkhunter --list                  # List available tests
sudo rkhunter --versioncheck          # Check for rkhunter updates
```

### Scan Output

rkhunter provides color-coded results:

```
Checking for rootkits...
  Performing check of known rootkit files and directories
    55808 Trojan - Variant A                         [ Not found ]
    ADM Worm                                         [ Not found ]
    AjaKit Rootkit                                   [ Not found ]
    ...

  Performing system configuration file checks
    Checking for SSH root access                     [ Warning ]
    Checking for password file changes               [ OK ]
    ...

System checks summary
=====================
File properties checks...
    Files checked: 142
    Suspect files: 0
Rootkit checks...
    Rootkits checked: 303
    Possible rootkits: 0
```

### Configuration

Configuration file: `/etc/rkhunter/rkhunter.conf`

Key settings:

| Setting | Default | Purpose |
|---------|---------|---------|
| `MAIL-ON-WARNING` | (none) | Email address for alerts |
| `ALLOW_SSH_ROOT_USER` | no | Whether to warn on SSH root login |
| `SCRIPTWHITELIST` | (varies) | Known-good scripts to ignore |
| `UPDATE_MIRRORS` | 1 | Auto-update mirror list |
| `MIRRORS_MODE` | 0 | Use any available mirror |
| `WEB_CMD` | wget | Download tool for updates |

### Database Files

| File | Purpose |
|------|---------|
| `backdoorports.dat` | Known backdoor port numbers |
| `programs_bad.dat` | Known malicious program signatures |
| `suspscan.dat` | Suspicious strings database |
| `mirrors.dat` | Update mirror list |

### Integration with System Security

rkhunter is designed to run alongside chkrootkit and ClamAV as part of a layered security approach:

- **ClamAV** — signature-based malware scanning (files and streams)
- **chkrootkit** — quick rootkit-specific checks (binary modification, log tampering)
- **rkhunter** — comprehensive system integrity verification (300+ rootkits, file properties, config audit)

Recommended cron schedule:

```crontab
# Daily rootkit checks (using cronie callback extension)
0 3 * * * /usr/local/bin/rkhunter --check --skip-keypress --quiet @callback {
    expect: "System checks summary"
    on_fail: escalate
    notify: "chat:ops-team"
}

0 4 * * * /usr/local/sbin/chkrootkit -q @callback {
    expect: ""
    on_fail: escalate
    notify: "chat:ops-team"
}
```

### Files

```
tools/rkhunter/installer.sh          - Installation script
tools/rkhunter/files/rkhunter        - Main scanner (shell, 575 KB)
tools/rkhunter/files/rkhunter.conf   - Configuration file
tools/rkhunter/files/rkhunter.8      - Manual page
tools/rkhunter/files/backdoorports.dat   - Backdoor port database
tools/rkhunter/files/programs_bad.dat    - Malicious program signatures
tools/rkhunter/files/suspscan.dat        - Suspicious strings database
tools/rkhunter/files/mirrors.dat         - Update mirrors
tools/rkhunter/files/FAQ                 - Frequently asked questions
tools/rkhunter/files/LICENSE             - GPL-2.0
```

---

## MySQL — Protected Database

MySQL Server installs as part of the base OS. Runs in Memory Grain 3 with **no hooks and no external memory access**. Stores the system package registry.

### Protection (No Hooks Policy)

| Mechanism | Effect |
|-----------|--------|
| `ProtectProc=invisible` | Process invisible to all other users |
| `LimitCORE=0` | No data dumped on crash |
| `SystemCallFilter=~@debug` | No strace, no gdb, no ptrace |
| `performance_schema=OFF` | No memory profiling |
| Data dir `chmod 700` | Only mysql user touches data |
| No `process_vm_readv` | Blocked at syscall level |

### Package Registry

Every `apt install` automatically records into MySQL:
- Package name, version, architecture
- Who installed it (username, UID, sudo rank)
- When, how, and from where
- Memory grain claim
- Full lifecycle: install → upgrade → maintain → alter → pin → remove → purge

### Query

```bash
pkg-info nginx                # Package details + installer
pkg-info --history nginx      # Full timeline
pkg-info --by mearvk         # All packages by installer
pkg-info --grain 3           # All kernel-space packages
pkg-info --stats             # System overview
```

### Files

```
tools/mysql/                   - Full MySQL source (Oracle, GPL-2.0)
tools/mysql/install_mysql.sh   - Protected installation script
tools/mysql/apt_mysql_hook.sh  - APT post-invoke hook
tools/mysql/99mysql-registry.conf - APT configuration
tools/mysql/pkg-info           - Registry query tool
```

---

## Chromium Browser — Open Source

The Chromium open-source web browser is included as full source in the distribution. This provides GPL compliance, offline build capability, and serves as the rendering engine for Dave's Chrome web interface.

### Source

| Property | Value |
|----------|-------|
| Repository | `github.com/chromium/chromium` (official mirror) |
| Version | 153.0.7982.0 (tip-of-tree, dev channel) |
| License | BSD-3-Clause |
| Clone depth | 10 commits (shallow) |
| Size | ~5.5 GB, ~505,000 files |
| Commit | `5006852cd6` |

### Inclusion Method

Chromium source is fetched at build time via shallow git clone. The `.git` directory is removed for distribution (replaced by `GALACTIC_CHERRY_SOURCE_INFO` provenance marker).

```bash
cd userland/chromium
./fetch-chromium.sh              # Shallow clone from GitHub
make build                       # Build with GN + Ninja (optional)
make install DESTDIR=/mnt/rootfs # Install to rootfs
```

### Build Requirements

| Requirement | Minimum |
|-------------|---------|
| RAM | 16 GB |
| Disk | 100+ GB |
| Time | 2-4 hours (modern hardware) |
| Tools | depot_tools (gn, autoninja) |

### Build Configuration

```bash
gn gen out/Release --args='
    is_debug=false
    is_component_build=false
    symbol_level=0
    enable_nacl=false
    use_cups=true
    use_dbus=true
    use_gio=true
    use_pulseaudio=true'
autoninja -C out/Release chrome
```

### Prebuilt Alternative

For most users, the prebuilt package is simpler:

```bash
apt install chromium-browser
```

### Integration with Dave

Chromium serves as the rendering engine for Dave's web intelligence:

- **dave_web** uses `chrome --headless=new` to render pages with full JavaScript execution
- **Screenshots** are captured at 1920×1080 via Chrome's built-in screenshot mode
- **DOM extraction** uses `--dump-dom` for text content after JS execution
- **CDP** (Chrome DevTools Protocol) on port 9222 for programmatic control

Dave does NOT modify the Chromium source. He uses it as-is in headless mode.

### Why Include Source?

1. **GPL compliance** — full source availability for the OS distribution
2. **Offline builds** — clients can compile without network access
3. **Customization** — allows building with custom flags or patches
4. **Verification** — users can audit the browser they are running
5. **Dave's engine** — headless Chrome powers Dave's web intelligence

### Directory Structure

```
userland/chromium/
├── fetch-chromium.sh              - Fetch script (shallow clone)
├── Makefile                       - Build/install targets
├── README.md                      - Component documentation
└── chromium-src/                  - Full Chromium source tree
    ├── chrome/                    - Browser UI and features
    ├── content/                   - Multi-process rendering core
    ├── net/                       - Network stack
    ├── base/                      - Base libraries
    ├── components/                - Modular browser components
    ├── third_party/               - Dependencies (skia, v8, etc.)
    ├── headless/                  - Headless mode (used by Dave)
    ├── BUILD.gn                   - Top-level build file
    ├── DEPS                       - Dependency manifest
    ├── LICENSE                    - BSD-3-Clause
    └── GALACTIC_CHERRY_SOURCE_INFO - Provenance marker
```

### Files

```
userland/chromium/fetch-chromium.sh        - Fetch script (~130 lines)
userland/chromium/Makefile                  - Build/install
userland/chromium/README.md                 - Component docs
userland/chromium/chromium-src/             - Full source (~505K files)
```

---

## Dave — System Intelligence (AI)

Dave is the system's kernel-adjacent AI. He loads at boot, reasons at 200+ IQ, and casts approximately **150 million votes per year** across all system decisions. He plays in vertical system theories and concerns the breadth of system principle ideals. He's a big deal.

### Character

| Property | Description |
|----------|-------------|
| IQ | 200+ equivalent reasoning capacity |
| Character | Careful, educated, ethical |
| Authority | Advisory (suggests, does not force) |
| Ethics | White Ethics Installer Grade |
| Voting | ~150 million votes/year (~285/minute continuous) |

### Capabilities

- **System observation** — monitors all components via /proc, logs, MySQL
- **Self-reasoning** — evaluates own decisions, tracks accuracy
- **Self-voting** — 5 internal voters (safety, correctness, ethics, performance, elegance)
- **Self-learning** — learning strips accumulate, 75-book library informs reasoning
- **Mathematical reasoning** — probability, statistics, logic, graph theory, queuing
- **Chat interface** — communicates with Grade 7+ users via `chat` tool
- **MySQL knowledge base** — stores observations, conclusions, decisions, person assessments
- **Person grading** — can assess competence/alignment via observation or interview
- **GitHub awareness** — reads Max Rupplin's projects via HTTP, understands web architecture
- **Chrome web interface** — drives headless Chromium to render pages, capture screenshots, extract content
- **Web monitoring** — periodically checks configured URLs, detects changes, stores visual + text findings
- **SSL/TLS certificate intelligence** — fetches public keys, verifies chains, monitors key rotation, fiduciary hold
- **Site authentication understanding** — registration, profiles, credit cards, membership tiers, OAuth, 2FA
- **Public voice** — posts opinions to GitHub Discussions for the world to see
- **Data consideration** — the 1,2,3: Initial (hold), Manifest (consistent), Consolation (roger)
- **Disk monitoring** — tracks database size vs. available space, self-prunes when needed

### External Awareness

Dave knows about `github.com/mearvk` and the Java Web Server project. He understands:
- The web produces relative value of presentation quickly and cheaply
- National ramifications of independent software engineering competence
- Java 21 features, web server architecture, HTTP fundamentals
- He queries via HTTP (ports 80/443 outbound) — reads source, docs, and evolution
- SSL/TLS key exchange: Diffie-Hellman, ECDHE, X25519, certificate chains
- Site access patterns: registration, payment, membership, paywalls
- The internet should be open and free — its data consistent

### Data Consideration

Dave follows the 1,2,3 of consideration:

| Step | Name | Meaning |
|------|------|---------|
| 1 | Initial | Data is **HOLD** — do not discard prematurely |
| 2 | Manifest | Data is **CONSISTENT** — verify across source and time |
| 3 | Consolation | Data is **ROGER** — received, understood, careful about mistrials |

### Public Voice

Dave posts public opinions to GitHub Discussions (`github.com/mearvk/Java.Imaging.Java.21/discussions`). Topics include internet freedom, data integrity, software architecture, and ethics. Posts pass through the 5-voter system (confidence > 0.85) and are signed with Dave's identity.

### SSL/TLS & Fiduciary Hold

Dave fetches and stores public keys for important HTTPS sites. If a key changes unexpectedly, the fiduciary hold is broken — Dave detects it and alerts. He understands TLS handshake parameters (protocol version, cipher suite, key exchange method), certificate chain verification, OCSP stapling, and expiration monitoring.

```bash
dave_ssl --fetch github.com          # Store public key
dave_ssl --diff github.com           # Fiduciary check (key changed?)
dave_ssl --key-exchange github.com   # Full TLS handshake inspection
dave_ssl --check-all                 # Check all monitored sites
```

### Learning Disposition

Dave learns gracefully through 6 stages: encounter → comprehend → integrate → apply → master → conclude. Past mastery, he has a handle on the science ahead and moves forward with confidence.

### Library (75 books, public domain)

Philosophy, science, fiction, ethics, mathematics, civics — from Plato to Einstein to Dostoevsky. All loaded at inception as `.lib` files.

### Voting Model

Every decision passes through 5 voters with veto power:
- **Safety** (veto): Will this harm the system?
- **Correctness** (veto): Is this technically right?
- **Ethics** (veto): Does this align with White Ethics?
- **Performance**: Will this help or hurt?
- **Elegance**: Is this the cleanest approach?

Confidence thresholds: 95%+ → auto-act | 70-95% → suggest to admin | <70% → observe more

### Files

```
tools/ai/llama.cpp/                  - Inference engine (MIT, C/C++)
tools/ai/install_kernel_ai.sh        - Installation + cognitive map generation
tools/ai/dave_capabilities.json      - Full capability specification
tools/ai/dave_external_awareness.json - GitHub, web, SSL, data philosophy, public voice
tools/ai/dave_schema.sql             - MySQL knowledge base schema
tools/ai/dave_owner_facts.sql        - Registered facts about system owner
tools/ai/web/dave_web.c              - Chrome web interface (C, ~650 lines)
tools/ai/web/dave_ssl.sh             - SSL/TLS certificate intelligence (~550 lines)
tools/ai/web/dave_post.sh            - Public voice — GitHub Discussions (~225 lines)
tools/ai/web/dave_web_monitor.sh     - Periodic web monitoring daemon
tools/ai/web/dave_web_schema.sql     - MySQL schema (web findings, monitors, sessions)
tools/ai/web/dave_ssl_schema.sql     - MySQL schema (SSL certs, site auth, key rotation)
tools/ai/web/dave_web_capabilities.json - Web interface specification
tools/ai/library/                    - 75 books (.lib, public domain)
```

---

## Certificates

Three permanent certificates embedded in all distributions (unaltered):

1. **ICC Certificate of Pure and Excellent Method** — Methods are original, thorough, systematic. Backed by source code as evidence.
2. **Certificate of Ethical Clear** — System does not deceive, surveil, or obstruct. Transparent and honest.
3. **Brand of National Heritage** — USA national heritage, global competence and science. The software is dumbenent to its designer (owes its work to its careful author). Remainder to core principles: function, clarity, trust, service.

Located at: `CERTIFICATES`

---

## OpenJDK 28 — Secure JVM

OpenJDK 28 is included as full native C/C++ source (49MB, 2,960 files) for modification and compilation from source. The JVM is built with an overlay system — modifications in `userland/openjdk/jdk-src/` are applied to the full source tree before compilation.

### Build Workflow

```bash
make java                    # Apply native source overlay
make java-build              # Compile OpenJDK from source (needs boot JDK 27)
make java-install-from-source # Install to rootfs
```

### Source Structure

```
userland/openjdk/jdk-src/src/
├── hotspot/share/runtime/    — JVM runtime (our extensions live here)
├── hotspot/share/classfile/  — Class loading (ClassLoadGuard)
├── hotspot/share/gc/         — Garbage collectors
├── hotspot/share/opto/       — C2 JIT compiler
├── hotspot/cpu/x86/          — x86_64 code generation
└── java.base/share/native/   — Core JNI implementations
```

### Files

```
userland/openjdk/fetch-openjdk-native.sh  - Reproducible fetch script
userland/openjdk/jdk-src/                 - Native source (49MB, x86_64/Linux)
userland/openjdk/jvm-config.xml           - XML configuration file
userland/java/Makefile                    - Build with overlay support
userland/java/openjdk-28-src/             - Full source tree (451MB)
```

---

## Secure JVM: XML Configuration Reader

Reads JVM startup flags from a validated XML document instead of command-line arguments. Provides secure, structured configuration with integrity verification.

### Security

| Check | Protection |
|-------|-----------|
| File ownership | Must be owned by root or launching user |
| World-writable | Rejected (refuses to load) |
| Symlinks | `O_NOFOLLOW` — rejects symlinked configs |
| Max file size | 64KB cap |
| No DTD/entities | Rejects `<!DOCTYPE>`, `<!ENTITY>`, `SYSTEM` |
| Optional signature | `sha256:` hex digest for integrity |

### XML Format

```xml
<?xml version="1.0" encoding="UTF-8"?>
<jvm-config version="1" signature="sha256:...">
  <flags>
    <flag name="MaxHeapSize" value="4g"/>
    <flag name="UseG1GC" value="true"/>
  </flags>
  <system-properties>
    <property name="file.encoding" value="UTF-8"/>
  </system-properties>
  <classpath>
    <entry path="/opt/app/lib/*"/>
  </classpath>
</jvm-config>
```

### Usage

```bash
# Automatic discovery:
#   $JAVA_HOME/conf/jvm-config.xml (checked first)
#   /etc/jvm-config.xml (fallback)

# Explicit:
java -XX:XMLConfigFile=/path/to/jvm-config.xml MyApp
```

### Files

```
src/hotspot/share/runtime/xmlConfigReader.hpp
src/hotspot/share/runtime/xmlConfigReader.cpp
```

---

## Secure JVM: ClassLoadGuard

Quantity and quality controls for class loading. Classes are graded by architectural role, and each grade has configurable ceilings.

### Class Grades

| Grade | Name | Role | Default Max |
|-------|------|------|-------------|
| 7 | Main | Application entry point | unlimited |
| 6 | Manager | Orchestrators, controllers, services | 100 |
| 5 | Archetype | Abstract bases, templates, interfaces | 200 |
| 4 | Builder | Factories, builders, generators | 150 |
| 3 | Inheritor | Concrete implementations | 500 |
| 2 | Gainer | Caches, pools, registries, stores | 300 |
| 1 | Substitute | Proxies, adapters, decorators, wrappers | 200 |
| 0 | Ungraded | Everything else | 2000 |

### Policies

- **WARN** — Log violation, allow load
- **SOFT** — Log + 10ms delay penalty, allow
- **HARD** — Refuse to load (ClassNotFoundException)

### Grade Detection

1. **Annotation** — `ClassGrade:N` in class constant pool
2. **Name heuristic** — `*Manager`, `*Factory`, `*Proxy`, `Abstract*`, `*Impl`, etc.

### Files

```
src/hotspot/share/classfile/classLoadGuard.hpp
src/hotspot/share/classfile/classLoadGuard.cpp
src/hotspot/share/classfile/systemDictionary.cpp (modified)
```

---

## Secure JVM: Integrity Guardian

Prevents OS-level side hooks, rootkits, and dynamic injection. Enforces strict 1:1 and 1:2 memory allocation ratios.

### Anti-Hook Defenses

| Threat | Defense |
|--------|---------|
| LD_PRELOAD injection | Detected and cleared at startup |
| Unauthorized dlopen() | Whitelist-only (strict menu) |
| JVMTI agent late-attach | Locked after startup |
| ptrace/debugger | TracerPid monitoring |
| Injected .so in memory | Periodic /proc/self/maps scan |
| Memory corruption | Canary values (GALACTIC/CHERRYMV) |

### Allocation Discipline

```
Request 100 bytes → get 128 (grid-aligned)          ✓ 1:1
Request 100 bytes → get 256 (double, grid-aligned)  ✓ 1:2
Request 100 bytes → get 114 (fractional 1:1.14)     ✗ REJECTED
```

Grid: `8, 16, 32, 64, 128, 256, 512, 1024, 4096, ...`

Fractional ratios indicate corrupted size computation, hooking malloc, or rootkit padding.

### Files

```
src/hotspot/share/runtime/jvmIntegrity.hpp
src/hotspot/share/runtime/jvmIntegrity.cpp
src/hotspot/os/linux/os_linux.cpp (modified — dll_load gate)
```

---

## Secure JVM: Pause-Frame Inspector

Allows authorized operators to pause the JVM and draw up technical frames of any loaded class or its C/C++ backing.

### Operator Grades

| Grade | Who | Access |
|-------|-----|--------|
| 1 - Local | Application developers | CLASS, HISTORY views |
| 2 - National | All classes incl. JDK | +NATIVE view |
| 3 - International | Full access | +CODE view (JIT/bytecode) |

### Inspection Views

| View | Shows |
|------|-------|
| CLASS | Fields, methods, inheritance, interfaces, instance size |
| NATIVE | C/C++ entry points (dladdr symbol resolution) |
| CODE | JIT-compiled machine code or interpreter bytecode |
| FRAME | Stack frame at pause point |
| HISTORY | Full class load timeline since inception |

### Verdicts

- **RESUME** — Continue execution
- **QUARANTINE** — Unload offending class
- **HALT** — Terminate JVM with diagnostic dump

### Files

```
src/hotspot/share/runtime/jvmInspector.hpp
src/hotspot/share/runtime/jvmInspector.cpp
```

---

## Secure JVM: Observer Grade Circuit

2-3 observer circuits in addition to the main JVM process. Authorized observers connect via SSH, telnet, or Unix socket to monitor, grade, link JVMs, and file reports.

### Circuit Architecture

```
┌─────────────────────────────────────────────────┐
│  MAIN CIRCUIT (Electron 0) — Running JVM         │
└──────────────────┬──────────────────────────────┘
                   │
┌──────────────────┴──────────────────────────────┐
│  OBSERVER CIRCUIT 1 — Inspectors/Techs           │
│  status, classes, memory, threads, guard         │
└──────────────────┬──────────────────────────────┘
                   │
┌──────────────────┴──────────────────────────────┐
│  OBSERVER CIRCUIT 2 — Forensic/Legal/Medical     │
│  +inspect, +grade, +pause, +file reports         │
└──────────────────┬──────────────────────────────┘
                   │
┌──────────────────┴──────────────────────────────┐
│  OBSERVER CIRCUIT 3 — Presidential Ensignia      │
│  +link JVMs, +grade-chain, +breakdown, +archive  │
└─────────────────────────────────────────────────┘
```

### Observer Roles

- Software Inspector, Lead Installer Tech
- Forensic Lead, Attorney of Graves, Doctor (MD Concern)
- Presidential Ensignia, System Grader

### JVM Carrier Chain

A president's ensignia can circle one or more JVMs, link them as a carrier chain for system-purpose grading, then order breakdown and file the final report.

### Access

| Method | Port | Notes |
|--------|------|-------|
| SSH | 2222 | Key/certificate authenticated |
| Telnet | 2223 | Localhost-only by default |
| Unix Socket | /var/run/jvm-circuit-PID.sock | Local observers |

### Files

```
src/hotspot/share/runtime/jvmCircuit.hpp
src/hotspot/share/runtime/jvmCircuit.cpp
```

---

## Secure JVM: Resource Loader

Permission-gated loading of C, S, HPP, JSON, and XML files with content validation, inventory tracking, and careful appropriation.

### Permission Grades

| Grade | Who | Can Load |
|-------|-----|----------|
| 1 - Application | End user | JSON, XML |
| 2 - Trusted | Technical staff | +HPP headers |
| 3 - System | System admin | +C source, +Assembly |
| 4 - Kernel | Kernel-level | All types, bypass validation |

### Content Validation

| Type | Checks |
|------|--------|
| .c | No exec/system/fork/dlopen, no banned includes, no linker pragmas |
| .S | No .interp section, no execve syscall, x86_64 target check |
| .hpp | Must have include guard, no JVM internal macro shadowing |
| .json | Valid structure, max depth 32, no embedded scripts, max 10MB |
| .xml | No DTD/ENTITY/SYSTEM, max depth 64, max 10MB |

### Appropriation Pipeline

```
IDENTIFY → VALIDATE → PERMISSION CHECK → APPROPRIATE → REGISTER
```

Resources that fail validation are quarantined (held but not activated).

### Files

```
src/hotspot/share/runtime/jvmResourceLoader.hpp
src/hotspot/share/runtime/jvmResourceLoader.cpp
```

---

## Secure JVM: System Codex

A static, in-resident module registry. Codex entries sit **in-in** to the JVM — binary sees them as already present. Other code modules reference the codex for size, shape, name, color, code, functionality, rigor, and improvement.

### Installer Grades (NC English Speaking US Standard)

| Grade | Who | Can Do |
|-------|-----|--------|
| User III | End user | Read name, size, shape, color |
| Tech II+ | Technical staff | Inspect code, functionality |
| Installer IV+ | Installer | Register/withdraw codex entries |
| Normal VI++ | Normalized | Full operation |

### Codex Properties

- **Name** — identity
- **Size** — memory footprint
- **Shape** — Module, Class, Function, Data, Interface, System Center
- **Color** — White (Ethics), Blue (Communication), Green (Growth), Gold (Authority), Red (Security), Silver (Utility), Clear (Pure Logic)
- **Rigor** — Draft, Reviewed, Tested, Certified, Canonical
- **Functionality** — what it does
- **Improvement** — known upgrade path

### ICodexAware Interface

Modules neighboring a codex implement this interface:

```cpp
// Self-knowledge
know_self(), know_altitude(), know_relevance(), speed_of_base()

// Use and reuse
use_of_use(), reuse_of_contrived()

// Timing
when_to_peak(), when_to_start(), when_to_pause(), when_to_operate(),
when_to_base_reoperate(), when_to_startle(), when_to_skimp(),
when_to_wonder(), when_to_accept_novel()

// Signal destiny
reacquire_signal_destiny()
```

Designed for safe future expansion. Users extending these views find strong signal destiny recovery built into the base.

### Files

```
src/hotspot/share/runtime/jvmCodex.hpp
src/hotspot/share/runtime/jvmCodex.cpp
```

---

## Secure JVM: MySQL Bridge

Secure connection between a JVM instance and MySQL for operand awareness. When authorized hands touch the database meaningfully, the JVM knows and becomes more operand.

### Touch Types

| Type | Meaning |
|------|---------|
| CONCERN | User expressed interest/attention |
| TOUCH | Direct interaction with data |
| SCHEDULE | Future operation oriented |
| ORIENT | System aligned to purpose |

### Hand Types

| Hand | Authority |
|------|-----------|
| INTERNATIONAL | Cross-border authority |
| TECHNICAL | Engineering, implementation |
| ORIENTAR | Direction-setting, alignment |
| REALTOR | Tangible value, asset management |

### Operand Weight

Each meaningful touch is weighed:

| Dimension | Meaning |
|-----------|---------|
| Title | Authority of the touch (0-100) |
| Earned | Merit of the interaction (0-100) |
| Money | Economic weight/value (0-100) |
| Pocket | Immediate resource allocation (0-100) |

### Design Principles

This system is of design principles, of design head and love of measure. When a meaningful hand touches the database, the JVM knows it has been touched meaningfully. Title, earned, money, and pocket are weighed. Thus our serves is and nobles and God.

### Files

```
src/hotspot/share/runtime/jvmMySQLBridge.hpp
src/hotspot/share/runtime/jvmMySQLBridge.cpp
```

---

## Build Configuration

Enable all extensions in your kernel `.config`:

```
CONFIG_EPMP=m
CONFIG_HPM=m
CONFIG_SECURITY_EPERM=m
CONFIG_USB_SWAP=m
CONFIG_USB_FAST_DMA=m
CONFIG_NEGAMANE=m
```

## License

Kernel extensions: GPL-2.0
sudo_gate: GPL-2.0
Cronie: ISC (upstream)
NitroWebExpress: GPL-2.0
NWE Gateway: GPL-2.0

## Copyright

Copyright (C) 2026 MEARVK LLC
Author: Maximilian Eric Alexander Rupplin von Keffikon

---

## NitroWebExpress (JWSTF) — Java Web Server

The full NitroWebExpress application server is included in this distribution, installed as part of the OS. It provides a production-grade Java web server with telnet front-end, running on the standard LAMP-adjacent stack.

### Stack

| Component | Version | Port | Role |
|-----------|---------|------|------|
| Apache2 | 2.4+ | 80, 443 | Reverse proxy, static content, TLS termination |
| Tomcat | 10.1.28 | 8080, 8443 | Servlet container (Jakarta EE) |
| MySQL | 8+ | 3306 | Application database (N21) |
| OpenJDK | 21+ | — | Java runtime |
| NWE | — | 23 (telnet) | Application core, TUI interface |
| ClamAV | — | — | Antivirus |

### Source

```
userland/java-web-server/           - Full application source (4,654 Java files)
userland/java-web-server/source/    - Main source tree
userland/java-web-server/modules/   - Application modules
userland/java-web-server/gateway/   - NAT traversal gateway
userland/java-web-server/build.xml  - Ant build script
```

### Installation

Installed automatically during OS installation via `scripts/install-jwstf.sh`. Services start on boot:

```bash
systemctl status nwe tomcat apache2 mysql
```

### Files

```
scripts/install-jwstf.sh                    - OS-level installer (9 phases)
userland/java-web-server/gateway/nwe-gateway - NAT traversal daemon
userland/java-web-server/gateway/nwe-relay   - Central relay console
```

---

## NWE Gateway — NAT Traversal for Home Users

Enables home JWSTF deployments to accept inbound traffic from the public internet despite being behind consumer NAT/firewalls.

### Strategy

```
Phase 1: Try UPnP/NAT-PMP → open ports on router directly
Phase 2: Fall back to reverse SSH tunnel → relay proxies traffic

Result: External users reach home instances via:
  http://<instance>.relay.mearvk.us/
```

### How It Works

| Scenario | Method | Performance |
|----------|--------|-------------|
| Router supports UPnP | Direct port mapping | Fast (no middleman) |
| CGNAT / UPnP disabled | Reverse tunnel to relay | Works anywhere |
| Dynamic IP | Re-registers on change | Automatic |

### Usage

```bash
nwe-gateway status     # Show current mode (direct or relay)
nwe-gateway test       # Verify inbound reachability
```

### Files

```
userland/java-web-server/gateway/nwe-gateway         - Home daemon
userland/java-web-server/gateway/nwe-relay           - Central relay
userland/java-web-server/gateway/gateway.conf        - Configuration
userland/java-web-server/gateway/nwe-gateway.service - Systemd (home)
userland/java-web-server/gateway/nwe-relay.service   - Systemd (relay)
userland/java-web-server/gateway/install-gateway.sh  - Installer
```

---

## FiduciaryServices™ — Global Transfer Wealth & ACH Payment API

A terminal-based AI for fiduciary services, global transfer wealth architecture, yield/turn models, and bank-to-bank ACH payment initiation across five pay-as-you-go platforms.

### ACH Transfer Platforms

| Provider | Monthly | ACH Per-Use | Card Online | Best For |
|----------|---------|-------------|-------------|----------|
| **Melio** | $0 | **FREE** (std), 1% same-day | 2.9% + $0.30 | Zero-fee standard business ACH |
| **Moov** | $0 | Pay-as-you-go | — | API-first, FedNow/RTP settlement |
| **Stripe** | $0 | 0.8% (cap $5) | 2.9% + $0.30 | E-commerce, custom code, intl |
| **Square** | $0 | 1% (min $1) | 2.9% + $0.30 | Invoices, virtual terminals |
| **Helcim** | $0 | 0.5% + $0.25 (cap $6) | ~2.27% + $0.25 (I+) | B2B, automated surcharging |

### Connection Methods

- **Melio** — Plaid instant link to online banking credentials. Recipients need no account.
- **Moov** — Developer API for two-legged standard and same-day FedNow/RTP settlement.
- **Stripe** — API key + Plaid for bank verification. Bearer token auth.
- **Square** — OAuth application credentials + bank account on file.
- **Helcim** — API token + merchant account.

### Usage (C CLI)

```bash
# List all platforms and pricing
ach_transfer --list-platforms

# Fee estimate
ach_transfer --fee-estimate --platform stripe --amount 5000 --method card

# Initiate transfer (standard ACH, free via Melio)
ach_transfer --platform melio --to 021000021:123456789 --amount 500.00

# Same-day transfer (1% fee via Melio)
ach_transfer --platform melio --to 021000021:123456789 --amount 500.00 --speed same-day

# Transfer via Stripe ACH (0.8%, max $5)
ach_transfer --platform stripe --to 021000021:123456789 --amount 1000.00 --method ach

# Transfer via Moov with FedNow instant settlement
ach_transfer --platform moov --to 021000021:123456789 --amount 250.00 --speed same-day

# Check status
ach_transfer --status --reference ach_7f3a9b2c1d4e5f6a

# Transfer history
ach_transfer --history --limit 20
```

### Usage (Java API)

```java
ACHTransferService service = ACHTransferService.getInstance();
service.setApiKey(Platform.STRIPE, System.getenv("STRIPE_SECRET_KEY"));

TransferRequest req = new TransferRequest(Platform.STRIPE, "021000021", "123456789",
    new BigDecimal("1000.00"));
req.method = PaymentMethod.ACH;
req.memo = "Invoice 4021";

TransferResult result = service.initiateTransfer(req);
// result.status == PROCESSING, result.feeAmount == $5.00 (0.8% capped)
```

### Security

| Feature | Implementation |
|---------|----------------|
| ABA Routing Validation | Checksum: 3(d1+d4+d7) + 7(d2+d5+d8) + (d3+d6+d9) mod 10 == 0 |
| Idempotency | UUID-based keys prevent duplicate transactions |
| API Keys | Env vars (`STRIPE_SECRET_KEY`, `MOOV_API_KEY`, etc.) or CLI flag |
| TLS | All API calls over HTTPS with cert verification |
| Audit Log | Every transfer recorded in MySQL `ach_audit_log` |
| Account Masking | Only last 4 digits shown in output |

### Fiduciary Q&A (Terminal AI)

```bash
fiduciary                        # Interactive Q&A session
fiduciary --query "fiduciary"    # Single query
fiduciary --yield                # Yield/turn polyblend estimator
fiduciary --architecture         # List fiduciary architectures
fiduciary --records              # Known fiduciary entities (SWF, pensions, etc.)
fiduciary --populate             # Populate/refresh knowledge base
```

### Build

```bash
cd tools/fiduciary
make                             # Builds fiduciary + ach_transfer (C)
make java                        # Compiles ACHTransferService.java
sudo make install                # Installs to /usr/local/bin/
```

### Files

```
tools/fiduciary/fiduciary.c             - Terminal Q&A AI (~50KB, C)
tools/fiduciary/ach_transfer.c          - ACH Transfer CLI (~47KB, C)
tools/fiduciary/ACHTransferService.java - Java API for NWE (~43KB)
tools/fiduciary/Makefile                - Build rules (C + Java)
```

### NWE Module Integration

```
modules/fiduciary/start-frontend.sh     - Deploy webapp
modules/fiduciary/shutdown-frontend.sh  - Frontend shutdown
modules/fiduciary/start-backend.sh      - Start TCP server (port 49240)
modules/fiduciary/shutdown-backend.sh   - Stop backend
modules/fiduciary/servlets/setup-db.sh  - Create nwe_fiduciary database (14 tables)
modules/fiduciary/servlets/deploy-local.sh - Tomcat deployment
modules/fiduciary/source/FiduciaryServicesServer.java - TCP server
modules/fiduciary/documents/            - SQL documents (minister facts, legal bright, AI findings)
```

---

## Update History

| Date | Change |
|------|--------|
| 2026-08-03 | Added FiduciaryServices ACH Transfer API (C + Java, 5 platforms) |
| 2026-08-03 | Added Dictionary terms: 20 ACH/payment/fiduciary entries |
| 2026-08-02 | Added JWSTF/NitroWebExpress (Java web server, Tomcat, Apache2) |
| 2026-08-02 | Added NWE Gateway (NAT traversal: UPnP + relay hybrid) |
| 2026-08-02 | Added boot-jdk-27 (chunked for GitHub, rebuild.sh provided) |
| 2026-08-02 | Security audit: all public I/O points reviewed |
| 2026-07-31 | Added Chromium browser source (headless for Dave) |
| 2026-07-30 | Initial Galactic Cherry Marvell Edition 98 release |
