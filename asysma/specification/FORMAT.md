# ASYSMA Format v0.1

The rehearsal format uses a ZIP-compatible container with a required manifest and signature material.

```text
package.asysma
  META-INF/ASYSMA.MF
  META-INF/ASYSMA.SIG
  META-INF/ASYSMA.PUB
  payload/...
```

## Required manifest fields

```text
format=ASYSMA-0.1
package-id=<stable identifier>
package-version=<semantic version>
entrypoint=<relative path>
target-platform=<linux|windows|macos|any>
target-architecture=<x86_64|aarch64|any>
minimum-java=<major version>
permissions=<comma-separated ordered set>
```

The manifest also contains one `sha384` record for every payload file. Paths are UTF-8, forward-slash separated, relative, normalized, and must not contain `..` or absolute roots.

## Native execution model

The current model assumes a **desktop OS is already running**. The `.asm` source is assembled into x86-64 machine code and then linked/packaged as the native executable expected by the target OS. The CPU executes the resulting machine code; it does not execute `.asm` source text.

The common CPU-level assumption is the Intel/AMD x86-64 ISA. OS-specific execution remains dependent on each platform's native ABI, executable format, loader, process model, and security boundary:

```text
x86-64 ISA
    ↓
OS ABI
    ↓
ELF / PE / Mach-O
    ↓
OS process loader
    ↓
x86-64 machine-code entrypoint
```

Ubuntu White Direct is the project's proposed common native API/contract above these OS-specific mechanisms. It must not be confused with a universal OS ABI.

## Startup measurement

The native assembly footprint should be sufficient to measure startup quality on Linux, Windows, and macOS. Initial measurements should include CPU/architecture identification, native entry timing, OS identity, ABI/loader handoff, capability discovery, and successful transition to the next native layer. The assembly should remain minimal and auditable.

## Signature

The signature covers the canonical manifest bytes plus the ordered payload digest records. The public key is carried separately and is itself authenticated by the deployment trust policy.

The package must fail closed on malformed fields, duplicate paths, digest mismatch, unsupported algorithms, or signature failure.
