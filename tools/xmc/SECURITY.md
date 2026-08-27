# XMC Security Model

## Process execution

XMC does not construct shell command strings for compiler-driver execution or OS registration. Child programs are invoked with explicit argument vectors, and filesystem copying is performed through native APIs.

## Integrity versus authenticity

A SHA-256 digest is an integrity fingerprint. It can detect accidental or post-build modification when compared with a trusted expected digest, but it does **not** authenticate the signer because an attacker who can modify the artifact can recompute the digest.

XMC therefore uses the following terminology:

- **Digest:** SHA-256 fingerprint of an artifact or metadata input.
- **Signature:** cryptographic proof produced by a signing key.
- **Provenance:** metadata describing the source, compiler, build, and requested signer identity.

The current XMC implementation records SHA-256 metadata. A future authenticated-release mode should add a real public-key signature rather than treating the digest as a signature.

## User-scoped registration

ASYSMA desktop/MIME registration is intended to remain user-scoped. XMC must not request administrator/root privileges merely to register an application type.

## Resource limits

The compiler uses bounded source, class, method, field, dependency, name, and path sizes. These limits are part of the defensive parsing boundary and should be covered by regression tests.

## Metadata isolation

Quality and project-specific classification fields are metadata. They must not override parser correctness, memory safety, output-format validity, or security policy.

## Release requirement

Before a release is considered production-ready, the XMC quality workflow should pass:

1. strict warning compilation;
2. version consistency checks;
3. compiler smoke tests;
4. integrated-driver tests;
5. SHA-256 known-answer tests;
6. AddressSanitizer/UndefinedBehaviorSanitizer tests.
