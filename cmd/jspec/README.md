# JSpec Professional Series

JSpec is the proposed execution motor for the `/cmd` desktop/executable series. Its first implementation targets Linux and is deliberately native C/C++, with a future Windows PE/COFF implementation planned around the same contract.

## Design intent

The project preserves the familiar pro-code executable model: an executable has an identity, receives an argument vector and environment, executes under the operating system, and returns a result. JSpec adds a controlled pre-launch layer without taking ownership of the program's cause.

The central rule is **JSpec surrounds execution; it does not replace the target**. The target remains authoritative. JSpec validates the target, establishes the launch contract, and then delegates to the operating system's native loader.

## Linux v1

Linux is the first platform because the native contract can be kept small and explicit:

- ELF identification
- executable and regular-file validation
- optional working-directory preparation
- native `execve()` handoff
- pass-through argument intent
- no shell reinterpretation
- no privilege escalation
- minimal launch overhead

The launcher is designed to sit beneath a desktop `.desktop` entry or above an ordinary shell command. A future desktop shell can provide the visual **cool/calm** layer, including bounded movement and theme-controlled color, but presentation must never affect execution semantics.

## Windows direction

Windows is the second platform target. The same JSpec contract maps to PE/COFF and `CreateProcessW()`. The `.jspec` specification therefore describes `.exe` identity and execution as a cross-platform contract while the native implementation remains platform-specific.

## JDK/JVM relationship

JSpec is intended to be usable beside a JDK/JVM and, where appropriate, as a native layer at the boundary between the runtime and operating system. Linux v1 does not require Java. This keeps the lowest execution layer deterministic and permits higher-level JVM integration later.

## Desktop arming

The conceptual desktop sequence is:

`desktop activation -> JSpec preflight -> OS loader -> cmd target`

A hover/proximity effect may visually **arm** the interface, but actual execution is armed by activation, not pointer position. This avoids making program correctness dependent on UI timing.

## Files

- `exe.jspec` — executable and JSpec contract.
- `jspec.h` — C ABI shared by C and C++.
- `jspec.c` — Linux native implementation.
- `jspec.cpp` — C++ professional wrapper.

The next implementation stage should add a small `/cmd/jspec` build target and a Linux `.desktop` launcher, followed by tests for ELF validation, argument preservation, exit-code behavior, and launch overhead.
