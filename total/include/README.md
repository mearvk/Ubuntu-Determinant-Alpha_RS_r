# Total Native Interfaces

This directory contains the public C interfaces for the Total native moderator.

## First-edition interfaces

- `total_domain.h` — domain/evidence vocabulary shared by banking, hospitality, regulated adult services, and other regulated commerce adapters.
- `total_policy.h` — versioned policy-provider ABI.
- `total_input.h` — bounded startup input registry supporting 3–1000 configured input slots.
- `total_statutory.h` — source metadata for statutes, regulations, judicial records, administrative records, contracts, and project policies.

## U.S. legal-policy boundary

These headers treat United States law as external governing authority. A native interface may carry a citation, source identifier, provenance, jurisdiction, and policy mapping; it does not thereby become a court or governmental authority.

The project-defined `.hss` concept is a proposed evidence-header convention, not a claim of a federal file format or government standard.

## Source separation

Statutory, regulatory, judicial, administrative, contractual, and project-policy records have distinct source types. The native evidence bus should not flatten them into a generic government record.

```text
source → verification → policy mapping → Total decision
```

## Evidence is not authority

A valid evidence record establishes that a structured assertion passed the native validation boundary. It does not itself authorize a business transaction, determine guilt, or create governmental power.

Administrative records and policy decisions must remain distinguishable from judicial adjudication.

## ABI discipline

Interfaces should remain small, versioned, explicit about ownership, and suitable for C callers. Implementations must document memory ownership and lifetime before exposing long-lived pointers across process boundaries.

The current first edition keeps the interfaces intentionally conservative. Stronger IPC, cryptographic verification, cgroup integration, SecureJDK/Graal integration, and production legal-policy verification belong behind later versioned interfaces.
