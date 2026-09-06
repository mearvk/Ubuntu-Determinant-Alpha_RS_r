# file-systems

Repository-level copies of the custom filesystems developed for the Ubuntu
White Edition kernel, gathered here for convenient reference and review.

## Contents

```text
file-systems/
└── tac3/            TAC3 — n-tuple redundant File System
    ├── tac3.h       TAC1/TAC2/TAC3 structs, wear/pressure model, constants
    ├── tac3.c       VFS filesystem + wear/pressure/health tables
    ├── Kconfig      config TAC3
    └── Makefile     obj-$(CONFIG_TAC3) += tac3.o
```

## TAC3 in brief

TAC3 maintains three coordinated tables over a block device:

- **Table 1 — Primary File Table:** canonical per-file/extent metadata.
- **Table 2 — Redundancy / Integrity:** an N-way, per-region, per-layer
  wear/health mirror (default 10× redundancy) so damage is evident and
  recoverable.
- **Table 3 — Admin / State:** device/media/administrative facts only
  (tech id, monitor health, table health, permits, timestamps) plus opaque
  operator-defined reference slots the kernel assigns **no** meaning to. The
  kernel does not compute or judge any human attribute.

Read/write "touches" accumulate weighted wear per region; clustered or
jarring access compounds recorded impact, and pressure/quality are scaled
against the drive's "touch grace" (media class, rated speed, endurance).

## Authoritative source

These are **copies**. The build-wired, authoritative source lives in the
vendored kernel tree and is what actually compiles:

```text
kernels/linux-5.15.204/linux-5.15.204/fs/tac3/
```

wired into `fs/Kconfig` (`source "fs/tac3/Kconfig"`) and `fs/Makefile`
(`obj-$(CONFIG_TAC3) += tac3/`). Edit the kernel-tree copy for anything that
must build; keep this reference copy in sync when it changes.
