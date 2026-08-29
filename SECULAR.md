# Ubuntu.Determinant.Beta.Restricted — Structural and Definition Glossary

`SECULAR.md` is the repository-wide structural glossary for the OS build. It relates the principal READMEs and specification documents to their implementation modules, source trees, build layers, configuration, tools, kernels, userland, and ISO construction.

The term is used here as a **non-confessional engineering classification**. It does not classify people by religion, belief, ethnicity, or other sensitive personal characteristics.

## System reading order

```text
README.md
  │
  ├── markdown/BUILD.md
  ├── markdown/BUILD_SOURCE_SAFETY.md
  │
  ├── kernels/
  ├── tools/
  ├── userland/
  │
  └── gnome-source/
       ├── README.md
       ├── SECTIONAL.md
       ├── <module>/source/
       ├── <module>/build/
       └── conf/white-edition/
```

## Primary documentation glossary

| Document | Relevance | Relationship |
|---|---|---|
| `README.md` | Repository architecture | Top-level project vocabulary and system map. |
| `SECULAR.md` | Structural glossary | This cross-module index and dependency/definition map. |
| `markdown/BUILD.md` | Build system | Describes how source becomes the OS. |
| `markdown/BUILD_SOURCE_SAFETY.md` | Source/build safety | Controls source acquisition and build inputs. |
| `markdown/FILESYSTEM.md` | Filesystem | Defines filesystem and userland relationships. |
| `markdown/THREE_TIER.md` | Total / Ground / Top | Connects kernel/OS, native moderation, and managed runtime. |
| `markdown/GRAAL_SECURITY_CONCEPT.md` | Graal security | Managed runtime/compiler security architecture. |
| `markdown/DOMAIN_SERVICES.md` | Domain adapters | Application/service evidence and authorization model. |
| `markdown/CERTIFICATES.md` | Certificates | Certificate-related runtime/build material. |
| `markdown/LEGAL.md` | Legal | Project legal and trademark guidance. |
| `markdown/LEGAL_NAMING_AND_SOURCE.md` | Provenance/naming | Source and naming boundaries. |
| `markdown/HSS_PREHEADER.md` | HSS layer | Project-specific document/protocol concepts. |
| `markdown/CTRMSCTL-1-2-3-4.mmd` | Evidence chain | 1-2-3-4 document/evidence structure. |
| `markdown/GCC-METADATA-1-2-3-4-2026-08-25.mmd` | GCC metadata | Metadata/evidence record. |

## GNOME documentation

| Location | Relevance | Relationship |
|---|---|---|
| `gnome-source/README.md` | GNOME overview | Module purposes, provenance, complexity and build relationships. |
| `gnome-source/SECTIONAL.md` | Module audit | Per-module source/build completeness. |
| `gnome-source/<module>/README.md` | Module documentation | Source, acquisition, purpose and build details. |
| `gnome-source/<module>/source/` | Source | Canonical pristine source boundary; `upstream/` is not the final name. |
| `gnome-source/<module>/build/` | Local build | Module build wrapper and structural preflight. |
| `gnome-source/conf/white-edition/` | Distribution configuration | GNOME defaults separated from source. |
| `gnome-source/conf/white-edition/theme/` | White Edition LAF | Theme, lighting, icon and installation contracts. |
| `theme/lighting.conf` | 3D lighting | Shared upper-left virtual light and elevation model. |
| `theme/white-edition.css` | Visual styling | White/gray/red presentation layer. |
| `theme/icons.conf` | Icon source | Declares `ubuntu-white/icons/set-002/*.png` as the initial Desktop LAF. |
| `theme/install-icons.sh` | Icon packaging | Validates and stages the set-002 PNG artwork into the ISO. |

### GNOME module glossary

| Module | Purpose | Desktop relationship |
|---|---|---|
| Cairo | 2D rendering | Rendering primitive. |
| GDK-Pixbuf | Image loading/scaling | Raster/image handling. |
| GLib | Core GNOME infrastructure | GIO, GSettings and common runtime utilities. |
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

## White Edition icon chain

```text
ubuntu-white/icons/set-002/*.png
            │
            ▼
gnome-source/conf/white-edition/theme/
            │
            ▼
      Ubuntu-White theme
            │
       ┌────┴────┐
       ▼         ▼
   Shell       GTK/GVfs
       └────┬────┘
            ▼
        Desktop LAF
```

Set-002 PNGs are the current development artwork source of truth for the initial Desktop LAF. The installer validates the source and does not silently substitute SVGs or unrelated icon sets.

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

`tools/` is a userspace tool collection, separate from the kernel. Its current Makefile explicitly builds and installs `pcopy` and `pmove`; `pmove` is intentionally a first-class tool rather than only a compatibility alias. fileciteturn249file0

The repository also contains `tools/git/` for Git acquisition/documentation and `scripts/` for repository/build automation. Other tool directories should be classified by their own README/build metadata rather than assumed to be kernel components.

## Kernel layer

The repository currently contains `kernels/linux-5.15.204/`. A kernel source tree alone does not prove that kernel code has been altered. A kernel alteration should be evidenced by a source revision, patch/diff, configuration, build metadata, or resulting artifact.

The normal Linux build system supports an out-of-tree output directory through `make O=<output-dir>`, keeping generated configuration and build output separate from kernel source. citeturn0search0

Kernel changes should therefore record:

1. source revision;
2. patch/diff;
3. `.config` or equivalent configuration source;
4. architecture/flavour;
5. build command/toolchain;
6. kernel/module/package artifacts;
7. boot/runtime verification.

Ubuntu's kernel annotations tooling provides an architecture/flavour configuration representation and import/export path; this is preferable to treating arbitrary generated `.config` files as the source of truth. citeturn0search9

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
userland + kernel
      ↓
root filesystem
      ↓
ISO/image
      ↓
boot/test/verification
```

GNOME is therefore one major subsystem of the OS, not the OS itself.

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
