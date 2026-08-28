#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
DEST="$ROOT/gnome-source/glib"
URL="https://github.com/GNOME/glib.git"
REF="main"
DEPTH="${GNOME_CLONE_DEPTH:-20}"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

git clone --depth "$DEPTH" --branch "$REF" "$URL" "$TMP/glib"
rm -rf "$DEST/.git"
cp -a "$TMP/glib/." "$DEST/"
rm -rf "$DEST/.git"
printf 'Imported GLib at clone depth %s into %s\n' "$DEPTH" "$DEST"
