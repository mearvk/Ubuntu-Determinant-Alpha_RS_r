# Ubuntu White Edition — Developer Model — 2026-08-25

## Position

Ubuntu White Edition presents **SecureJDK 28 + XMC** as a complementary top-down developer toolchain for producing, packaging, and launching modern applications.

The supported artifact family is:

```text
.class
.xclass
.asysma
```

The important qualification is that `.asysma` is the portable application/container layer; native execution still requires an appropriate platform payload and host runtime. Therefore "any OS" means a common application format and execution contract across supported operating systems, not identical native instructions on every CPU/OS.

## Developer choices

### Java / SecureJDK 28

```text
Java source
    ↓
javac
    ↓
.class
```

SecureJDK 28 provides the managed Java runtime and ordinary Java compilation path.

### XMC

```text
supported source / metadata
    ↓
XMC
    ↓
.xclass
```

XMC is the repository's XML Metaclass Compiler and produces the documented `.xclass` metadata artifact.

### ASYSMA

```text
.class + .xclass + metadata + native payload(s)
                    ↓
              ASYSMA packaging
                    ↓
                 .asysma
```

The intended developer experience is that a normal XMC compilation workflow can make both the `.xclass` and corresponding `.asysma` artifact available without requiring the caller to choose an output mode.

## Native portability

The OS remains the authority for native loading:

```text
Linux   → ELF
Windows → PE/COFF
macOS   → Mach-O
```

An ASYSMA package may eventually contain multiple platform payloads. The runtime selects a declared compatible payload after architecture and capability checks.

## White Edition principle

**One developer model, explicit layers, auditable outputs.**

Compilation, metadata generation, packaging, integrity, native execution, and Java execution remain distinguishable stages. This makes the system easier to test, secure, and maintain over time.

## Status

This is the architectural position for 2026-08-25. The XMC ASYSMA writer is currently a prototype and requires completion of the production integrity/signature, manifest, multi-platform payload, and runtime validation layers before the `.asysma` format should be represented as production-ready.
