#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
DEST="$ROOT/gnome-source/gdk-pixbuf"
URL="https://github.com/GNOME/gdk-pixbuf.git"
REF="main"
DEPTH="${GNOME_CLONE_DEPTH:-20}"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

git clone --depth "$DEPTH" --branch "$REF" "$URL" "$TMP/gdk-pixbuf"
rm -rf "$DEST/.git"
cp -a "$TMP/gdk-pixbuf/." "$DEST/"
rm -rf "$DEST/.git"
printf 'Imported GDK-Pixbuf at clone depth %s into %s\n' "$DEPTH" "$DEST"
