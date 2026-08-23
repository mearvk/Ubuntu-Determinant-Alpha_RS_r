# JSpec Professional Series

JSpec is the execution motor for the `/cmd` desktop/executable series. Linux is the first native target, with Windows PE/COFF planned against the same contract.

## Professional executable architecture

The JSpec Professional model keeps the familiar native executable path while adding a deliberately small, controlled pre-run layer:

```text
                         JSpec Professional
                                │
                         desktop / shell
                                │
                           cmd icon/link
                                │
                                ▼
                         JSpec pre-runner
                                │
                                ▼
                            .alpha
                     JSpec executable identity
                                │
                    ┌───────────┴───────────┐
                    │                       │
                 Linux v1               Windows v2
                    │                       │
                  .elf                    .exe
                  (ELF)                 (PE/COFF)
                    │                       │
                    ▼                       ▼
               Linux OS loader       Windows OS loader
                 execve()             CreateProcessW()
                    │                       │
                    └───────────┬───────────┘
                                │
                                ▼
                          target program
                                │
                                ▼
                          cmd / result
```

The executable-family order is intentionally:

1. **`.alpha`** — JSpec Professional identity and pre-run contract.
2. **`.elf`** — Linux/Unix native executable family.
3. **`.exe`** — Windows PE/COFF executable family.

`.alpha` does not replace the native binary format. On Linux v1 it is an ELF executable carrying the `.alpha` filename identity. The OS therefore retains its established loader while JSpec and the desktop linking system share a higher-level executable identity.

## `.alpha` native executable

The JSpec Professional executable identity is **`.alpha`**. On Linux v1, `.alpha` is not a second binary container: it is a normal **ELF executable carrying the `.alpha` filename identity**. This is deliberate. The OS retains its established executable loader while JSpec gains a distinct executable family with minimal overhead.

The launch model is:

`cmd icon/link -> JSpec pre-runner -> .alpha -> native OS loader -> target`

This gives the JSpec interpretive/pre-runner and the desktop linking system a common identity while keeping the kernel path conventional. The `.alpha` launcher uses direct `execve()` on Linux and does not invoke a shell.

## Design principles

- preserve cause and target identity
- preserve argv, environment, working directory, stdio, and result semantics
- keep the native representation congruent with the host OS
- minimize startup work and resident state
- fail closed on an invalid target
- keep presentation separate from execution correctness

## Weight and performance

`.alpha` deliberately avoids a custom binary wrapper around ELF. That removes a second loader and avoids duplicated headers or a persistent runtime. The first launcher is a small C program compiled directly to ELF. JSpec can therefore inspect the file as an ELF executable and the desktop system can treat it as a normal executable target.

## Cool/calm presentation

Desktop hover, proximity, color, and movement remain presentation features. They may visually arm the JSpec interface, but actual execution begins only on activation. No visual effect may alter scheduling, arguments, privileges, or executable semantics.

## Linux v1

- `.alpha` executable identity
- ELF-native binary
- direct `execve()` handoff
- argument/environment preservation
- no shell reinterpretation
- no privilege escalation
- minimal launch overhead
- C implementation with a C++-compatible JSpec ABI

## Windows direction

Windows is the next platform target. The same JSpec identity can be represented by a PE/COFF `.alpha` executable or by an `.alpha` launcher that resolves a PE `.exe`. The native handoff will map to `CreateProcessW()` while preserving the JSpec contract.

## JDK/JVM relationship

JSpec remains native at the OS boundary and does not require Java for Linux v1. A JDK/JVM can later consume the JSpec ABI or use `.alpha` as its executable boundary without replacing the native loader.

## Files

- `exe.jspec` — cross-platform JSpec executable contract.
- `alpha-format.md` — `.alpha` format and compatibility definition.
- `alpha.c` — minimal Linux `.alpha` executable source.
- `alpha.h` — `.alpha` identity constants.
- `Makefile` — builds `cmd.alpha` as an ELF executable.
- `jspec.h` — C ABI for JSpec preflight and handoff.
- `jspec.c` — Linux native JSpec implementation.
- `jspec.cpp` — C++ wrapper.

Build with `make` from `/cmd/jspec`. The produced `cmd.alpha` is an ELF executable whose filename supplies the JSpec `.alpha` identity.
