#!/bin/sh
set -eu

# Import the complete upstream Dino source as ordinary files under
# trillian/dino/. The imported directory is intentionally NOT a Git
# repository of its own, so the parent repository can track the source.
REPO_URL='https://github.com/dino/dino.git'
PIN='8d49d83b3b45ab22d7b9d945c4b32296b07cb49e'
DEST='dino'

if [ -d "$DEST/.git" ]; then
    echo "Existing Dino Git checkout detected. Converting it to an ordinary source tree."
    cd "$DEST"
    if ! git diff --quiet || ! git diff --cached --quiet; then
        echo "Dino checkout has local modifications; refusing conversion." >&2
        exit 3
    fi
    CURRENT="$(git rev-parse HEAD)"
    if [ "$CURRENT" != "$PIN" ]; then
        echo "Dino checkout is at $CURRENT, expected $PIN; refusing conversion." >&2
        exit 2
    fi
    rm -rf .git
    cd ..
elif [ -e "$DEST" ]; then
    echo "A non-Git path already exists at $DEST; refusing to overwrite." >&2
    exit 1
else
    TMP="${DEST}.import.$$"
    trap 'rm -rf "$TMP"' EXIT HUP INT TERM
    git clone --depth 1 "$REPO_URL" "$TMP"
    cd "$TMP"
    git fetch --depth 1 origin "$PIN"
    git checkout --detach "$PIN"
    cd ..
    rm -rf "$DEST"
    mv "$TMP" "$DEST"
    trap - EXIT HUP INT TERM
    rm -rf "$DEST/.git"
fi

cat > DINO-VENDOR.md <<'EOF'
# Dino Source Import Record

This directory contains an ordinary-file import of the open-source Dino XMPP client for independent development.

Upstream: https://github.com/dino/dino
Pinned commit: `8d49d83b3b45ab22d7b9d945c4b32296b07cb49e`
License: GPL-3.0

The source is intentionally stored as ordinary files under `trillian/dino/`, not as a Git submodule or nested Git repository. Upstream `.git` administration data is removed by the import script.

This is not recovered source code from the historical Cerulean Studios Trillian client. Upstream copyright and license notices remain part of the imported source tree.
EOF

echo "Dino source imported as ordinary files at $DEST/$PIN"
