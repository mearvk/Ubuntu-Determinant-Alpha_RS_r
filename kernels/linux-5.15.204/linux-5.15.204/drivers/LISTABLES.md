# LISTABLES — Hardware Types, Categories & Review Vocabulary

**Project:** Ubuntu Determinant  
**Kernel:** Linux 5.15.204  
**Project attention:** Max Rupplin — MEARVK LLC — 2026  
**Method:** Presence Concord / Software Reuse & Control  
**Status:** DRAFT review taxonomy

## Purpose

`LISTABLES.md` provides a practical classification vocabulary for reviewing the Linux driver tree. It groups hardware by **category**, then asks whether the relationship is best understood inductively from observed evidence, or reducibly through a well-defined interface, specification, bus, protocol, or abstraction.

These are review categories, not claims that every device in a category is currently supported by this particular kernel configuration.

## Category / Induct / Reducible

| Hardware category | Typical examples | Induct — evidence gathered upward | Reducible — interface understood downward |
|---|---|---|---|
| CPU / processor | x86, ARM, RISC-V, PowerPC | boot behavior, features, topology | ISA, privilege levels, registers |
| Memory | DRAM, persistent memory, ECC | capacity, faults, NUMA behavior | physical addresses, memory-controller interfaces |
| Firmware / platform | ACPI, UEFI, device tables | discovered platform facts | standardized tables, methods, firmware ABI |
| PCI / PCIe | bridges, endpoints, expansion cards | enumeration and device IDs | config space, BARs, MSI/MSI-X, PCIe protocol |
| USB | hubs, keyboards, storage, cameras | descriptors, enumeration, hotplug | USB classes, endpoints, transfers |
| Storage | SATA, SCSI, NVMe, MMC, SD | media behavior, queueing, errors | command sets, block layer, controller registers |
| Network | Ethernet, Wi-Fi, WWAN | link state, packets, PHY behavior | network protocols, MAC/PHY interfaces, DMA |
| Graphics | GPU, display controller, framebuffer | modes, memory, rendering behavior | DRM/KMS, command interfaces, MMIO |
| Input | keyboard, mouse, touch, tablet | events and device capabilities | HID/input event models |
| Audio | HDA, USB audio, codecs | streams, rates, channels | ALSA interfaces, codec registers, DMA |
| Camera / media | sensors, capture devices, codecs | formats, streams, timing | V4L2/media APIs, bus protocols |
| Serial / terminal | UART, TTY, console devices | line behavior, interrupts | UART registers, TTY interfaces |
| I2C / SPI | sensors, controllers, EEPROMs | device responses and identification | bus transactions and controller APIs |
| GPIO | pins, expanders, controllers | pin state and events | GPIO descriptors and controller registers |
| Clock / reset | PLLs, clocks, reset controllers | frequency/state behavior | clock/reset frameworks and registers |
| Power | regulators, batteries, PMICs | voltage/current/thermal observations | regulator, power-supply and PM frameworks |
| Thermal | sensors, fans, thermal zones | temperature and cooling response | thermal framework and sensor interfaces |
| Watchdog | hardware watchdog timers | timeout/reset behavior | watchdog API and registers |
| RTC / time | real-time clocks | observed timekeeping behavior | RTC subsystem and device registers |
| Hardware security | TPM, secure elements | attestation/device behavior | TPM/TEE/security framework interfaces |
| Virtualization | virtio, hypervisor devices | guest-visible behavior | hypervisor ABI and virtio specifications |
| InfiniBand / fabric | HCAs, fabric adapters | link/fabric observations | RDMA/verbs and transport interfaces |
| CAN / field bus | CAN controllers | frames and bus state | CAN subsystem and controller protocol |
| Industrial I/O | ADC, DAC, sensors | measured channels and events | IIO subsystem and device registers |
| LEDs / indicators | status LEDs, triggers | state changes | LED class/trigger interfaces |
| HID / specialty input | gamepads, tablets, human interfaces | descriptors/events | HID reports and input subsystem |
| Bluetooth | controllers, radios | discovery, links, profiles | HCI and Bluetooth protocol layers |
| Fibre Channel | HBAs, storage fabrics | fabric/device discovery | FC transport and SCSI interfaces |
| Thunderbolt / USB4 | docks, displays, PCIe tunnels | topology and hotplug | tunnel/link management interfaces |
| FPGA / programmable logic | FPGA bridges, accelerators | programmed-device behavior | bus/register/DMA interfaces |
| Accelerator | AI, crypto, compute accelerators | workload/performance behavior | device APIs, command queues, DMA/MMIO |
| Miscellaneous | vendor-specific devices | observed device behavior | documented vendor ABI or kernel subsystem |

## Inductive review

**Induct** asks: *What can responsibly be concluded from observed evidence?*

Useful evidence includes:

- device enumeration;
- stable device identifiers;
- kernel logs;
- register behavior where documented;
- bus transactions;
- interrupt behavior;
- DMA behavior;
- power and thermal observations;
- reproducible test results;
- hardware documentation;
- firmware-provided information;
- controlled fault behavior.

Inductive conclusions should be proportional to evidence. A device appearing on a bus does not by itself prove that every feature is supported.

## Reducible review

**Reducible** asks: *Can the device relationship be reduced to a known, testable software interface?*

Examples include:

```text
PCI device -> PCI core -> driver -> subsystem -> userspace
USB device -> USB core -> class/device driver -> subsystem -> userspace
NVMe      -> PCIe/NVMe core -> block layer -> filesystem -> userspace
GPU       -> DRM/KMS -> driver -> display/rendering interfaces
Sensor    -> I2C/SPI -> IIO -> userspace
Audio     -> bus/controller -> ALSA -> userspace
```

A reducible relationship is valuable because it makes dependencies, tests, failure modes, and maintenance responsibilities clearer.

## Review grades

The repository's 1–5 scale applies to the **software artifact and evidence**, not to people.

| Grade | Review meaning |
|---|---|
| 1 | Bare: little characterization or evidence. |
| 2 | Basic: ordinary structure but meaningful gaps. |
| 3 | Sound: normal, understandable, responsible reuse/control. |
| 4 | Mature: strong provenance, design, testing, maintenance, and concord. |
| 5 | Clean/Superb: exceptional completeness and evidence. |

Ordinary hardware-driver forms normally remain between **1 and 3**. If the source form or provenance cannot reasonably be explained, the provisional grade should normally not exceed **2**.

## Rounding vocabulary for reviewers

Reviewers should use calibrated qualifiers rather than turning uncertain observations into absolute claims.

### Conservative adverbs / qualifiers

`approximately` · `apparently` · `arguably` · `broadly` · `currently` · `generally` · `likely` · `nominally` · `ordinarily` · `potentially` · `provisionally` · `reasonably` · `roughly` · `typically` · `usually` · `tentatively` · `comparatively` · `substantially` · `materially` · `conditionally` · `independently` · `explicitly` · `demonstrably`

### Evidence-strength phrases

`observed in source` · `supported by history` · `supported by SPDX` · `supported by documentation` · `reproduced in test` · `consistent with` · `appears compatible with` · `not yet established` · `requires verification` · `provisional pending evidence` · `not inferred from style alone` · `no independent evidence located`

## Noun corners — areas where review attention can turn

“ Noun corners” are the concrete subjects that can hide an otherwise reasonable-looking concern. Reviewers should check them deliberately rather than letting a polished source surface distract from them.

| Concern corner | Questions |
|---|---|
| **Origin** | Where did this code or hardware description originate? |
| **Authorship** | What evidence supports the credited author? |
| **License** | What license/SPDX expression actually applies? |
| **Interface** | What ABI/API/bus contract does the component rely upon? |
| **Dependency** | What other kernel or firmware component must exist? |
| **Privilege** | What authority does the driver exercise? |
| **Memory** | Does it allocate, map, DMA, or expose memory? |
| **Concurrency** | What locks, interrupts, workqueues, or races matter? |
| **Failure** | What happens when hardware disappears or misbehaves? |
| **Firmware** | What external firmware is assumed? |
| **Configuration** | Which Kconfig/build choices alter behavior? |
| **Persistence** | What state survives reboot, suspend, reset, or hotplug? |
| **Security** | What trust boundary does the driver cross? |
| **Privacy** | What device data can become observable to software/userspace? |
| **Update** | Who patches and tests the component now? |
| **Reproducibility** | Can the claimed behavior be built and tested again? |
| **Evidence** | What supports the reviewer's conclusion? |
| **Uncertainty** | What remains unknown? |
| **Control** | What does the project actually control? |
| **Concord** | Which neighboring components must remain compatible? |

## Distraction and angle control

A reviewer should actively separate **appearance** from **evidence**. The following are common distractions:

- an impressive author name without source evidence;
- a clean code style without complete provenance;
- a complex file that is merely generated;
- a simple file performing a security-critical operation;
- a familiar device name without confirmed feature support;
- repository ownership confused with copyright ownership;
- build success confused with runtime correctness;
- enumeration confused with full hardware support;
- historical authorship confused with present maintenance;
- project control confused with legal ownership;
- a numerical grade treated as a human judgment;
- a confident adjective substituting for a test result.

## Category-against-category review

When a driver belongs to multiple categories, review the intersection explicitly. Examples:

```text
PCI + Network       -> DMA, interrupts, firmware, packet path
USB + HID           -> descriptors, hotplug, input events
PCI + GPU           -> MMIO, DMA, memory management, display
I2C + Sensor        -> bus reliability, calibration, power, IIO
Storage + Security  -> data integrity, DMA, firmware, encryption
Power + Thermal     -> limits, governors, emergency behavior
Virtualization + IO -> guest/host boundary, DMA, device emulation
```

The intersection can be more important than either category alone.

## Ethical control

US-oriented ethical control means responsible software stewardship: accurate attribution, lawful reuse, security-aware maintenance, privacy protection, reproducibility, evidence-based claims, and appropriate handling of sensitive information. It is **not** a government certification, citizenship test, psychological ranking, or institutional endorsement.

## Project reference

**Max Rupplin — MEARVK LLC — 2026** records current project developer and maintenance attention. Historical upstream authorship and applicable rights remain preserved.

## Final reviewer rule

> **Classify first. Observe second. Reduce where the interface permits. Qualify uncertainty. Inspect the corners. Preserve attribution. Test the claim. Record what the project actually controls.**
