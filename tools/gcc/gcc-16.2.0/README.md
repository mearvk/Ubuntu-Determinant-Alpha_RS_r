# GCC 16.2.0 — MEARVK Source Record

## Purpose

This directory is the MEARVK repository's source-preservation location for the **GNU Compiler Collection (GCC) 16.2.0** source tree.

The source is retained as source, not represented as a MEARVK-authored implementation. **MEARVK LTD is the repository integrator/distributor for this copy and does not claim copyright ownership of the GCC project or of third-party components contained in this directory.**

Version is confirmed by `gcc/BASE-VER` as **16.2.0**.

## Provenance

- Upstream project: **GNU Compiler Collection (GCC)**
- Preserved version: **16.2.0**
- Repository location: `tools/gcc/gcc-16.2.0/`
- MEARVK repository: `mearvk/Ubuntu.Determinant.Beta.Restricted`
- Preservation role: source import, organization, build/integration work, and repository documentation
- GCC source documentation states that the directory contains the GNU Compiler Collection and that its manuals and runtime libraries may have different licensing terms. The original GCC README remains authoritative for upstream provenance. 

This README is an **integration and provenance record**. It does not replace any upstream license, copyright notice, NOTICE file, source-file header, or component-specific license.

## Initial / Foundational Contributors

GCC is a long-running community project with contributors extending over decades. It is not accurate to reduce its authorship to a single person or company.

Historically important project leadership and foundational contributors include:

- **Richard Stallman** — initiated the GNU Compiler Collection/GNU C Compiler project and the GNU project context in which GCC originated.
- **The Free Software Foundation (FSF)** — stewarded and published GCC under the GNU project for much of its history.
- **The GCC development community** — successive maintainers and contributors developed the compiler, language front ends, optimizers, back ends, runtime libraries, testsuite, documentation, and ports.

The current source tree contains a substantially larger contributor and maintainer population. The authoritative current maintainer record is `MAINTAINERS`; it identifies global reviewers and maintainers for individual targets and components. It should be consulted rather than treating this short historical list as a complete authorship list.

The repository copy does **not** transfer or replace any of those contributors' copyrights.

## Current GCC Maintainer Record

The imported `MAINTAINERS` file contains, among others, global reviewers including Richard Biener, Richard Earnshaw, Jakub Jelinek, Jeff Law, Michael Meissner, Jason Merrill, David S. Miller, Joseph Myers, Andrew Pinski, Richard Sandiford, Bernd Schmidt, Ian Lance Taylor, and Jim Wilson, together with maintainers for individual CPU ports and compiler components.

The complete authoritative list is the file:

`MAINTAINERS`

Do not infer copyright ownership from maintainer status. Maintainers are responsible for project areas; copyright remains governed by the applicable source notices and licenses.

## License Inventory

GCC is a **multi-license source distribution**. There is no single license statement that should be mechanically applied to every file in this directory.

The imported top-level license documents include:

| File | License / purpose |
|---|---|
| `COPYING` | **GNU General Public License, version 2 (GPL-2.0)**. This is the complete GPLv2 license text supplied with the source distribution. |
| `COPYING3` | **GNU General Public License, version 3 (GPL-3.0)**. Supplied for components released under GPLv3 terms. |
| `COPYING.LIB` | **GNU Lesser General Public License, version 2.1 (LGPL-2.1)**. Supplied for library components released under LGPL terms. |
| `COPYING.RUNTIME` | **GCC Runtime Library Exception, version 3.1**, an additional permission associated with GPLv3-covered runtime-library files that carry the corresponding notice. |

The GCC Runtime Library Exception is particularly important when examining compiler-produced programs: it provides additional permissions for certain GCC headers and runtime libraries when they are incorporated into independently written programs. **It does not mean that every GCC source file or every GCC-associated library has the same exception.** The individual source-file notice controls.

### Additional license families and component-specific terms

The GCC distribution is composed of multiple libraries, utilities, language runtimes, target support, imported components, and historical code. Consequently, additional files may carry:

- GPL terms at different versions or with later-version permissions;
- LGPL terms, including library-specific LGPL terms;
- the GCC Runtime Library Exception where explicitly stated;
- permissive licenses such as BSD-style, MIT-style, ISC-style, zlib-style, or similarly permissive notices in particular bundled components;
- public-domain or public-domain-like notices where explicitly stated by the relevant component;
- special-purpose exceptions or additional permissions attached to a particular file or library;
- third-party component licenses whose terms are preserved in that component's own license or notice files.

**This list describes license families, not a relicensing of the source.** A file must be evaluated from its own copyright and license header and, where applicable, its component's COPYING/README/NOTICE documentation.

## License-reading rule for this repository

For any redistribution, modification, build, or packaging decision, apply this order of authority:

1. The individual source file's copyright and license notice.
2. A license or NOTICE file explicitly covering that file or component.
3. The component directory's licensing documentation.
4. The top-level GCC license documents listed above.
5. This MEARVK README, which is explanatory only and **does not grant additional rights**.

Where notices conflict or scope is uncertain, do not assume the broader permission. Consult the original license text and the applicable component documentation.

## Copyright and attribution

Copyright notices in the GCC source remain intact. This repository copy should preserve those notices when source is copied, modified, or redistributed.

MEARVK-specific work should be clearly distinguished from upstream GCC work. In particular:

- **Upstream GCC source:** remains attributable to its original authors, contributors, and copyright holders.
- **MEARVK repository organization/integration:** may be separately attributed to MEARVK LTD where applicable.
- **Local build scripts, patches, wrappers, installers, tests, and integration code:** have their own authorship and licensing and should not be assumed to inherit GCC licensing merely because they invoke or accompany GCC.

## What this document does not mean

This document does not:

- relicense GCC;
- claim GCC as proprietary MEARVK software;
- claim ownership of upstream GCC copyrights;
- replace GPL, LGPL, runtime-exception, or third-party license texts;
- grant trademark rights;
- establish that every file in the tree has the same license;
- establish that generated compiler output is itself licensed identically to the GCC source that produced it.

## Repository preservation note

The source tree was imported into the MEARVK Beta repository as source material for local compiler development, testing, integration, and reproducible build work. The import should be treated as an upstream source snapshot plus repository-level integration metadata.

Before making a release containing GCC or a GCC-derived component, run a fresh license/provenance audit against the exact release tree and retain the corresponding license texts and notices.

## Verification references

- `gcc/BASE-VER` — GCC version (`16.2.0`)
- `README` — upstream GCC source description
- `MAINTAINERS` — current maintainer/component ownership map
- `COPYING` — GPLv2 text
- `COPYING3` — GPLv3 text
- `COPYING.LIB` — LGPLv2.1 text
- `COPYING.RUNTIME` — GCC Runtime Library Exception 3.1

**MEARVK integration label:** `MEARVK LTD — GCC 16.2.0 Source Preservation / Integration`

**Important:** This document is an informational provenance summary, not legal advice. The license and copyright notices distributed with each source component remain controlling.
