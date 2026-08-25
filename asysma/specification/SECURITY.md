# ASYSMA Security Profile

## Trust boundary

The verifier is the trust boundary. It must never execute an entrypoint while package authenticity or payload integrity is unknown.

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
- audit-friendly result records.

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

## Threat model

The rehearsal must test malicious archives, path traversal, duplicate manifest records, corrupted payloads, wrong signatures, unsupported algorithms, platform mismatch, architecture mismatch, oversized extraction, and interrupted installation.

No `.asysma` format can make an untrusted host trustworthy. Security depends on the package, verifier, platform, key-management policy, and operating-system boundary together.
