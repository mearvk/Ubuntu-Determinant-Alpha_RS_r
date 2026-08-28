#!/usr/bin/env bash
set -euo pipefail
umask 022
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
DEST="$ROOT/gnome-source/cairo"
URL="https://github.com/GNOME/cairo.git"
REF="master"
DEPTH="${GNOME_CLONE_DEPTH:-20}"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
command -v git >/dev/null || { echo 'ERROR: git is required' >&2; exit 1; }
git clone --depth "$DEPTH" --branch "$REF" --single-branch "$URL" "$TMP/cairo"
git -C "$TMP/cairo" fsck --no-progress
test -f "$TMP/cairo/meson.build" || { echo 'ERROR: incomplete Cairo source tree' >&2; exit 1; }
test -f "$TMP/cairo/README.md" || { echo 'ERROR: missing Cairo README' >&2; exit 1; }
rm -rf "$DEST/.git"
cp -a "$TMP/cairo/." "$DEST/"
rm -rf "$DEST/.git"
printf 'Imported verified Cairo source at clone depth %s into %s\n' "$DEPTH" "$DEST"
printf '%s\n' 'Compile/install safety: use a dedicated DESTDIR or prefix; do not run generated binaries as root; review install manifests.'
