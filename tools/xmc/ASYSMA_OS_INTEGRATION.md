# ASYSMA OS Integration Contract

## Principle

An `.asysma` package is an application container, not an ELF, PE/COFF, or Mach-O executable. XMC therefore composes the application identity and icon into the package workflow, while the operating system remains responsible for native process loading.

The supported model is:

```text
source
  |
  +--> XMC ----------------> .xclass
  |
  +--> ASYSMA packer ------> .asysma
  |
  +--> icon metadata ------> application identity
  |
  +--> OS integration -----> clickable launcher / file association
                                  |
                                  v
                            ASYSMA runtime
                                  |
                                  v
                           native or Java entry
```

## Linux

Install a MIME definition for `application/x-asysma` and a desktop entry whose `Exec` target is the ASYSMA runtime adapter. Use the repository icon as the application icon.

The `.asysma` file should **not** be marked executable merely because it is a package. The executable permission belongs to the runtime adapter or a platform-native bootstrap executable.

## Windows

The installer should register `.asysma` under a dedicated ProgID, associate it with the signed ASYSMA launcher, and assign the XMC/ASYSMA icon through the ProgID's DefaultIcon registration. The launcher is the executable; the package remains data passed to that launcher.

If a future native ASYSMA executable format is introduced, it must be separately versioned and registered only after the OS loader contract is defined.

## macOS

Use a normal application bundle (`.app`) as the executable integration boundary. Declare the `asysma` document type and MIME/UTI mapping in the bundle's `Info.plist`, use the XMC/ASYSMA icon in the bundle, and pass the selected `.asysma` document to the application runtime.

The package itself should remain a document/container unless a future native loader specification explicitly defines executable `.asysma` semantics.

## Compile-time composition

The compiler/build process should embed stable application identity into the generated package manifest:

- application name;
- source provenance;
- XMC version;
- ASYSMA format version;
- host/architecture profile;
- icon identifier/hash;
- startup entry mode;
- TEC policy;
- integrity metadata.

The icon is therefore part of application composition, but the platform-specific launcher remains the executable boundary.

## File association safety

A file association must never imply that arbitrary `.asysma` bytes are executable. The launcher must validate the package magic, version, manifest bounds, integrity metadata, host profile, and startup policy before execution.

The current ASYSMA packer is a prototype and explicitly requires production work for canonical manifests, cryptographic integrity, package verification, deterministic generation, and complete bounds validation. See `README_ASYSMA.md`.
