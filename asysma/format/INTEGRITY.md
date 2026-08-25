# ASYSMA Integrity v1

Integrity verification occurs before the Java payload is started.

```text
container bytes
   -> bounds validation
   -> manifest verification
   -> native payload verification
   -> Java/application payload verification
   -> signature/authenticity policy
   -> execute
```

## Requirements

- Hashes cover the exact byte ranges declared by the container.
- Integer overflow and out-of-range sections are rejected.
- Signature verification, where required by policy, occurs before native payload execution.
- Verification failure is terminal for that launch attempt.
- Integrity does not imply authorization; ASYSMA policy remains a separate decision.

The cryptographic algorithm is deliberately a profile choice rather than hard-coded into the conceptual format. A concrete SecureJDK 28 release profile must name its required algorithms and key representation.
