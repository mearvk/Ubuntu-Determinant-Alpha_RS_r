# Common x86-64 Native Bootstrap

`white_direct_bootstrap.asm` is the first common assembly source for Ubuntu White Direct.

## Design rule

The source contains **no Linux, Windows, or macOS system call** and no OS-name conditional branch. It operates at the common x86-64 instruction level and calls an opaque host adapter supplied by the native executable boundary.

The same assembly source can therefore be assembled into an object for each of the three target executable environments:

```text
                 common source
                       │
          ┌────────────┼────────────┐
          ▼            ▼            ▼
        ELF/ABI      PE/ABI       Mach-O/ABI
        Linux        Windows       macOS
          │            │            │
          └────────────┼────────────┘
                       ▼
                Ubuntu White Direct
```

The **source is common; the executable container and host adapter are necessarily platform-native**. A single byte-for-byte executable cannot normally be accepted as a native application by all three operating systems because Linux, Windows, and macOS use different executable formats and native process interfaces.

## Bootstrap responsibilities

The common assembly is intentionally small. It:

1. establishes a controlled x86-64 function frame;
2. records basic CPU evidence using `CPUID`;
3. validates the Direct adapter callback is present;
4. invokes the host adapter through the documented callback contract;
5. returns a deterministic success/failure result;
6. performs no privileged operation;
7. does not load or execute an ASYSMA payload.

## Why the OS is not encoded in this source

The OS cannot safely be inferred from a universal CPU instruction alone. OS interaction requires an OS-specific ABI, executable loader, and API/system-call convention. Linux and macOS use closely related System V AMD64 procedure-call rules, while Windows uses the Microsoft x64 ABI. citeturn0search0turn0search1turn0search2

Therefore the common assembly deliberately stops at a **host adapter contract**. The native launcher for each OS provides that adapter. This lets the common source remain unchanged while the operating system performs its normal executable loading and process setup.

## Rehearsal boundary

The intended sequence is:

```text
OS desktop already running
        ↓
OS loads native executable
        ↓
common x86-64 bootstrap
        ↓
CPU evidence
        ↓
OS-specific Direct adapter
        ↓
host evidence / capabilities
        ↓
ASYSMA verification
        ↓
next native or Java layer
```

This is a desktop native bootstrap, not a firmware or pre-OS bootloader.
