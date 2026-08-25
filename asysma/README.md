# ASYSMA Secure Package Foundation

This directory defines the first rehearsal implementation of the project-defined `.asysma` secure application/package format.

## Strategy

`.asysma` is a signed package and execution description, not a replacement for ELF, PE, or Mach-O. Native platform launchers remain platform-native; `.asysma` supplies the common package identity, manifest, policy, hashes, and signature boundary.

Execution is deliberately staged:

```text
read -> parse -> validate -> verify signature -> platform check -> policy check -> authorize -> load -> execute -> verify result
```

No privileged payload should execute before integrity and authenticity verification.

## Current rehearsal scope

1. Define a versioned manifest.
2. Define canonicalization rules.
3. Define SHA-384 content digests.
4. Define detached Ed25519 signatures for the rehearsal profile.
5. Define explicit platform/architecture and permission declarations.
6. Provide a Java 21 verifier/inspector.
7. Leave native launcher generation to `jpackage`/Native Image in the packaging layer.

This is an engineering foundation, not a claim of production security certification.
