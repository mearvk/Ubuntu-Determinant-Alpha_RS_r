# GNOME Source Sectional Build and Completeness Report

**Project:** Ubuntu Determinant Beta Restricted / Ubuntu White Edition
**Tree:** `main/gnome-source`
**Purpose:** Per-module inventory, source completeness audit, acquisition/build descriptor, and integration status.

## 1. Audit rule

A module is considered **SOURCE-COMPLETE** only when the repository contains the actual upstream source tree, not merely a README, pull script, archive, placeholder, or empty directory. The source tree must expose its normal project identity and a build entry point appropriate to the project (for example `meson.build`, `configure.ac`/`autogen.sh`, or an equivalent build definition).

`README.md`, `pull-source.sh`, checksum files, and source archives are acquisition metadata; they are not substitutes for the extracted source tree.

The pull scripts are intended to be executed by the ISO/build environment. This GitHub-side audit verifies what was committed to the repository. It does **not** claim that a remote shell execution occurred when it did not.

## 2. Status vocabulary

- **SOURCE-COMPLETE** — source tree is present and recognizable as the upstream project; build entry point is present or has been directly observed.
- **SOURCE-PRESENT / NORMALIZATION REQUIRED** — substantial source is present, but it is outside the canonical `upstream/` layout, has an unexpected name/version, or requires normalization before the module is considered complete.
- **SOURCE-MISSING** — only acquisition metadata or an empty/placeholder directory is present.
- **SOURCE-REVIEW** — source presence is established, but the available API listing was insufficient to inspect all build-critical files.
- **NOT AUDITED** — directory exists but has not yet been sufficiently inspected.

## 3. Module matrix

| Module | Role | Expected build system | Repository source state | Status |
|---|---|---|---|---|
| Cairo | 2D graphics/rendering library | Meson | `upstream/` contains substantial upstream Cairo source; project files including `INSTALL`, `NEWS`, `COPYING` and CI metadata are present | **SOURCE-COMPLETE** |
| GDK-Pixbuf | Image loading/pixbuf infrastructure for GTK | Meson | Module directory exists; detailed upstream build-tree inspection still required | **SOURCE-REVIEW** |
| GLib | Core GNOME/GLib runtime, GObject, GIO | Meson | Full upstream-style project tree is present, including development metadata and CI/build files | **SOURCE-COMPLETE** |
| glib-networking | GIO networking/TLS implementations | Meson | Source exists under `glib-networking-2.90.alpha/`, including `meson.build`, `meson_options.txt`, `COPYING`, `NEWS`, and project files; it is not in the canonical `upstream/` location and is an alpha-named tree | **SOURCE-PRESENT / NORMALIZATION REQUIRED** |
| GNOME Control Center | GNOME Settings application | Meson | `upstream/gnome-control-center-50.3/` is a substantial source tree with `README.md`, `COPYING`, CI/build support and source directories | **SOURCE-COMPLETE** |
| GNOME Shell | GNOME desktop shell | Meson | Module directory exists; complete build-tree inspection required | **SOURCE-REVIEW** |
| GNOME Software | Graphical software/app management | Meson | `upstream/gnome-software-50.3/` is present with source boundary and checksum metadata | **SOURCE-REVIEW** |
| GNOME Terminal | GNOME terminal application | Meson | `gnome-terminal-3.60.0.tar.xz` and extracted `gnome-terminal-3.60.0/` are present; source extraction is therefore materially present outside the canonical `upstream/` convention | **SOURCE-PRESENT / NORMALIZATION REQUIRED** |
| GTK | UI toolkit | Meson | Module directory exists; complete build-tree inspection required | **SOURCE-REVIEW** |
| GVfs | Virtual filesystem/GIO backends | Autotools in the committed 1.9.5 tree | Full-looking `gvfs-1.9.5/` tree is present with `Makefile.am`, `Makefile.in`, `INSTALL`, `NEWS`, `COPYING` and project files; version is substantially older than the intended GNOME generation | **SOURCE-PRESENT / NORMALIZATION REQUIRED** |
| Mutter | GNOME compositor/window manager | Meson | Module directory exists; complete build-tree inspection required | **SOURCE-REVIEW** |
| Orca | GNOME accessibility/screen reader | Python/meson packaging | Module directory exists but its `upstream/` source tree was not exposed by the repository API audit | **SOURCE-MISSING / RECHECK** |
| Vala | GNOME/GLib programming language/compiler | Autotools/Meson-era upstream tooling | `upstream/vala` is currently a zero-length repository file rather than an extracted Vala source tree | **SOURCE-MISSING** |
| Gala | Elementary OS compositor/window manager | Meson | Module directory exists; it is a separate project from GNOME Mutter | **SOURCE-REVIEW** |

## 4. Detailed module sections

### 4.1 Cairo

**Function:** 2D vector graphics and rendering library used beneath GTK/GNOME rendering paths.

**Source boundary:** `gnome-source/cairo/upstream/`

**Observed evidence:** The repository contains a substantial upstream tree. Files such as `AUTHORS`, `BUGS`, `CODING_STYLE`, `COPYING`, `INSTALL`, `NEWS`, and CI metadata are present. This is consistent with a real Cairo checkout rather than a placeholder. 

**Determinant integration:** Keep pristine Cairo under `upstream/`. Theme, rendering, and Ubuntu White Edition changes belong in an offset/patch layer.

**Status:** **SOURCE-COMPLETE**.

### 4.2 GDK-Pixbuf

**Function:** GTK image/pixbuf loading and image-format infrastructure.

**Integration relevance:** This is one of the important locations for desktop icon/image loading. It should remain compatible with PNG/JPEG assets used by the Ubuntu White Edition icon system.

**Status:** **SOURCE-REVIEW** pending direct inspection of the extracted source root and build entry point.

### 4.3 GLib

**Function:** Core GNOME platform library, including GObject, utility APIs, GIO and filesystem/network abstractions.

**Integration relevance:** GLib/GIO is a major candidate for the higher-level implementation of the Determinant extended path notation (`...` and `....`). Linux kernel `..` semantics remain unchanged.

**Observed evidence:** The committed tree contains upstream development/configuration material, including `.clang-format`, `.editorconfig`, `.gitlab-ci.yml`, `.gitmodules`, licensing and contribution files. 

**Status:** **SOURCE-COMPLETE** for repository-source purposes; runtime build should still be performed by the ISO build environment.

### 4.4 glib-networking

**Function:** GIO networking implementations, including TLS/networking integration.

**Observed source:** `gnome-source/glib-networking/glib-networking-2.90.alpha/` contains a recognizable upstream tree and a `meson.build` plus `meson_options.txt`.

**Problem:** The acquisition script describes a pristine `upstream/` destination, but the repository currently has an alpha-named source directory at the module root. This needs to be normalized so the source boundary is unambiguous.

**Status:** **SOURCE-PRESENT / NORMALIZATION REQUIRED**.

### 4.5 GNOME Control Center

**Function:** GNOME Settings/control-center application.

**Observed source:** `upstream/gnome-control-center-50.3/` contains actual project material, including `.clang-format`, CI configuration, `COPYING`, `NEWS`, `README.md`, `build-aux`, and `data` directories.

**Integration relevance:** White Edition system settings, theme controls, desktop behavior, and user-facing configuration can be integrated here without changing the underlying kernel filesystem semantics.

**Status:** **SOURCE-COMPLETE**.

### 4.6 GNOME Shell

**Function:** Desktop shell: overview, panels, launchers, shell UI and GNOME session integration.

**Integration relevance:** Primary candidate for White Edition shell styling and desktop-level icon/theme presentation.

**Status:** **SOURCE-REVIEW** until the extracted source root and build entry point are directly enumerated.

### 4.7 GNOME Software

**Function:** Graphical application/software management frontend.

**Observed source:** `upstream/gnome-software-50.3/` exists with `SOURCE-INFO.txt`, a checksum file, and a versioned source directory.

**Integration relevance:** White Edition branding and repository/application presentation can be layered here while retaining upstream source separately.

**Status:** **SOURCE-REVIEW** pending direct inspection of the versioned directory's build files.

### 4.8 GNOME Terminal

**Function:** GNOME terminal emulator.

**Observed source:** The repository contains both `gnome-terminal-3.60.0.tar.xz` and an extracted `gnome-terminal-3.60.0/` directory.

**Problem:** The source is not currently normalized beneath `upstream/` like Cairo and the other source boundaries. The archive and extracted source are evidence of real source acquisition, but the ISO source contract should use one canonical source root.

**Status:** **SOURCE-PRESENT / NORMALIZATION REQUIRED**.

### 4.9 GTK

**Function:** Primary GNOME UI toolkit and widget/rendering layer.

**Integration relevance:** One of the most important modules for Ubuntu White Edition's visual theme, widget colors, controls, typography, and image presentation.

**Status:** **SOURCE-REVIEW** until the complete extracted source root is enumerated.

### 4.10 GVfs

**Function:** GIO virtual filesystem services and filesystem backends.

**Observed source:** `gvfs-1.9.5/` contains `Makefile.am`, `Makefile.in`, `INSTALL`, `NEWS`, `COPYING`, `README`, and other upstream files. This is actual source, not an empty directory.

**Problem:** Version 1.9.5 is an old generation relative to the rest of the GNOME source set. It should not silently become the production GVfs version for a GNOME 50-based desktop.

**Status:** **SOURCE-PRESENT / NORMALIZATION REQUIRED**. The source should be deliberately upgraded/pinned to the target GNOME generation and placed under the canonical `upstream/` boundary.

### 4.11 Mutter

**Function:** GNOME compositor and window manager; responsible for the core display/compositing/window-management path in a GNOME desktop.

**Integration relevance:** Critical to the actual GNOME desktop rendering/compositing experience. This is distinct from the quick-preview `isolation-desktop` renderer.

**Status:** **SOURCE-REVIEW** pending direct enumeration of the extracted source tree.

### 4.12 Orca

**Function:** GNOME accessibility screen reader.

**Integration relevance:** Accessibility integration for the White Edition desktop.

**Observed repository state:** The expected module directory and acquisition files have existed, but the audit did not find an exposed `upstream/` source directory through the repository API. The module must therefore be repulled or its actual extracted source location identified.

**Status:** **SOURCE-MISSING / RECHECK**.

### 4.13 Vala

**Function:** Vala compiler and language tooling used by GNOME/GLib projects.

**Observed repository state:** `gnome-source/vala/upstream/vala` is a zero-length file. It is not a source checkout.

**Consequence:** The Vala pull script has not resulted in a repository-contained Vala source tree in the current Git state.

**Status:** **SOURCE-MISSING**.

### 4.14 Gala

**Function:** Elementary OS compositor/window manager.

**Important distinction:** Gala is not GNOME Mutter. It is retained as a separately identifiable optional component and must not be represented as the GNOME compositor.

**Status:** **SOURCE-REVIEW**.

## 5. Desktop integration map

```text
Ubuntu White Edition
        │
        ├── GNOME Shell ───────── Desktop shell / shell UI
        │       │
        │       └── Mutter ────── compositor / window manager
        │
        ├── GTK / GDK-Pixbuf ──── widgets / images / visual theme
        │
        ├── GLib / GIO ────────── filesystem & application APIs
        │       │
        │       ├── GVfs ──────── virtual filesystem backends
        │       └── glib-networking
        │
        ├── Cairo ─────────────── 2D rendering
        │
        ├── GNOME Control Center ─ system settings
        ├── GNOME Software ────── application management
        ├── GNOME Terminal ────── terminal application
        ├── Orca ──────────────── accessibility
        └── Vala ──────────────── GNOME/GLib development toolchain

Optional alternative:
        Gala ─────────────────── separate compositor/window-manager project
```

## 6. Determinant path extension

The Linux kernel's ordinary `..` semantics remain unchanged.

The planned higher-level path policy is:

```text
..      one parent directory
...     two parent directories
....    three parent directories
```

This belongs above the kernel VFS path resolver, with GLib/GIO and the desktop file manager being the appropriate integration points. It should not be implemented by changing the kernel's meaning of `..`.

## 7. White Edition visual integration

The desktop icon and rendering work should follow this separation:

1. Preserve upstream GNOME source.
2. Keep Ubuntu White Edition assets outside pristine source.
3. Integrate PNG/JPEG desktop icon assets through the appropriate GTK/GDK-Pixbuf/GNOME Shell theme/resource paths.
4. Keep rendering changes layered so upstream updates can be rebased.
5. Keep MATE available as a selectable desktop option where the ISO build permits it.
6. Keep `isolation-desktop` classified as a preview/renderer and not as the production desktop implementation.

## 8. Build-readiness conclusion

The audit found several genuine upstream source trees, but **the GNOME source collection is not yet uniformly normalized**. In particular:

- Cairo and GLib have strong source-tree evidence.
- GNOME Control Center has a complete-looking versioned source tree.
- glib-networking has real source but is in an unexpected alpha-named location.
- GNOME Terminal has a real archive and extracted source but needs canonical placement.
- GVfs has real source but is pinned to an old 1.9.5 generation and needs a deliberate version decision.
- Vala currently does **not** contain the actual Vala source tree.
- Orca requires a source-tree recheck.
- Several remaining modules require direct enumeration before being marked SOURCE-COMPLETE.

Therefore the repository should **not yet label the entire GNOME source set as complete**. The next build-maintenance pass should normalize the source boundaries, repull missing modules, and perform actual compile/configure tests in the ISO build environment.

## 9. Required completion gate

Before the GNOME option is declared production-ready, the build should require all selected modules to satisfy:

```text
[ ] source tree exists
[ ] source root is canonical
[ ] expected build definition exists
[ ] version/ref is recorded
[ ] checksum or commit is recorded
[ ] dependencies are declared
[ ] source configures successfully
[ ] source compiles successfully
[ ] install/staging succeeds
[ ] ISO packaging includes the resulting component
[ ] White Edition theme/assets apply successfully
[ ] original upstream source remains recoverable
```

**Report status:** repository source audit completed to the extent exposed by the GitHub source tree; runtime execution of every pull/build script remains a build-host operation and is intentionally not represented as having occurred here.
