# XMC + ASYSMA Developer README

## Purpose

This document is the focused README for the repository's **XMC + ASYSMA** application pipeline. It complements the main repository README without replacing its broader system documentation.

The design goal is:

> **One developer model, explicit execution boundaries, auditable outputs.**

## Output model

XMC and the Java toolchain address three related artifacts:

```text
Java source ──→ javac ──→ .class
source      ──→ XMC  ───→ .xclass
.class + .xclass + declared native payload(s)
                 │
                 ▼
              ASYSMA
                 │
                 ▼
              .asysma
```

The unified `xmc-asysma` driver is intended to produce `.xclass` and `.asysma` together, avoiding an unnecessary output-mode decision during normal development.

## XMC

XMC is the repository's XML Metaclass Compiler under `/tools/xmc/`. Its direct compiler artifact is `.xclass`. The ASYSMA driver adds the application-container packaging stage.

XMC is a developer/compiler component. It does **not** replace the operating-system loader and does not imply that one native machine-code payload can execute unchanged on Linux, Windows, and macOS.

## ASYSMA

ASYSMA is the common application/container format. A package declares its startup model explicitly:

```text
JAVA
NATIVE
NATIVE_THEN_JAVA
```

It may contain Java classes, XMC metadata, policy/integrity metadata, and explicitly declared native payloads.

The native representation remains platform-specific:

```text
Linux   → ELF
Windows → PE/COFF
macOS   → Mach-O
```

A portable ASYSMA package may therefore carry separately declared native payloads and select the compatible one after host and architecture validation.

## Transbound Execution Contract

The **Transbound Execution Contract (TEC)** defines the permitted boundary between native and managed execution.

```text
ISOLATED
NATIVE_TO_JAVA
JAVA_TO_NATIVE
```

A package does not gain bidirectional native/Java access merely because both components are present. The permitted direction must be declared by policy.

Each transfer is represented by a bounded record:

```text
version
operation
permissions
input_size
output_size
```

The current reference implementation uses:

```text
TEC_VERSION   = 1
MAX_TRANSFER  = 65536 bytes
```

The native reference implementation is in:

```text
/tools/xmc/tec/tec.h
/tools/xmc/tec/tec.c
```

The Java-side model is:

```text
/tools/xmc/tec/tec-java.java
```

These are prototype contract components. Runtime integration must validate every transfer before crossing the boundary.

## Unified native + Java execution

A combined application is modeled as:

```text
                 Application.asysma
                         │
                    Flow policy
                         │
              ┌──────────┴──────────┐
              ▼                     ▼
        Native C/C++              Java
              │                     │
              └─────── TEC ─────────┘
```

The preferred startup sequence for a native-bootstrapped Java application is:

```text
OS loader
   ↓
ASYSMA bootstrap
   ↓
integrity / bounds checks
   ↓
host + architecture profile
   ↓
TEC policy validation
   ↓
native bootstrap
   ↓
NATIVE_TO_JAVA handoff
   ↓
SecureJDK 28
   ↓
Java application
```

For a `JAVA_TO_NATIVE` application, native entry is permitted only after the manifest and TEC policy authorize that transition.

For `ISOLATED`, no native/managed transfer is allowed.

## Host selection

The XMC/ASYSMA prototype records the native executable family for the build host:

```text
Linux   → ELF
Windows → PE/COFF
macOS   → Mach-O
```

It recognizes the principal prototype architectures:

```text
x86-64
AArch64
```

Host identification is descriptive and is **not by itself authorization to execute**. Runtime policy remains authoritative.

## SecureJDK 28 relationship

SecureJDK 28 is the reference managed runtime for the ASYSMA Java path.

The intended division of responsibility is:

```text
XMC          compiler / metadata generation
ASYSMA       application packaging / policy description
native       platform-specific bootstrap or native component
TEC          native ↔ Java boundary contract
SecureJDK 28 managed Java execution
OS loader    platform-native executable loading
```

This keeps the layers auditable instead of making XMC responsible for the operating system's loader or process model.

## Security position

The current implementation is a **prototype/rehearsal**, not a production security certification.

Before production use, the design requires at least:

- canonical manifest encoding;
- cryptographic integrity records;
- package/signature verification;
- deterministic package generation;
- authenticated native-to-Java handoff;
- complete offset and size validation;
- robust platform-payload selection;
- explicit privilege and capability policy;
- reliable process termination and OS security integration.

In particular, an ASYSMA package must never execute a native payload merely because that payload is present in the container.

## Relevant files

```text
/tools/xmc/
/tools/xmc/xmc.c
/tools/xmc/xmc-asysma
/tools/xmc/asysma_manifest.c
/tools/xmc/tec/
/tools/xmc/ASYSMA_INTEGRATION.md
/asysma/format/ASYSMA_FORMAT.md
```

The format specification is the authoritative description of the ASYSMA container. This README is the concise developer-facing guide to the XMC integration.
