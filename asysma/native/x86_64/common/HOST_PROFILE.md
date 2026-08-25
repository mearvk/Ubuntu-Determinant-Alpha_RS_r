# Common x86-64 Host Profile

Layer 2 follows the native Direct startup handshake.

## Observations

The normalized host profile may contain:

- OS family
- OS version
- CPU architecture
- total physical memory
- available memory
- total storage capacity
- available storage capacity
- adapter status
- observation flags

The common assembly does not call Linux, Windows, or macOS APIs. The platform adapter supplies these observations through the common Direct contract.

## Failure policy

The host-profile layer distinguishes **unavailable information** from **unsafe execution**.

An unavailable OS version, memory statistic, or storage statistic is represented as unknown and may cause ASYSMA policy to refuse the next layer. It must not cause an uncontrolled native exception.

A malformed adapter pointer, invalid handoff, or failed native contract is a hard failure.

## Sequence

```text
Native startup
    ↓
Direct OS handshake
    ↓
Host profile
    ├── OS family
    ├── OS version
    ├── memory
    └── storage
    ↓
ASYSMA policy
    ↓
Java executor / JavaFX
```

## Platform implementations

Linux, Windows, and macOS adapters may use their normal documented native APIs. The common source remains OS-neutral. The adapter translates those platform-specific results into the normalized host profile.

## Security posture

The profile is observational. It does not elevate privilege, modify the operating system, disable security controls, or claim that a host is trusted merely because its identity is recognized.
