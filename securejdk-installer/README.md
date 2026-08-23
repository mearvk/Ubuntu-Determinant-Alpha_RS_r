# Secure JDK 28 Installer

A JavaFX-based installer and configuration front end for **Secure JDK 28**.

## Product intent

The installer is intentionally more than a file copier. It provides a branded configuration aperture for the Secure JDK 28 product, including:

- installation target selection;
- PATH and `JAVA_HOME` configuration;
- security posture selection;
- JavaFX integration;
- **Total** installation review;
- **Memory Management** profiles;
- an **Aperture** for advanced configuration;
- installation progress and a staged manifest.

The visual treatment uses a restrained United States-inspired palette: navy, white, and red, with the product name as the primary visual mark.

## Source layout

```text
securejdk-installer/
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

## Build

The project targets JDK 28 and uses OpenJFX as the JavaFX layer. JavaFX is kept as an explicit dependency because JavaFX is a separate OpenJFX technology rather than an assumed component of every OpenJDK distribution.

With JDK 28 and Maven installed:

```bash
mvn clean javafx:run
```

For a production image, the next implementation phase should use `jlink`/`jpackage` or an equivalent platform packaging pipeline and bundle the exact approved JavaFX runtime for each supported operating system.

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

Before commercial distribution, the repository should include the exact Secure JDK license, third-party notices, OpenJDK attribution, JavaFX/OpenJFX licensing notices, update policy, support terms, and any trademark guidance applicable to the final brand.

OpenJDK materials commonly use GPLv2 with the Classpath Exception for relevant OpenJDK components, but the exact licenses of every redistributed component must be checked against the actual Secure JDK build. Java SE/JDK 28 specifications are separately documented by OpenJDK. 

## Production milestones

1. Replace staging with signed Secure JDK artifact installation.
2. Add platform-specific detection for Linux, Windows, and macOS.
3. Add checksum/signature verification before payload extraction.
4. Implement real PATH/JAVA_HOME integration with rollback.
5. Implement the Memory Management profile compiler.
6. Implement Aperture schemas and validation.
7. Add uninstall/repair/upgrade flows.
8. Package with `jpackage` for supported platforms.
9. Add automated installer tests and reproducible build metadata.
10. Connect the final installer to the Secure JDK 28 distribution manifest.
