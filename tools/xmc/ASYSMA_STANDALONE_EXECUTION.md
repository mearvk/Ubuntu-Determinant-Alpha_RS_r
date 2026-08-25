# ASYSMA Standalone Execution

XMC supports two execution models for `.asysma` output:

1. **Standalone** — the generated package contains a platform-native bootstrap boundary and can be launched directly without requiring a user to visit SecureJDK28 or install an unrelated base product.
2. **Spring/runtime** — the operating system opens the package through the installed XMC/ASYSMA runtime and its file association.

The package must carry a versioned manifest and application identity. A standalone implementation must validate the package before dispatching its payload: magic, format version, header/package bounds, host architecture, integrity metadata, and startup policy.

The `.asysma` suffix is an application format identifier; executability is provided by a platform-native bootstrap representation. XMC is responsible for composing the application identity and icon. The OS integration layer is responsible for desktop/file association.

## Desktop output

For a compiled program named `ProgramName`, the build/install layer may produce:

- `ProgramName.asysma` — application package/executable artifact;
- a Linux `.desktop` launcher where required by the desktop environment;
- a Windows shortcut/association through the ASYSMA ProgID;
- a macOS `.app` application boundary when appropriate.

The XMC/ASYSMA icon and program name are derived from the application manifest. Existing `.asysma` associations should not be overwritten blindly; installation should inspect the current association and update it only when the XMC/ASYSMA association is absent or older than the installed version.

## Security boundary

The standalone bootstrap must reject malformed packages and must never execute payload bytes before validation. It must not silently elevate privileges. Installation-time OS registration requires the normal permissions of the operating system.

The current C bootstrap files provide the versioned header and bounds-checking foundation. Full native payload dispatch remains target-specific and must be completed and tested separately for ELF/Linux, PE/Windows, and Mach-O/macOS.