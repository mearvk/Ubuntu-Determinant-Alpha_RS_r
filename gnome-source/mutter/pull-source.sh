#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
DEST="$ROOT/gnome-source/mutter"
URL="https://github.com/GNOME/mutter.git"
REF="main"
DEPTH="${GNOME_CLONE_DEPTH:-20}"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

git clone --depth "$DEPTH" --branch "$REF" "$URL" "$TMP/mutter"
rm -rf "$DEST/.git"
cp -a "$TMP/mutter/." "$DEST/"
rm -rf "$DEST/.git"
printf 'Imported Mutter at clone depth %s into %s\n' "$DEPTH" "$DEST"
