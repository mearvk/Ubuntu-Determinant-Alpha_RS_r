# Signing the APT repository

The published APT repository is **GPG-signed** so `apt` trusts it without
`[trusted=yes]`. The private key never lives in the repository — it is provided
to CI as an encrypted GitHub Actions secret. This is a one-time setup performed
by a repository admin.

## 1. Generate a signing key (once, on a trusted machine)

```sh
# Non-interactive key generation.
cat > /tmp/apt-key.conf <<'EOF'
%no-protection
Key-Type: RSA
Key-Length: 4096
Name-Real: Ubuntu Determinant APT
Name-Email: packages@mearvk.example
Expire-Date: 0
%commit
EOF
gpg --batch --gen-key /tmp/apt-key.conf
rm -f /tmp/apt-key.conf

# Find the key id.
gpg --list-secret-keys --keyid-format=long
```

If you want a passphrase, drop the `%no-protection` line and set one; then also
configure the `APT_GPG_PASSPHRASE` secret below.

## 2. Export the keys

```sh
KEYID=<the long key id from above>

# PRIVATE key -> goes into a GitHub secret (keep it safe, never commit it).
gpg --armor --export-secret-keys "$KEYID" > apt-private.asc

# PUBLIC key -> distributed to users. CI also regenerates this as KEY.gpg,
# but you can commit a copy under docs/apt/ if you prefer a stable path.
gpg --armor --export "$KEYID" > apt-public.asc
```

## 3. Add the repository secrets

In **Settings → Secrets and variables → Actions → New repository secret**:

| Secret name           | Value                                             |
|-----------------------|---------------------------------------------------|
| `APT_GPG_PRIVATE_KEY` | the entire contents of `apt-private.asc`          |
| `APT_GPG_PASSPHRASE`  | the key's passphrase (omit/empty if unprotected)  |

Then delete `apt-private.asc` from disk.

## 4. Enable GitHub Pages

**Settings → Pages → Build and deployment → Source = "GitHub Actions".**

The `apt-repo` workflow deploys to Pages via the official
`actions/deploy-pages` action, so no `gh-pages` branch is needed.

## 5. Publish

Push a `v*` tag (e.g. `v1.0.0`) or run the **APT repository** workflow manually
(**Actions → APT repository → Run workflow**). The workflow builds the `.deb`s,
generates the index, signs `Release` into `InRelease` + `Release.gpg`, exports
the public key to `KEY.gpg`, and deploys everything to Pages.

## Key rotation

Generate a new key, update `APT_GPG_PRIVATE_KEY`/`APT_GPG_PASSPHRASE`, re-run the
workflow, and tell users to re-import the key. The repository URL and
`sources.list` line do not change.
