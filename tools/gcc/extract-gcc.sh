#!/bin/sh
# Extract an already-downloaded GCC release archive.
# Verification is performed when the archive has a recorded SHA-256 digest.
set -eu

VERSION="16.2.0"
ARCHIVE="gcc-${VERSION}.tar.xz"
DIR="gcc-${VERSION}"
SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
cd "$SCRIPT_DIR"

if [ ! -f "$ARCHIVE" ]; then
    echo "error: $ARCHIVE is not present in $SCRIPT_DIR" >&2
    echo "Run ./download-gcc.sh first, or place the official archive here." >&2
    exit 1
fi

if [ -d "$DIR" ]; then
    echo "error: extraction target already exists: $DIR" >&2
    echo "Remove it first if you intentionally want a fresh extraction." >&2
    exit 1
fi

if [ -f "gcc-${VERSION}.sha256" ]; then
    if command -v sha256sum >/dev/null 2>&1; then
        sha256sum -c "gcc-${VERSION}.sha256"
    elif command -v shasum >/dev/null 2>&1; then
        EXPECTED=$(awk '{print $1}' "gcc-${VERSION}.sha256")
        ACTUAL=$(shasum -a 256 "$ARCHIVE" | awk '{print $1}')
        [ "$EXPECTED" = "$ACTUAL" ] || { echo "error: SHA-256 verification failed" >&2; exit 1; }
    else
        echo "error: sha256sum or shasum is required for verification" >&2
        exit 1
    fi
else
    echo "warning: no recorded SHA-256 file; extracting without local digest verification" >&2
fi

echo "Extracting $ARCHIVE"
tar -xJf "$ARCHIVE"
echo "GCC source extracted to: $SCRIPT_DIR/$DIR"
