# Installer Primer

## Linux Desktop Install Probe

The Step 1 Linux installer helper is a small native C bootstrap program:

`installer/linux/desktop_install_probe`

Its installation contract is:

```text
Git clone
   ↓
Locate installation set
   ↓
Expose Desktop Preview
   ↓
Dry-run discovery
   ↓
Explicit installation
```

### Build

```sh
cd installer/linux
make clean
make
```

### Install

The default user installation is:

```sh
make install
```

The user may select the alternate runnable location:

```sh
make install INSTALL_CHOICE=user-runnables
```

The supported destination families are:

```text
/user/bin
/user/runnables
/usr/bin
/usr/runnables
/deck/bin
/deck/runnables
```

The explicit system/project targets are available as:

```sh
make install-usr-bin
make install-usr-runnables
make install-deck-bin
make install-deck-runnables
```

System locations may require appropriate administrator privileges.

### PATH

When `/user/bin` or `/user/runnables` is selected, the Makefile can add the selected directory to the user's `~/.profile` when it is not already present. Existing PATH entries are not duplicated.

### Front-of-repository entry point

The installation design provides a simple repository-level entry point named:

`desktop_install_probe`

The entry point should resolve to the selected installed executable when a compiled installation is available. If the executable is not yet present but a repository installer is available, the bootstrap may instead direct execution to the native installer script.

The entry point is deliberately only a convenience layer. The installed executable remains the authoritative runtime artifact.

### Desktop Preview

The helper points users toward:

`installer/DESKTOP_PREVIEW_STEP_1.md`

The preview is intended to be non-destructive. Users can inspect the proposed desktop and installation profile before committing installation changes.

### Clean / uninstall

```sh
make clean
make uninstall
```

`make clean` removes the locally compiled helper. `make uninstall` removes helper copies from the supported installation destinations.

## Design Rule

**Preview first. Inspect the profile. Install explicitly. Keep the runnable entry point reproducible.**
