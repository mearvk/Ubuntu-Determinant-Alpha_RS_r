# JDesk ASYSMA Build Plan

This is the next implementation layer after the JDesk ASYSMA bridge contract.

## 1. Inputs

```text
JDesk Java classes
JDesk native sources
SecureJDK 28
CMD-origin icon assets
ASYSMA manifest
```

The first implementation should package existing build products rather than introduce a new native compiler.

## 2. Build stages

```text
native source
   -> platform native build
   -> architecture/capability labeling

Java source
   -> javac
   -> .class

classes + native payload + manifest + icons
   -> ASYSMA packager
   -> JDesk.asysma
```

## 3. Runtime validation

The launcher must validate, in order:

1. ASYSMA magic/version.
2. Header bounds and integer ranges.
3. Manifest entry type.
4. Host architecture.
5. Native CPU capability requirements.
6. Payload integrity.
7. SecureJDK 28 availability/policy.
8. Native-to-Java handoff metadata.
9. Java entry point.

A failed mandatory check stops that launch attempt.

## 4. CPU dispatch

JDesk's existing optimized native build must be treated as an optimized target, not as the universal x86-64 baseline.

The ASYSMA package may eventually contain multiple native variants:

```text
native/x86-64
native/x86-64-v2
native/x86-64-v3
native/x86-64-v4
```

The bootstrap selects only a variant supported by the current CPU and policy.

## 5. Java handoff

The native layer must pass a narrow, documented handoff structure to the Java bridge. It should contain only information required by the runtime, such as:

```text
ASYSMA format version
package identity
host-profile result
selected native variant
Java runtime requirement
Java entry name
resource root
```

It must not become an uncontrolled general-purpose native API.

## 6. Installation

The initial installation path remains compatible with the existing JDesk installer. ASYSMA installation may add:

```text
JDesk.asysma
SecureJDK-28 association
icon registration
desktop launcher
```

The installer must not require administrator/root privileges unless the selected installation scope explicitly requires them.

## 7. Test matrix

Initial test targets:

| Platform | Native representation | Managed runtime |
|---|---|---|
| Linux x86-64 | ELF | SecureJDK 28 |
| Windows x86-64 | PE/COFF | SecureJDK 28 |
| macOS x86-64 | Mach-O | SecureJDK 28 |

Apple Silicon is intentionally outside the first x86-64 profile and should receive a separate architecture profile rather than being mislabeled as x86-64.

## 8. Completion criteria

The first implementation is complete when a generated JDesk ASYSMA package can:

- be structurally parsed;
- reject malformed headers safely;
- select a supported native payload;
- verify integrity;
- evaluate execution policy;
- locate the required SecureJDK 28 runtime;
- execute the native bootstrap;
- transfer to JDesk's Java entry;
- start the desktop application;
- terminate normally under OS process control.

This document describes the implementation plan; it does not claim that the binary packer or native ASYSMA launcher is complete yet.
