# Total Native Interfaces

This directory contains the public C interfaces for the Total native moderator.

## First-edition interfaces

- `total_domain.h` — domain/evidence vocabulary shared by banking, hospitality, regulated adult services, and other regulated commerce adapters.
- `total_policy.h` — versioned policy-provider ABI. Policy decisions remain outside the privileged evidence representation.
- `total_input.h` — bounded startup input registry supporting 3–1000 configured input slots.

## Boundary rule

These headers describe mechanisms and contracts. They do not encode judgments about human worth, consent, or social status.

Evidence is not authority. A valid evidence record establishes that a structured assertion passed the native validation boundary; it does not by itself authorize a business transaction or human action.

## ABI discipline

Interfaces should remain small, versioned, explicit about ownership, and suitable for C callers. Implementations must document memory ownership and lifetime before exposing long-lived pointers across process boundaries.

The current first edition keeps the interfaces intentionally conservative. Stronger IPC, cryptographic verification, cgroup integration, and SecureJDK/Graal integration belong behind later versioned interfaces.
