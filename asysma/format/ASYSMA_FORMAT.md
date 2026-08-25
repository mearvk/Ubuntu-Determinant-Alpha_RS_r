# ASYSMA v1 Format

## Purpose

ASYSMA is a versioned application/container format for a small native bootstrap, host observation, integrity metadata, policy, and a managed Java payload.

The initial runtime target is x86-64 Intel/AMD on Linux, Windows, and macOS, with SecureJDK 28 as the reference Java runtime.

## Layout

```text
Header
Manifest
Integrity descriptor
Native platform payload(s)
ASYSMA policy
Java/application payload
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
icon_family
icon_revision
```

## Runtime sequence

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

## Compatibility

Format, Direct interface, bootstrap, and Java bridge versions are independent. A reader must reject unsupported mandatory features rather than guessing their meaning.
