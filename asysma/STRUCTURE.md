# ASYSMA File Structure

```text
asysma/
├── README.md
├── specification/
│   ├── FORMAT.md
│   └── SECURITY.md
├── java/
│   └── src/main/java/com/mearvk/asysma/Inspector.java
├── native/
│   ├── x86_64/
│   │   ├── common/
│   │   ├── linux/
│   │   ├── windows/
│   │   └── macos/
│   └── direct/
│       ├── include/
│       └── adapters/
├── packaging/
│   ├── jpackage/
│   └── native-image/
└── examples/
    └── minimal/
```

## Native layer

The first native target is Intel/AMD x86-64. Assembly sources (`.asm` or `.s`) are source artifacts that are assembled into machine code. They are not distributed as though the operating system directly executes source text.

The native layer is deliberately divided into:

- **common x86-64:** CPU/ISA-level assumptions and startup primitives;
- **Linux:** ELF/ABI/native API implementation;
- **Windows:** PE/ABI/native API implementation;
- **macOS:** Mach-O/ABI/native API implementation;
- **Direct:** Ubuntu White's common project-level native contract.

The Direct contract should cover common operations without pretending that the three operating systems have identical ABIs or security models.

## Resulting package/executable relationship

```text
.asysma  → signed common package
ELF      → Linux native launcher
PE       → Windows native launcher
Mach-O   → macOS native launcher
```

The package format is stable across host platforms while the execution mechanism remains native to each OS.

## Desktop execution boundary

The current design starts **after the operating system and desktop have loaded**:

```text
OS boot → kernel → services → login → desktop → native launcher → ASYSMA → Java/application
```

This is not a firmware or pre-OS bootloader design. A future boot/recovery experiment must be specified separately.

## Rehearsal stages

Stage 1: inspect and verify.
Stage 2: establish x86-64 native startup and measurement.
Stage 3: implement Ubuntu White Direct contract.
Stage 4: implement Linux, Windows, and macOS adapters.
Stage 5: package Java application.
Stage 6: generate platform launcher with native tooling and/or `jpackage`.
Stage 7: optionally generate a native Java executable with Native Image.
Stage 8: exercise the package inside a VM.
Stage 9: test privileged installation only after verification tests pass.
