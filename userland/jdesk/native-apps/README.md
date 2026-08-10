# JDesk Native Application Launcher

Runs native binaries from all three major operating systems (Linux ELF, Windows PE, macOS Mach-O) under the JVM Memory Proxy governance layer. Desktop icons for core productivity applications appear on JDesk startup.

## Supported Binary Formats

| OS | Format | Detection | Execution Method |
|----|--------|-----------|-----------------|
| Linux | ELF 64-bit | `\x7fELF` magic | Direct exec under `java -memory-guard` |
| Linux | ELF 32-bit | `\x7fELF` magic | Direct exec under `java -memory-guard` |
| Windows | PE/PE32+ | `MZ` magic | Wine + `java -memory-guard` |
| macOS | Mach-O 64 | `\xFE\xED\xFA\xCF` magic | Darling + `java -memory-guard` |
| Any | Shell (#!) | `#!` shebang | Direct exec under `java -memory-guard` |

## Default Desktop Applications

| Icon | Application | Binary | Format | Approx Size |
|------|-------------|--------|--------|-------------|
| 📝 | Writer (Word Processor) | LibreOffice Writer | ELF (Linux native) | ~350 MB |
| 💻 | IDE | VS Codium (open-source VS Code) | ELF (Linux native) | ~300 MB |
| 🌐 | Browser | Chromium | ELF (Linux native) | ~180 MB |
| 🖥️ | Terminal | JDesk Terminal (built-in) | Java + JNI | ~2 MB |
| 📁 | Files | PCManFM-Qt (file manager) | ELF (Linux native) | ~45 MB |
| ⚙️ | Settings | JDesk Settings (built-in) | Java | ~1 MB |

## Disk Allocation

| Category | Allocation |
|----------|-----------|
| Linux native binaries | 900 MB |
| Windows PE binaries (Wine layer) | 450 MB |
| macOS Mach-O binaries (Darling layer) | 350 MB |
| Wine runtime | 400 MB |
| Darling runtime | 300 MB |
| Icon assets + metadata | 50 MB |
| Headroom / updates | 550 MB |
| **Total** | **3 GB** |

> **Note:** 2 GB is insufficient for all three OS native stacks. Base allocation increased to **3 GB** to accommodate Wine (~400 MB), Darling (~300 MB), and the native binaries with headroom for updates.

## Launch Flow

```
User double-clicks desktop icon
        │
        ▼
┌────────────────────────────────────┐
│ JDesk Icon Handler                 │
│ Reads .jdesk-app manifest          │
│ Detects binary format (magic bytes)│
└───────────────┬────────────────────┘
                │
                ▼
┌────────────────────────────────────┐
│ Format Router                      │
│ ELF → direct exec                  │
│ PE  → wine prefix + exec           │
│ Mach-O → darling prefix + exec     │
│ Script → interpreter dispatch      │
└───────────────┬────────────────────┘
                │
                ▼
┌────────────────────────────────────────────────────────────┐
│ java -memory-guard -Xguard:profile=<app-profile> <binary>  │
│                                                            │
│ Memory Proxy governs:                                      │
│   • RAM budget (per-app configured)                        │
│   • Disk I/O rate limiting                                 │
│   • CPU time accounting                                    │
│   • Thread/process count ceiling                           │
│   • Telemetry to JDesk status bar                          │
└────────────────────────────────────────────────────────────┘
```

## Application Profiles (jvm-config.xml)

Each desktop application has a tuned resource profile:

| Application | RAM Soft | RAM Hard | CPU | Threads | Disk Write |
|-------------|----------|----------|-----|---------|-----------|
| Writer | 512 MB | 2 GB | 80% | 32 | 200 MB/s |
| IDE | 1 GB | 4 GB | 90% | 128 | 500 MB/s |
| Browser | 1 GB | 4 GB | 90% | 256 | 200 MB/s |
| Terminal | 64 MB | 256 MB | 50% | 16 | 50 MB/s |
| Files | 128 MB | 512 MB | 40% | 16 | 100 MB/s |

## Cross-Platform Execution

### Windows Binaries (PE)
Wine provides Win32/Win64 API translation. The Memory Proxy wraps the Wine process itself, governing the Windows binary indirectly:
```
java -memory-guard -Xguard:profile=windows-app wine /path/to/app.exe
```

### macOS Binaries (Mach-O)
Darling provides macOS API translation (similar to Wine for Windows). Still experimental but functional for CLI tools and some GUI apps:
```
java -memory-guard -Xguard:profile=macos-app darling shell /path/to/app
```

### Native Linux (ELF)
Direct execution — the primary path. Full Memory Proxy governance with zero translation overhead:
```
java -memory-guard -Xguard:profile=writer /opt/jdesk/apps/libreoffice/soffice --writer
```

## Installation

```bash
cd userland/jdesk/native-apps
make install-linux       # Install Linux native applications
make install-wine        # Install Wine + Windows app support
make install-darling     # Install Darling + macOS app support
make install-icons       # Install desktop icons and manifests
make install-all         # Everything
```

## Files

```
userland/jdesk/native-apps/
├── README.md                       - This file
├── Makefile                        - Build/install targets
├── manifests/                      - .jdesk-app manifest files
│   ├── writer.jdesk-app
│   ├── ide.jdesk-app
│   ├── browser.jdesk-app
│   ├── terminal.jdesk-app
│   ├── files.jdesk-app
│   └── settings.jdesk-app
├── icons/                          - SVG desktop icons
│   ├── writer.svg
│   ├── ide.svg
│   ├── browser.svg
│   ├── terminal.svg
│   ├── files.svg
│   └── settings.svg
├── profiles/                       - Memory Proxy resource profiles
│   └── jdesk-apps.xml
├── launcher/
│   └── NativeAppLauncher.java      - Format detection + launch logic
├── wine/
│   └── install-wine.sh             - Wine installation script
└── darling/
    └── install-darling.sh          - Darling installation script
```

## License

GPL-2.0

## Copyright

Copyright (C) 2026 MEARVK LLC
Author: Maximilian Eric Alexander Rupplin von Keffikon
