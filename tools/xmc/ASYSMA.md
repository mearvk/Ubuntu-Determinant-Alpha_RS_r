# XMC → ASYSMA

XMC now has a defined packaging path for producing an `.asysma` container from its known outputs.

## Workflow

```text
source
  ├── Java source ──→ javac ──→ .class
  ├── XMC source ───→ xmc ────→ .xclass
  └── native source ───────────→ platform native artifact
                                  │
                                  ▼
                         XMC ASYSMA packager
                                  │
                                  ▼
                              .asysma
```

The `.asysma` file is a portable container. It is not itself a universal CPU instruction stream. The native payload remains platform-specific and the OS loader still loads the applicable ELF, PE/COFF, or Mach-O representation.

## Prototype packager

`asysma_pack.c` is the initial packaging companion to XMC. It accepts an explicit entry mode:

```text
JAVA
NATIVE
NATIVE_THEN_JAVA
```

Example:

```sh
./asysma_pack \
  --output JDesk.asysma \
  --entry NATIVE_THEN_JAVA \
  --java us.mearvk.jdesk.JDeskApplication \
  --xclass JDesk.xclass \
  --native jdesk-native
```

## Important status

This is a **prototype packaging writer**, not yet the final production ASYSMA implementation. The current writer deliberately has a simple container layout and does not yet implement the final canonical cryptographic integrity descriptor, signature policy, multi-platform payload table, or complete manifest schema.

Those are required before the format is considered production-ready.

## Any-OS objective

The goal is one `.asysma` application artifact that can be recognized on supported operating systems and then select an appropriate platform payload:

```text
                 JDesk.asysma
                      │
          ┌───────────┼───────────┐
          ▼           ▼           ▼
       Linux       Windows      macOS
        ELF         PE/COFF      Mach-O
          \           |           /
           └──── ASYSMA ─────────┘
                     │
                SecureJDK 28
                     │
                Java application
```

A future multi-payload implementation should put all supported native variants into the package and select them using explicit architecture and capability metadata. A package must never execute a native payload merely because it is present.
