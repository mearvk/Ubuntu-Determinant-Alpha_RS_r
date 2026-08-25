# Ubuntu White Edition

## Ubuntu Determinant — Professional Systems Edition

**Repository:** `mearvk/Ubuntu.Determinant.Beta.Restricted`  
**Edition:** Ubuntu White  
**Status:** Experimental engineering / integration  
**Architecture focus:** x86-64 Intel/AMD, with platform-native support for Linux, Windows, and macOS where applicable  
**Managed runtime focus:** SecureJDK 28  
**Native/application bridge:** ASYSMA  

> **Ubuntu White is the professional presentation and engineering profile for the Ubuntu Determinant project: clear provenance, explicit authority boundaries, conservative native execution, documented build paths, and a clean separation between experimental concepts and established operating-system behavior.**

---

## 1. Executive Architecture

```text
                    UBUNTU WHITE
                         │
        ┌────────────────┼────────────────┐
        │                │                │
     Native            ASYSMA         SecureJDK 28
     OS layer          bridge          managed layer
        │                │                │
        └────────────────┼────────────────┘
                         │
                     JDesk / apps
```

The project separates four concerns:

1. **Ground** — operating-system and hardware facts.
2. **Native bridge** — explicit platform bootstrap and capability selection.
3. **Managed runtime** — SecureJDK 28 and Java applications.
4. **Application/service layer** — JDesk, domain services, and other userland programs.

The existing Total three-tier model remains a conceptual and implementation surface; it does not replace Linux kernel authority or normal operating-system security mechanisms.

---

## 2. Today's ASYSMA / SecureJDK 28 Update — 2026-08-25

ASYSMA is now documented as an explicit executable/container contract with three entry modes:

```text
JAVA
NATIVE
NATIVE_THEN_JAVA
```

### JAVA

```text
.asysma → integrity/policy → SecureJDK 28 → Java application
```

### NATIVE

```text
.asysma → native bootstrap → host profile → policy → native application
```

### NATIVE_THEN_JAVA

```text
OS loader
   ↓
ASYSMA native bootstrap
   ↓
host / CPU profile
   ↓
integrity + policy
   ↓
SecureJDK 28
   ↓
Java application
```

The ASYSMA container does **not** replace ELF, PE/COFF, or Mach-O. The operating system still performs normal native loading. ASYSMA supplies the common application-level contract after that platform boundary.

### Java compiler relationship

```text
Java source → javac → .class
                         │
                         ├── Java-only ASYSMA
                         │
native payload ──────────┤
                         ▼
                   ASYSMA packager
                         ▼
                      .asysma
```

`javac` remains a Java compiler. Native code is an explicit package component; it is never inferred merely from the presence of Java classes.

---

## 3. JDesk Integration

JDesk is the first concrete desktop application target for the `NATIVE_THEN_JAVA` ASYSMA model.

```text
OS native loader
      ↓
ASYSMA bootstrap
      ↓
CPU / host profile
      ↓
integrity / policy
      ↓
SecureJDK 28
      ↓
JDeskApplication
      ↓
JavaFX desktop
```

The existing JDesk native build uses x86-64-v3 optimization. Ubuntu White therefore treats x86-64-v3 as an **optimized capability target**, not as the universal x86-64 baseline. The runtime must select only a payload supported by the current CPU.

Initial platform representations are:

| Platform | Native representation |
|---|---|
| Linux | ELF |
| Windows | PE/COFF |
| macOS | Mach-O |

The first architecture profile is x86-64 Intel/AMD. Apple Silicon should receive a separate architecture profile rather than being mislabeled as x86-64.

The original CMD icon family is the initial ASYSMA/JDesk icon identity.

---

## 4. Installer Integration

The installer now has an explicit integration target for:

```text
SecureJDK 28
ASYSMA runtime
JDesk ASYSMA application
Desktop integration / icons
```

ASYSMA remains optional. A normal SecureJDK installation must remain useful without ASYSMA.

The installer must not silently execute an untrusted ASYSMA package. Native payload structure, architecture/capability requirements, integrity, and policy must be validated before execution.

Reference: `installer/ASYSMA_INTEGRATION_2026-08-25.md`.

---

## 5. XMC Status

The repository has been searched across the relevant Java/OpenJDK, native, kernel, and branch surfaces for `XMC`, `xmc`, and `XMCCompiler`.

**No verified XMC compiler class has been located in the current repository.**

Accordingly, Ubuntu White does not claim that an XMC compiler already exists. If an XMC component is subsequently identified, its first safe role should be ASYSMA packaging of existing Java and native build products before any claim of new machine-code generation.

---

# 6. Markdown Documentation — Ordered and Alphabetized

The `markdown/` directory is the project's documentary source set. The files below are presented alphabetically by filename, with a concise professional purpose statement.

| Order | Document | Role |
|---:|---|---|
| 01 | `BLACK.SLAVES.md` | Ubuntu source-package/source-distribution material and GPL-oriented source availability record. |
| 02 | `BUILD.md` | Full-system build prerequisites, build sequence, kernel/rootfs/ISO production. |
| 03 | `CERTIFICATES.md` | Project certificate and method assertions; retained as project documentation, not governmental certification. |
| 04 | `DOMAIN_SERVICES.md` | Common evidence/provenance adapter for domain applications and regulated service environments. |
| 05 | `FILESYSTEM.md` | Proposed `/usr`, `/user`, and `/deck` filesystem/user-space organization. |
| 06 | `GRAAL_SECURITY_CONCEPT.md` | Graal/SecureJDK Proffer security and semantic seed concepts. |
| 07 | `HSS_PREHEADER.md` | Language-neutral descriptive/evidentiary pre-header concept. |
| 08 | `LEGAL.md` | Project civic/legal-policy concept; not a substitute for applicable law or legal advice. |
| 09 | `LEGAL_NAMING_AND_SOURCE.md` | Naming discipline separating real governmental sources from project abstractions. |
| 10 | `MEARVK.md` | Project/persona narrative material; treated as non-technical documentation. |
| 11 | `PROFFER_FRAMING_SEED.md` | Compact semantic seed for the Proffer modeling framework. |
| 12 | `PROGRESS.md` | Engineering review and project-progress record. |
| 13 | `README.md` | Extended project documentation and historical technical overview. |

The source set is intentionally retained rather than silently rewriting historical material. Ubuntu White uses this index to distinguish **technical specification, build documentation, conceptual research, legal-policy material, and historical/project narrative**.

---

## 7. New ASYSMA Documentation Set

The current ASYSMA work is maintained separately from the older `markdown/` corpus so that the executable-format specification can evolve without rewriting historical documents.

```text
asysma/format/ASYSMA_FORMAT.md
asysma/format/MANIFEST.md
asysma/jdesk/ASYSMA_JDESK_BRIDGE.md
asysma/jdesk/JDESK_ASYSMA_MANIFEST.example
asysma/jdesk/JDESK_ASYSMA_BUILD_PLAN.md
asysma/jdesk/JDESK_ASYSMA_TEST_MATRIX.md
ASYSMA-1-2-3-4-2026-08-25.mmd
installer/ASYSMA_INTEGRATION_2026-08-25.md
```

These documents establish the current design record, manifest contract, JDesk bridge, build plan, validation matrix, and installer integration.

---

## 8. 1-2-3-4 Engineering Model

```text
1 — Native Foundation
    OS loader boundary and conservative native bootstrap

2 — Host and Integrity
    CPU / OS / memory / storage observation and package validation

3 — Execution Bridge
    JAVA / NATIVE / NATIVE_THEN_JAVA selection and handoff

4 — Java / Application
    SecureJDK 28 and the managed application
```

The dated engineering record is `ASYSMA-1-2-3-4-2026-08-25.mmd`.

---

## 9. Security Principles

Ubuntu White adopts the following engineering rules for native/runtime integration:

- Native execution is explicit.
- OS loaders retain platform authority.
- Package bounds are checked before payload use.
- Unsupported CPU features cause refusal rather than speculative execution.
- Integrity and authorization are separate concepts.
- Installation does not imply execution trust.
- Native-to-Java handoff uses a narrow documented interface.
- No ASYSMA component silently elevates privileges.
- Normal OS process termination remains effective.
- Unknown mandatory format features cause rejection rather than guessing.
- Experimental claims are labeled as experimental.
- Project-defined authorities are not represented as governmental authorities.

> **Description precedes execution; evidence precedes authority.**

---

## 10. Build and Release Discipline

The professional Ubuntu White workflow is:

```text
source
  ↓
review
  ↓
compile
  ↓
structural validation
  ↓
integrity validation
  ↓
platform validation
  ↓
package
  ↓
install
  ↓
runtime validation
```

The existing build documentation remains authoritative for the project's Linux image-building process. The ASYSMA documents govern the newer executable/container layer.

---

## 11. Scope and Status

Ubuntu White is an engineering edition, not a claim that every experimental component is production-ready. In particular, ASYSMA's binary packer, native bootstrap implementation, cryptographic profile, CPU-dispatch implementation, and complete cross-platform runtime require implementation and testing beyond the documentation layer.

The repository should distinguish three states clearly:

```text
KNOWN / IMPLEMENTED
DESIGNED / SPECIFIED
EXPERIMENTAL / PROPOSED
```

This distinction is part of the professional standard.

---

## 12. Primary References

- `README.md` — extended historical and technical project README.
- `markdown/` — ordered project documentation corpus.
- `asysma/format/` — ASYSMA executable/container specification.
- `asysma/jdesk/` — JDesk integration specification.
- `installer/` — installation contracts.
- `userland/java/openjdk-28-src/` — SecureJDK/OpenJDK 28 source area.
- `userland/jdesk/` — JDesk desktop implementation.

**Ubuntu White Edition — 2026-08-25**
