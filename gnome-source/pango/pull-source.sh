#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
DEST="$ROOT/gnome-source/pango"
URL="https://github.com/GNOME/pango.git"
REF="main"
DEPTH="${GNOME_CLONE_DEPTH:-20}"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

git clone --depth "$DEPTH" --branch "$REF" "$URL" "$TMP/pango"
rm -rf "$DEST/.git"
cp -a "$TMP/pango/." "$DEST/"
rm -rf "$DEST/.git"
printf 'Imported Pango at clone depth %s into %s\n' "$DEPTH" "$DEST"
