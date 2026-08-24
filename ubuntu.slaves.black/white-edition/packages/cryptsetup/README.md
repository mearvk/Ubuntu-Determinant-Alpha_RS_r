# White Edition — `cryptsetup`

**Status:** W2 — Storage security review

`cryptsetup` is a security-critical storage boundary. White Edition work must prioritize data safety, interoperability, recovery, and explicit operator understanding.

## Objectives

- Preserve compatibility with established LUKS and dm-crypt formats.
- Make encryption and recovery states understandable.
- Avoid unsafe defaults that can make recovery or key management ambiguous.
- Keep key material out of logs and ordinary diagnostics.
- Document backup/recovery requirements before destructive operations.

## Native implementation

`cryptsetup` is primarily C. Native changes require a concrete correctness, security, or compatibility justification and focused tests. Established cryptographic implementations should be reused rather than introducing new primitives.

## Evidence

- LUKS creation/open/close tests;
- encrypted-volume read/write tests;
- wrong-key and failure-path tests;
- metadata inspection tests;
- recovery-path verification;
- upgrade compatibility tests;
- key-material exposure review.

## GUI relationship

A JavaFX administration interface may display volume state and guide supported operations, but destructive storage operations require explicit confirmation and must use the underlying supported tools rather than bypassing them.

## Economy

Record storage-tool startup cost, resident memory, and material impact on encryption/decryption throughput. Data integrity and security take priority over small resource savings.

**Stewardship:** Max Rupplin — MEARVK LLC
