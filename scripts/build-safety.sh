#!/usr/bin/env bash
set -euo pipefail
umask 022

# Build/source safety gate for the GNOME source import.
# This script validates source trees and creates SHA-256 manifests before a
# build is allowed to consume them. It never executes files from the source.

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
GNOME_ROOT="$ROOT/gnome-source"
MANIFEST="$GNOME_ROOT/SHA256SUMS.source"
STAGE="${BUILD_DIR:-$ROOT/build}/rootfs"
PREFIX="${DESTDIR:-$STAGE}"

fail() { echo "ERROR: $*" >&2; exit 1; }
command -v sha256sum >/dev/null || fail "sha256sum is required"
command -v find >/dev/null || fail "find is required"

[ -d "$GNOME_ROOT" ] || fail "missing gnome-source directory"

# Refuse unsafe installation destinations. A build may stage under the repo,
# but this gate will not silently install into the host filesystem.
case "$PREFIX" in
  "$ROOT"/*) ;;
  *) fail "unsafe DESTDIR/build staging path: $PREFIX (use a path under $ROOT/build)" ;;
esac

TMP_MANIFEST="$(mktemp)"
trap 'rm -f "$TMP_MANIFEST"' EXIT

# Hash source files in deterministic path order. Ignore Git metadata and
# transient build/cache directories. SHA-256 is supplemental to Git commit
# provenance: it gives an independent content digest for the initial crawl.
find "$GNOME_ROOT" -type f \
  ! -path '*/.git/*' \
  ! -path '*/build/*' \
  ! -path '*/_build/*' \
  ! -name 'SHA256SUMS.source' \
  -print0 | sort -z | while IFS= read -r -d '' file; do
    sha256sum "$file"
done > "$TMP_MANIFEST"

mv "$TMP_MANIFEST" "$MANIFEST"
trap - EXIT

# Source completeness gate for every recognized component.
for component in glib pango gdk-pixbuf cairo gtk gnome-shell mutter; do
  dir="$GNOME_ROOT/$component"
  [ -d "$dir" ] || fail "missing GNOME component: $component"
  [ -f "$dir/README.md" ] || fail "missing README.md: $component"
  [ -f "$dir/meson.build" ] || fail "missing meson.build: $component"
done

# Never execute downloaded source or generated executables as part of this gate.
# Compilation should occur as an unprivileged user; installation must be a
# separately reviewed staged operation.
echo "Source safety gate passed."
echo "SHA-256 manifest: $MANIFEST"
echo "Staging destination: $PREFIX"
echo "No upstream source executable was run."
echo "Do not use sudo for compilation; review DESTDIR/install manifests before packaging."
