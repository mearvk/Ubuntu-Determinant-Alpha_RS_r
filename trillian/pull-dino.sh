#!/bin/sh
set -eu

# Import the complete upstream Dino source as ordinary files under
# trillian/dino/. The imported directory must NOT remain a Git repository,
# because the parent repository is the development repository.
REPO_URL='https://github.com/dino/dino.git'
PIN='8d49d83b3b45ab22d7b9d945c4b32296b07cb49e'
DEST='dino'

if [ -e "$DEST/.git" ]; then
    echo "Existing Git metadata detected in $DEST."

    if [ -d "$DEST/.git" ]; then
        cd "$DEST"
        if ! git diff --quiet || ! git diff --cached --quiet; then
            echo "Dino checkout has local modifications; refusing conversion." >&2
            exit 3
        fi

        # A clone can exist without a checked-out commit. In that case,
        # verify HEAD only when one is actually available.
        CURRENT="$(git rev-parse HEAD 2>/dev/null || true)"
        if [ -n "$CURRENT" ] && [ "$CURRENT" != "$PIN" ]; then
            echo "Dino checkout is at $CURRENT, expected $PIN; refusing conversion." >&2
            exit 2
        fi
        cd ..
    else
        # A .git file indicates a worktree/submodule-style repository link.
        echo "Nested Git link detected; refusing to discard unknown repository metadata." >&2
        exit 4
    fi

    # Remove only nested Git administration data. Source files remain intact.
    rm -rf "$DEST/.git"
    echo "Removed nested Git metadata; Dino is now an ordinary source tree."
elif [ -e "$DEST" ]; then
    echo "Existing ordinary Dino source tree detected; no overwrite performed."
    exit 0
else
    TMP="${DEST}.import.$$"
    trap 'rm -rf "$TMP"' EXIT HUP INT TERM
    git clone "$REPO_URL" "$TMP"
    cd "$TMP"
    git checkout --detach "$PIN"
    cd ..
    rm -rf "$DEST"
    mv "$TMP" "$DEST"
    trap - EXIT HUP INT TERM
    rm -rf "$DEST/.git"
    echo "Dino source imported as ordinary files."
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

echo "Dino source is ready as ordinary parent-repository files at $DEST/"
