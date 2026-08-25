# ASYSMA File Structure

```text
asysma/
├── README.md
├── specification/
│   ├── FORMAT.md
│   └── SECURITY.md
├── java/
│   └── src/main/java/com/mearvk/asysma/Inspector.java
├── packaging/
│   ├── jpackage/
│   └── native-image/
└── examples/
    └── minimal/
```

The resulting package is intentionally separated from platform executables:

```text
.asysma  -> signed common package
ELF      -> Linux launcher
PE       -> Windows launcher
Mach-O   -> macOS launcher
```

The package format is therefore stable across host platforms while the execution mechanism remains native to each OS.

## Rehearsal stages

Stage 1: inspect and verify.
Stage 2: package Java application.
Stage 3: generate platform launcher with `jpackage`.
Stage 4: optionally generate a native Java executable with Native Image.
Stage 5: exercise the package inside a VM.
Stage 6: test privileged installation only after verification tests pass.
