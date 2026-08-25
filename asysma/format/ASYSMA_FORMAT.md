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

## Java compiler relationship

The ordinary Java compiler remains responsible for Java source to JVM class-file compilation:

```text
Java source -> javac -> .class
```

ASYSMA packaging is a separate concern:

```text
.class + metadata + optional native payload
                    -> ASYSMA packer -> .asysma
```

A future SecureJDK tool may provide a convenient source-to-ASYSMA workflow, but ASYSMA does not require `javac` itself to become a native compiler.

## Layout

```text
Header
Manifest
Integrity descriptor
Native platform payload(s), when declared
ASYSMA policy
Java/class payload(s), when declared
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

## Initial icon identity

The first ASYSMA release uses the original CMD icon family:

`/icons/cmd/cmd/cmd-icon-four-trimmed-transparent-v2.zip`

CMD was the original program identity; ASYSMA initially inherits that icon set.

## Security

Unknown host observations are distinct from native contract failures. No ASYSMA component may elevate privileges, disable OS security controls, or create an unkillable process. Native payloads must validate all offsets, sizes, architecture fields, and handoff structures before use.

Native execution must never be silently inferred from the presence of Java classes. A native component is an explicit package capability and must pass the applicable integrity and policy gates.

## Compatibility

Format, Direct interface, bootstrap, and Java bridge versions are independent. A reader must reject unsupported mandatory features rather than guessing their meaning.
