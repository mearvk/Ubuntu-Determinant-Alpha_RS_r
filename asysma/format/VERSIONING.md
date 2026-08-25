# ASYSMA Versioning v1

The following versions are independent:

```text
ASYSMA format version
Direct interface version
native bootstrap version
Java bridge version
SecureJDK version
```

A package may therefore evolve its runtime while retaining an older container format.

## Compatibility rules

- Major format incompatibility requires explicit reader support.
- Minor additions must be optional or explicitly negotiated.
- Unknown mandatory features cause a controlled refusal to execute.
- Readers must never guess the semantics of an unknown field or flag.
- The SecureJDK 28 integration identifies its Java runtime requirement separately from the ASYSMA format version.

The objective is long-lived interoperability through explicit contracts, not an assumption that today's executable remains valid forever.
