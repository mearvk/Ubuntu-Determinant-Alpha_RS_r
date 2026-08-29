#!/usr/bin/env bash
set -euo pipefail

# Ubuntu Determinant — GNOME Software source acquisition
#
# Downloads a pinned official GNOME release archive without requiring a
# GitHub/GitLab username or password. Pristine source is kept below
# gnome-source/gnome-software/upstream/ so Determinant modifications can
# remain separate as patches/offsets.

VERSION="${GNOME_SOFTWARE_VERSION:-50.3}"
ARCHIVE="gnome-software-${VERSION}.tar.xz"
SERIES="${VERSION%%.*}"
SOURCE_URL="${GNOME_SOFTWARE_SOURCE_URL:-https://download.gnome.org/sources/gnome-software/${SERIES}/${ARCHIVE}}"
CHECKSUM_URL="${GNOME_SOFTWARE_CHECKSUM_URL:-https://download.gnome.org/sources/gnome-software/${SERIES}/${ARCHIVE%.tar.xz}.sha256sum}"
EXPECTED_SHA256="${GNOME_SOFTWARE_SHA256:-}"

ROOT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
UPSTREAM_DIR="${ROOT_DIR}/upstream"
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

command -v curl >/dev/null 2>&1 || { echo "ERROR: curl is required." >&2; exit 1; }
command -v sha256sum >/dev/null 2>&1 || { echo "ERROR: sha256sum is required." >&2; exit 1; }
command -v tar >/dev/null 2>&1 || { echo "ERROR: tar is required." >&2; exit 1; }

mkdir -p "$UPSTREAM_DIR"

printf '=== Downloading GNOME Software %s ===\n' "$VERSION"
printf 'Source: %s\n' "$SOURCE_URL"

curl --fail --location --retry 3 --proto '=https' --tlsv1.2 \
  --output "$TMP_DIR/$ARCHIVE" "$SOURCE_URL"

if [ -n "$EXPECTED_SHA256" ]; then
  printf '%s  %s\n' "$EXPECTED_SHA256" "$TMP_DIR/$ARCHIVE" | sha256sum --check --strict
else
  printf 'Checksum source: %s\n' "$CHECKSUM_URL"
  curl --fail --location --retry 3 --proto '=https' --tlsv1.2 \
    --output "$TMP_DIR/checksums" "$CHECKSUM_URL"

  EXPECTED_SHA256="$(awk -v file="$ARCHIVE" '$2 == file || $2 == "*" file { print $1; exit }' "$TMP_DIR/checksums")"
  if [ -z "$EXPECTED_SHA256" ]; then
    echo "ERROR: published checksum for $ARCHIVE was not found." >&2
    exit 1
  fi

  printf '%s  %s\n' "$EXPECTED_SHA256" "$TMP_DIR/$ARCHIVE" | sha256sum --check --strict
fi

ACTUAL_SHA256="$(sha256sum "$TMP_DIR/$ARCHIVE" | awk '{print $1}')"
printf 'SHA256: %s\n' "$ACTUAL_SHA256"

rm -rf "$TMP_DIR/source"
mkdir -p "$TMP_DIR/source"
tar -xJf "$TMP_DIR/$ARCHIVE" -C "$TMP_DIR/source"

EXTRACTED="$TMP_DIR/source/gnome-software-${VERSION}"
if [ ! -d "$EXTRACTED" ]; then
  echo "ERROR: archive did not contain expected directory gnome-software-${VERSION}" >&2
  exit 1
fi

rm -rf "$UPSTREAM_DIR/gnome-software-${VERSION}"
cp -a "$EXTRACTED" "$UPSTREAM_DIR/gnome-software-${VERSION}"
printf '%s  %s\n' "$ACTUAL_SHA256" "$ARCHIVE" > "$UPSTREAM_DIR/gnome-software-${VERSION}.sha256"
cat > "$UPSTREAM_DIR/SOURCE-INFO.txt" <<EOF
Project: gnome-software
Version: ${VERSION}
Source URL: ${SOURCE_URL}
Checksum URL: ${CHECKSUM_URL}
SHA256: ${ACTUAL_SHA256}
Acquired: $(date -u '+%Y-%m-%dT%H:%M:%SZ')

This directory contains pristine upstream source. Determinant modifications
must be maintained outside this directory as patches/offsets.
EOF

printf '=== GNOME Software source installed ===\n'
printf '  %s\n' "$UPSTREAM_DIR/gnome-software-${VERSION}"
