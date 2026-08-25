# ASYSMA v1 Format

## Purpose

ASYSMA is a versioned application/container format for a small native bootstrap, host observation, integrity metadata, policy, and a managed Java payload.

The initial runtime target is x86-64 Intel/AMD on Linux, Windows, and macOS, with SecureJDK 28 as the reference Java runtime.

## Execution model

An ASYSMA package may be:

```text
JAVA
NATIVE
NATIVE_THEN_JAVA
```

`JAVA` starts the managed Java entry through SecureJDK 28.

`NATIVE` starts an explicitly declared native entry.

`NATIVE_THEN_JAVA` starts the native bootstrap first, establishes the Direct/host-profile and policy boundary, and then transfers execution to the Java entry.

The native component is always explicit in the manifest when present.

## Compiler and packaging relationship

The repository contains an existing XMC implementation at `tools/xmc/`.

XMC is the **XML Metaclass Compiler**. Its documented target is the SecureJDK 28 `.xclass` format. `tools/xmc/xmc.c` is the compiler source and the repository also contains a built `xmc` executable.

The compilation relationship is:

```text
Java source -> javac -> .class
source      -> XMC  -> .xclass
.class + .xclass + metadata + native payload(s)
                         -> ASYSMA packager -> .asysma
```

Compilation, metadata generation, packaging, and execution remain separately auditable stages even when the developer toolchain produces both `.xclass` and `.asysma` outputs automatically.

## Layout

```text
Header
Manifest
Integrity descriptor
Flow/TEC policy
Native platform payload(s), when declared
ASYSMA policy
Java/class payload(s), when declared
Optional XMC/.xclass metadata
Optional resources
```

The container does not replace ELF, PE/COFF, or Mach-O. A platform-native loader selects the appropriate native representation before the common ASYSMA execution contract begins.

## Header

The fixed header identifies:

- magic = `ASYSMA`
- format version
- format revision
- target architecture
- flags
- manifest offset/size
- integrity descriptor offset/size
- payload offset/size

All offsets and sizes must be bounds-checked before use.

## Manifest

The manifest is declarative and may contain:

```text
format
version
architecture
minimum_direct_revision
native_bootstrap
host_profile
java_runtime
entry_type
java_entry
native_entry
native_architecture
xmc_metadata
icon_family
icon_revision
tec_version
flow_policy
max_transfer
```

`entry_type` is one of:

```text
JAVA
NATIVE
NATIVE_THEN_JAVA
```

A `NATIVE_THEN_JAVA` package must explicitly identify both its native component and Java entry.

## Transbound Execution Contract

Every native/managed boundary is governed by the **Transbound Execution Contract (TEC)**. The package must declare the permitted direction rather than inferring it from the presence of components.

Initial flow modes are:

```text
ISOLATED
NATIVE_TO_JAVA
JAVA_TO_NATIVE
```

Unlisted transitions are denied. Bidirectional operation is not implied merely because both endpoint implementations exist.

The TEC transfer record is:

```text
version
operation
permissions
input_size
output_size
```

The current reference implementation uses `TEC_VERSION = 1` and an initial maximum transfer size of 64 KiB per input/output field. Implementations must reject an unsupported version, unknown flow, null transfer record, or transfer exceeding the declared bound.

The native reference implementation is `tools/xmc/tec/tec.h` and `tools/xmc/tec/tec.c`; the Java representation is `tools/xmc/tec/tec-java.java`.

### Recommended startup flow

```text
OS loader
  -> ASYSMA bootstrap
  -> integrity verification
  -> host/CPU profile
  -> TEC flow-policy validation
  -> native bootstrap
  -> TEC NATIVE_TO_JAVA handoff
  -> SecureJDK 28
  -> Java application
```

For a `JAVA_TO_NATIVE` application, the native boundary may be entered only after the manifest and TEC policy authorize that direction.

For `ISOLATED`, no cross-boundary transfer is permitted.

## Runtime sequences

### JAVA

```text
OS loader
  -> ASYSMA launcher
  -> integrity/policy
  -> SecureJDK 28
  -> Java application
```

### NATIVE

```text
OS loader
  -> native bootstrap
  -> Direct adapter
  -> host profile
  -> integrity/policy
  -> native application
```

### NATIVE_THEN_JAVA

```text
OS loader
  -> native bootstrap
  -> Direct adapter
  -> host profile
  -> integrity verification
  -> TEC policy
  -> SecureJDK 28
  -> Java application
```

## XMC metadata stage

When `.xclass` metadata is included, ASYSMA records its presence and integrity but does not silently reinterpret it as native machine code. SecureJDK 28 structural loaders remain responsible for the documented `.xclass` loading path.

XMC remains a compiler/metadata stage. It is not assumed to generate native machine code merely because an ASYSMA package also contains a native payload.

## Portability

A portable ASYSMA application may contain multiple declared native payloads:

```text
Linux   -> ELF
Windows -> PE/COFF
macOS   -> Mach-O
```

The runtime selects a compatible payload using explicit OS, architecture, and capability metadata. A package must never execute a native payload merely because it is present.

"Any OS" therefore means a common ASYSMA application contract across supported operating systems, not identical native instructions on every platform.

## Initial icon identity

The first ASYSMA release uses the original CMD icon family:

`/icons/cmd/cmd/cmd-icon-four-trimmed-transparent-v2.zip`

CMD was the original program identity; ASYSMA initially inherits that icon set.

## Security

Unknown host observations are distinct from native contract failures. No ASYSMA component may elevate privileges, disable OS security controls, or create an unkillable process.

Native payloads must validate all offsets, sizes, architecture fields, and handoff structures before use. TEC records must be validated before crossing an execution boundary.

Native execution must never be silently inferred from the presence of Java classes or `.xclass` metadata. A native component is an explicit package capability and must pass the applicable integrity, architecture, and policy gates.

The current ASYSMA writer remains a prototype. Production readiness additionally requires canonical manifest encoding, cryptographic integrity records, signature/policy verification, authenticated native-to-Java handoff, deterministic package generation, and complete multi-platform payload selection.

## Compatibility

Format, Direct interface, bootstrap, TEC, Java bridge, XMC metadata, and SecureJDK versions are independent. A reader must reject unsupported mandatory features rather than guessing their meaning.
