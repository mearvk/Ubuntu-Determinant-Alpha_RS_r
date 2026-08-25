# Common x86-64 Soft-Lock Rehearsal

The common bootstrap establishes a **cooperative desktop resident state** after the operating system has already loaded the application.

It is intentionally not a kernel lock, boot lock, persistence mechanism, or security-control bypass.

## Startup contract

```text
Desktop / OS
    ↓
native executable wrapper
    ↓
white_direct_lock_entry
    ↓
CPU evidence
    ↓
Direct adapter probe
    ↓
READY / UNSUPPORTED / FAILED
    ↓
cooperative RESIDENT state
    ↓
ASYSMA interpreter / Java executor
```

## Exception policy

The bootstrap does **not** attempt to suppress operating-system exceptions. It avoids deliberately generating exceptions for normal startup failure and returns explicit status codes. Native adapters must handle their own OS ABI and error reporting safely.

The process remains subject to ordinary OS termination, scheduling, memory protection, and security policy.

## "Lock" meaning

For this project, lock means that after successful startup the application enters a stable, cooperative desktop state until its normal release/termination path is requested. It does not mean an unkillable process, privileged persistence, desktop takeover, or bypass of user/administrator controls.

## Common-source goal

The assembly source contains no Linux, Windows, or macOS system calls. The executable wrapper supplies a tiny platform adapter. Therefore the same x86-64 assembly can be assembled as part of Linux ELF, Windows PE/COFF, or macOS Mach-O builds without embedding an OS identity in the common source.

## Handoff

Once the native state is `RESIDENT`, the remaining ASYSMA layer may inspect the host profile, apply package policy, and start the Java executor/JavaFX layer. The native bootstrap remains a small, auditable root-of-observation rather than becoming the application runtime.
