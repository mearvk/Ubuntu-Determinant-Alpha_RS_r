# Ubuntu Determinant — APT repository

Install the precompiled installer binaries with `apt-get`. The repository is
**GPG-signed**, so no `[trusted=yes]` workaround is needed.

- **Repository URL:** `https://mearvk.github.io/Ubuntu.Determinant.Beta.Restricted/apt`
- **Suite / component:** `stable main`
- **Architecture:** `amd64`

## Add the repository

Copy-paste the whole block (Debian/Ubuntu, `apt` 2.4+):

```sh
# 1. Import the signing key into a dedicated keyring.
curl -fsSL https://mearvk.github.io/Ubuntu.Determinant.Beta.Restricted/apt/KEY.gpg \
  | sudo gpg --dearmor -o /usr/share/keyrings/ubuntu-determinant.gpg

# 2. Register the repository, bound to that key.
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/ubuntu-determinant.gpg] https://mearvk.github.io/Ubuntu.Determinant.Beta.Restricted/apt stable main" \
  | sudo tee /etc/apt/sources.list.d/ubuntu-determinant.list

# 3. Refresh and install.
sudo apt-get update
sudo apt-get install os-security-installer git-improved-installer
```

## Available packages

| Package                  | What it installs                                  | Path            |
|--------------------------|---------------------------------------------------|-----------------|
| `os-security-installer`  | Native OS security baseline installer             | `/usr/sbin`     |
| `git-improved-installer` | Native improved-Git installer                     | `/usr/sbin`     |
| `white-installer`        | White Edition smooth install orchestrator         | `/usr/bin`      |
| `desktop-install-probe`  | Desktop install discovery/bootstrap probe         | `/usr/bin`      |
| `nxtt`                   | NXTT uninstaller helper                           | `/usr/bin`      |

Install any subset, e.g. `sudo apt-get install white-installer`.

## Using them

Every binary defaults to a **safe dry-run** and prints `--help`:

```sh
os-security-installer --help
sudo os-security-installer            # dry-run plan, changes nothing
sudo os-security-installer --apply    # actually install the security baseline
```

## Updating

```sh
sudo apt-get update && sudo apt-get upgrade
```

## Removing the repository

```sh
sudo rm /etc/apt/sources.list.d/ubuntu-determinant.list \
        /usr/share/keyrings/ubuntu-determinant.gpg
sudo apt-get update
```

## Notes & caveats

- **amd64 only.** The published `.deb`s are `amd64`. On another architecture,
  build from source via `make -C installer/linux all` (see `installer/INSTALL.md`).
- **These packages install unmanaged tools, not distro replacements.** They add
  the project's own binaries; they do not alter how apt manages system packages.
- **Signing key trust.** You are trusting the project's key for these packages.
  Review `packaging/SIGNING.md` for how the repository is signed and how keys are
  rotated.
- If `apt-get update` reports a `NO_PUBKEY`/signature error, re-import the key
  from step 1 (the key may have been rotated).
