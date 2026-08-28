#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
DEST="$ROOT/gnome-source/gnome-shell"
URL="https://github.com/GNOME/gnome-shell.git"
REF="main"
DEPTH="${GNOME_CLONE_DEPTH:-20}"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

git clone --depth "$DEPTH" --branch "$REF" "$URL" "$TMP/gnome-shell"
rm -rf "$DEST/.git"
cp -a "$TMP/gnome-shell/." "$DEST/"
rm -rf "$DEST/.git"
printf 'Imported GNOME Shell at clone depth %s into %s\n' "$DEPTH" "$DEST"
