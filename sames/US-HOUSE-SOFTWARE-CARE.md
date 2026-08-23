# US House Software Care

## Purpose

This document defines a friendly, cross-platform software-care layer for U.S. households and, where applicable, institutional House environments. It covers installation, removal, updates, compatibility, and everyday conveniences for Microsoft and Apple software without assuming that every package is available on every operating system.

The term **US House** is used here as a software/service environment. It does not imply affiliation with or authorization by the U.S. House of Representatives.

## Care model

```text
inspect → identify → plan → authorize → install/update/remove → verify → record
```

The scripts should prefer package managers and vendor-supported mechanisms, make changes visible before authorization, preserve logs, and avoid silently downloading arbitrary executables.

## Microsoft support

Windows systems should use native Windows package-management facilities where available, such as `winget`, Microsoft Store mechanisms, or an organization's approved management service. The repository may provide PowerShell wrappers that:

- detect the operating system and package manager;
- search for a named application;
- show the proposed install/update/remove operation;
- request explicit authorization for persistent changes;
- execute the approved operation;
- verify the resulting installation;
- record a local evidence summary.

Examples include Microsoft 365, Edge, Visual Studio Code, and other software for which a supported package source is available. Package identity and publisher should be verified before installation.

## Apple support

macOS systems should use Apple-supported installation and update paths where available, including Homebrew where intentionally adopted by the user, the App Store, signed vendor installers, and approved device-management services. Shell wrappers may provide the same inspect → authorize → apply → verify flow.

The scripts must not bypass Gatekeeper, code signing, notarization, privacy controls, or administrator policy merely for convenience.

## Linux / Wine support

Ubuntu systems should prefer Aptitude/APT and other native package mechanisms. Windows applications running under Wine should remain clearly identified as Windows applications and should be tested as an interoperability case rather than treated as native Linux software.

A `.so` and a `.dll` are not interchangeable by renaming. Where translation, rebuilding, or compatibility layers are required, the operation should identify the actual mechanism and record its result.

## Convenience commands

The intended command families are:

```text
house status
house search <name>
house install <name>
house update <name>
house update-all
house remove <name>
house verify <name>
house evidence <name>
```

The implementation may map these commands to PowerShell on Windows, shell tooling on macOS/Linux, and platform-specific package managers underneath.

## Safety and evidence

Removal and installation are persistent operations. A production implementation should show the target, publisher, source, version, dependencies, and expected effect before authorization. Updates should preserve enough evidence to determine what version was present before and after the operation.

No script in this layer should:

- disable security controls for convenience;
- execute an untrusted downloaded script automatically;
- delete unrelated user data;
- silently elevate privileges;
- claim that an installation is verified when it was not;
- represent a government or vendor endorsement that does not exist.

**Clean and bearing:** clean means the operation is understandable and bounded; bearing means the system accepts responsibility for showing what it changed and what evidence supports the result.

## Relationship to Ubuntu Grand 1–2–3–4

1. **Your desktop** — friendly cross-platform convenience.
2. **Your software** — installation, update, and removal through supported mechanisms.
3. **Your compatibility** — Windows/macOS/Linux interoperability, including Wine where appropriate.
4. **Your systems** — verification, provenance, evidence, and durable software care.

The design is compatible with **US Software Systems 3 — Green. Cool. Timber.**
