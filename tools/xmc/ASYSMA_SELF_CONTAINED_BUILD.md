# ASYSMA Self-Contained Build Contract

Date: 2026-08-25

This document records the agreed execution model for XMC-generated `.asysma` applications.

## Build requirement

XMC composes each `.asysma` artifact with the components required for its target platform:

- ASYSMA container header and manifest;
- application metadata and identity;
- application icon;
- target-native bootstrap executable;
- compiled program payload;
- integrity information sufficient for pre-execution validation.

The resulting artifact is intended to be independently launchable without requiring the user to visit a website or install SecureJDK28 or another unrelated base product first.

## Native loader model

The target-native bootstrap is deliberately small. It validates the ASYSMA container, locates the internal native program, validates its target and integrity information, and then delegates actual program loading to the operating system's normal native loader facilities.

The bootstrap is not intended to reimplement an ELF, PE, or Mach-O loader.

## Targets

- Linux: ELF bootstrap and Linux-native payload.
- Windows: PE bootstrap and Windows-native payload.
- macOS: Mach-O/application bootstrap and macOS-native payload.

The exact bootstrap representation is target-specific, but the ASYSMA manifest remains versioned and common.

## Runtime spring

A separately installed XMC/ASYSMA runtime remains supported. An installed runtime may provide file associations, desktop integration, diagnostics, updates, and a fallback execution path. It is not a prerequisite for a properly composed standalone artifact.

## Desktop identity

XMC derives the desktop application name and icon from the application manifest. Installation may create the platform's native desktop/shortcut representation. Existing `.asysma` associations should be inspected before changing them.

## Verification gate

A self-contained artifact is not considered complete until each target can be compiled, launched directly, and verified without the external runtime. The repository source contract therefore precedes, but does not substitute for, local native build testing.