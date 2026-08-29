# Ubuntu.Determinant.Beta.Restricted — Structural and Definition Glossary

`SECULAR.md` is the repository-wide structural glossary for the OS build. It relates the principal READMEs and specification documents to their implementation modules, source trees, build layers, configuration, tools, kernels, userland, Total native moderation, GNOME, White Edition, and ISO construction.

## System reading order

```text
README.md
  ├── markdown/BUILD.md
  ├── kernels/
  ├── tools/
  ├── userland/
  ├── total/
  └── gnome-source/
       ├── <module>/source/
       ├── <module>/build/
       └── conf/white-edition/
```

## Core glossary

| Document / area | Relevance | Relationship |
|---|---|---|
| `README.md` | Repository architecture | Top-level project vocabulary and system map. |
| `SECULAR.md` | Structural glossary | Cross-module index and definition map. |
| `markdown/BUILD.md` | Build system | Describes how source becomes the OS. |
| `markdown/BUILD_SOURCE_SAFETY.md` | Source/build safety | Controls source acquisition and build inputs. |
| `markdown/FILESYSTEM.md` | Filesystem | Defines filesystem and userland relationships. |
| `markdown/THREE_TIER.md` | System tiers | Connects kernel/OS, native moderation, and managed runtime. |
| `total/README.md` | Total native moderator | Defines the native middle layer. |
| `tools/` | Native/userland tools | Utility and operator layer separate from the kernel. |
| `kernels/` | Kernel | Linux operating-system foundation. |
| `gnome-source/README.md` | GNOME overview | Desktop module map and provenance. |
| `gnome-source/SECTIONAL.md` | GNOME audit | Per-module source/build completeness. |
| `gnome-source/conf/white-edition/` | White Edition configuration | Distribution defaults and LAF policy. |

## Total native moderator

`total/` is a first-class native subsystem positioned between Linux facilities and higher-level application/runtime semantics. Its documented model separates evidence from authority and uses a controlled policy boundary. The source tree contains `include/`, `src/`, `tests/`, `Makefile`, `README.md`, and `total.conf.example`.

```text
Linux kernel / hardware
        ↓
      Total
        ↓
SecureJDK 28 / Graal
        ↓
applications/services
```

Its documented evidence flow is:

```text
input → normalization → provenance → validation → policy
      → action → observation → retained evidence
```

The project distinguishes specified, implemented, production-certified, and boot-verified states; documentation alone does not establish successful compilation or deployment.

## GNOME glossary

| Module | Purpose | Desktop relationship |
|---|---|---|
| Cairo | 2D rendering | Rendering primitive. |
| GDK-Pixbuf | Image loading/scaling | Raster/image handling. |
| GLib | Core GNOME infrastructure | GIO, GSettings and common runtime services. |
| glib-networking | Networking/TLS integration | GIO/GLib networking. |
| GTK | UI toolkit | Application widgets and presentation. |
| Mutter | Compositor/window manager | Windows, display composition and compositor effects. |
| GNOME Shell | Desktop shell | Panel/dash, overview and desktop interaction. |
| GNOME Control Center | Settings UI | Presents settings owned by schemas/services. |
| GNOME Software | Software center | Software/application management. |
| GNOME Terminal | Terminal | User terminal experience. |
| GVfs | Virtual filesystem | File/application access through GIO. |
| Orca | Accessibility | Screen-reader/accessibility layer. |
| Vala | Language/compiler | Build-time GNOME development tooling. |
| Gala | Separate compositor | Optional; not the GNOME Shell compositor. |

## White Edition visual system

The White Edition configuration layer establishes a predominantly white professional desktop with dark gray controls/text, neutral gray depth and shadows, and restrained Ubuntu-red active/focus accents. The precision-lighting specification uses one stationary upper-left virtual key light and progressively different elevations for icons, taskbar, windows, and dialogs.

The implementation boundary is intentionally separated:

```text
conf/white-edition
        │
        ├── dconf/GSettings defaults
        ├── theme/CSS
        ├── theme/lighting.conf
        └── theme/icon contract
                    │
          ┌─────────┼─────────┐
          ↓         ↓         ↓
       Shell      Mutter     GTK
```

The bottom taskbar is a White Edition requirement. Where GNOME does not expose a behavior as a normal dconf setting, the implementation belongs in the supported Shell extension/customization layer rather than an invented configuration key.

## White Edition PNG icon inventory — set-002

`ubuntu-white/icons/set-002/` is the authoritative **development artwork source for the initial Desktop LAF**. These are PNG assets. They must remain separate from GNOME upstream source and are installed through the White Edition icon-theme packaging layer after validation.

The current repository inventory contains 12 numbered PNG assets. The Markdown image links below deliberately point to the repository artwork so GitHub renders the actual icons in this glossary.

| # | Icon | Filename | Format | Source | Initial LAF descriptor |
|---:|---|---|---|---|---|
| 001 | ![icon-001](https://raw.githubusercontent.com/mearvk/Ubuntu.Determinant.Beta.Restricted/main/ubuntu-white/icons/set-002/icon-001.png) | `icon-001.png` | PNG | `ubuntu-white/icons/set-002/` | Initial Desktop LAF asset 001; semantic role remains tied to the artwork until explicitly catalogued. |
| 002 | ![icon-002](https://raw.githubusercontent.com/mearvk/Ubuntu.Determinant.Beta.Restricted/main/ubuntu-white/icons/set-002/icon-002.png) | `icon-002.png` | PNG | `ubuntu-white/icons/set-002/` | Initial Desktop LAF asset 002; semantic role remains tied to the artwork until explicitly catalogued. |
| 003 | ![icon-003](https://raw.githubusercontent.com/mearvk/Ubuntu.Determinant.Beta.Restricted/main/ubuntu-white/icons/set-002/icon-003.png) | `icon-003.png` | PNG | `ubuntu-white/icons/set-002/` | Initial Desktop LAF asset 003; semantic role remains tied to the artwork until explicitly catalogued. |
| 004 | ![icon-004](https://raw.githubusercontent.com/mearvk/Ubuntu.Determinant.Beta.Restricted/main/ubuntu-white/icons/set-002/icon-004.png) | `icon-004.png` | PNG | `ubuntu-white/icons/set-002/` | Initial Desktop LAF asset 004; semantic role remains tied to the artwork until explicitly catalogued. |
| 005 | ![icon-005](https://raw.githubusercontent.com/mearvk/Ubuntu.Determinant.Beta.Restricted/main/ubuntu-white/icons/set-002/icon-005.png) | `icon-005.png` | PNG | `ubuntu-white/icons/set-002/` | Initial Desktop LAF asset 005; semantic role remains tied to the artwork until explicitly catalogued. |
| 006 | ![icon-006](https://raw.githubusercontent.com/mearvk/Ubuntu.Determinant.Beta.Restricted/main/ubuntu-white/icons/set-002/icon-006.png) | `icon-006.png` | PNG | `ubuntu-white/icons/set-002/` | Initial Desktop LAF asset 006; semantic role remains tied to the artwork until explicitly catalogued. |
| 007 | ![icon-007](https://raw.githubusercontent.com/mearvk/Ubuntu.Determinant.Beta.Restricted/main/ubuntu-white/icons/set-002/icon-007.png) | `icon-007.png` | PNG | `ubuntu-white/icons/set-002/` | Initial Desktop LAF asset 007; semantic role remains tied to the artwork until explicitly catalogued. |
| 008 | ![icon-008](https://raw.githubusercontent.com/mearvk/Ubuntu.Determinant.Beta.Restricted/main/ubuntu-white/icons/set-002/icon-008.png) | `icon-008.png` | PNG | `ubuntu-white/icons/set-002/` | Initial Desktop LAF asset 008; semantic role remains tied to the artwork until explicitly catalogued. |
| 009 | ![icon-009](https://raw.githubusercontent.com/mearvk/Ubuntu.Determinant.Beta.Restricted/main/ubuntu-white/icons/set-002/icon-009.png) | `icon-009.png` | PNG | `ubuntu-white/icons/set-002/` | Initial Desktop LAF asset 009; semantic role remains tied to the artwork until explicitly catalogued. |
| 010 | ![icon-010](https://raw.githubusercontent.com/mearvk/Ubuntu.Determinant.Beta.Restricted/main/ubuntu-white/icons/set-002/icon-010.png) | `icon-010.png` | PNG | `ubuntu-white/icons/set-002/` | Initial Desktop LAF asset 010; semantic role remains tied to the artwork until explicitly catalogued. |
| 011 | ![icon-011](https://raw.githubusercontent.com/mearvk/Ubuntu.Determinant.Beta.Restricted/main/ubuntu-white/icons/set-002/icon-011.png) | `icon-011.png` | PNG | `ubuntu-white/icons/set-002/` | Initial Desktop LAF asset 011; semantic role remains tied to the artwork until explicitly catalogued. |
| 012 | ![icon-012](https://raw.githubusercontent.com/mearvk/Ubuntu.Determinant.Beta.Restricted/main/ubuntu-white/icons/set-002/icon-012.png) | `icon-012.png` | PNG | `ubuntu-white/icons/set-002/` | Initial Desktop LAF asset 012; semantic role remains tied to the artwork until explicitly catalogued. |

The repository directory confirms these 12 PNG files and their individual source paths/sizes. fileciteturn256file0L2-L2 The table intentionally does **not** invent semantic names from filenames alone. Once the artwork is formally assigned roles such as folder, home, trash, terminal, settings, or downloads, those assignments should be recorded here and in the icon-theme manifest together.

### Icon safety contract

```text
set-002 PNG artwork
       ↓
validate filesystem objects
       ↓
validate PNG-only boundary
       ↓
preserve source artwork
       ↓
package as Ubuntu-White
       ↓
GNOME Shell / GTK / GVfs consumers
```

The production installer must not silently substitute SVGs, follow external symlinks, or consume unrelated development sets. Generated/resized derivatives belong in the build/package layer, not in the authoritative artwork directory.

## Source/build boundary

```text
source/       pristine upstream code
patches/      deliberate project modifications
build/        local build wrappers/preflight
build-local/  generated build output
conf/         distribution configuration
```

Generated output must not become a second source tree. This separation makes provenance, review, rollback, and reproducibility explicit.

## Tools

`tools/` is a userspace tool collection, separate from the kernel. Its current Makefile explicitly builds and installs `pcopy` and `pmove`; `pmove` is intentionally a first-class tool rather than only a compatibility alias.

The repository also contains `tools/git/` for Git acquisition/documentation and `scripts/` for repository/build automation. Other tool directories should be classified by their own README/build metadata rather than assumed to be kernel components.

## Kernel layer

The repository currently contains `kernels/linux-5.15.204/`. A kernel source tree alone does not prove that kernel code has been altered. A kernel alteration should be evidenced by a source revision, patch/diff, configuration, build metadata, or resulting artifact.

The normal Linux build system supports an out-of-tree output directory through `make O=<output-dir>`, keeping generated configuration and build output separate from kernel source.

Kernel changes should therefore record:

1. source revision;
2. patch/diff;
3. `.config` or equivalent configuration source;
4. architecture/flavour;
5. build command/toolchain;
6. kernel/module/package artifacts;
7. boot/runtime verification.

## Userland/operator layer

Userland commands remain distinct from kernel primitives. The project's proposed extended `rmdir` behavior belongs in the userland command implementation, while the kernel filesystem primitive remains unchanged unless a deliberate kernel patch is documented.

Likewise, path syntax such as `..` and any additional path operators should be documented as userland/path-resolution policy unless the kernel path-walk implementation is deliberately changed.

## ISO relationship

```text
source acquisition
      ↓
source verification
      ↓
module preflight/build
      ↓
patches
      ↓
configuration
      ↓
icons/theme
      ↓
kernel + Total + userland + GNOME
      ↓
root filesystem
      ↓
ISO/image
      ↓
boot/test/verification
```

GNOME and Total are therefore distinct major subsystems of the OS: GNOME supplies the desktop experience; Total supplies a native evidence/policy mediation layer; Linux supplies the ground operating-system facilities.

## Status vocabulary

| Status | Meaning |
|---|---|
| `SOURCE PRESENT` | Canonical source tree exists. |
| `BUILD DEFINED` | Local build wrapper recognizes the source. |
| `BUILD VERIFIED` | Compilation/configure/test actually completed. |
| `CONFIGURED` | Distribution defaults are defined. |
| `PACKAGED` | Output is staged into the target root/image. |
| `BOOT VERIFIED` | Resulting image boots and passes declared tests. |
| `NEEDS REVIEW` | Evidence is incomplete or structure is unusual. |

A README or script is not evidence of a completed build. Execution evidence is required for `BUILD VERIFIED`, `PACKAGED`, and `BOOT VERIFIED`.

## Provenance questions

Every major subsystem should answer:

```text
What source is this?
Which exact version/revision is it?
What did we modify?
How was it built?
Where did the artifact go?
```

`SECULAR.md` is the cross-reference layer; module READMEs remain authoritative for module-specific details.
