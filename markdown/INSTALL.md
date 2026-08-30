# Installation Primer

## Desktop Preview and Install Profile

The Ubuntu White Edition installation flow is designed to make the desktop visible before installation is committed:

```text
ISO → Try Desktop → Inspect Install Profile → Select destination → Install → First Boot
```

The Linux bootstrap helper is `installer/linux/desktop_install_probe`. It discovers the Git clone and the primed installation set, reports the Step 1 desktop preview, and remains non-destructive unless `--install` is explicitly requested.

## Linux Installation Locations

The helper recognizes three roots, each with two executable classes:

```text
/user/                 /usr/                 /deck/
├── bin/               ├── bin/               ├── bin/
└── runnables/         └── runnables/         └── runnables/
```

Normal `make install` selects `/user/bin` by default. The user may select `/user/runnables`:

```sh
make install
make install INSTALL_CHOICE=user-runnables
```

Explicit `/usr` and `/deck` targets are available for deployments that require those locations. System-owned destinations may require elevated privileges.

When a `/user` destination is selected, the installer may add that directory to the user's `PATH` through `~/.profile`, only when the entry is not already present.

## Repository Entry Point

After installation, the helper is exposed through the repository's front entry point:

```text
desktop_install_probe → selected installed executable
```

The entry point is a convenience link, not a second copy of the executable. If an executable is unavailable but the repository's native installation script is present, the bootstrap process may use that script as the installation path rather than pretending that a binary exists.

## Build / Test / Clean

```sh
cd installer/linux
make clean
make
make install
./desktop_install_probe
```

The final command performs discovery by default. Use `--install` only when installation is intended.

## Step 1 Reference

See `installer/DESKTOP_PREVIEW_STEP_1.md` for the desktop-preview acceptance criteria and iteration loop.

See `installer/linux/DESKTOP_INSTALL_PROBE.md` and `installer/linux/DESKTOP_INSTALL_PROBE.hss` for the helper contract.

## Uninstaller Direction

Ubuntu White Edition's native uninstaller uses a shared software-relationship model. Software is classified as **main**, **installed**, or **sibling** so an uninstall operation can explain relevant consequences without silently removing related software.

The machine-readable model is `installer/software-relative-meaning.json`. User confirmation remains authoritative; recommendations are informational and should be reversible where practical.
