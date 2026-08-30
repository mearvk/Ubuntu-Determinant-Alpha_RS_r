# Proffer

Proffer is a small native model/runtime component centered on a three-dimensional process space, memory-over-time behavior, process diagonals, and a SecureJDK/Graal awareness boundary.

## Current implementation

The native C implementation currently provides:

- `ProfferVec3`: a three-dimensional coordinate/vector.
- `ProfferMemoryObject`: an identified memory object with position, mass, and birth tick.
- `proffer_memory_fall()`: derives a time-relative position by decreasing `z` according to elapsed ticks.
- `ProfferProcessDiagonal`: represents a start point, end point, and process time.
- `proffer_diagonalize()`: packages RAM, processor, and process-time coordinates into a process diagonal.
- `ProfferAwareness`: an ABI/versioned feature declaration for the SecureJDK/Graal boundary.
- Awareness validation requiring 3D space, memory-time, process-diagonal, Fielter, and Proffer features.

## Source layout

```text
src/main/
├── c/
│   ├── net_universe.c
│   ├── net_universe.h
│   ├── proffer_model_notes.c
│   ├── securejdk_awareness.c
│   └── securejdk_awareness.h
├── cpp/
└── java/
```

The C layer is intentionally free of operating-system hooks and privilege escalation. The SecureJDK awareness code acts as a native model/ABI boundary rather than granting security authority.

## Model constants

The current awareness ABI is version `1` and uses `net_center = 2.0`. Required feature flags are represented as a bit mask.

## Status

This directory is a foundational implementation. The C model is small and explicit; C++ and Java integration points are reserved for subsequent runtime implementations.
