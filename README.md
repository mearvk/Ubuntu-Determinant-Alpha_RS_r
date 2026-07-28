MearvK Ltd - MEARVK LLC

Maximilian Eric Alexander Rupplin von Keffikon - MEARVK - MEARVK LLC

Owner of Establishment of Corporate ongoing Finance - US United States a Minister

Owner of Miramax Films UK & US United States and Settlement - NO GODZILLA

![Profile views](https://views.igorkowalczyk.dev/api/badge/@mearvk?style=flat)

---

# Ubuntu Determinant Alpha RS

A custom Linux kernel (5.15.204) with extensions for extended port addressing, heuristic security monitoring, graded privilege systems, extended permission classes, USB dynamic RAM expansion, immutable filesystem branding, terminal chat, cron callbacks, and per-user kernel objects.

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
13. [Certificates](#certificates)

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

## Certificates

Three permanent certificates embedded in all distributions (unaltered):

1. **ICC Certificate of Pure and Excellent Method** — Methods are original, thorough, systematic. Backed by source code as evidence.
2. **Certificate of Ethical Clear** — System does not deceive, surveil, or obstruct. Transparent and honest.
3. **Brand of National Heritage** — USA national heritage, global competence and science. The software is dumbenent to its designer (owes its work to its careful author). Remainder to core principles: function, clarity, trust, service.

Located at: `CERTIFICATES`

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

## Copyright

Copyright (C) 2026 MEARVK LLC
Author: Maximilian Eric Alexander Rupplin von Keffikon
