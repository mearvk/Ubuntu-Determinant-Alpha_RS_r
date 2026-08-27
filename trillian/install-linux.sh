#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")" && pwd)"
PREFIX="${PREFIX:-$HOME/.local}"

cd "$ROOT"
make PREFIX="$PREFIX" build

# Install only through the project's declared Meson install manifest.
meson install -C build-linux --destdir "${DESTDIR:-}" --prefix "$PREFIX"

echo "Trillian/Dino installed to prefix: $PREFIX"
