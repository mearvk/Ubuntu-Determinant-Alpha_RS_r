# Debian packaging & signed APT repository

This directory turns the repository's precompiled installer binaries into
`.deb` packages and publishes them as a **signed APT repository** on GitHub
Pages, so users can install them with `apt-get`.

## What gets packaged

| Package                  | Binary source (`installer/linux/`)      | Installs to      |
|--------------------------|-----------------------------------------|------------------|
| `os-security-installer`  | `os_security_installer.c`               | `/usr/sbin`      |
| `git-improved-installer` | `git_improved_installer.c`              | `/usr/sbin`      |
| `white-installer`        | `white_installer_orchestrator.c`        | `/usr/bin`       |
| `desktop-install-probe`  | `desktop_install_probe.c`               | `/usr/bin`       |
| `nxtt`                   | `nxtt-uninstaller.c`                     | `/usr/bin`       |

The package list, versions, and metadata live in `packages.manifest` — a single
source of truth consumed by both `build-deb.sh` and the CI workflow.

## Building locally

```sh
# Build every .deb into packaging/out/pool/
packaging/build-deb.sh

# Then generate the repository index (Packages/Release) into packaging/out/
packaging/make-repo.sh
```

`build-deb.sh` prefers `dpkg-deb` when present and falls back to a portable
`ar`+`tar` assembly (a `.deb` is just an `ar` archive of `debian-binary`,
`control.tar.gz`, `data.tar.gz`), so it works even on hosts without the Debian
packaging toolchain.

## Publishing (CI)

`.github/workflows/apt-repo.yml` builds the binaries and `.deb`s on an Ubuntu
runner, generates the index, **GPG-signs** `Release` (producing `InRelease` and
`Release.gpg`), and deploys the whole `packaging/out/` tree to GitHub Pages.

Signing requires two repository secrets (see `packaging/SIGNING.md`):

- `APT_GPG_PRIVATE_KEY` — ASCII-armored private key
- `APT_GPG_PASSPHRASE`  — its passphrase (may be empty)

## Installing (end users)

See `docs/apt/index.md` for the copy-paste instructions. In short:

```sh
curl -fsSL https://<owner>.github.io/<repo>/apt/KEY.gpg \
  | sudo gpg --dearmor -o /usr/share/keyrings/ubuntu-determinant.gpg
echo "deb [signed-by=/usr/share/keyrings/ubuntu-determinant.gpg] https://<owner>.github.io/<repo>/apt stable main" \
  | sudo tee /etc/apt/sources.list.d/ubuntu-determinant.list
sudo apt-get update
sudo apt-get install os-security-installer git-improved-installer
```
