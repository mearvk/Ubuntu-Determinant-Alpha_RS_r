# ✦ THE ROYAL PROGRAMME — RANKED ✦

## All Programs and Their Relative Ranks

**Max Rupplin — MEARVK LLC**
**Repository:** `Ubuntu.Determinant.Beta.Restricted`
**Reference:** `ubuntu.slaves.black`
**Status:** Ranking reference (derived from the A–Z catalogue)
**Companion:** [`PROGRAMS-A-Z.md`](PROGRAMS-A-Z.md)

---

## 0. What "rank" means here

This document lists all 26 programs in the A–Z userland programme with a
**relative rank**. Rank is a *development-and-priority ordering*, not a claim of
quality, worth, or completeness. It is derived transparently from signals already
present in the project's own documents — no rank is invented arbitrarily.

**Ranking method (scored, then ordered).** Each program is scored on:

1. **Development status** (from `PROGRAMS-A-Z.md`): In development = 3, Planned = 1
   (Existing = 4, Reference = 0.5, Retired = 0 — none currently in those states).
2. **Foundational weight** (README "foundational vs optional"; the House-as-computer
   and security emphasis): core system/security/recovery facility = 2; general
   household tool = 1; convenience/efficiency tool = 0.
3. **Systemic reach** ("relative size of meaning" — how much other software depends
   on it): high = 1, medium = 0.5, low = 0.

`Rank score = status + foundational + reach` (higher = higher rank). Ties are
broken by foundational weight, then alphabetical order. Tiers group the scores:
**Tier I** (core, ≥5), **Tier II** (important, 3–4.5), **Tier III** (supporting, ≤2.5).

Ranks are provisional and should move as programs are actually implemented; a
proposal is not an implementation.

## 1. Ranked programme (highest rank first)

| Rank | Program | Letter | Tier | Status | Score | Why it ranks here |
|---:|---|:---:|:---:|---|---:|---|
| 1 | **Security** | S | I | In development | 6.0 | Security posture/policy — foundational and system-wide. |
| 2 | **Installer** | I | I | In development | 6.0 | Install/repair/configure/remove — gateway for everything else. |
| 3 | **Java** | J | I | In development | 5.5 | JDK/runtime administration; SecureJDK/Graal is a project pillar. |
| 4 | **Recovery** | R | I | Planned | 5.0 | Repair/rollback/recovery — core safety facility. |
| 5 | **Updates** | U | I | Planned | 5.0 | Software/definition/config updates — integrity over time. |
| 6 | **Packages** | P | I | Planned | 5.0 | Package inspection/management — foundation of the userland. |
| 7 | **Monitor** | M | II | Planned | 4.5 | Processes/resources/services — the observability surface. |
| 8 | **Keys** | K | II | Planned | 4.5 | Key/certificate administration — security-adjacent, broad reach. |
| 9 | **Network** | N | II | Planned | 4.0 | Network config/diagnostics — broad dependency. |
| 10 | **Telnet** | T | II | In development | 4.0 | Service-protocol admin / controlled access (active work). |
| 11 | **Backup** | B | II | Planned | 4.0 | Local/scheduled backup — household safety. |
| 12 | **Console** | C | II | Planned | 3.5 | Friendly command/system console — cross-cutting entry point. |
| 13 | **Files** | F | II | Planned | 3.5 | Household file browser/transfer — everyday foundation. |
| 14 | **Library** | L | II | Planned | 3.0 | Software/source/doc catalogue — supports discovery. |
| 15 | **Virtualization** | V | II | Planned | 3.0 | VM / isolated workloads — capable but not baseline household. |
| 16 | **Queue** | Q | III | Planned | 2.5 | Jobs / scheduled tasks — supporting service. |
| 17 | **eXchange** | X | III | Planned | 2.5 | Import/export/migration/interop — supporting. |
| 18 | **Web** | W | III | Planned | 2.5 | Local web services / browser-facing admin — supporting. |
| 19 | **Zero** | Z | III | Planned | 2.5 | Reset/cleanup/decommission/secure-state — supporting safety. |
| 20 | **Editor** | E | III | Planned | 2.0 | General text/source/config editing — useful household tool. |
| 21 | **Documents** | D | III | Planned | 2.0 | Local document creation/indexing — household tool. |
| 22 | **Archive** | A | III | Planned | 2.0 | Household/project archive management — household tool. |
| 23 | **Office** | O | III | Planned | 2.0 | Productivity suite entry point — household convenience. |
| 24 | **Graphics** | G | III | Planned | 1.5 | Images/diagrams/simple assets — convenience. |
| 25 | **Health** | H | III | Planned | 1.5 | System health/diagnostics dashboard — convenience/observability. |
| 26 | **Yield** | Y | III | Planned | 1.0 | Resource/storage/workload efficiency — optional efficiency tool. |

## 2. By letter (A–Z) with assigned rank

| Letter | Program | Rank | Tier | Status |
|:---:|---|---:|:---:|---|
| A | Archive | 22 | III | Planned |
| B | Backup | 11 | II | Planned |
| C | Console | 12 | II | Planned |
| D | Documents | 21 | III | Planned |
| E | Editor | 20 | III | Planned |
| F | Files | 13 | II | Planned |
| G | Graphics | 24 | III | Planned |
| H | Health | 25 | III | Planned |
| I | Installer | 2 | I | In development |
| J | Java | 3 | I | In development |
| K | Keys | 8 | II | Planned |
| L | Library | 14 | II | Planned |
| M | Monitor | 7 | II | Planned |
| N | Network | 9 | II | Planned |
| O | Office | 23 | III | Planned |
| P | Packages | 6 | I | Planned |
| Q | Queue | 16 | III | Planned |
| R | Recovery | 4 | I | Planned |
| S | Security | 1 | I | In development |
| T | Telnet | 10 | II | In development |
| U | Updates | 5 | I | Planned |
| V | Virtualization | 15 | II | Planned |
| W | Web | 18 | III | Planned |
| X | eXchange | 17 | III | Planned |
| Y | Yield | 26 | III | Planned |
| Z | Zero | 19 | III | Planned |

## 3. Tier summary

- **Tier I — Core (highest rank):** Security, Installer, Java, Recovery, Updates, Packages.
  The system's integrity, installation, runtime, and recovery backbone. Three of
  these (Security, Installer, Java) are already *in development*.
- **Tier II — Important:** Monitor, Keys, Network, Telnet, Backup, Console, Files,
  Library, Virtualization. Broad-reach services and everyday household foundations.
- **Tier III — Supporting/convenience:** Queue, eXchange, Web, Zero, Editor,
  Documents, Archive, Office, Graphics, Health, Yield.

## 4. Honesty note

These ranks are a **planning/priority ordering** derived from the A–Z catalogue's
own status field and the README's foundational / "size of meaning" framing. They
are not a measure of program quality, and they carry no claim that any program is
complete or production-ready. Re-rank as real implementation status changes;
`PROGRAMS-A-Z.md` remains the source of truth for each program's description and
development state.

---

**Stewardship:** Max Rupplin — MEARVK LLC.
**Repository:** `mearvk/Ubuntu.Determinant.Beta.Restricted` · **Section:** `ubuntu.slaves.black`.
