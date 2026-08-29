#!/usr/bin/env bash
set -euo pipefail

# Ubuntu Determinant GNOME source-layout normalizer.
#
# Canonical layout:
#   gnome-source/<module>/source/
#
# `upstream/` is intentionally NOT a final repository name. Older pull scripts
# and already-acquired trees may still use it, so this script safely migrates
# them into the canonical `source/` location before a build consumes them.
#
# The script is deliberately filesystem-oriented: it can normalize source that
# was pulled on the build host even when the large upstream tree is not checked
# into Git. It never follows symlinks while copying and never deletes a source
# tree until its contents have been successfully transferred.

ROOT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"

MODULES=(
  cairo
  gdk-pixbuf
  glib
  glib-networking
  gnome-control-center
  gnome-shell
  gnome-software
  gnome-terminal
  gtk
  gvfs
  mutter
  orca
  vala
  gala
)

copy_tree() {
  local src="$1" dst="$2"
  mkdir -p "$dst"
  if command -v rsync >/dev/null 2>&1; then
    rsync -a --links --safe-links "$src/" "$dst/"
  else
    cp -a "$src/." "$dst/"
  fi
}

normalize_module() {
  local module="$1"
  local base="$ROOT_DIR/$module"
  local source="$base/source"
  local old="$base/upstream"

  mkdir -p "$base"

  if [ -d "$old" ]; then
    if [ -e "$source" ] && [ ! -d "$source" ]; then
      echo "ERROR: $module: source exists but is not a directory: $source" >&2
      return 1
    fi

    if [ -d "$source" ] && [ "$(find "$source" -mindepth 1 -maxdepth 1 -print -quit)" ]; then
      echo "ERROR: $module: refusing to merge non-empty upstream into non-empty source automatically." >&2
      echo "       Review: $old -> $source" >&2
      return 1
    fi

    mkdir -p "$source"
    copy_tree "$old" "$source"
    rm -rf --one-file-system "$old"
    echo "Normalized $module: upstream -> source"
  else
    mkdir -p "$source"
    echo "Ready $module: canonical source directory is $source"
  fi
}

for module in "${MODULES[@]}"; do
  normalize_module "$module"
done

printf '\nGNOME source layout normalization complete.\n'
printf 'Canonical source root: gnome-source/<module>/source/\n'
printf 'No module should use upstream/ as its final source location.\n'
