# THE UNITED STATES USERLAND PROGRAM

## A Considered Framework for Software, Markets, Houses, and Responsible Computing

**Max Rupplin — MEARVK LLC**

---

## 1. Purpose and Founding Consideration

The United States Userland Program is a considered framework for building useful, understandable, maintainable software for the United States market and for the houses, offices, institutions, and ordinary computing environments in which that software will operate. It is intended to bring together the practical disciplines of native computing, Java and JVM applications, graphical user interfaces, system utilities, security, documentation, and careful software stewardship under a coherent userland philosophy. The purpose is not to accumulate programs for their own sake. Each program should have a recognizable reason to exist, a clear boundary, a maintainable implementation, and a user-facing experience that respects the person operating it.

The US market provides the principal practical setting for this work. A healthy software environment should serve ordinary users as well as technically capable operators: it should install predictably, communicate its purpose plainly, expose configuration without unnecessary complexity, and fail in ways that are understandable. The concept of the “US House” is used broadly here to mean the ordinary place in which computing takes place—a home, office, workshop, classroom, laboratory, small business, institution, or other legitimate environment. The software should therefore be capable of being useful without requiring every user to become a system programmer.

A common presentation language is an important part of this program. Userland applications in development should, where appropriate, receive a common JavaFX graphical environment with a cool-white visual theme, consistent layout conventions, clear typography, and recognizable desktop icons. The GUI may administer the application, configure it, monitor it, or simply provide an accessible interface to its principal function. The interface should not obscure the underlying program. Rather, it should provide a clean meeting point between the system and its user.

The program also recognizes that good software is built in layers. Native C and C++ components may provide low-level facilities; Java and the JVM may provide higher-level applications and services; Ubuntu source material may provide reference implementations and system foundations; and documentation provides the human record by which the whole system remains understandable. These layers should remain identifiable. Security-sensitive functionality should favor established, reviewed primitives and system APIs over the presentation of newly written cryptographic code as if it were independently audited.

---

## 2. The US Market

The US market is diverse. It includes technically sophisticated organizations, small businesses, independent developers, schools, laboratories, public-serving institutions, and individual households. A useful userland should therefore emphasize interoperability, reliability, transparent configuration, sensible defaults, and long-term maintainability.

The market-oriented objective is not to imitate every existing application. It is to identify useful functions and implement them with enough discipline that they can become dependable components of a larger computing environment. Programs should be classified honestly as **Existing**, **In Development**, **Planned**, or **Proposed**. This distinction prevents a proposal from being mistaken for a completed capability.

A mature application should have a defined purpose, a build path, documentation, appropriate tests, a security boundary, and a user interface when a graphical interface materially improves its use. The presence of a GUI is not itself evidence of completeness; the quality of the underlying application remains primary.

---

## 3. US Houses and Everyday Computing

The house is an important test of software quality because it exposes a program to ordinary expectations. Users want applications that open, explain themselves, remember appropriate settings, recover from ordinary mistakes, and avoid demanding unnecessary technical knowledge.

For this reason, the userland should favor applications that can stand alone while also cooperating with neighboring programs. A file utility should understand files; a network utility should explain its connection state; an administrative application should distinguish configuration from operation; and a security application should clearly identify what it protects and what it does not.

Desktop icons should be treated as functional entry points rather than decoration. An icon should identify the program, launch the appropriate userland application, and lead to an interface whose behavior is consistent with the rest of the environment.

---

## 4. Common JavaFX User Interface Standard

Where a graphical application is appropriate, the preferred presentation is a **cool-white JavaFX interface** shared across the userland.

The common standard should provide:

- consistent window geometry;
- restrained white and light-gray surfaces;
- clear dark text;
- consistent menus and toolbars;
- predictable configuration panels;
- accessible status information;
- coherent icons;
- keyboard navigation where practical;
- sensible scaling for different displays;
- separation between ordinary operation and advanced administration.

The visual language should be calm rather than ornamental. The purpose of the interface is to make the application easier to understand and operate.

The same common layout conventions, fonts, spacing rules, control behavior, and visual hierarchy should be reused wherever practical. This creates a recognizable MEARVK userland rather than a collection of unrelated applications.

---

## 5. Desktop Presence

Applications intended for ordinary user operation should have a defined desktop integration strategy.

A desktop entry may provide:

1. direct launch of the application;
2. access to configuration;
3. access to documentation;
4. status or administration where appropriate;
5. an identifiable icon and application name.

Not every background service needs a desktop icon. A service that exists only to support another program should not be forced into a graphical model simply for consistency. The standard should be applied with judgment.

---

## 6. Native and Java Boundaries

The userland may contain both native and Java components.

**Native C/C++** is appropriate where direct operating-system integration, low-level performance, hardware interaction, or existing native interfaces make it useful.

**Java/JVM** is appropriate for portable applications, structured services, graphical programs, administrative interfaces, and components that benefit from the Java ecosystem.

The boundary between the two should be documented. Native code should not be duplicated unnecessarily in Java, and Java applications should not require native components when the standard Java platform already provides the required capability.

---

## 7. Security and Cryptographic Foundations

Security is a foundational property of the userland rather than an optional decoration.

The `/crypto/` catalog should organize major cryptographic families, including symmetric algorithms, asymmetric algorithms, key-agreement systems, signatures, and cryptographic hashes. Each documented algorithm should identify its historical or current status and distinguish educational/reference material from production-ready use.

For production applications, established Java Cryptography Architecture and Java Cryptography Extension facilities, operating-system primitives, and vetted cryptographic libraries should be preferred where available. New implementations of cryptographic primitives require particular caution because correctness of the mathematics does not by itself establish implementation security.

The theoretical record should explain the mathematics, assumptions, threat model, and intended relationship of each cryptographic class. Theory should support implementation rather than substitute for testing, review, or operational security.

---

## 8. Documentation and Chain of Development

Documentation should follow the software.

An application should have, as appropriate:

- `README.md`;
- implementation documentation;
- configuration documentation;
- build instructions;
- security notes;
- theoretical documentation where mathematics or formal assumptions are important;
- test information;
- a clear development status.

The Ubuntu source archive under `ubuntu.slaves.black` is valuable reference infrastructure. It contains Ubuntu 22.04.3 LTS source material organized across source-archive discs and provides package inventories and reconstruction/extraction tooling. It should remain distinguishable from the MEARVK application catalog.

The `manifest.txt` file should remain the machine-oriented inventory of archived packages, while the A–Z program document remains the human-oriented record of applications and development intent.

---

## 9. A–Z Program Register

The A–Z register is the principal planning device for the userland. Each proposed program should eventually have an identifiable name, purpose, status, implementation location, GUI decision, desktop decision, dependencies, and documentation path.

A letter does not require a program to be invented merely to fill an alphabetic position. Empty positions are preferable to unnecessary software. Where multiple names describe the same function, the strongest and clearest name should become the canonical entry and alternatives should be retained as aliases or historical notes when useful.

### A — Administration
System administration, configuration, service control, and userland management tools.

### B — Backup
Reliable local backup, restoration, verification, and backup-status utilities.

### C — Crypto
Cryptographic facilities, certificate/key management, and documented security interfaces.

### D — Desktop
Desktop utilities, application launchers, icon management, and common JavaFX desktop services.

### E — Editor
Text, source, configuration, and structured-document editing facilities.

### F — Files
File management, inspection, synchronization, archival, and storage utilities.

### G — Graphics
Image, rendering, visualization, and graphical inspection utilities.

### H — House
House-oriented administration and user-facing system tools for ordinary computing environments.

### I — Information
System information, diagnostics, inventory, and readable reporting.

### J — Java
Java/JVM utilities, JavaFX applications, runtime administration, and Java development tools.

### K — Keys
Key stores, credentials, certificates, signing material, and related security administration.

### L — Logs
Log viewing, filtering, inspection, rotation, and diagnostic presentation.

### M — Market
Market-oriented information and analytical utilities where appropriate to the project.

### N — Network
Network inspection, configuration, diagnostics, and ordinary network-user utilities.

### O — Operations
Operational tools for starting, stopping, monitoring, and maintaining applications and services.

### P — Packages
Package inspection, source management, installation support, and package-oriented tooling.

### Q — Query
Search, query, filtering, and structured information retrieval applications.

### R — Runtime
Runtime inspection, Java runtime management, native runtime utilities, and execution tools.

### S — Security
Security administration, policy inspection, auditing, and defensive system utilities.

### T — Terminal
Terminal-oriented utilities, shells, command interfaces, and terminal administration.

### U — User
User accounts, preferences, profiles, permissions, and user-facing configuration.

### V — Viewer
Document, log, image, source, and system-information viewing applications.

### W — Web
Web-facing utilities, local web interfaces, HTTP-related tools, and controlled browser-support facilities.

### X — X / Display
Display-server, graphics-session, X11, and graphical-environment utilities where required.

### Y — Yield / Utility
Small focused utilities whose value is practical rather than categorical; the entry should remain intentionally broad until a strong program is identified.

### Z — System / Zero-Latency Utilities
Specialized system utilities, performance tools, and programs that do not naturally belong elsewhere.

---

## 10. Program Classification

Every entry in the A–Z register should ultimately receive one of four statuses:

| Status | Meaning |
|---|---|
| **Existing** | Present and materially usable in the repository. |
| **In Development** | Code exists and is actively being developed. |
| **Planned** | Accepted as a future development target. |
| **Proposed** | A useful idea that has not yet been accepted as a development commitment. |

This classification is deliberately conservative. It protects the document from becoming a catalogue of claims rather than a reliable engineering record.

---

## 11. Program Quality Standard

A healthy userland program should answer five questions clearly:

1. **What does it do?**
2. **Who is it for?**
3. **How is it built and operated?**
4. **What does it depend upon?**
5. **How is its behavior documented and tested?**

A graphical application should additionally answer:

6. **Why does it need a GUI?**
7. **What does its desktop entry launch?**
8. **What configuration belongs in the GUI?**

Security-sensitive applications should answer additional questions concerning trust boundaries, key material, cryptographic primitives, data handling, and failure behavior.

---

## 12. Quality, Maintenance, and Restraint

The health of a software system is measured not only by what it contains but by what it can continue to maintain. Every new program adds source, documentation, testing, dependencies, packaging, security considerations, and future maintenance.

The program therefore favors **small, coherent applications with strong boundaries** over unnecessarily large applications that combine unrelated functions. Shared infrastructure should be reused when that improves consistency without creating hidden coupling.

Documentation should be manicured as carefully as code. Names should be stable. Sections should have a purpose. Examples should be truthful. Experimental ideas should be marked as experimental. Deprecated facilities should be labeled rather than silently presented as current recommendations.

---

## 13. Future Considerations

The A–Z register is intentionally a living architectural document. Programs may move from Proposed to Planned, from Planned to In Development, and from In Development to Existing. Some proposals may be removed when experience demonstrates that they are unnecessary.

The common JavaFX standard should evolve in parallel with the applications. As programs become concrete, shared controls, themes, icons, configuration components, accessibility conventions, and desktop integration should become reusable userland infrastructure rather than separately reinvented features.

The crypto catalog should likewise grow carefully. Major standardized algorithms and historically significant systems can be documented for reference, while production use should remain grounded in reviewed implementations and appropriate cryptographic APIs.

The ultimate measure is simple: a person should be able to encounter a MEARVK application, understand what it is, start it, use it safely, configure it when necessary, and find enough documentation to know where it belongs in the larger system.

---

## 14. Stewardship

This document describes a development direction, not a claim that every proposed application already exists. Its purpose is to provide a stable reference against which implementation can be measured.

The United States market and the US House are treated here as practical environments in which software should be useful, comprehensible, dependable, and respectful of the person using it. The userland should remain technically serious while retaining the ordinary qualities that make software livable: clarity, restraint, consistency, and care.

**Max Rupplin**  
**MEARVK LLC**

---
