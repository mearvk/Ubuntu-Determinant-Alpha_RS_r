#!/usr/bin/env bash
set -euo pipefail

# Ubuntu Determinant — gnome-control-center source acquisition
#
# Downloads a pinned official GNOME release archive without requiring a
# GitHub/GitLab username or password. The pristine source is kept below
# gnome-source/gnome-control-center/upstream/ so future Determinant changes
# can be maintained as separate offsets/patches.

VERSION="${GNOME_CONTROL_CENTER_VERSION:-50.3}"
ARCHIVE="gnome-control-center-${VERSION}.tar.xz"
SERIES="${VERSION%.*}"
SOURCE_URL="${GNOME_CONTROL_CENTER_SOURCE_URL:-https://download.gnome.org/sources/gnome-control-center/${SERIES}/${ARCHIVE}}"
SHA256="${GNOME_CONTROL_CENTER_SHA256:-}"

ROOT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
UPSTREAM_DIR="${ROOT_DIR}/upstream"
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

command -v curl >/dev/null 2>&1 || { echo "ERROR: curl is required." >&2; exit 1; }
command -v sha256sum >/dev/null 2>&1 || { echo "ERROR: sha256sum is required." >&2; exit 1; }
command -v tar >/dev/null 2>&1 || { echo "ERROR: tar is required." >&2; exit 1; }

mkdir -p "$UPSTREAM_DIR"

printf '=== Downloading gnome-control-center %s ===\n' "$VERSION"
printf 'Source: %s\n' "$SOURCE_URL"

curl --fail --location --retry 3 --proto '=https' --tlsv1.2 \
  --output "$TMP_DIR/$ARCHIVE" "$SOURCE_URL"

CHECKSUM_URL="${GNOME_CONTROL_CENTER_CHECKSUM_URL:-https://download.gnome.org/sources/gnome-control-center/${SERIES}/gnome-control-center-${VERSION}.sha256sum}"

if [ -z "$SHA256" ]; then
  printf 'Checksum file: %s\n' "$CHECKSUM_URL"
  if curl --fail --location --retry 3 --proto '=https' --tlsv1.2 \
      --output "$TMP_DIR/checksum.txt" "$CHECKSUM_URL"; then
    SHA256="$(awk -v file="$ARCHIVE" '$0 ~ file {print $1; exit}' "$TMP_DIR/checksum.txt")"
  fi
fi

if [ -n "$SHA256" ]; then
  printf '%s  %s\n' "$SHA256" "$TMP_DIR/$ARCHIVE" | sha256sum --check --strict
else
  echo "ERROR: no SHA-256 checksum was available for ${ARCHIVE}." >&2
  exit 1
fi

ACTUAL_SHA256="$(sha256sum "$TMP_DIR/$ARCHIVE" | awk '{print $1}')"
printf 'SHA256: %s\n' "$ACTUAL_SHA256"

rm -rf "$TMP_DIR/source"
mkdir -p "$TMP_DIR/source"
tar -xJf "$TMP_DIR/$ARCHIVE" -C "$TMP_DIR/source"

EXTRACTED="$TMP_DIR/source/gnome-control-center-${VERSION}"
if [ ! -d "$EXTRACTED" ]; then
  echo "ERROR: archive did not contain expected directory gnome-control-center-${VERSION}" >&2
  exit 1
fi

rm -rf "$UPSTREAM_DIR/gnome-control-center-${VERSION}"
cp -a "$EXTRACTED" "$UPSTREAM_DIR/gnome-control-center-${VERSION}"
printf '%s\n' "$ACTUAL_SHA256" > "$UPSTREAM_DIR/gnome-control-center-${VERSION}.sha256"
cat > "$UPSTREAM_DIR/SOURCE-INFO.txt" <<EOF
Project: gnome-control-center
Version: ${VERSION}
Source URL: ${SOURCE_URL}
SHA256: ${ACTUAL_SHA256}
Acquired: $(date -u '+%Y-%m-%dT%H:%M:%SZ')

This directory contains pristine upstream source. Determinant modifications
must be maintained outside this directory as patches/offsets.
EOF

printf '=== gnome-control-center source installed ===\n'
printf '  %s\n' "$UPSTREAM_DIR/gnome-control-center-${VERSION}"
