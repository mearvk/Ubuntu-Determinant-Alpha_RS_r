# ASYSMA Policy v1

ASYSMA policy evaluates measured host state before SecureJDK 28 starts.

## Decision sequence

```text
native handoff valid
    -> host profile available
    -> package integrity valid
    -> required capabilities satisfied
    -> authorization policy satisfied
    -> START
```

## Host observations

The policy may consider:

- architecture
- OS family
- OS version
- available memory
- available storage
- adapter status
- package capabilities

Unknown observations are not automatically failures. Policy may require a specific value when the application needs it.

## Safety

Policy does not elevate privileges or disable operating-system security controls. The operating system remains authoritative over process lifetime, permissions, filesystem access, and termination.
