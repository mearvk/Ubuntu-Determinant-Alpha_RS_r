#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")" && pwd)"
SRC="$ROOT/dino"
BUILD="$ROOT/build-macos"

if [[ ! -d "$SRC" ]]; then
  echo "ERROR: $SRC does not exist. Run ./pull-dino.sh first." >&2
  exit 1
fi
command -v meson >/dev/null 2>&1 || { echo "ERROR: meson is required." >&2; exit 2; }
command -v ninja >/dev/null 2>&1 || { echo "ERROR: ninja is required." >&2; exit 2; }

meson setup "$BUILD" "$SRC" --buildtype=debugoptimized --warnlevel=3
meson compile -C "$BUILD"
echo "Trillian/Dino macOS build completed: $BUILD"
