# Noun / Company Recognition Register

**Project:** Ubuntu Determinant  
**Kernel:** Linux 5.15.204  
**Project attention:** Max Rupplin — MEARVK LLC — 2026  
**Method:** Presence Concord / Software Reuse & Control

## Purpose

`noun` and `company` are intentionally separate dimensions of recognition:

```text
noun   = the hardware/software type
company = the recognized company associated with that type
```

Together they form a **recognized noun 2-tuple**:

```text
(Noun, Company)
```

Examples:

```text
(GPU, NVIDIA)
(Ethernet, Intel)
(SoC, Qualcomm)
(Sensor, STMicroelectronics)
(Server, IBM)
(Mainframe, IBM)
(Computer, NEC)
```

Here `GPU`, `Ethernet`, `SoC`, `Sensor`, `Server`, `Mainframe`, and `Computer` are nouns/types. `NVIDIA`, `Intel`, `Qualcomm`, `STMicroelectronics`, `IBM`, and `NEC` are company names.

The tuple is a **recognition key**, not a claim that the company authored, owns, manufactures, endorses, or currently supports every item belonging to the noun category.

## Directory grammar

The directory structure follows the same distinction:

```text
noun/
  company/
    <noun-type>/
      README.md
      <company>.md
      <company>-<generation-or-era>.md
```

For example:

```text
noun/company/mainframe/IBM.md
noun/company/computer/NEC.md
noun/company/gpu/NVIDIA.md
noun/company/ethernet/Intel.md
```

The first directory component identifies the **noun/type**. The document beneath it identifies the **company**. A time derivative identifies a generation, era, architecture, or other supported historical distinction.

## Recognition levels

| Grade | Recognition state |
|---|---|
| 1 | Noun/type recognized; company relationship unknown. |
| 2 | Company/type association is plausible but not independently established. |
| 3 | Association is supported by reliable technical or project documentation. |
| 4 | Association is supported by source/tree, vendor, maintainer, or specification evidence. |
| 5 | File/device-specific recognition with provenance, license, identity, and historical evidence. |

Only relationships supported by evidence should be promoted above grade 2.

## Time derivatives

Hardware and companies change over time. A recognized relationship may therefore be represented as:

```text
(noun, company, generation/era, evidence)
```

A later product generation must not automatically inherit every property of an earlier generation. Where historical continuity matters, create a derivative document rather than silently merging periods.

## Circuit recognition

Where a tuple identifies a circuit, controller, chipset, board, or device family, record the recognition path separately:

```text
noun/type
 -> company association
 -> device family
 -> vendor/device identifier
 -> circuit/controller
 -> driver
 -> kernel subsystem
 -> verification
```

Recognition of a circuit is not proof of authorship of its driver.

## Company evidence

Preferred evidence, in descending strength:

1. file-specific device IDs and source provenance;
2. kernel source/maintainer records;
3. vendor technical documentation;
4. standards/specifications;
5. project documentation;
6. reliable public Internet references;
7. contextual inference.

Internet discovery is a useful **co-frame**, but contextual discovery alone should not become an ownership or authorship claim.

## Ethical control

The tuple supports responsible identification and maintenance. It does not establish citizenship, legal nationality, institutional endorsement, copyright ownership, or personal status.

## Privacy

Do not place private correspondence, personal profiles, credentials, psychological material, confidential contracts, or sensitive security evidence in these public recognition records.

## Project reference

**Max Rupplin — MEARVK LLC — 2026** records project-level maintenance and documentation attention. It does not replace historical company, contributor, copyright, or license information.