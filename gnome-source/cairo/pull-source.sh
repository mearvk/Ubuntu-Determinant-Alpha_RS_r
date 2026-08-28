#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
DEST="$ROOT/gnome-source/cairo"
URL="https://github.com/GNOME/cairo.git"
REF="master"
DEPTH="${GNOME_CLONE_DEPTH:-20}"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

git clone --depth "$DEPTH" --branch "$REF" "$URL" "$TMP/cairo"
rm -rf "$DEST/.git"
cp -a "$TMP/cairo/." "$DEST/"
rm -rf "$DEST/.git"
printf 'Imported Cairo at clone depth %s into %s\n' "$DEPTH" "$DEST"
