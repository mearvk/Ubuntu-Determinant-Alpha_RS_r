#!/usr/bin/env bash
set -euo pipefail

# Ubuntu Determinant — glib-networking source acquisition
#
# Downloads a pinned official GNOME release archive without requiring a
# GitHub/GitLab username or password. The pristine source is kept below
# gnome-source/glib-networking/upstream/ so future Determinant changes can
# be maintained as separate offsets/patches.
#
# 2.80.1 is the latest stable release in the 2.80 series and is the
# appropriate baseline for the Ubuntu 24.04-era GNOME/GLib stack. GNOME's
# source index lists 2.80.1 and its checksum/archive files.

VERSION="${GLIB_NETWORKING_VERSION:-2.80.1}"
ARCHIVE="glib-networking-${VERSION}.tar.xz"
SOURCE_BASE="${GLIB_NETWORKING_SOURCE_BASE:-https://download.gnome.org/sources/glib-networking}"
SOURCE_URL="${GLIB_NETWORKING_SOURCE_URL:-${SOURCE_BASE}/${VERSION%.*}/${ARCHIVE}}"
CHECKSUM_URL="${GLIB_NETWORKING_CHECKSUM_URL:-${SOURCE_BASE}/${VERSION%.*}/glib-networking-${VERSION}.sha256sum}"
SHA256="${GLIB_NETWORKING_SHA256:-}"

ROOT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
UPSTREAM_DIR="${ROOT_DIR}/upstream"
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

command -v curl >/dev/null 2>&1 || { echo "ERROR: curl is required." >&2; exit 1; }
command -v sha256sum >/dev/null 2>&1 || { echo "ERROR: sha256sum is required." >&2; exit 1; }
command -v tar >/dev/null 2>&1 || { echo "ERROR: tar is required." >&2; exit 1; }

mkdir -p "$UPSTREAM_DIR"

printf '=== Downloading glib-networking %s ===\n' "$VERSION"
printf 'Source: %s\n' "$SOURCE_URL"

curl --fail --location --retry 3 --proto '=https' --tlsv1.2 \
  --output "$TMP_DIR/$ARCHIVE" "$SOURCE_URL"

if [ -z "$SHA256" ]; then
  printf '=== Downloading upstream checksum ===\n'
  curl --fail --location --retry 3 --proto '=https' --tlsv1.2 \
    --output "$TMP_DIR/${ARCHIVE}.sha256sum" "$CHECKSUM_URL"
  SHA256="$(awk -v file="$ARCHIVE" '$2 == file || $2 == "*" file {print $1; exit}' "$TMP_DIR/${ARCHIVE}.sha256sum")"
  if ! [[ "$SHA256" =~ ^[0-9a-fA-F]{64}$ ]]; then
    echo "ERROR: Could not extract SHA-256 for ${ARCHIVE} from ${CHECKSUM_URL}." >&2
    exit 1
  fi
fi

printf '%s  %s\n' "$SHA256" "$TMP_DIR/$ARCHIVE" | sha256sum --check --strict
ACTUAL_SHA256="$(sha256sum "$TMP_DIR/$ARCHIVE" | awk '{print $1}')"
printf 'SHA256: %s\n' "$ACTUAL_SHA256"

rm -rf "$TMP_DIR/source"
mkdir -p "$TMP_DIR/source"
tar -xJf "$TMP_DIR/$ARCHIVE" -C "$TMP_DIR/source"

EXTRACTED="$TMP_DIR/source/glib-networking-${VERSION}"
if [ ! -d "$EXTRACTED" ]; then
  echo "ERROR: archive did not contain expected directory glib-networking-${VERSION}" >&2
  exit 1
fi

rm -rf "$UPSTREAM_DIR/glib-networking-${VERSION}"
cp -a "$EXTRACTED" "$UPSTREAM_DIR/glib-networking-${VERSION}"
printf '%s\n' "$ACTUAL_SHA256" > "$UPSTREAM_DIR/glib-networking-${VERSION}.sha256"
cat > "$UPSTREAM_DIR/SOURCE-INFO.txt" <<EOF
Project: glib-networking
Version: ${VERSION}
Source URL: ${SOURCE_URL}
Checksum URL: ${CHECKSUM_URL}
SHA256: ${ACTUAL_SHA256}
Acquired: $(date -u '+%Y-%m-%dT%H:%M:%SZ')

This directory contains pristine upstream source. Determinant modifications
must be maintained outside this directory as patches/offsets.
EOF

printf '=== glib-networking source installed ===\n'
printf '  %s\n' "$UPSTREAM_DIR/glib-networking-${VERSION}"
