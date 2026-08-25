# C + Java Unified ASYSMA Experience

This example deliberately demonstrates both sides of the proposed single-application model.

```text
C native layer
     |
     | narrow ABI
     v
SecureJDK 28 / Java
     |
     v
ASYSMA application
```

The native example exposes only `asysma_native_start(uint32_t version)`. The Java example is intentionally independent of native object layouts.

A production bridge can use JNI or the Java Foreign Function & Memory API after the ABI contract is finalized.

## Two forms of experience

1. **Native-first:** native startup validates the host and hands off to Java.
2. **Managed-first:** Java starts normally and calls a deliberately bounded native service.

Both can eventually be packaged as one `.asysma`; neither requires merging native machine instructions with JVM bytecode into one instruction stream.
