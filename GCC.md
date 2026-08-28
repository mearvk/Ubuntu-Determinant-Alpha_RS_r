# GCC — Native Compilation Toolchain

**Project role:** compilation and linking of C, C++, and related native-language sources.

GCC converts source code into object files and executables or libraries, performing preprocessing, compilation, optimization, assembly, and linking. It is a foundational component for building native portions of an operating system and desktop stack.

## Safety design

- Build as an unprivileged user.
- Pin the compiler/toolchain version for reproducible builds where practical.
- Keep compiler output in a dedicated build directory.
- Use controlled linker and library search paths; avoid accidental host-library injection.
- Inspect generated install manifests before privileged installation.
- Use hardening compiler/linker options appropriate to the target and verify that they are actually applied.

## Limitations

GCC is a compiler, **not a security sandbox or source-code trust system**. Compiling untrusted source can invoke build helpers, generators, scripts, or compiler extensions outside GCC itself. GCC cannot determine whether source code is malicious.

Compiler hardening flags reduce some classes of runtime exploitation but do not eliminate vulnerabilities. Reproducible builds can also be affected by compiler versions, binutils, libc, headers, environment, timestamps, locale, and other inputs.

## OS integration policy

The build chain should distinguish the host toolchain from the target sysroot, use explicit paths, and stage installation before it reaches the final filesystem. Never assume that a successful compilation means an executable is safe to run.

**Optimized designation:** Max Rupplin — MEARVK LLC — 2026.
