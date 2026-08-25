# Driver Documentation — Master Register

**Project:** Ubuntu Determinant  
**Kernel:** Linux 5.15.204  
**Project attention:** Max Rupplin — MEARVK LLC — 2026

## Purpose

This document is the master index for driver-source documentation, provenance, reuse, control, and ethical engineering review.

The central model is:

```text
Presence
  -> Identity
  -> Authorship
  -> Content
  -> Provenance
  -> License
  -> Custody
  -> Modification
  -> Dependencies
  -> Verification
  -> Concord
```

## Noun / Company recognition

The driver tree now contains a parallel recognition register at:

```text
noun/company/<noun-type>/<company>.md
```

Here **noun = hardware/software type** and **company = recognized company associated with that type**. The tuple `(Noun, Company)` is a recognition key, not an automatic ownership or authorship claim.

The base grammar and evidence rules are defined in `noun/company/README.md`. Time derivatives may add generation/era information when the kernel actually contains corresponding identifiers or implementations.

## Populated noun categories

The recognition tree has been populated from the LISTABLES taxonomy with category records for:

- CPU / processor
- Memory
- Firmware / platform
- PCI / PCIe
- USB
- Storage
- Network
- Graphics / GPU
- Input / HID
- Audio
- Camera / media
- Serial / terminal
- I2C / SPI
- GPIO
- Clock / reset
- Power
- Thermal
- Watchdog
- RTC / time
- Hardware security
- Virtualization
- InfiniBand / fabric
- CAN / field bus
- Industrial I/O
- LEDs / indicators
- HID / specialty input
- Bluetooth
- Fibre Channel
- Thunderbolt / USB4
- FPGA / programmable logic
- Accelerator
- Miscellaneous

These category records are recognition scaffolds. They do not assert that every listed hardware class is enabled in the current kernel configuration.

## Company-specific derivatives currently registered

The following records have been created where the kernel family has a corresponding vendor/device or driver relationship requiring a more specific recognition key:

| Tuple | Record | Status |
|---|---|---|
| `(Network, Intel)` | `noun/company/network/Intel.md` | Vendor/category derivative; file-level provenance remains authoritative. |
| `(Network, AMD)` | `noun/company/network/AMD.md` | Vendor/category derivative; exact family review remains. |
| `(GPU, AMD)` | `noun/company/gpu/AMD.md` | Vendor/category derivative; exact ASIC/file review remains. |
| `(GPU, Intel)` | `noun/company/gpu/Intel.md` | Vendor/category derivative; exact generation/file review remains. |
| `(GPU, NVIDIA)` | `noun/company/gpu/NVIDIA.md` | Vendor/category derivative; open-source Nouveau scope distinguished. |
| `(Storage, Intel)` | `noun/company/storage/Intel.md` | Vendor/category derivative; exact controller/file review remains. |
| `(Storage, QLogic)` | `noun/company/storage/QLogic.md` | Historical/vendor category derivative; exact source lineage remains. |

Additional company records should be created only after confirming a corresponding device identifier, source implementation, maintainer record, or other reliable kernel evidence.

## Grading policy

The 1–5 grade is a **software artifact and evidence-quality grade**. It is not an intelligence score, citizenship score, psychological assessment, legal status, or judgment of an individual.

- **1/5 — Bare:** minimally characterized.
- **2/5 — Basic:** understandable but with material provenance/documentation gaps.
- **3/5 — Sound:** normal, coherent, and sufficiently documented for responsible reuse.
- **4/5 — Mature:** unusually strong engineering/provenance/control evidence.
- **5/5 — Clean/Superb:** exceptional completeness and concord evidence.

Ordinary driver files should normally remain **1–3**. If the formal structure or provenance cannot reasonably be explained, the provisional grade is normally capped at **2** until evidence resolves the concern.

## Grade 1–2 author/provenance register

The following category is intentionally conservative. These are **relative documentation concerns**, not accusations about authors or claims of deficient engineering ability.

| Grade | Component/file class | Authorship concern | Required action |
|---|---|---|---|
| 1 | Bare/minimally characterized driver source | Historical author, license, or source relationship may require direct verification | Preserve existing notices; inventory provenance before making project claims. |
| 1 | Simple generated/definition/header material without sufficient provenance context | File form may be normal while authorship evidence remains thin | Identify generator/source and retain applicable license information. |
| 2 | Ordinary driver with incomplete local provenance record | Original author may be clear elsewhere but not yet registered locally | Cross-check notices, Git history, SPDX, and subsystem records. |
| 2 | Compatibility/wrapper/legacy driver with limited documentation | Technical form may explain simplicity; maintenance history may be incomplete | Record subsystem role, upstream origin, and current maintenance state. |
| 2 | Security-sensitive small file whose simplicity masks high responsibility | Small size does not imply low importance | Review interfaces, invariants, security assumptions, and provenance separately. |

**Important:** no author name should be invented from topic, style, reputation, account presence, revenue, or similarity to other work. Names should come from reliable source evidence.

## Grade 3–5 rule

For grade **3 or above**, the relative subsystem `README.md` should include an authorship concern section identifying:

1. original/upstream authorship as supported by evidence;
2. applicable license/SPDX state;
3. source/provenance basis;
4. MEARVK modification or maintenance status;
5. unresolved questions;
6. verification/concord status.

## Ethical-control interpretation

US-oriented ethical control here means responsible software stewardship: lawful reuse, accurate attribution, license compliance, security responsibility, privacy protection, reproducibility, and evidence-based claims. It does not constitute government certification, court authority, citizenship determination, or legal clearance.

## Privacy

Detailed personal, psychological, confidential legal, contractual, payment, security-sensitive, or private correspondence material should not be placed in public driver documentation merely to strengthen a grade. Public records should contain the minimum information necessary for provenance and reproducibility; sensitive evidence should remain appropriately restricted.

## Reuse and control

MEARVK may control compilation, configuration, testing, deployment, patching, security review, and maintenance of incorporated drivers. Such operational control does not transfer upstream copyright or authorship.

Where a file is genuinely modified by MEARVK, the project modification should be documented without removing historical notices. Original MEARVK implementation may carry a MEARVK authorship notice when appropriate.

## Current project reference

**Max Rupplin — MEARVK LLC — 2026**  
Project developer / maintenance attention for Ubuntu Determinant.

This record does not replace upstream authorship, licensing, or other rights.

## Completion register

The intended completion state is one subsystem `README.md` for every driver directory and subdirectory, plus source-level provenance for significant `.c` and `.h` files. The actual repository tree is authoritative for what has been completed; this master document must not claim documentation exists where it has not yet been created.
