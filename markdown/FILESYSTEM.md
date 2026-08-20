# Filesystem Layout — Ubuntu Determinant Alpha RS

*Copyright (C) 2026 MEARVK LLC*
*Author: Maximilian Eric Alexander Rupplin von Keffikon*

---

## Overview

This OS maintains three parallel user-space hierarchies:

| Path   | Purpose |
|--------|---------|
| `/usr` | System programs and libraries — standard FHS, managed by the package system |
| `/user`| User-facing programs, personal tools, and MEARVK-specific runtime — managed by the owner/operator |
| `/deck`| Professional-grade system software — databases, IDEs, creative tools, audio, security, scanning, heuristics, network-aware programs |

All three exist at the root level. `/usr` retains its standard Linux meaning. `/user` and `/deck` are new.

---

## /usr — System (Standard FHS)

The traditional Unix system directory. Contains:

```
/usr/
├── bin/          System binaries (ls, grep, gcc, etc.)
├── lib/          System shared libraries
├── lib64/        64-bit libraries (symlink or separate on some systems)
├── include/      C/C++ headers for system libraries
├── share/        Architecture-independent data (man pages, icons, locales)
├── local/        Locally compiled software (not from package manager)
│   ├── bin/
│   ├── lib/
│   └── share/
├── sbin/         System administration binaries
└── src/          Kernel source headers (for module builds)
```

Rules:
- Managed by `apt` / `dpkg` (package system)
- NEGAMANE-branded entries are immutable
- Permission class: system-level access required for modification
- Standard FHS semantics apply

---

## /user — Owner/Operator Space

A new top-level directory for user-facing, human-curated, and MEARVK-specific software. Distinct from `/home` (which is per-user data) and `/usr` (which is system-managed packages).

This is where **personal software** lives: GIMP, email clients, games, IDEs, personal MySQL instances, personal email accounts, and anything the owner installs on a personal basis. The system installer and JDesk Software Center route personal installs here by default.

```
/user/
├── bin/          Personal executables (GIMP, Thunderbird, games, IDEs)
├── lib/          Personal libraries and runtime data
│   ├── games/    Game data and engines
│   ├── ide/      IDE installations (IntelliJ, Eclipse, etc.)
│   ├── mysql/    Personal MySQL data directory
│   ├── browser/  Browser profiles and extensions
│   └── python/   Personal Python packages (virtualenvs)
├── share/        Personal shared data
│   ├── accounts/ Email accounts, personal service configs
│   ├── mail/     Local mail storage (personal accounts)
│   ├── icons/    Personal icon themes
│   ├── themes/   Personal desktop themes
│   ├── fonts/    User-installed fonts
│   └── db/       Personal databases (SQLite, etc.)
├── include/      Personal development headers
├── etc/          Personal configuration files
│   ├── mysql/    Personal MySQL config (my.cnf)
│   └── mail/     Personal mail client config
├── local/        Personal locally-compiled software
│   ├── bin/
│   ├── lib/
│   └── share/
```

Rules:
- NOT managed by the package system — manual or JDesk-managed installation
- Not NEGAMANE-branded by default (owner can modify freely)
- Permission class: Trusted or Genius (owner-operator level)
- Intended for software that the system owner chose to install outside the package system
- `/user/bin` is added to PATH after `/usr/local/bin` and before `/usr/bin`

---

## /deck — Professional System Software

The home for professional-grade, system-aware applications. These are programs that operate at a higher tier than basic utilities — they are network-aware, security-conscious, performance-critical, or domain-specialized.

**What belongs in /deck:**

- **Databases** — MySQL, PostgreSQL, and other professional data stores
- **IDEs** — Professional development environments (JDesk IDE, Eclipse, etc.)
- **Creative/Artist tools** — Image editors, vector graphics, 3D modeling, video production
- **Professional audio** — DAWs, audio processing, studio-grade recording tools
- **Security software** — ClamAV, intrusion detection, firewall managers, forensic tools
- **Scanning systems** — Vulnerability scanners, port scanners, compliance checkers
- **Heuristics** — AI/ML inference engines, anomaly detection, behavioral analysis
- **Network-aware programs** — Servers, proxies, protocol analyzers, monitoring dashboards

```
/deck/
├── bin/          Professional application binaries
├── lib/          Shared libraries for /deck applications
├── share/        Data files, configs, documentation for /deck programs
├── include/      Headers (for development against /deck libraries)
├── local/        Locally compiled professional software
│   ├── bin/
│   ├── lib/
│   └── share/
```

Rules:
- Programs here are expected to be system-aware (network, security, resources)
- Higher permission class requirements than `/user` programs
- Dave AI integration expected (telemetry, intelligence hooks, event correlation)
- NEGAMANE-brandable for integrity protection of critical tools
- Arena pool allocation: `/deck` programs may receive dedicated memory arenas
- `/deck/bin` and `/deck/local/bin` are in PATH
- `/deck/lib` and `/deck/local/lib` are in LD_LIBRARY_PATH

---

## Comparison

| Aspect | `/usr` | `/user` | `/deck` |
|--------|--------|---------|---------|
| Managed by | apt/dpkg | Owner (manual / JDesk) | Owner / JDesk / dedicated installers |
| Immutable (NEGAMANE) | Yes (system entries) | No (by default) | Yes (critical tools branded) |
| Permission class | System | Trusted/Genius | Elevated (Trusted minimum) |
| In default PATH | Yes | Yes | Yes |
| Contains kernel tools | Yes | No | No |
| Contains personal tools | No | Yes | No |
| Contains professional tools | No | No | Yes |
| Network-aware programs | Some | No | Yes (primary home) |
| Security software | Some (base) | No | Yes (primary home) |
| Dave AI integration | Minimal | Optional | Expected |
| Survives OS reinstall | No (replaced) | Yes (preserved) | Yes (preserved) |

---

## PATH Order

```bash
/usr/local/bin:/user/local/bin:/user/bin:/deck/local/bin:/deck/bin:/usr/bin:/bin:/usr/sbin:/sbin
```

`/user/bin` and `/deck/bin` sit between `/usr/local/bin` and `/usr/bin`, giving both priority over system packages but not over locally compiled system tools.

---

## Rationale

1. `/home` is per-user private data — not suitable for system-wide user-installed tools
2. `/usr/local` is traditionally for locally compiled system packages — semantically different from "the owner's personal toolkit"
3. `/opt` is for self-contained third-party packages — not a general bin/lib/share hierarchy
4. `/user` fills the gap: a structured hierarchy for the human operator's software, surviving OS upgrades and clearly separated from system management

---

## Future Definitions

`/usr`, `/user`, and `/deck` will be further specified as the system matures. Topics to define:

- [x] `/deck` purpose and semantics — professional system software (databases, IDEs, creative, audio, security, scanning, heuristics, network-aware)
- [ ] Grain-claim propagation: which grain level applies to `/user` and `/deck` executables
- [ ] JDesk integration: app manifests that install into `/user/bin` vs `/deck/bin` vs `/usr/bin`
- [ ] Arena pool allocation: whether `/user` and `/deck` executables get their own arena pool segments
- [ ] NEGAMANE opt-in: allowing owner to brand specific `/user` or `/deck` entries as immutable
- [ ] Backup/restore: `/user` and `/deck` preservation across OS reinstall or upgrade
- [ ] Dave awareness: indexing `/user` and `/deck` contents for system intelligence
- [ ] Permission class enforcement for `/deck` (minimum Trusted)
- [ ] `/deck` package format: how professional software is installed/updated in /deck
- [ ] `/deck` service management: how /deck daemons (MySQL, scanners) integrate with systemd

---

*To be continued.*
