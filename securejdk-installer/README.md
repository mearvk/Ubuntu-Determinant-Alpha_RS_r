# Secure JDK 28 Installer

A JavaFX-based installer and configuration front end for **Secure JDK 28**.

## Product identity and attribution

The Secure JDK 28 installer carries the following product identity in its interface and release materials:

**MEARVK LLC 2028 ©**

Graal-related software is kept as a separate attribution/value line rather than being represented as MEARVK-owned technology:

**Graal software — All applicable Graal trademarks and notices included © 2026**

The exact trademark, copyright, and third-party notice language must be reviewed against the components actually redistributed in each production build. Copyright and trademark notices should not be interpreted as transferring ownership of third-party marks.

## Product intent

The installer is intentionally more than a file copier. It provides a branded configuration aperture for the Secure JDK 28 product, including installation target selection, PATH and `JAVA_HOME` configuration, security posture selection, JavaFX integration, **Total** installation review, **Memory Management** profiles, an **Aperture** for advanced configuration, installation progress, and a staged manifest.

The visual treatment uses a restrained United States-inspired palette: navy, white, and red, with the product name as the primary visual mark.

## Native product names

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
        ├── branding.properties
        └── securejdk.css
```

The repository also contains `.github/workflows/securejdk28-native.yml`, which builds native packages on target operating systems.

## Branding implementation

The JavaFX installer displays **MEARVK LLC 2028 ©** in the primary product chrome and installation summary. The separate Graal attribution appears as a distinct notice:

> Graal software — All applicable Graal trademarks and notices included © 2026

The source also stores these values in `branding.properties` so future native packaging, installer manifests, About dialogs, and release documentation can consume the same canonical product strings.

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
11. Perform a final trademark/copyright notice review before commercial release.
