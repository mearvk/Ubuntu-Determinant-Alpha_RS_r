# Ubuntu White Edition — Package Quality Standard

## Purpose

Ubuntu White Edition is the quality and integration layer applied to the Ubuntu 22.04 source foundation used by this project. It does **not** replace Ubuntu upstream source wholesale. Instead, it establishes a controlled overlay process in which package improvements are proposed, reviewed, tested, documented, and then integrated with explicit provenance.

The source archive remains the upstream baseline. White Edition changes belong in the project overlay, patches, build configuration, tests, and documentation so that the difference between upstream and project work remains recoverable.

## Economy of the Operating System

The present `ubuntu.slaves.black` archive records approximately **19 GB** of Ubuntu 22.04.3 LTS source across four source discs and approximately **2,500 source packages**. The extracted package inventory is organized by disc and package, while packages above the 50 MB extraction threshold remain represented in `skipped.txt`. fileciteturn14file0

For planning purposes, 19 GB / 2,500 packages is roughly **7.6 MB of source per package on average**. This is a source-economy measure, not installed-system size and not a monetary valuation. It is useful because it shows that the operating system is an ecosystem of thousands of individually maintained economic units: libraries, tools, runtimes, desktop components, services, kernels, drivers, languages, and development infrastructure.

The White Edition objective is therefore not simply to make every package larger or more featureful. The objective is to increase **quality per unit of system complexity**: fewer unnecessary changes, clearer defaults, better failure behavior, stronger build reproducibility, coherent documentation, appropriate security controls, and a consistent user experience.

## Quality Principles

1. **Upstream first.** Preserve upstream behavior unless a documented White Edition reason exists for changing it.
2. **Small deltas.** Prefer narrow patches over broad forks.
3. **Reproducibility.** Record source version, patch identity, build inputs, and expected outputs.
4. **Security.** Prefer established security mechanisms and avoid unaudited replacement cryptography.
5. **Compatibility.** Preserve Debian/Ubuntu packaging conventions where they serve users and maintainers.
6. **User clarity.** Improve messages, defaults, configuration, and GUI integration without hiding technical state.
7. **Resource economy.** Measure startup time, memory, disk footprint, dependency count, and build cost where material.
8. **Accessibility.** Preserve usable keyboard navigation, readable typography, localization, and appropriate contrast.
9. **Evidence.** Every material change should have a test or a documented reason why testing is not applicable.
10. **Reversibility.** Every overlay should be independently identifiable and removable.

## Package Quality Grades

| Grade | Meaning | Action |
|---|---|---|
| W0 | Upstream baseline | No White Edition change required. |
| W1 | Clean integration | Packaging, documentation, build, or presentation refinement. |
| W2 | Quality improvement | Tested functional, security, reliability, or usability improvement. |
| W3 | Architectural change | Significant behavior or dependency change requiring dedicated review. |
| HOLD | Needs evidence | Do not integrate until provenance, licensing, compatibility, or testing is resolved. |

A grade describes the **White Edition change**, not the quality of the upstream project itself.

## Integration Order

### Phase 1 — Foundation

Prioritize packages that establish the system's trust and execution foundation:

- `base-files`
- `base-passwd`
- `bash`
- `coreutils`
- `dpkg`
- `apt`
- `debootstrap`
- `glibc`
- `gcc` / `binutils`
- `systemd`
- `dbus`
- `openssl`
- `ca-certificates`
- `apparmor`
- `cryptsetup`
- `grub2`
- kernel packages

These should receive build reproducibility, hardening, failure-mode, documentation, and provenance review before cosmetic changes are prioritized.

### Phase 2 — Core Userland

Review:

- filesystem and archive utilities;
- networking and DNS tools;
- process and service administration;
- package management;
- shell and terminal tools;
- logging and diagnostics;
- certificate and key infrastructure.

The existing manifest demonstrates that the archive contains these core components, including `apt`, `apparmor`, `audit`, `bash`, `bind9`, `coreutils`, `cryptsetup`, `curl`, `dpkg`, `glibc`, `gnupg2`, and related infrastructure. fileciteturn12file0

### Phase 3 — Desktop and User Experience

Review GTK/desktop foundations, fonts, icons, display services, Java/OpenJFX components, configuration tools, and application launch integration.

The repository's Ubuntu source inventory explicitly includes GTK, GNOME, OpenJFX, fonts, icon themes, and Java-related packages. fileciteturn14file0

Where an application is one of our userland applications, the White Edition GUI standard should use the common cool-white JavaFX design where JavaFX is appropriate. Ubuntu-native applications should not be forcibly rewritten merely to obtain visual consistency.

### Phase 4 — Specialized Packages

Review databases, development environments, scientific tools, cloud components, media systems, drivers, language runtimes, and other specialized packages according to actual product need.

### Phase 5 — Optional and Archival Material

Large or specialized source packages should remain available without automatically becoming part of the minimum White Edition installation. The archive already records a substantial set of packages above the 50 MB extraction threshold, including LibreOffice, multiple Linux variants, NVIDIA driver families, GCC, LLVM, Noto fonts, MySQL, and OpenJDK LTS. fileciteturn13file0

## Change Record Contract

Each integrated package change should eventually have:

```text
package/
├── upstream-version
├── white-edition-grade
├── rationale.md
├── patches/
├── tests/
└── THEORETICAL.md       # when mathematical/security reasoning is material
```

The change record should identify:

- upstream package and version;
- exact White Edition modification;
- reason for modification;
- security implications;
- compatibility implications;
- build/test evidence;
- runtime/resource effect when material;
- licensing/provenance notes;
- rollback path.

## What We Should Not Do

White Edition should not:

- silently claim upstream changes as MEARVK work;
- overwrite the Ubuntu source archive merely to apply local preferences;
- replace mature cryptographic primitives with unreviewed implementations;
- add GUI layers to services that do not benefit from them;
- optimize solely for source size while degrading runtime quality;
- remove packages solely because they are large;
- change package behavior without recording the compatibility consequence.

## Current Baseline

The repository's top-level build already distinguishes kernel, userland, X11, tools, desktop, root filesystem, and image construction. fileciteturn11file0 The White Edition package process should therefore attach to those existing build boundaries rather than invent a second operating-system build model.

The next implementation layer should be a package overlay/patch registry. It should start with the foundation packages, assign W0–W3/HOLD status, and add tests before changing package source. This keeps the integration orderly and allows the operating-system economy to be measured as quality, complexity, resource consumption, and maintenance burden rather than as raw source volume alone.

---

**Max Rupplin — MEARVK LLC**
