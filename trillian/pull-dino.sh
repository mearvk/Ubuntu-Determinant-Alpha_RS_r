#!/bin/sh
set -eu

# Vendor the complete upstream Dino source into this directory.
# The checkout is intentionally local-only; trillian/.gitignore excludes it
# from the parent repository so normal pushes do not upload Dino source.
REPO_URL='https://github.com/dino/dino.git'
PIN='8d49d83b3b45ab22d7b9d945c4b32296b07cb49e'
DEST='dino'

if [ -d "$DEST/.git" ]; then
    echo "Existing local Dino checkout detected."
    cd "$DEST"

    if ! git diff --quiet || ! git diff --cached --quiet; then
        echo "Dino checkout has local modifications; refusing automatic change." >&2
        exit 3
    fi

    CURRENT="$(git rev-parse HEAD)"
    if [ "$CURRENT" = "$PIN" ]; then
        echo "Dino is already at pinned commit: $PIN"
        exit 0
    fi

    echo "Dino exists at commit: $CURRENT"
    echo "Pinned project revision: $PIN"
    echo "No automatic overwrite or reset performed." >&2
    exit 2
fi

if [ -e "$DEST" ]; then
    echo "A non-Git path already exists at $DEST; refusing to overwrite." >&2
    exit 1
fi

git clone --no-checkout "$REPO_URL" "$DEST"
cd "$DEST"
git checkout --detach "$PIN"
cd ..

cat > DINO-VENDOR.md <<'EOF'
# Dino Vendor Record

This directory is an independent vendor/import location for the open-source Dino XMPP client.

Upstream: https://github.com/dino/dino
Pinned commit: `8d49d83b3b45ab22d7b9d945c4b32296b07cb49e`
License: GPL-3.0

The imported source remains governed by its upstream license and notices. It is not recovered source code from the historical Cerulean Studios Trillian client.

The `dino/` checkout is intentionally local-only and is excluded by `trillian/.gitignore`; it must not be committed to the parent repository.

To refresh the vendor copy, choose a new reviewed upstream commit and update this record and script together.
EOF

echo "Dino source imported at $DEST/$PIN"
