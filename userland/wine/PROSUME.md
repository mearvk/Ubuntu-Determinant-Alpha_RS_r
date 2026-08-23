# Wine Prosume Compatibility Layer

## Purpose

This directory contains Wine 9.0 source plus a project-level compatibility model for **prosume** operation: proactively measuring what can be executed, translated, rebuilt, bridged, or otherwise made interoperable across Windows and Linux userland.

The model intentionally distinguishes **binary translation** from **source-level porting**. An ELF `.so` is not generally convertible into a Windows `.dll` by renaming or copying it. A useful `.so -> .dll` assessment must inspect architecture, ABI, exported symbols, dependencies, calling conventions, data-model assumptions, and required platform services. When those properties are incompatible, the correct result is a rebuild/port recommendation rather than a deceptive conversion claim.

Likewise, a Windows PE executable running under Wine should be evaluated against the same observable contract as a Linux executable running natively: process creation, arguments, environment, filesystem effects, IPC, networking, graphics/audio, exit status, signals/exceptions, child processes, and resource behavior. The implementation mechanism differs; the compatibility contract should remain comparable.

## Bidirectional processing directive

The Wine integration should reason in both directions:

1. **Windows program -> Linux host**: identify PE/COFF input, select the appropriate Wine/Winelib path, establish a controlled prefix, resolve Windows dependencies, execute, and measure observable behavior.
2. **Linux program -> Windows host**: identify ELF/Linux input and determine whether native Windows execution is possible through recompilation, Winelib-style adaptation, a compatibility subsystem, or a separate Linux environment/VM. Do not label an ELF executable as a Windows executable merely because Wine is present.
3. **Windows -> Linux programmable -> Windows**: permit a Windows workload to invoke a Linux-side programmable component when an explicit bridge exists, then return results across a declared IPC/API boundary. The bridge is part of the compatibility contract, not an implicit side effect.
4. **Linux -> Windows programmable -> Linux**: apply the same rule in reverse. Preserve provenance, identity, arguments, results, and failure semantics across the boundary.

The goal is not to make every binary run everywhere. The goal is to make the system **know what kind of interoperability is actually present**.

## Compatibility quality score

The project-level assessment uses five dimensions, each scored independently:

- **Format** — ELF vs PE/COFF and architecture compatibility.
- **ABI/API** — exported symbols, calling convention, data model, runtime ABI, and API availability.
- **Dependencies** — shared-library/DLL imports and whether equivalent providers exist.
- **Execution** — whether the target can actually be loaded and run through the selected mechanism.
- **Observability** — whether inputs, outputs, exit status, filesystem/process/network effects, and failures can be measured reproducibly.

A high score means the evidence supports the claimed execution path; it does **not** mean that an ELF `.so` has magically become a native Windows DLL.

## Installer / integration policy

Installation should be conservative and explicit. The compatibility tooling may inspect the host, locate Wine/Winelib, create or select a prefix, and produce a plan. System-wide installation, package-manager changes, registry changes, services, or elevated operations require explicit authorization by the calling installer layer.

The surrounding SecureJDK/installer work can consume the resulting assessment as a machine-readable gate before selecting an executable, library, service, scheduler, or cross-platform implementation.

## Existing Wine source

The bundled source identifies itself as Wine 9.0 and retains the upstream build model. The upstream README describes Wine as a loader plus Winelib, with Windows API calls implemented using Unix/X11/Mac equivalents.

This project layer therefore sits **beside** the Wine implementation rather than pretending that Wine itself is a universal binary converter.
