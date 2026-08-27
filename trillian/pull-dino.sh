#!/bin/sh
set -eu

# Vendor the complete upstream Dino source into this directory.
# The pin is recorded explicitly so the imported source is reproducible.
REPO_URL='https://github.com/dino/dino.git'
PIN='8d49d83b3b45ab22d7b9d945c4b32296b07cb49e'
DEST='dino'

if [ -e "$DEST" ]; then
    echo "Refusing to overwrite existing $DEST" >&2
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

To refresh the vendor copy, choose a new reviewed upstream commit and update this record and script together.
EOF

echo "Dino source imported at $DEST/$PIN"
