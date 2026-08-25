# XMC / ASYSMA Integrated Pipeline

XMC now has an explicit driver for the complete developer-side packaging path.

```text
source
  |
  +--> xmc -----------------> .xclass
  |
  +--> ASYSMA manifest ------+
                              |
                              +--> TEC v1 policy
                              |
                              +--> host format/architecture
                              |
                              +--> SecureJDK 28 metadata
                              |
                              +--> optional native payload
                              |
                              v
                           .asysma
```

The `xmc-asysma` driver invokes XMC first and then creates the ASYSMA artifact automatically. No output-mode flag is required.

## Host formats

The manifest helper identifies the build host as:

- Linux: ELF
- Windows: PE/COFF
- macOS: Mach-O

Architecture is explicitly recorded, with x86-64 and AArch64 recognized by the prototype.

## TEC integration

The generated manifest records:

```text
tec_version=1
max_transfer=65536
```

The runtime must still perform the actual TEC validation before an execution boundary. The packaging step does not substitute for runtime enforcement.

## Important boundary

The current integration makes XMC a practical `.xclass` + `.asysma` developer workflow. It does not claim that XMC itself replaces the operating-system loader or that one native payload is executable on every OS.

A production multi-platform package must contain separately declared native payloads and select the compatible payload after host validation.
