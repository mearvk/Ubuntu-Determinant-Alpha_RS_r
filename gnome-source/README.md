# GNOME Source Reference

This directory contains the GNOME and GNOME-adjacent source components used by Ubuntu.Determinant.Beta.Restricted / Ubuntu White Edition.

## Canonical source layout

Every module uses the same source boundary:

```text
gnome-source/<module>/
├── README.md
├── pull-source.sh
├── source/               # canonical upstream source tree
└── patches/              # optional Determinant offsets/patches
```

**`source/` is the final source directory name.** The older `upstream/` name is transitional only and must not be used as the production source boundary.

If an older acquisition still leaves an `upstream/` directory, run:

```bash
./gnome-source/normalize-source-layout.sh
```

The normalizer migrates an acquired `upstream/` tree to `source/` without changing the source contents.

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
orca/
vala/
gala/
```

Gala remains separately identified as the elementary OS compositor/window-manager project; it is not a substitute for GNOME Mutter.

## Source policy

For every module, preserve the upstream repository or official release URL, exact revision/tag/release, checksum where applicable, license and copyright notices, and acquisition metadata. Keep Ubuntu White Edition / Determinant changes in a separate patch or offset layer.

The ISO build should consume only:

```text
gnome-source/<module>/source/
```

This gives every module one consistent source boundary regardless of whether the acquisition mechanism uses Git or an official release archive.

See `SECTIONAL.md` for the per-module source and build audit.
