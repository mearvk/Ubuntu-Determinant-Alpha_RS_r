#!/usr/bin/env bash
set -euo pipefail

# Ubuntu Determinant — GNOME Terminal source acquisition
#
# Downloads a pinned official GNOME release archive without interactive Git
# credentials. Pristine source is kept under upstream/ so Determinant changes
# can be maintained separately as patches/offsets.

VERSION="${GNOME_TERMINAL_VERSION:-3.60.0}"
ARCHIVE="gnome-terminal-${VERSION}.tar.xz"
SOURCE_URL="${GNOME_TERMINAL_SOURCE_URL:-https://download.gnome.org/sources/gnome-terminal/${VERSION%.*}/${ARCHIVE}}"
CHECKSUM_URL="${GNOME_TERMINAL_CHECKSUM_URL:-${SOURCE_URL}.sha256sum}"
EXPECTED_SHA256="${GNOME_TERMINAL_SHA256:-}"

ROOT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
UPSTREAM_DIR="${ROOT_DIR}/upstream"
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

command -v curl >/dev/null 2>&1 || { echo "ERROR: curl is required." >&2; exit 1; }
command -v sha256sum >/dev/null 2>&1 || { echo "ERROR: sha256sum is required." >&2; exit 1; }
command -v tar >/dev/null 2>&1 || { echo "ERROR: tar is required." >&2; exit 1; }

mkdir -p "$UPSTREAM_DIR"

printf '=== Downloading GNOME Terminal %s ===\n' "$VERSION"
printf 'Source: %s\n' "$SOURCE_URL"

curl --fail --location --retry 3 --proto '=https' --tlsv1.2 \
  --output "$TMP_DIR/$ARCHIVE" "$SOURCE_URL"

# Prefer an explicitly pinned checksum; otherwise obtain GNOME's published
# checksum file and extract the checksum for this exact archive.
if [ -z "$EXPECTED_SHA256" ]; then
  printf 'Checksum: %s\n' "$CHECKSUM_URL"
  curl --fail --location --retry 3 --proto '=https' --tlsv1.2 \
    --output "$TMP_DIR/checksum.txt" "$CHECKSUM_URL"
  EXPECTED_SHA256="$(awk -v archive="$ARCHIVE" '$0 ~ archive {print $1; exit}' "$TMP_DIR/checksum.txt")"
fi

if ! [[ "$EXPECTED_SHA256" =~ ^[0-9a-fA-F]{64}$ ]]; then
  echo "ERROR: no valid SHA-256 checksum was obtained for $ARCHIVE." >&2
  exit 1
fi

printf '%s  %s\n' "$EXPECTED_SHA256" "$TMP_DIR/$ARCHIVE" | sha256sum --check --strict
ACTUAL_SHA256="$(sha256sum "$TMP_DIR/$ARCHIVE" | awk '{print $1}')"
printf 'SHA256: %s\n' "$ACTUAL_SHA256"

mkdir -p "$TMP_DIR/source"
tar -xJf "$TMP_DIR/$ARCHIVE" -C "$TMP_DIR/source"

EXTRACTED="$TMP_DIR/source/gnome-terminal-${VERSION}"
if [ ! -d "$EXTRACTED" ]; then
  echo "ERROR: archive did not contain expected directory gnome-terminal-${VERSION}" >&2
  exit 1
fi

rm -rf "$UPSTREAM_DIR/gnome-terminal-${VERSION}"
cp -a "$EXTRACTED" "$UPSTREAM_DIR/gnome-terminal-${VERSION}"
printf '%s  %s\n' "$ACTUAL_SHA256" "$ARCHIVE" > "$UPSTREAM_DIR/gnome-terminal-${VERSION}.sha256"
cat > "$UPSTREAM_DIR/SOURCE-INFO.txt" <<EOF
Project: gnome-terminal
Version: ${VERSION}
Source URL: ${SOURCE_URL}
SHA256: ${ACTUAL_SHA256}
Acquired: $(date -u '+%Y-%m-%dT%H:%M:%SZ')

This directory contains pristine upstream source. Determinant modifications
must be maintained outside this directory as patches/offsets.
EOF

printf '=== GNOME Terminal source installed ===\n'
printf '  %s\n' "$UPSTREAM_DIR/gnome-terminal-${VERSION}"
