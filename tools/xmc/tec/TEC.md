# Transbound Execution Contract (TEC)

TEC defines the boundary between native C/C++ execution and managed Java execution inside an ASYSMA application.

## Initial flow modes

```text
NATIVE_TO_JAVA
JAVA_TO_NATIVE
ISOLATED
```

The package manifest must explicitly declare the permitted direction. Unlisted transitions are denied.

## Transfer record

Every transition carries a bounded record:

```text
version
operation
permissions
input_size
output_size
```

The prototype bounds each input and output transfer to 64 KiB. This is an initial safety boundary, not a claim that every application should use this limit.

## Execution model

```text
ASYSMA
  |
  v
Flow policy
  |
  +--> native bootstrap -- TEC --> Java
  |
  +--> Java -- TEC --> native
  |
  +--> isolated component
```

Native-to-Java is the preferred first startup path. Java-to-native is an explicitly permitted secondary path. Bidirectional execution is not implied merely because both directions are implemented.

## Safety properties

- Version is mandatory.
- Unknown flow values are rejected.
- Null transfer records are rejected.
- Transfer sizes are bounded before crossing the boundary.
- The contract carries operation and permission metadata.
- The contract does not expose native object layouts or arbitrary pointers.
- Normal OS process termination remains effective.

## C and Java implementation

`tec.h` / `tec.c` provide the native validation ABI.

`tec-java.java` provides the managed-side transfer model.

The next integration stage is to connect these records to the ASYSMA manifest and native-to-Java bridge. Until that integration is complete, TEC should be treated as a prototype contract rather than a complete security boundary.
