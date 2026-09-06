# DESCRIPTOR — `ubuntu.slaves.black/`

**Project:** Ubuntu Determinant
**Edition:** Ubuntu White Edition
**Project attention:** Max Rupplin — MEARVK LLC — 2026
**Section:** `ubuntu.slaves.black`
**Purpose:** Machine- and human-readable descriptor of this directory's contents and structure

---

## 1. What this directory is

`ubuntu.slaves.black/` is the **Ubuntu 22.04.3 LTS (Jammy) source foundation** for
the distribution: a complete source-package archive (~19 GB, ~2,500 packages)
stored in a Git-compatible way by splitting the four official source ISOs into
20–21 MB chunks, plus the tooling to reassemble ISOs, extract packages, and fetch
selectively. It exists primarily for **GPL source-availability compliance** and as
the package base for White Edition integration. See `README.md` for the full
manual.

## 2. Top-level contents

### Documents (`.md`)

| File | Description |
|---|---|
| `README.md` | Primary manual: archive layout, disc contents, reassemble→extract workflow, sparse-checkout grades, storage guidance, licensing. |
| `PROGRAMS-A-Z.md` | A–Z catalogue of the 26 planned userland programs (role, GUI direction, development status) + design rules. |
| `PROGRAMS-RANKED.md` | The 26 programs with relative ranks (1–26) and tiers; ranking method documented. Companion to `PROGRAMS-A-Z.md`. |
| `WHITE-EDITION-INTEGRATION.md` | White Edition package-integration program: ordered stages, Priority Rings A–E, promotion record, foundation queue. |
| `WHITE-EDITION-RING-A-MATRIX.md` | Ring A (System Trust) foundation-package matrix: grades (W0–W3), review order, change record. |
| `DESCRIPTOR.md` | This file — descriptor of the directory. |

### Inventory / status files

| File | Description |
|---|---|
| `manifest.txt` | Full extracted-package inventory. Format: `disc/package_name  compressed_size_MB  status` (~2,500 entries). |
| `skipped.txt` | Packages over the 50 MB extraction threshold (available from full ISOs only). |

### Scripts (`.sh`)

| File | Description |
|---|---|
| `reassemble-source-all.sh` | Rebuild all four disc ISOs from their split chunks. |
| `reassemble-source-iso-1.sh` | Rebuild disc 1 ISO from chunks. |
| `reassemble-source-iso-2.sh` | Rebuild disc 2 ISO from chunks. |
| `reassemble-source-iso-3.sh` | Rebuild disc 3 ISO from chunks. |
| `reassemble-source-iso-4.sh` | Rebuild disc 4 ISO from chunks. |
| `extract-source-packages.sh` | Extract individual source packages from reassembled ISOs (`--all` or `--package <name>`). |
| `extract-small-packages.sh` | Extract only packages ≤ 50 MB. |
| `check-compiled-artifacts.sh` | Audit for oversized/compiled artifacts that should not be committed. |
| `delete-full-isos.sh` | Remove reassembled ISOs while keeping the chunks (rebuildable). |
| `sparse-checkout.sh` | Selective fetch by disc + grade (1 Essential / 2 Standard / 3 Complete). |

### Subdirectories

| Directory | Description |
|---|---|
| `1/` | Disc 1 — 221 chunks (~4.5 GB), 683 extracted packages. Core system (glibc, gcc, binutils, bash, dpkg, apt, systemd, grub2, python, ruby, fonts, gtk, gnome, kernel tools). |
| `2/` | Disc 2 — 221 chunks (~4.6 GB), 1496 packages. Libraries & languages (boost, cairo, icu, mesa, qt, kde, java, perl, language packs). |
| `3/` | Disc 3 — 62 chunks (~1.3 GB), 162 packages. Runtime & desktop (perl, python, pipewire, qt5, protobuf, openexr, openjfx, openmpi). |
| `4/` | Disc 4 — 71 chunks (~1.4 GB), 221 packages. System services (openssl, openssh, neutron, nova, horizon, linux-meta, nvidia-settings, X11 libs). |
| `5/` | Reserved (placeholder; marker file). |
| `jars/` | Java connector packages (e.g. `mysql-connector-j`). |
| `white-edition/` | White Edition work area; `white-edition/packages/` holds per-package integration dirs (16 Ring-A foundation packages: apparmor, apt, audit, base-files, base-passwd, bash, ca-certificates, coreutils, cryptsetup, dbus, dpkg, glibc, grub2, linux-kernel, openssl, systemd). |

## 3. Disc summary

| Disc | Chunks | Size | Packages | Primary contents |
|---|---|---|---|---|
| 1 | 221 | ~4.5 GB | 683 | Core system |
| 2 | 221 | ~4.6 GB | 1496 | Libraries & languages |
| 3 | 62 | ~1.3 GB | 162 | Runtime & desktop |
| 4 | 71 | ~1.4 GB | 221 | System services |
| 5 | — | — | — | Reserved |

## 4. Conventions

- **Chunk naming:** `ubuntu_<disc>_<suffix>` (e.g. `ubuntu_1_aa … _im`); each chunk ≤ 21 MB for Git compatibility.
- **Extraction threshold:** 50 MB; larger packages are listed in `skipped.txt`, not extracted.
- **Sparse-checkout grades:** 1 = Essential (~33%), 2 = Standard (~66%), 3 = Complete (100%).
- **White Edition grades:** W0–W3 / HOLD (see the two `WHITE-EDITION-*` docs).

## 5. Notes

Source packages retain their upstream licenses (mostly GPL-2.0, LGPL-2.1, MIT,
BSD, Apache-2.0). Archive assembly and tooling © 2026 MEARVK LLC; Ubuntu source
packages © their respective authors (Canonical Ltd, upstream maintainers). This
descriptor reflects the directory's top-level contents at time of writing; if
files are added or removed, update this file to match.

---

**Stewardship:** Max Rupplin — MEARVK LLC · `mearvk/Ubuntu.Determinant.Beta.Restricted` · `ubuntu.slaves.black`.
