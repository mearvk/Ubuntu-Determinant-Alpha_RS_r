# Ubuntu White Edition — Ubuntu 22 Package Integration

**Max Rupplin — MEARVK LLC**

## Executive Position

`ubuntu.slaves.black` is the Ubuntu 22.04.3 LTS source foundation. It contains approximately 19 GB of source material across four source discs and approximately 2,500 source packages. fileciteturn14file0

White Edition integration is a controlled overlay process. The upstream archive is preserved as evidence and reference; White Edition changes are layered, identified, tested, and documented separately. This is the safest way to improve the operating system without losing the ability to determine what came from Ubuntu and what was changed by this project.

## Operating-System Economy

A useful first-order measure is:

```text
source economy ≈ total source footprint / package count
                 ≈ 19 GB / 2,500
                 ≈ 7.6 MB/package average
```

This number is only a planning statistic. It does not describe installed size, RAM usage, binary size, market value, or performance. A better White Edition economy model is a vector:

```text
E = {source, binary, disk, RAM, startup, dependencies,
     build-time, maintenance, security, user-complexity}
```

The desired direction is to improve useful capability while keeping unnecessary complexity from growing faster than value.

## Ordered Integration Program

### 01 — Provenance

For each package, preserve the Ubuntu source version, original licensing information, and source location. Do not edit the archive in place merely to make it look different.

### 02 — Build Health

Confirm that the package can be rebuilt in the project's supported build environment. Capture compiler/toolchain assumptions and material warnings.

### 03 — Security Baseline

Review hardening, permissions, service exposure, temporary-file handling, parser boundaries, certificate handling, cryptographic APIs, and privilege transitions according to the package's function.

### 04 — Reliability

Exercise normal operation and expected failure paths. Error messages should identify the operation, failure condition, and useful recovery information without leaking secrets.

### 05 — Resource Economy

Measure material changes to installed footprint, runtime memory, startup time, process count, dependency count, and build cost. Do not optimize a metric in isolation.

### 06 — User Experience

For user-facing programs, improve configuration clarity, documentation, localization, keyboard operation, desktop integration, and visual consistency. Use the common cool-white JavaFX standard for MEARVK Java applications where appropriate.

### 07 — Documentation

Record every non-trivial change in the package's White Edition change record. Security or mathematical changes should receive deeper technical documentation.

### 08 — Regression

Run package-specific tests plus the relevant system-level tests before promoting the change.

### 09 — Promotion

Move a package from baseline to W1/W2/W3 only when the evidence supports the grade. Use HOLD where provenance, licensing, compatibility, or testing remains unresolved.

## Priority Rings

### Ring A — System Trust

`base-files`, `base-passwd`, `glibc`, `bash`, `coreutils`, `dpkg`, `apt`, `debootstrap`, `systemd`, `dbus`, `openssl`, `ca-certificates`, `apparmor`, `audit`, `cryptsetup`, `grub2`, and kernel families.

### Ring B — System Operation

Filesystem utilities, networking, DNS, SSH, logging, service management, package helpers, shell tooling, compression, archive tools, and hardware discovery.

### Ring C — Desktop

GTK/GLib, GNOME foundations, display services, fonts, icon themes, Java/OpenJFX, desktop configuration, and application launch integration.

### Ring D — Development

GCC, binutils, LLVM, CMake, Java tooling, Python, Perl, Ruby, build systems, documentation systems, and testing frameworks.

### Ring E — Specialized

Databases, cloud infrastructure, media stacks, scientific packages, drivers, language-specific ecosystems, and optional applications.

The source archive's manifest confirms the presence of many of these foundational families. fileciteturn12file0

## Large Package Policy

The repository already records packages larger than the 50 MB extraction threshold separately. Examples include `libreoffice`, multiple Linux kernel variants, NVIDIA driver families, GCC, LLVM, Noto font collections, MySQL, and OpenJDK LTS. fileciteturn13file0

Large source size is not itself a defect. A package should instead be judged on whether its capability belongs in the default image, an optional image, a development image, or the source archive only. This permits a smaller practical operating environment without discarding source provenance.

## Package Promotion Record

Use this compact record for each package selected for active integration:

| Field | Required value |
|---|---|
| Package | Exact source package name |
| Ubuntu baseline | Exact version/revision |
| White Edition grade | W0/W1/W2/W3/HOLD |
| Purpose | Why it is in the image |
| Change | Exact modification |
| Evidence | Tests/build/security evidence |
| Resource effect | Known material effect |
| Dependencies | Added/removed/changed dependencies |
| GUI | None/native/JavaFX where appropriate |
| Rollback | Patch/revision that restores baseline |

## Immediate Foundation Queue

The first package review wave should concentrate on package-management and trust boundaries rather than cosmetic changes:

1. `apt`
2. `dpkg`
3. `base-files`
4. `base-passwd`
5. `bash`
6. `coreutils`
7. `glibc`
8. `openssl`
9. `ca-certificates`
10. `apparmor`
11. `audit`
12. `systemd`
13. `dbus`
14. `cryptsetup`
15. `grub2`
16. kernel source families

No package in this queue should be altered merely because it is important. Importance means it receives earlier review and stronger evidence requirements.

## Relationship to the Existing Build

The repository's Makefile already separates kernel, userland, X11, tools, desktop, root filesystem, initramfs, GRUB, and ISO construction. fileciteturn11file0 White Edition integration should attach to those boundaries.

The archive's existing sparse-checkout mechanism also recognizes three fetch grades—Essential, Standard, and Complete—based on package size, importance, relevance, structure, stability, and normality. fileciteturn15file0 The White Edition W0–W3 grades are intentionally different: they describe **the quality and risk of a proposed modification**, not how much source should be downloaded.

## Definition of Done

A package is White Edition integrated when:

- its upstream identity is recorded;
- its local change is isolated and reproducible;
- its build succeeds in the intended environment;
- relevant tests pass;
- security-sensitive behavior has been reviewed;
- resource effects are understood where material;
- user-facing changes are documented;
- licensing/provenance remains clear;
- the package can be reverted to the Ubuntu baseline.

This provides an orderly path from a large Ubuntu source archive to a carefully maintained White Edition operating system without confusing source volume with system quality.
