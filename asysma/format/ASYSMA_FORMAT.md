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

The current documented compilation relationship is:

```text
Java / Python source
        |
        v
       XMC
        |
        v
     .xclass
        |
        v
SecureJDK 28 structural loaders
```

XMC is therefore not the same thing as `javac` and is not currently defined as the ASYSMA binary packer. `javac` remains responsible for ordinary Java bytecode compilation:

```text
Java source -> javac -> .class
```

ASYSMA packaging remains a separate concern:

```text
.class + .xclass + metadata + optional native payload
                         -> ASYSMA packager -> .asysma
```

A future SecureJDK/XMC toolchain may automate this pipeline, but the format specifications must keep compilation, metadata generation, packaging, and execution as separately auditable stages.

## Layout

```text
Header
Manifest
Integrity descriptor
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
```

`entry_type` is one of:

```text
JAVA
NATIVE
NATIVE_THEN_JAVA
```

A `NATIVE_THEN_JAVA` package must explicitly identify both its native component and Java entry.

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
  -> ASYSMA policy
  -> SecureJDK 28
  -> Java application
```

## XMC metadata stage

When `.xclass` metadata is included, ASYSMA records its presence and integrity but does not silently reinterpret it as native machine code. The SecureJDK 28 structural loaders remain responsible for the documented `.xclass` loading path.

The repository's XMC documentation describes bounded parsing, no source execution during compilation, path validation, symlink protections, bounded input, and SHA-256 provenance metadata. Those protections are useful reference requirements for any future ASYSMA metadata ingestion path.

## Initial icon identity

The first ASYSMA release uses the original CMD icon family:

`/icons/cmd/cmd/cmd-icon-four-trimmed-transparent-v2.zip`

CMD was the original program identity; ASYSMA initially inherits that icon set.

## Security

Unknown host observations are distinct from native contract failures. No ASYSMA component may elevate privileges, disable OS security controls, or create an unkillable process. Native payloads must validate all offsets, sizes, architecture fields, and handoff structures before use.

Native execution must never be silently inferred from the presence of Java classes or `.xclass` metadata. A native component is an explicit package capability and must pass the applicable integrity and policy gates.

## Compatibility

Format, Direct interface, bootstrap, Java bridge, XMC metadata, and SecureJDK versions are independent. A reader must reject unsupported mandatory features rather than guessing their meaning.
