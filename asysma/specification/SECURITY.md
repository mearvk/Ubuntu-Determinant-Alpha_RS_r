# ASYSMA Security Profile

## Trust boundary

The verifier is the trust boundary. It must never execute an entrypoint while package authenticity or payload integrity is unknown.

The native launcher is an additional trust boundary between the desktop OS process and the ASYSMA/Java control plane. It should be minimal, measurable, and auditable.

## Known architecture

For the first target, the CPU is Intel/AMD x86-64. The CPU executes machine-code instructions defined by the x86-64 ISA. It does not execute `.asm` source files. Assembly source must be assembled and linked into the native executable format recognized by the host OS.

The common CPU foundation is therefore the ISA, not a universal operating-system interface. Linux, Windows, and macOS retain different ABIs, executable formats, loaders, system APIs, process models, and privilege boundaries.

```text
x86-64 ISA
    ↓
OS ABI
    ↓
ELF / PE / Mach-O
    ↓
OS loader
    ↓
process
```

Ubuntu White Direct is the proposed project-level common native contract over these differences. It is an abstraction, not a replacement for the OS ABI.

## Desktop boundary

The initial launcher operates after the OS and desktop are running. It is not a firmware bootloader and must not assume pre-OS privileges.

```text
Desktop
  ↓
native launcher
  ↓
Direct API / native adapter
  ↓
ASYSMA verification
  ↓
controlled load
```

## Required controls

- canonical manifest encoding;
- SHA-384 payload digests;
- Ed25519 signature verification for the rehearsal profile;
- explicit algorithm identifiers;
- explicit platform and architecture targeting;
- path traversal rejection;
- duplicate-path rejection;
- size limits before extraction;
- no implicit privilege escalation;
- least-privilege permission declarations;
- deterministic verification result;
- audit-friendly result records;
- minimal native launcher footprint;
- explicit separation of CPU/ISA assumptions from OS-specific ABI code;
- startup measurement and reproducible native-launch tests;
- fail-closed handling of unsupported OS/ABI/architecture conditions.

## Permission model

Permissions are declarations, not grants. The host policy decides whether a requested permission is allowed.

Suggested vocabulary:

```text
filesystem.read
filesystem.write
process.inspect
process.control
network.client
system.install
system.reconfigure
native.execute
```

`system.reconfigure`, `system.install`, `process.control`, and `native.execute` are privileged capabilities and should require an explicit administrative policy.

## Native concerns

The assembly layer must remain small. It should establish only the state and measurement needed to enter the native contract safely. It should not become a second operating system or contain unnecessary application policy.

Native startup measurements should cover, where supported:

- CPU/architecture identity;
- entry/start timing;
- OS identity/version;
- ABI/loader handoff;
- native capability availability;
- privilege state;
- successful transition to the next layer.

Results should be treated as observations with evidence, not assumptions.

## Threat model

The rehearsal must test malicious archives, path traversal, duplicate manifest records, corrupted payloads, wrong signatures, unsupported algorithms, platform mismatch, architecture mismatch, oversized extraction, interrupted installation, unexpected native startup conditions, and ABI/API incompatibility.

No `.asysma` format can make an untrusted host trustworthy. Security depends on the package, native launcher, verifier, platform, key-management policy, and operating-system boundary together.
