# ✦ THE ROYAL PROGRAMME OF AMERICAN USERLAND ✦

## A–Z Reference for the United States Market and American Houses

**Max Rupplin — MEARVK LLC**  
**Repository:** `Ubuntu.Determinant.Beta.Restricted`  
**Reference:** `ubuntu.slaves.black`  
**Status:** Foundational planning document  
**Audience:** United States users, households, developers, administrators, educators, and small organizations

---

## Frontier Statement I — A Useful American Userland

This document establishes a careful A–Z catalogue for a practical United States userland: software that is understandable at the desktop, respectful of the household, useful to an individual, and capable of growing into a serious professional environment. The intention is not to imitate an operating system by collecting programs indiscriminately. It is to establish a small, coherent body of applications whose interfaces, configuration, documentation, security posture, and installation experience behave as one family.

## Frontier Statement II — The House as a First-Class Computer

The principal unit of consideration is the American house: one person, a family, a home office, a workshop, a schoolroom, or a small organization sharing a computer and its services. Programs should therefore be modest in their demands, clear about what they change, reversible where practical, and comfortable for ordinary users. A household should be able to understand what is installed, what is running, what information is stored, and what requires administrative authority.

## Frontier Statement III — The United States Market as a Quality Standard

For the United States market, the project should favor durable software, plain language, accessibility, predictable configuration, transparent licensing, sensible security boundaries, and compatibility with common American computing environments. “Market” here means practical adoption and trust rather than commercial pressure: a program earns its place by being useful, maintainable, legible, and responsible. The catalogue therefore distinguishes foundational applications from optional tools and does not require every letter to become a large program.

## Frontier Statement IV — One Family, One Standard

Every developed graphical userland application should share the project's common visual language: a cool white JavaFX presentation, restrained typography, consistent spacing, clear status indicators, accessible controls, and an appropriate desktop icon. The graphical interface may operate the program itself, administer its configuration, explain its state, or provide a friendly front door to an otherwise command-line service. Native C/C++ components and Java components should have explicit boundaries, and security-sensitive facilities should prefer established system and JCA/JCE primitives over unaudited replacement cryptography.

---

# A–Z Programme

| Letter | Programme | Role | GUI Direction | Initial Status |
|---|---|---|---|---|
| **A** | **Archive** | Household and project archive management | JavaFX browser, restore and integrity view | Planned |
| **B** | **Backup** | Local, removable, and scheduled backup management | JavaFX backup plan and verification panel | Planned |
| **C** | **Console** | Friendly command and system console | JavaFX terminal/front-end | Planned |
| **D** | **Documents** | Local document creation, indexing, and organization | JavaFX document desk | Planned |
| **E** | **Editor** | General text/source/configuration editing | JavaFX editor | Planned |
| **F** | **Files** | Household file browser and transfer tool | JavaFX file manager | Planned |
| **G** | **Graphics** | Images, diagrams, and simple visual assets | JavaFX canvas/workbench | Planned |
| **H** | **Health** | System health, diagnostics, and maintenance—not medical care | JavaFX status dashboard | Planned |
| **I** | **Installer** | Installation, repair, configuration, and removal | JavaFX installer | In development |
| **J** | **Java** | Java/JDK administration and runtime management | JavaFX Java administration | In development |
| **K** | **Keys** | Cryptographic key and certificate administration | JavaFX key store interface | Planned |
| **L** | **Library** | Local software, source, documentation, and package catalogue | JavaFX library browser | Planned |
| **M** | **Monitor** | Processes, resources, services, and activity | JavaFX system monitor | Planned |
| **N** | **Network** | Network configuration and diagnostics | JavaFX network desk | Planned |
| **O** | **Office** | Household productivity suite entry point | JavaFX office launcher | Planned |
| **P** | **Packages** | Software/package inspection and management | JavaFX package manager | Planned |
| **Q** | **Queue** | Jobs, scheduled tasks, and deferred operations | JavaFX job queue | Planned |
| **R** | **Recovery** | Repair, rollback, and recovery assistance | JavaFX recovery console | Planned |
| **S** | **Security** | Local security posture and policy administration | JavaFX security centre | In development |
| **T** | **Telnet** | Legacy/service protocol administration and controlled access | JavaFX service interface | In development |
| **U** | **Updates** | Software, definitions, and configuration update management | JavaFX update centre | Planned |
| **V** | **Virtualization** | Virtual-machine and isolated workload management | JavaFX VM manager | Planned |
| **W** | **Web** | Local web services and browser-facing administration | JavaFX web service console | Planned |
| **X** | **eXchange** | Import/export, migration, and interoperability | JavaFX transfer wizard | Planned |
| **Y** | **Yield** | Resource, storage, and workload efficiency | JavaFX capacity dashboard | Planned |
| **Z** | **Zero** | Reset, cleanup, decommissioning, and secure-state preparation | JavaFX guided reset interface | Planned |

---

# Programme Design Rules

## 1. The Common GUI Contract

Each graphical application should use the same general visual contract:

- Cool white primary surface.
- Clean secondary panels with restrained contrast.
- Consistent application title, icon, menu, and status placement.
- Clear distinction between **Use**, **Configure**, **Inspect**, and **Repair** actions.
- Accessible keyboard navigation and readable control labels.
- No unnecessary animation or visual clutter.
- A desktop icon for applications intended for direct household use.
- A useful command-line entry point where the underlying program naturally supports one.
- A configuration screen that explains consequential changes before applying them.
- Consistent success, warning, and failure states.

The GUI is a common front door, not a requirement that every service become a graphical application internally.

## 2. Household Safety and Reversibility

Programs intended for ordinary users should make consequential operations explicit. Destructive operations should identify what will be affected, provide a confirmation boundary, and offer recovery where technically possible. Administrative operations should state when elevated authority is required. A household user should never have to infer whether a button means “inspect” or “change.”

## 3. Security Boundary

Security applications should expose state and policy without pretending that a visual interface itself makes an operation secure. Cryptography belongs behind reviewed interfaces and established primitives. The project may contain C and Java reference material for educational and integration purposes, but production security should use maintained implementations and system/JCA/JCE providers where appropriate.

## 4. American Market and Household Considerations

The catalogue is deliberately oriented toward broad United States use rather than a particular corporation, state, or political institution. It should accommodate:

- individual consumers;
- families and shared household computers;
- home offices and independent professionals;
- small businesses;
- schools and educational environments;
- developers and technical users;
- administrators maintaining modest deployments.

Programs should avoid assuming that every user has enterprise infrastructure, a dedicated administrator, unlimited storage, or constant connectivity.

## 5. Documentation Contract

Each mature programme should eventually have:

```text
<program>/
├── README.md
├── THEORETICAL.md       # when mathematics, security, or formal assumptions matter
├── *.hsss               # project theory/specification where appropriate
├── src/
│   ├── main/java/       # Java implementation
│   └── main/c/          # native implementation where required
├── scripts/
├── tests/
└── packaging/
```

The exact tree may vary by program, but documentation should remain discoverable and consistent.

---

# Relationship to `ubuntu.slaves.black`

`ubuntu.slaves.black` is principally an Ubuntu 22.04.3 LTS source archive and reconstruction area. Its existing documentation describes source packages distributed across four source discs, package inventories, extraction tooling, and reassembly scripts. This A–Z programme document does **not** replace that archive. Instead, it provides a human-facing architectural index for deciding which userland facilities should be developed or integrated from the available Ubuntu foundation.

The package archive and its `manifest.txt` should remain machine-oriented source inventory. This document is deliberately product- and user-oriented. A future reconciliation process should map each programme to relevant Ubuntu packages, existing project source, native dependencies, Java dependencies, tests, and packaging requirements.

---

# Development States

**Existing** — present and substantially usable.  
**In development** — active implementation exists or is being integrated.  
**Planned** — accepted into the A–Z programme but not yet implemented.  
**Reference** — documentation or source material exists for future integration.  
**Retired** — retained for historical compatibility but not recommended for new deployments.

These states should be kept honest. A proposal is not an implementation, and a source archive is not automatically a finished application.

---

# Quality and Stewardship

The governing principle is simple: **make the computer easier to understand without making it less capable.** The userland should feel composed rather than crowded. Each program should have a clear reason to exist, a known relationship to the operating system, a defined security boundary, and a maintainable path from source to installation.

The project should favor small, dependable pieces over novelty for its own sake. Where an existing Ubuntu, OpenJDK, JavaFX, POSIX, or established cryptographic facility already solves a problem well, integration is generally preferable to unnecessary reinvention. Where the project introduces something new, its purpose, assumptions, limitations, and maintenance responsibility should be written down.

For American households and the wider United States market, quality should ultimately appear as ordinary reliability: a clean installation, a familiar desktop, an understandable configuration screen, predictable updates, useful recovery, and software that remains respectful of the person sitting in front of the machine.

---

# Stewardship

**Max Rupplin — MEARVK LLC**

This document is a planning and architecture reference. It does not constitute a warranty, security certification, financial recommendation, medical guidance, governmental endorsement, or representation that every listed programme is complete or production-ready.

**Repository:** `mearvk/Ubuntu.Determinant.Beta.Restricted`  
**Section:** `ubuntu.slaves.black`  
**Document:** `PROGRAMS-A-Z.md`
