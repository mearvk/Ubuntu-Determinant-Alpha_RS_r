# GNOME Source Reference

This directory contains the GNOME and GNOME-adjacent source components used by Ubuntu.Determinant.Beta.Restricted / Ubuntu White Edition.

## Canonical source layout

Every module uses the same source boundary:

```text
gnome-source/<module>/
├── README.md
├── pull-source.sh
├── source/              # canonical upstream source tree
└── patches/              # optional Determinant offsets/patches
```

**`source/` is the final source directory name.** The older `upstream/` name is transitional only and must not be used as the production source boundary.

If a source acquisition script still produces `upstream/`, run:

```bash
./gnome-source/normalize-source-layout.sh
```

The normalizer safely migrates an acquired `upstream/` tree to `source/` without changing the upstream contents. It is intended for build-host source trees as well as repository-contained trees.

## Source policy

For every imported component, preserve:

- upstream repository or official release URL;
- exact revision, tag, release, or archive checksum;
- import/acquisition metadata;
- applicable license and copyright notices;
- local Determinant modifications as separate patches/offsets;
- a recognizable upstream build entry point.

Do not mix Ubuntu White Edition changes into the pristine `source/` tree unless a deliberate source patch is being maintained there by the build system.

Do not commit generated build artifacts or caches as source.

## Current module set

```text
cairo/
gdk-pixbuf/
glib/
glib-networking/
gnome-control-center/
gnome-shell/
gnome-software/
gnome-terminal/
gtk/
gvfs/
mutter/
orcа/
vala/
gala/
```

`orca/` above is the GNOME accessibility component; its source must still be validated by the module audit. Gala remains separately identified as the elementary OS compositor/window-manager project and is not substituted for Mutter.

## Build principle

The ISO build should consume only:

```text
gnome-source/<module>/source/
```

and apply any Ubuntu White Edition / Determinant customization from a separate patch or offset layer. This makes the source boundary consistent across all GNOME modules and avoids baking the acquisition mechanism (`upstream/`) into the final build contract.

See `SECTIONAL.md` for the per-module source and build audit.
