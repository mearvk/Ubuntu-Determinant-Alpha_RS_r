#!/usr/bin/env bash
set -euo pipefail

# Install the repository's ubuntu-white/icons artwork as the initial desktop
# icon theme. This is an allow-list installer: it copies only approved
# root-level SVG artwork, never working sets or arbitrary filesystem objects.
# GNOME source trees are never used as a second icon source.
#
# Usage: install-icons.sh <target-root>

ROOT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")/../../../../" && pwd)"
ICON_ROOT="$ROOT_DIR/ubuntu-white/icons"
TARGET_ROOT="${1:-}"
THEME_ROOT="$TARGET_ROOT/usr/share/icons/Ubuntu-White"

[ -n "$TARGET_ROOT" ] || { echo "ERROR: target root is required." >&2; exit 2; }
[ -d "$TARGET_ROOT/etc" ] || { echo "ERROR: target root lacks /etc: $TARGET_ROOT" >&2; exit 2; }
[ -d "$ICON_ROOT" ] || { echo "ERROR: icon source not found: $ICON_ROOT" >&2; exit 1; }

case "$TARGET_ROOT" in
  /*) ;;
  *) echo "ERROR: target root must be an absolute path." >&2; exit 2 ;;
esac

# Do not allow links or special files in the artwork source. This prevents a
# malformed checkout from redirecting installation outside the icon tree.
if find -L "$ICON_ROOT" -type l -print -quit | grep -q .; then
  echo "ERROR: symbolic links found under icon source; refusing installation." >&2
  exit 1
fi
if find "$ICON_ROOT" \( -type b -o -type c -o -type p -o -type s \) -print -quit | grep -q .; then
  echo "ERROR: special filesystem object found in icon source." >&2
  exit 1
fi

mkdir -p "$THEME_ROOT/scalable/places" \
         "$THEME_ROOT/scalable/apps" \
         "$THEME_ROOT/scalable/actions"

copy_icon() {
  local name="$1" category="$2"
  local src="$ICON_ROOT/$name.svg"
  [ -f "$src" ] || return 0
  install -m 0644 -- "$src" "$THEME_ROOT/scalable/$category/$name.svg"
}

# These are the initial Desktop LAF assets. Additional artwork is added only
# by an explicit allow-list change after review.
copy_icon folder places
copy_icon home places
copy_icon trash places
copy_icon terminal apps
copy_icon settings apps
copy_icon downloads actions

# The theme index is repository-controlled and installed independently of
# artwork so the resulting theme has a deterministic definition.
install -m 0644 -- "$(dirname -- "$0")/icon-theme/index.theme" "$THEME_ROOT/index.theme"

printf 'Ubuntu White Edition icon theme installed: %s\n' "$THEME_ROOT"
