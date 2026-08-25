#!/bin/sh
# Download and extract the pinned GCC source release.
# The script deliberately does not commit the large source tree for you.
set -eu

VERSION="16.2.0"
ARCHIVE="gcc-${VERSION}.tar.xz"
URL="https://gcc.gnu.org/pub/gcc/releases/gcc-${VERSION}/${ARCHIVE}"
DIR="gcc-${VERSION}"
SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
cd "$SCRIPT_DIR"

if [ -d "$DIR" ]; then
    echo "GCC source already exists: $SCRIPT_DIR/$DIR" >&2
    echo "Remove it first if you intentionally want a fresh extraction." >&2
    exit 1
fi

if [ ! -f "$ARCHIVE" ]; then
    echo "Downloading $URL"
    if command -v curl >/dev/null 2>&1; then
        curl -fL --retry 3 -o "$ARCHIVE" "$URL"
    elif command -v wget >/dev/null 2>&1; then
        wget -O "$ARCHIVE" "$URL"
    else
        echo "error: curl or wget is required" >&2
        exit 1
    fi
else
    echo "Using existing archive: $ARCHIVE"
fi

if command -v sha256sum >/dev/null 2>&1; then
    SUM=$(sha256sum "$ARCHIVE" | awk '{print $1}')
elif command -v shasum >/dev/null 2>&1; then
    SUM=$(shasum -a 256 "$ARCHIVE" | awk '{print $1}')
else
    echo "error: sha256sum or shasum is required for verification" >&2
    exit 1
fi

# GCC's official release archive is accompanied by SHA256SUMS. Fetch the
# release checksum file and verify the exact archive before extraction.
CHECKSUM_URL="https://gcc.gnu.org/pub/gcc/releases/gcc-${VERSION}/sha256.sum"
TMP_CHECKSUM=".gcc-${VERSION}-sha256.sum"
if command -v curl >/dev/null 2>&1; then
    curl -fL --retry 3 -o "$TMP_CHECKSUM" "$CHECKSUM_URL"
elif command -v wget >/dev/null 2>&1; then
    wget -O "$TMP_CHECKSUM" "$CHECKSUM_URL"
fi

EXPECTED=$(awk -v f="$ARCHIVE" '$NF == f {print $1; exit}' "$TMP_CHECKSUM" 2>/dev/null || true)
if [ -z "$EXPECTED" ]; then
    echo "error: official checksum for $ARCHIVE was not found" >&2
    rm -f "$TMP_CHECKSUM"
    exit 1
fi
if [ "$SUM" != "$EXPECTED" ]; then
    echo "error: SHA-256 verification failed" >&2
    echo "expected: $EXPECTED" >&2
    echo "actual:   $SUM" >&2
    rm -f "$TMP_CHECKSUM"
    exit 1
fi
rm -f "$TMP_CHECKSUM"

printf '%s  %s\n' "$SUM" "$ARCHIVE" > "gcc-${VERSION}.sha256"

echo "SHA-256 verified: $SUM"
echo "Extracting $ARCHIVE"
tar -xJf "$ARCHIVE"

echo "GCC source extracted to: $SCRIPT_DIR/$DIR"
echo "Review it before adding it to Git."
