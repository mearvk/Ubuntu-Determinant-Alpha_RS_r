#!/usr/bin/env bash
set -euo pipefail

# Install the repository's Ubuntu White Edition icons as the initial desktop
# icon theme. The source of truth is ubuntu-white/icons; GNOME source trees
# must never become a second copy of the artwork.
#
# Usage: install-icons.sh <target-root>

ROOT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")/../../../../" && pwd)"
ICON_ROOT="$ROOT_DIR/ubuntu-white/icons"
TARGET_ROOT="${1:-}"

[ -n "$TARGET_ROOT" ] || { echo "ERROR: target root is required." >&2; exit 2; }
[ -d "$TARGET_ROOT/etc" ] || { echo "ERROR: target root lacks /etc: $TARGET_ROOT" >&2; exit 2; }
[ -d "$ICON_ROOT" ] || { echo "ERROR: icon source not found: $ICON_ROOT" >&2; exit 1; }

case "$TARGET_ROOT" in
  /|/*) ;;
  *) echo "ERROR: target root must be an absolute path." >&2; exit 2 ;;
esac

# Refuse to follow links in the artwork tree. This prevents a malformed icon
# checkout from causing files outside the intended theme destination to be
# copied or inspected by the installer.
if find -L "$ICON_ROOT" -type l -print -quit | grep -q .; then
  echo "ERROR: symbolic links found under icon source; refusing installation." >&2
  exit 1
fi

# Reject device/socket/FIFO entries; the icon source should contain regular
# artwork and directories only.
if find "$ICON_ROOT" -type f -o -type d | head -n 1 >/dev/null; then :; fi
if find "$ICON_ROOT" \( -type b -o -type c -o -type p -o -type s \) -print -quit | grep -q .; then
  echo "ERROR: non-regular filesystem object found in icon source." >&2
  exit 1
fi

DEST="$TARGET_ROOT/usr/share/icons/Ubuntu-White"
mkdir -p "$DEST"

# Copy the artwork without dereferencing source symlinks (already prohibited)
# and preserve file metadata where possible. No deletion of unrelated target
# files is performed.
cp -a -- "$ICON_ROOT/." "$DEST/"

# A valid icon theme needs an index.theme. Do not silently fabricate one if the
# source package already supplies one; only create the minimal index when the
# repository's icon directory has not yet provided it.
if [ ! -f "$DEST/index.theme" ]; then
  cat > "$DEST/index.theme" <<'EOF'
[Icon Theme]
Name=Ubuntu-White
Comment=Ubuntu White Edition desktop icon theme
Inherits=hicolor
EOF
fi

printf 'Ubuntu White Edition icons installed: %s\n' "$DEST"
