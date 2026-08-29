#!/usr/bin/env bash
set -euo pipefail

# Ubuntu Determinant — GVfs source acquisition
#
# Downloads a pinned official GNOME GVfs release archive without requiring
# GitHub/GitLab credentials. Pristine source is kept under upstream/ so
# Determinant changes can remain separate patches/offsets.

VERSION="${GVFS_VERSION:-1.60.0}"
ARCHIVE="gvfs-${VERSION}.tar.xz"
MAJOR_MINOR="${VERSION%.*}"
SOURCE_URL="${GVFS_SOURCE_URL:-https://download.gnome.org/sources/gvfs/${MAJOR_MINOR}/${ARCHIVE}}"
CHECKSUM_URL="${GVFS_CHECKSUM_URL:-https://download.gnome.org/sources/gvfs/${MAJOR_MINOR}/${ARCHIVE}.sha256sum}"
EXPECTED_SHA256="${GVFS_SHA256:-}"

ROOT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
UPSTREAM_DIR="${ROOT_DIR}/upstream"
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

command -v curl >/dev/null 2>&1 || { echo "ERROR: curl is required." >&2; exit 1; }
command -v sha256sum >/dev/null 2>&1 || { echo "ERROR: sha256sum is required." >&2; exit 1; }
command -v tar >/dev/null 2>&1 || { echo "ERROR: tar is required." >&2; exit 1; }

mkdir -p "$UPSTREAM_DIR"

printf '=== Downloading GVfs %s ===\n' "$VERSION"
printf 'Source: %s\n' "$SOURCE_URL"

curl --fail --location --retry 3 --proto '=https' --tlsv1.2 \
  --output "$TMP_DIR/$ARCHIVE" "$SOURCE_URL"

if [ -n "$EXPECTED_SHA256" ]; then
  printf '%s  %s\n' "$EXPECTED_SHA256" "$TMP_DIR/$ARCHIVE" | sha256sum --check --strict
else
  printf 'Checksum source: %s\n' "$CHECKSUM_URL"
  curl --fail --location --retry 3 --proto '=https' --tlsv1.2 \
    --output "$TMP_DIR/$ARCHIVE.sha256sum" "$CHECKSUM_URL"

  # GNOME checksum files conventionally contain: <hash>  <filename>.
  EXPECTED_SHA256="$(awk -v file="$ARCHIVE" '$2 == file { print $1; exit }' "$TMP_DIR/$ARCHIVE.sha256sum")"
  if [ -z "$EXPECTED_SHA256" ]; then
    echo "ERROR: could not find checksum for $ARCHIVE in $CHECKSUM_URL" >&2
    exit 1
  fi

  printf '%s  %s\n' "$EXPECTED_SHA256" "$TMP_DIR/$ARCHIVE" | sha256sum --check --strict
fi

ACTUAL_SHA256="$(sha256sum "$TMP_DIR/$ARCHIVE" | awk '{print $1}')"
printf 'SHA256: %s\n' "$ACTUAL_SHA256"

rm -rf "$TMP_DIR/source"
mkdir -p "$TMP_DIR/source"
tar -xJf "$TMP_DIR/$ARCHIVE" -C "$TMP_DIR/source"

EXTRACTED="$TMP_DIR/source/gvfs-${VERSION}"
if [ ! -d "$EXTRACTED" ]; then
  echo "ERROR: archive did not contain expected directory gvfs-${VERSION}" >&2
  exit 1
fi

rm -rf "$UPSTREAM_DIR/gvfs-${VERSION}"
cp -a "$EXTRACTED" "$UPSTREAM_DIR/gvfs-${VERSION}"
printf '%s  %s\n' "$ACTUAL_SHA256" "$ARCHIVE" > "$UPSTREAM_DIR/gvfs-${VERSION}.sha256"
cat > "$UPSTREAM_DIR/SOURCE-INFO.txt" <<EOF
Project: gvfs
Version: ${VERSION}
Source URL: ${SOURCE_URL}
Checksum URL: ${CHECKSUM_URL}
SHA256: ${ACTUAL_SHA256}
Acquired: $(date -u '+%Y-%m-%dT%H:%M:%SZ')

This directory contains pristine upstream source. Determinant modifications
must be maintained outside this directory as patches/offsets.
EOF

printf '=== GVfs source installed ===\n'
printf '  %s\n' "$UPSTREAM_DIR/gvfs-${VERSION}"
