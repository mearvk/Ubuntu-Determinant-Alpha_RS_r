# Filesystem Layout — Ubuntu Determinant Alpha RS

*Copyright (C) 2026 MEARVK LLC*
*Author: Maximilian Eric Alexander Rupplin von Keffikon*

---

## Overview

This OS maintains three parallel user-space hierarchies:

| Path   | Purpose |
|--------|---------|
| `/usr` | What the machine considers on behalf of the user — system-managed, machine-curated |
| `/user`| Directly for the user, by the user, for the future user — binaries, libraries, structs, organizations for building things |
| `/deck`| Professional-grade system software — databases, IDEs, creative tools, audio, security, scanning, heuristics, network-aware programs |

All three exist at the root level. `/usr` retains its standard Linux meaning. `/user` and `/deck` are new.

> **Kernel-level redundancy is a separate concern.** This document describes the
> user-space *layout*. The N-way redundant file table with wear/pressure/health
> (Tables 1/2/3), and the kernel-call handles through which its reads and writes
> are serviced, live in the **TAC3** filesystem module — see
> [`markdown/TAC3.md`](TAC3.md) and `fs/tac3/` in the kernel tree.

---

## /usr — Machine on Behalf of the User

Software in `/usr` is what **the machine considers on behalf of the user**. These are programs the system runs, manages, and maintains so that the user's environment functions. The user does not directly curate `/usr` — the machine does, through the package system. The machine installs, updates, and removes `/usr` contents to serve the user's needs without requiring the user's direct involvement.

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
- The machine decides what lives here — the user benefits passively

---

## /user — Directly for the User, by the User, for the Future User

Software in `/user` exists **on direct behalf of the user**. These are binaries, libraries, structs, and organizations that the user actively chose, built, or curated. `/user` is where you build things for the future — for the future version of yourself, for the next project, for what comes next.

This is not the machine acting on your behalf. This is **you** acting on your behalf.

```
/user/
├── bin/          User-installed executables (personal tools, scripts)
├── lib/          User libraries (custom .so/.a, JDesk extensions)
├── share/        User-shared data (custom themes, documentation, assets)
├── include/      User headers (for personal development projects)
├── local/        User's locally compiled software
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
- Binaries, libraries, structs, organizations — all for building the future

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
