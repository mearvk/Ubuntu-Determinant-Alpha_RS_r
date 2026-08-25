# ASYSMA / JDesk Bridge

## Purpose

This document defines the first concrete application of the ASYSMA `NATIVE_THEN_JAVA` model to the existing JDesk desktop implementation.

JDesk already has a native component and a Java application layer. ASYSMA therefore acts as a packaging and execution contract around the existing architecture rather than replacing it.

## Existing implementation boundary

```text
userland/jdesk/native
        |
        v
native launcher / JNI support
        |
        v
userland/jdesk/src/us/mearvk/jdesk/JDeskApplication.java
        |
        v
JavaFX desktop
```

The native implementation must remain responsible only for platform-specific bootstrap and native services. The Java layer remains responsible for the desktop application.

## ASYSMA execution

```text
OS native loader
      |
      v
ASYSMA native bootstrap
      |
      v
host profile
      |
      v
integrity / policy
      |
      v
SecureJDK 28
      |
      v
JDeskApplication
```

## CPU baseline

The current JDesk native build uses x86-64-v3 optimization. ASYSMA must therefore distinguish:

```text
x86-64 baseline
x86-64-v2
x86-64-v3
x86-64-v4
```

The ASYSMA bootstrap should use the most conservative supported baseline and perform capability selection before choosing an optimized JDesk native payload. A package must never execute instructions unsupported by the host CPU.

## Java discovery

The ASYSMA Java bridge should prefer the configured SecureJDK 28 runtime. If runtime discovery is necessary, it should follow the existing JDesk discovery contract while retaining explicit policy and integrity checks.

## Entry declaration

The initial JDesk ASYSMA manifest should conceptually contain:

```text
entry_type = NATIVE_THEN_JAVA
native_bootstrap = present
native_architecture = x86-64
java_runtime = SecureJDK-28
java_entry = us.mearvk.jdesk.JDeskApplication
icon_family = CMD
icon_revision = four-trimmed-transparent-v2
```

The concrete class name is subject to the final JDesk build/package structure.

## Safety rules

1. Do not replace the operating system loader.
2. Do not elevate privileges as part of the bridge.
3. Do not disable OS security controls.
4. Verify package bounds before reading payloads.
5. Verify native payload integrity before execution.
6. Check CPU capabilities before optimized native execution.
7. Treat Java runtime selection as an explicit policy decision.
8. Keep native and Java responsibilities separated.
9. Preserve normal OS process termination semantics.
10. Fail closed when a mandatory contract is unsupported.

## Relationship to XMC

If an XMC compiler/packager is introduced, JDesk is an appropriate first application target because it exercises both sides of the ASYSMA model:

```text
Java classes
     +
native component
     +
manifest / integrity metadata
     |
     v
XMC / ASYSMA packager
     |
     v
JDesk.asysma
```

XMC should package existing native and Java outputs initially rather than silently generating machine code without an explicit compiler specification.
