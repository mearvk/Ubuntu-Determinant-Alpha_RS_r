# TAC3 — Tripartite Addressable Cache (3-Table Edition)

*Copyright (C) 2026 MEARVK LLC*
*Author: Maximilian Eric Alexander Rupplin von Keffikon*

---

## What TAC3 is

**TAC3** is a kernel filesystem module for the Ubuntu Determinant / White Edition
tree. It is an **N-way redundant filesystem** whose reads and writes are
serviced **only** through its own kernel-call handles — its VFS operation
tables. Once the module registers the filesystem, every standard
`read()` / `write()` / `mmap()` / `fsync()` that lands on a TAC3 mount is
dispatched through TAC3's own handles, and every serviced I/O feeds a
wear / pressure / health engine.

There is no side channel: the standard VFS entry points *are* the new handles.

Source: `kernels/linux-5.15.204/linux-5.15.204/fs/tac3/`
(`tac3.h`, `tac3.c`, `Kconfig`, `Makefile`). Config symbol: `CONFIG_TAC3`.
Module name: `tac3`. TAC3 is the rebrand of the earlier `ntuple` module.

---

## The three tables

TAC3 keeps three coordinated tables over an N-layer ("multitude") redundant
file table. The default multitude is **10** ("10 of file redundancy"); common
configured values are **1, 3, 5, 10** (any value in `[1, 16]` is accepted).

| Table | Name    | Holds |
|-------|---------|-------|
| **1** | `FILE`   | File entries replicated across the N layers (`struct tac3_file_entry`): logical inode id, size, which layers hold a good copy (`layer_mask`), the current authoritative layer, and a per-layer `present[]` validity map. |
| **2** | `HEALTH` | Per-layer and per-region read / write / pressure / wear plus derived disk health (`struct tac3_layer_health`, `struct tac3_region_wear`). This is the "secondary table about the first table" at the configured 3×/5×/10× multitude. |
| **3** | `ADMIN`  | Administrative / state properties (`struct tac3_admin_state`): objective facts plus opaque operator-supplied reference values. |

---

## Quality, pressure and wear

Reads and writes are the events that move the health model.

- **QUALITY** (0–1000 ‰): how well an observed read met the backing device's
  throughput spec. TAC3 times each transfer, converts bytes ÷ nanoseconds into
  an observed MB/s, and scales it against the device-class ceiling
  (`quality = min(1000, observed × 1000 ÷ ceiling)`).
- **PRESSURE** (0–1000 ‰): the instantaneous load appealed to the device. It
  rises with a region's accumulated **read-heat** — re-reading the same area
  raises its heat, so heavily read areas show more pressure (this is the
  recorded "wear" from repeated reads).
- **Jarring access**: a single transfer spanning many pages at once is treated
  as heavy / abrupt. A jarring event records **extra impact spread across all N
  layers**, not just the one that serviced the request.

Each layer's `disk_health` starts at 1000 and decays with write-wear, jarring
events and IO errors. `disk_health` maps to a health color (below).

### Device-class speed ceilings

The ceiling used to scale quality mirrors the project's `pcopy` device model:

| Class | Ceiling (MB/s) |
|-------|----------------|
| IDE HDD | 80 |
| SATA HDD | 150 |
| SAS HDD | 200 |
| SATA SSD | 550 |
| NVMe Gen3 | 3500 |
| NVMe Gen4 | 7000 |
| NVMe Gen5 | 14000 |
| USB2 | 35 |
| USB3 | 400 |
| USB4 | 3000 |

---

## Health color model

TAC3 uses the project's **green / white / yellow** model (from
`aptitude/health/`) — there is **no red-alarm** state:

| State | Meaning |
|-------|---------|
| `GREEN`  | healthy / verified (`disk_health ≥ 850`, no errors) |
| `WHITE`  | informational / normal (`600 ≤ disk_health < 850`) |
| `YELLOW` | attention recommended — not failure (`disk_health < 600` or any error) |

File-table health is the minimum layer health across the N layers.

---

## The new kernel-call handles (VFS surface)

TAC3 publishes the following operation tables. These are the sole entry points
for I/O on a TAC3 file; the module wires them onto every inode it creates.

| Table | Symbol | Key members |
|-------|--------|-------------|
| `file_operations` (regular) | `tac3_file_operations` | `read_iter`, `write_iter`, `mmap`, `open`, `release`, `fsync`, `llseek`, `splice_read`, `splice_write` |
| `file_operations` (dir) | `tac3_dir_operations` | `iterate_shared`, `read`, `llseek`, `fsync` |
| `inode_operations` (file) | `tac3_file_inode_operations` | `setattr`, `getattr` |
| `inode_operations` (dir) | `tac3_dir_inode_operations` | `create`, `lookup`, `link`, `unlink`, `symlink`, `mkdir`, `rmdir`, `mknod`, `rename`, `setattr`, `getattr` |
| `address_space_operations` | `tac3_aops` | `readpage`, `write_begin`, `write_end`, `set_page_dirty` |
| `super_operations` | `tac3_super_operations` | `alloc_inode`, `free_inode`, `statfs`, `drop_inode`, `show_options`, `put_super` |
| `file_system_type` | `tac3_fs_type` | registered via `register_filesystem()` at module init |

**Routing.** `tac3_read_iter` and `tac3_write_iter` are thin wrappers: they
drive the generic page-cache movers (`generic_file_read_iter` /
`generic_file_write_iter`), then feed the result into `tac3_record_access()`
with the derived `(layer, region)`, the observed throughput (reads), and a
jarring flag. Because the wrappers *are* the `read_iter`/`write_iter` handles,
no read or write can bypass the health accounting.

Data lives in the page cache with no device writeback (a memory-backed
instance, mirroring `ramfs`' `ram_aops`); `tac3_aops` owns page movement.

---

## Mounting and runtime knobs

```sh
# Mount with 10-way redundancy (default) on an NVMe Gen4 backing profile:
mount -t tac3 -o multitude=10,device_class=6 none /mnt/tac3

# Common alternatives: multitude=1, 3, 5, 10  (range 1..16)
```

Observability and control:

| Interface | Purpose |
|-----------|---------|
| `/proc/tac3/status` | brand, redundancy, device ceiling, file-table + monitor health |
| `/proc/tac3/health` | per-layer Table 2: reads, writes, read-heat, write-wear, jarring, avg quality ‰, avg pressure ‰, health ‰ |
| `/proc/tac3/admin`  | Table 3 admin facts + opaque operator reference slots |
| `/dev/tac3` (ioctl) | `TAC3_IOC_{SET,GET}_CONFIG` (multitude, device class) and `TAC3_IOC_{SET,GET}_ADMIN` (Table 3) — ioctl magic `'T'` |

---

## Table 3 and the ethics boundary

Table 3 records **administrative facts** — a technical/asset id, the monitor's
own health, the configured multitude, file-table health, a schema revision,
creation/update timestamps, and an operational-permit bitmask.

It also carries **eight opaque operator-supplied reference slots**
(`operator_ref[8]` with operator-chosen `operator_ref_label[8]`). These are
stored **verbatim** exactly as an operator sets them and carry **no
kernel-assigned meaning**.

**The kernel does not compute, infer, or judge any person's intelligence,
worth, feelings, learning, friendships, or standing.** This boundary is
deliberate. It reflects the repository's stated ethic that a mechanism *proves
a measurement; it does not decide a person's worth.* The opaque slots exist so
an operator can attach their own external references to an instance's state
record without the kernel assigning any interpretation to them.

---

## Build / test caveat

The module targets Linux **5.15.204** and its VFS surface was written against
the exact APIs in this tree (`fs/ramfs`, `fs/libfs.c`'s `ram_aops`). It has
**not been compile-tested here** — this environment has no kernel build tree.
Building `CONFIG_TAC3=m` inside the full kernel source is the verification step.

---

*See also: `markdown/FILESYSTEM.md` (the `/usr` `/user` `/deck` user-space
layout — a separate concern from TAC3's kernel-level redundancy).*
