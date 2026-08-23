# Secure JDK 28 Installer

A JavaFX-based installer and configuration front end for **Secure JDK 28**.

## Product intent

The installer is intentionally more than a file copier. It provides a branded configuration aperture for the Secure JDK 28 product, including installation target selection, PATH and `JAVA_HOME` configuration, security posture selection, JavaFX integration, **Total** installation review, **Memory Management** profiles, an **Aperture** for advanced configuration, installation progress, and a staged manifest.

The visual treatment uses a restrained United States-inspired palette: navy, white, and red, with the product name as the primary visual mark.

## Native product names

The native distribution names are deliberately simple:

```text
Windows x64:
    SecureJDK28.exe

Linux x86_64:
    SecureJDK28.sans

macOS Apple Silicon:
    SecureJDK28.dmg / SecureJDK28.app

macOS Intel:
    SecureJDK28.dmg / SecureJDK28.app
```

### Linux `.sans`

`SecureJDK28.sans` is **not a script or a renamed text launcher**. The packaging step copies the ELF launcher produced by `jpackage` and gives it the Secure JDK `.sans` product suffix. It remains an executable ELF binary. The complete self-contained application image is distributed beside it in `SecureJDK28/`.

The Linux distribution is therefore intended to be launched as:

```bash
./SecureJDK28.sans
```

The accompanying tarball preserves the application image and launcher together.

## Native packaging architecture

```text
securejdk-installer/
├── packaging/
│   ├── build-linux.sh
│   ├── build-windows.ps1
│   └── build-macos.sh
├── pom.xml
├── README.md
└── src/main/
    ├── java/
    │   ├── module-info.java
    │   └── com/securejdk/installer/
    │       ├── InstallerConfig.java
    │       ├── InstallerEngine.java
    │       └── SecureJdkInstallerApp.java
    └── resources/
        └── securejdk.css
```

The repository also contains `.github/workflows/securejdk28-native.yml`, which builds the native packages on their target operating systems. This is important because `jpackage` produces platform-specific application packages and the native package must be built on the corresponding platform. Oracle's packaging documentation identifies Windows `exe`/`msi`, Linux `deb`/`rpm`, and macOS `pkg`/`dmg` as supported native package formats and notes that packaging is performed on the target platform. citeturn0search2turn0search1

## Build

The project targets JDK 28 and uses OpenJFX as the JavaFX layer.

Interactive development:

```bash
mvn clean javafx:run
```

Native builds:

```bash
# Linux
./packaging/build-linux.sh

# Windows PowerShell
./packaging/build-windows.ps1

# macOS
./packaging/build-macos.sh
```

`jpackage` creates a self-contained application image containing the application launcher and runtime dependencies; it can then create platform-specific installable packages. citeturn0search0turn0search2

## Native outputs

### Linux

`build-linux.sh` creates:

```text
SecureJDK28.sans
SecureJDK28/
SecureJDK28-linux-x86_64.tar.gz
```

The `.sans` file is the ELF application launcher. The complete application image is required for normal operation because it contains the packaged runtime and application resources.

### Windows

`build-windows.ps1` creates:

```text
SecureJDK28.exe
```

The Windows build requests a Start Menu entry, desktop shortcut, and directory chooser through `jpackage`.

### macOS

`build-macos.sh` creates both an application image and a DMG. The GitHub Actions matrix builds both Apple Silicon and Intel variants.

Production macOS distribution should add Apple code signing and notarization. `jpackage` supports macOS package customization and signing-related options, but release signing credentials belong in the protected build environment rather than this repository. citeturn0search1

## Installation engine boundary

`InstallerEngine` currently stages a destination tree and writes:

```text
conf/securejdk-installer.manifest
```

It deliberately does **not** claim to install a final Secure JDK binary artifact until the exact Secure JDK 28 distribution, checksums, signatures, licensing notices, and platform packages are selected.

That boundary is important for product integrity: the JavaFX installer is the configuration/product layer, while the JDK payload must remain a verified, versioned artifact.

## Memory Management

The first UI provides policy profiles rather than inventing JVM flags. The production implementation should translate the selected profile into an approved, versioned Secure JDK configuration after platform detection and hardware/memory inspection.

Recommended profiles:

- `Automatic`
- `Developer Workstation`
- `Server`
- `High-Memory Workstation`
- `Custom`

## Aperture

**Aperture** is the Secure JDK installer's term for the amount of runtime configuration exposed to the operator.

- Standard users receive a concise set of safe choices.
- Developers can open a wider configuration surface.
- Enterprise deployments can apply a centrally defined profile.
- Maximum-control deployments can expose explicitly documented advanced settings.

An aperture setting is configuration visibility; it is not an authorization mechanism.

## Commercial target

The product concept currently assumes a **$25 USD per-copy target** for an individual U.S. edition. That figure is a product/business assumption, not an assertion that OpenJDK itself requires a purchase fee.

Before commercial distribution, the repository should include the exact Secure JDK license, third-party notices, OpenJDK attribution, JavaFX/OpenJFX licensing notices, update policy, support terms, and trademark guidance applicable to the final brand.

## Production release requirements

1. Replace staging with signed Secure JDK artifact installation.
2. Add checksum/signature verification before payload extraction.
3. Implement real PATH/JAVA_HOME integration with rollback.
4. Implement the Memory Management profile compiler.
5. Implement Aperture schemas and validation.
6. Add uninstall/repair/upgrade flows.
7. Add signed Windows release binaries.
8. Add signed and notarized macOS releases.
9. Add reproducible native build metadata and artifact hashes.
10. Connect the final installer to the Secure JDK 28 distribution manifest.
