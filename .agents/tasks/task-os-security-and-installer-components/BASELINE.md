# BASELINE — task-os-security-and-installer-components (FEAT-001)

Verified baseline captured on the `feat/os-security-and-installer-components`
branch before any functional change. No scripts were modified in this feature.
Validation is limited to static checks (`bash -n`, JSON parse) per the sandbox
constraints: no apt, no live installer run, no whiptail/dialog/shellcheck on host.

## Syntax baseline (green)

`bash -n` returns exit 0 for all six existing scripts:

| Script | `bash -n` |
| --- | --- |
| `scripts/galactic-cherry-installer` | OK (exit 0) |
| `scripts/install-gnome-desktop.sh` | OK (exit 0) |
| `scripts/install-jwstf.sh` | OK (exit 0) |
| `scripts/install-ubuntu-installer.sh` | OK (exit 0) |
| `scripts/install-desktop-selector.sh` | OK (exit 0) |
| `scripts/install-mate-desktop.sh` | OK (exit 0) |

Reproduce:

```
bash -n scripts/galactic-cherry-installer scripts/install-gnome-desktop.sh \
        scripts/install-jwstf.sh scripts/install-ubuntu-installer.sh \
        scripts/install-desktop-selector.sh scripts/install-mate-desktop.sh
```

## (a) White / GNOME boot path is present and functional

- `scripts/install-desktop-selector.sh` defaults `DESKTOP="${DESKTOP:-gnome}"`
  and routes `DESKTOP=gnome` to `install-gnome-desktop.sh`
  (`scripts/install-desktop-selector.sh:6,10`). `DESKTOP=mate` routes to the
  legacy MATE script; unknown values exit 2.
- `scripts/install-gnome-desktop.sh` installs the GNOME stack from
  `archive.ubuntu.com` — `gnome-shell`, `mutter`, `nautilus`, `gdm3`, plus
  session/Xorg/audio/network packages
  (`scripts/install-gnome-desktop.sh:56-66`, apt sources at lines 42-47).
- It makes the graphical login authoritative:
  `systemctl set-default graphical.target` with a symlink fallback, enables
  `gdm3`, disables `lightdm`
  (`scripts/install-gnome-desktop.sh:71-77`).
- The Ubuntu White overlay is additive and gated on `GNOME_THEME`
  (default `ubuntu-white`). When the theme is `ubuntu-white|white|determinant`
  it fetches and runs `install-ubuntu-white-theme.sh`
  (`scripts/install-gnome-desktop.sh:16,24-27,86-99`); `stock|upstream`
  applies no overlay. Icons/CSS are toggled via `UBUNTU_WHITE_ICONS` /
  `UBUNTU_WHITE_CSS`.

Conclusion: the "check that we have that" GNOME + Ubuntu White boot path is
present and intact. It must not be broken by later features.

## (b) `gnome-source/` is a safety-gate input, not wired to boot

- The only script that references the `gnome-source/` trees is
  `scripts/build-safety.sh`, via `GNOME_ROOT="$ROOT/gnome-source"`
  (`scripts/build-safety.sh:10-11,19,34,48`).
- That script is a SHA-256 source-safety gate: it hashes the source files into
  `gnome-source/SHA256SUMS.source` and asserts each component
  (`glib`, `pango`, `gdk-pixbuf`, `cairo`, `gtk`, `gnome-shell`, `mutter`) has
  `README.md` + `meson.build`. It explicitly never executes upstream source and
  refuses unsafe DESTDIR paths.
- `grep -rn -E "gnome-source|GNOME_ROOT" scripts/` matches **only**
  `scripts/build-safety.sh`. No installer or boot-path script builds or installs
  from `gnome-source/`. The runtime GNOME comes from Ubuntu archive packages
  (point a), not from these source trees.

## (c) Security tools (ClamAV etc.) are installed only by install-jwstf.sh

- `scripts/install-jwstf.sh` is the only script that actually installs the
  security suite: `clamav`, `clamav-daemon`, `ufw`
  (`scripts/install-jwstf.sh:95-97`), configures UFW rules and enables
  `clamav-freshclam.service`
  (`scripts/install-jwstf.sh:405-422`).
- Elsewhere the security tools are only **advertised**, not installed:
  - `scripts/galactic-cherry-installer:157` — descriptive text listing
    "Security tools (chkrootkit, rkhunter, ClamAV)".
  - `scripts/install-ubuntu-installer.sh:185-187` — HTML installer slide
    advertising `chkrootkit`, `rkhunter`, `ClamAV`.
- `scripts/build-from-manifest.sh:191-193` lists `tools-clamav`,
  `tools-chkrootkit`, `tools-rkhunter` in BUILD_ORDER, so security is expected
  in the build, but there is no general-purpose install path that mirrors the
  jwstf logic for a standard desktop install.

## (d) `git` is only an optional manifest entry, no dedicated install

- `installer/software-relative-meaning.json:74` —
  `{"package":"git","rank":8,"category":"installed","importance":"optional"}`.
  The manifest parses cleanly (`python3 -m json.tool`).
- There is no `scripts/*git*` install script and no "git-improved" component
  wired anywhere today.

## Validation harness for later features

- Shell: `bash -n <file>` must exit 0 for every modified `.sh` and for
  `scripts/galactic-cherry-installer`.
- JSON: `python3 -m json.tool <file> >/dev/null` for any modified manifest.
- Wiring: grep-confirm new components are referenced in the installer's
  install step, not merely declared.
- Do NOT run apt or the installer against a disk in this sandbox; static and
  syntax validation only.
