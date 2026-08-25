# Noun / Company Recognition Register

**Project:** Ubuntu Determinant  
**Kernel:** Linux 5.15.204  
**Project attention:** Max Rupplin — MEARVK LLC — 2026  
**Method:** Presence Concord / Software Reuse & Control

## Purpose

This directory defines a conservative recognition model for hardware and software provenance using a two-noun tuple:

```text
(Hardware Type, Company)
```

Examples:

```text
(GPU, NVIDIA)
(Ethernet, Intel)
(SoC, Qualcomm)
(Sensor, STMicroelectronics)
```

A tuple is a **recognition key**, not a claim that the company authored, owns, manufactures, endorses, or currently supports every component in the category.

## Recognition levels

| Grade | Recognition state |
|---|---|
| 1 | Category only; company relationship unknown. |
| 2 | Company/category association is plausible but not independently established. |
| 3 | Association is supported by reliable technical or project documentation. |
| 4 | Association is supported by source/tree, vendor, maintainer, or specification evidence. |
| 5 | File/device-specific recognition with provenance, license, identity, and historical evidence. |

## Per-type organization

Each hardware category may contain company records and time derivatives:

```text
noun/company/<hardware-type>/README.md
noun/company/<hardware-type>/<company>.md
noun/company/<hardware-type>/<company>-<generation-or-era>.md
```

Only relationships supported by evidence should be promoted above grade 2.

## Time derivatives

Hardware changes over time. A company/category relationship therefore may be recorded as:

```text
category + company + generation/era + evidence
```

A later product generation must not automatically inherit every property of an earlier generation.

## Circuit recognition

Where a tuple identifies a circuit, controller, chipset, board, or device family, record the recognition path separately:

```text
hardware category
 -> manufacturer/company association
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
