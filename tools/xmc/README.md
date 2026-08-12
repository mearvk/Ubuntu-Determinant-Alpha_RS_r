# xmc — XML Metaclass Compiler

**Version:** 1.0.0  
**Edition:** Galactic Cherry Marvell 98  
**Target:** SecureJDK 28 (.xclass format)  
**License:** GPL-2.0 WITH Classpath-exception-2.0

## Overview

`xmc` compiles Java (`.java`) or Python (`.py`) source files into the SecureJDK 28 XML class file format (`.xclass`). The `.xclass` format carries rich metadata beyond binary `.class`: provenance, design intent, security grades, dependencies, quality assessments, and contracts.

## What xmc Produces

For each class found in source, xmc generates an `.xclass` file containing:

1. **Identity** — structural position (name, superclass, interfaces, methods, fields, weight)
2. **Quality Democracy** — democratic structural assessment (voice, representation, participation, transparency, accountability)
3. **Quality Woman** — feminine excellence assessment (care, integrity, nurture, resolve, grace)
4. **Design** — INT tier (1-4) and wet structure (module, demange, demart, artistry)
5. **Security** — trust grade and classload grade
6. **Conduct Frame** — international law basis for the compilation
7. **Provenance** — compiler identity, installer tech signature, SHA-256 integrity

## Relationship to javac

`xmc` studies the same structural concerns as `javac` from OpenJDK 28 (`src/jdk.compiler/share/classes/com/sun/tools/javac/main/`):

- Source parsing and structural extraction (parse phase)
- Class declaration recognition (enter phase)
- Security: bounded input, no symlink following, no hostile constructs
- No code execution or side effects during compilation

Unlike `javac`, which emits bytecode (`.class`), `xmc` emits metadata (`.xclass`). The `.xclass` output feeds directly into the SecureJDK 28's `jvmINTLoader` for structural placement at runtime.

## Conduct Frames

The xmc binary adjusts quality scoring based on international law or conduct frame:

| Frame | Code | Emphasis | Legal Basis |
|-------|------|----------|-------------|
| US Standard | `us` | Voice, participation, liberty | US Constitution, Bill of Rights |
| European Union | `eu` | Transparency, accountability, data protection | EU Charter, GDPR, Treaty of Lisbon |
| International | `intl` | Balanced universal assessment | UN Charter, Universal Declaration |
| Commonwealth | `cw` | Representation, accountability, precedent | Common Law, Magna Carta, Westminster |

## INT Tiers & Wet Structure

Each class is assigned to one of four tiers (mirroring `jvmINTLoader.hpp`):

| Tier | Name | Inference Rule |
|------|------|----------------|
| 1 | Module System | Default; self-supporting foundation |
| 2 | Setup Technology | Lateral count > 3; connective tissue |
| 3 | Modulator Technocator | INT complexity > 50 or artistry > 70 |
| 4 | Technology Mind Control | INT complexity > 80; executive concern |

Wet structure scores (0-100 each) describe internal character:
- **module** — foundation weight, self-support
- **demange** — pre-artistic form, the seed (abstracts, interfaces)
- **demart** — chemistry before wisdom, preparation (complex reactions)
- **artistry** — full craft expression, realized form (balanced, elegant)

## Usage

```bash
xmc MyClass.java                          # Java → .xclass (US Standard)
xmc --frame=eu UserService.java           # EU conduct frame
xmc --frame=intl --verbose App.py         # International + details
xmc --tier=3 --color=blue ArtEngine.java  # Force tier/color
xmc --sign-as="mearvk - Installer Tech 2" Main.java
xmc --no-sign --dry-run Test.py           # Parse without output
```

## Build

```bash
make          # Build xmc binary
make test     # Smoke test (Java + Python)
make install  # Install to /usr/local/bin/
```

## Security Concerns (from javac study)

| Concern | Mitigation |
|---------|-----------|
| Hostile source constructs | Parse only structure; no expression evaluation |
| Symlink attacks on input | `O_NOFOLLOW` + `lstat()` check |
| Symlink attacks on output | `O_NOFOLLOW` on output fd |
| Unbounded input | 16 MB source file cap |
| Memory exhaustion | Bounded class/method/field counts |
| Output tampering | SHA-256 signature in provenance block |
| DTD/ENTITY injection | Output contains no DTD/ENTITY/SYSTEM |
| Path traversal | Source/output paths validated |

## Files

```
tools/xmc/xmc.c      - Compiler source (~1800 lines, C11)
tools/xmc/Makefile    - Build/install/test
tools/xmc/README.md   - This file
```

## Integration

Output `.xclass` files are consumed by:
- `jvmINTLoader` — structural placement at tier level
- `classLoadGuard` — quality and quantity gate at load time
- `xmlConfigReader` — validates .xclass integrity at JVM startup
- `jvmCodex` — registers as codex entries if shape qualifies

## Copyright

Copyright (C) 2026 MEARVK LLC  
Author: Maximilian Eric Alexander Rupplin von Keffikon  
Installer Tech: mearvk - Installer Tech 2
