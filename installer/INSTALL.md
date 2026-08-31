# Installer Primer

## White Installer (full smooth install experience)

`white-installer` is the default "usual" smooth front door for installing the
system. It is a single native C11 orchestrator ELF built from
`installer/linux/white_installer_orchestrator.c` (+ `.h`). It is a control
plane, not an installer engine: it never partitions, formats, mounts, chroots,
or runs package tooling itself. It probes the host, previews the desktop
read-only, lets the user pick components, records a target, requires an
explicit confirm, then delegates to the existing Bash install engine
`scripts/galactic-cherry-installer` and emits an audit report.

`white-installer` and the existing script path coexist. The Bash engine
`scripts/galactic-cherry-installer` (and the native fallback
`installer/install-native.sh`) remain independently runnable, and the ELF only
delegates to that engine rather than replacing it.

### Flow

The orchestrator runs seven clearly labeled stages:

```text
1. PROBE     locate the Git clone, report host uname info, report whether the
             Bash engine and whiptail/dialog are present (runs unprivileged)
   ↓
2. PREVIEW   point at installer/DESKTOP_PREVIEW_STEP_1.md (read-only)
   ↓
3. COMPONENTS  interactive [x]/[ ] checkbox toggle, or a resolved preset list
   ↓
4. TARGET    record the chosen disk/target path only (never touches it)
   ↓
5. CONFIRM   print the full plan summary + data-loss warning; require explicit
             authorization before any delegation
   ↓
6. DELEGATE  execv into scripts/galactic-cherry-installer with the resolved
             selection (falls back to installer/install-native.sh)
   ↓
7. AUDIT     emit the ARCHITECTURE.md section-7 audit report (no secrets/PII)
```

The default run is a dry-run: it performs the probe, preview, component plan,
and target plan, prints a plan/preview audit report, and exits without ever
delegating or touching a disk. Delegation happens only when it is explicitly
authorized (see `--install`/`--confirm` below).

### Components

The optional components mirror the Bash engine's contract exactly (same ids,
descriptions, and defaults):

```text
id            default  description
ubuntu-white  ON       Ubuntu White theme + icon overlay (GNOME)
security      ON       OS security suite (ClamAV, UFW, AppArmor, fail2ban,
                       unattended-upgrades, rkhunter, chkrootkit)
git-improved  ON       Improved Git (modern git + git-lfs + companions)
jwstf         OFF      JWSTF / NitroWebExpress Java web server
```

When no selection is supplied the resolved list defaults to
`DEFAULT_COMPONENTS = "ubuntu-white security git-improved"`.

### CLI flags

Both `--flag value` and `--flag=value` forms are accepted. Unknown flags print
an error pointing at `--help` and exit non-zero.

```text
--help, -h            print usage listing every component id, description, and
                      default, plus all flags
--desktop <name>      desktop to install: mate | gnome | vanilla
--enable <list>       comma- or space-separated components to turn ON
--disable <list>      comma- or space-separated components to turn OFF
--target, --disk <p>  target device/path (recorded and shown; see note below)
--non-interactive     skip prompts and use the provided/default selections
--install, --confirm  authorize delegation to the engine
--dry-run             plan only, never delegate (this is the default)
```

### Environment variables

The orchestrator honors the same environment as the Bash engine:

```text
INSTALL_DESKTOP       desktop to install (mate | gnome | vanilla)
INSTALL_COMPONENTS    space- or comma-separated component list
GC_COMPONENTS         alias for INSTALL_COMPONENTS
```

### Delegation scheme

On an authorized (non-dry-run) run the orchestrator resolves the absolute path
to `scripts/galactic-cherry-installer` under the located repository and
`execv`s into it so the engine replaces the process. The resolved component
selection is passed to the engine through the `INSTALL_COMPONENTS` environment
variable in the child, together with `--non-interactive` and, when set,
`--desktop <name>` on the engine argv.

The `--target`/`--disk` value is captured, shown in the confirm summary, and
recorded in the audit report, but it is not forwarded as an engine argument.
The engine's own disk-selection step stays authoritative for choosing and
erasing the device.

If `scripts/galactic-cherry-installer` is absent, the orchestrator falls back
to `installer/install-native.sh`.

### Privilege boundary

`white-installer` runs unprivileged. It only probes, previews, plans, and
delegates. The Bash engine it hands off to is what enforces root for the
privileged install operations. The orchestrator never attempts to gain
privilege itself.

### Build

The in-environment build is the default target:

```sh
make -C installer/linux all
```

This builds `white-installer` (linked with `-static-libgcc`) alongside
`desktop_install_probe` and `nxtt`.

A separate portable target links with `-static` for the live ISO and minimal
environments:

```sh
make -C installer/linux white-installer-static
```

The `-static` target writes to the same `white-installer` output name. Pure
`-static` linking needs a static libc, which is not present in the restricted
sandbox, so this target is expected to fail there. That failure is acceptable:
the target is intended for a full toolchain. Re-run `make -C installer/linux
white-installer` afterward to restore the runnable dynamic build.

## Linux Desktop Install Probe

The Step 1 Linux installer helper is a small native C bootstrap program:

`installer/linux/desktop_install_probe`

`desktop_install_probe` is the Step-1 discovery and bootstrap probe.
`white-installer` (above) is the full smooth orchestration that delegates to
the Bash engine. The probe stays as-is for lightweight discovery; the
orchestrator is the default entry point for the complete guided install.

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
