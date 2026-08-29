#!/usr/bin/env bash
set -euo pipefail
umask 022

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
DEST="$ROOT/gnome-source/cairo"

# Cairo is a freedesktop.org project, not a GNOME GitHub repository.
# Keep the upstream location configurable, but default to the official
# freedesktop GitLab repository. Do not prompt for GitHub credentials.
URL="${CAIRO_SOURCE_URL:-https://gitlab.freedesktop.org/cairo/cairo.git}"
REF="${CAIRO_SOURCE_REF:-master}"
DEPTH="${CAIRO_CLONE_DEPTH:-20}"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

command -v git >/dev/null || { echo 'ERROR: git is required' >&2; exit 1; }

echo "=== Pulling Cairo source ==="
echo "  Repository: $URL"
echo "  Ref:        $REF"
echo "  Depth:      $DEPTH"

# Use an explicit public clone URL. If an operator has configured a private
# mirror, credentials may be supplied through that mirror's normal Git setup;
# the default upstream must remain anonymously cloneable.
git clone --depth "$DEPTH" --branch "$REF" --single-branch "$URL" "$TMP/cairo"

git -C "$TMP/cairo" fsck --no-progress

test -f "$TMP/cairo/meson.build" || {
  echo 'ERROR: incomplete Cairo source tree (meson.build missing)' >&2
  exit 1
}
test -f "$TMP/cairo/README.md" || {
  echo 'ERROR: incomplete Cairo source tree (README.md missing)' >&2
  exit 1
}

echo "=== Cairo source revision ==="
git -C "$TMP/cairo" rev-parse HEAD

git -C "$TMP/cairo" describe --tags --always 2>/dev/null || true

mkdir -p "$DEST"
rm -rf "$DEST/.git"
cp -a "$TMP/cairo/." "$DEST/"
rm -rf "$DEST/.git"

printf 'Imported Cairo source at clone depth %s into %s\n' "$DEPTH" "$DEST"
printf '%s\n' 'Compile/install safety: use a dedicated DESTDIR or prefix; do not run generated binaries as root; review install manifests.'
printf '%s\n' 'Upstream: https://gitlab.freedesktop.org/cairo/cairo'
