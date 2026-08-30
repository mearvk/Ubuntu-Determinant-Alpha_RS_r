#!/bin/sh
# Install a desktop launcher for one XMC source file.
# The launcher invokes xmc-build; it does not pretend that .asysma is an
# operating-system executable. The resulting .asysma remains beside SOURCE.
set -eu

if [ "$#" -ne 1 ]; then
    echo "usage: xmc-install-desktop.sh SOURCE" >&2
    exit 2
fi

SOURCE=$(CDPATH= cd -- "$(dirname -- "$1")" && pwd)/$(basename -- "$1")
if [ ! -f "$SOURCE" ]; then
    echo "xmc-install-desktop: source file not found: $SOURCE" >&2
    exit 2
fi

XMC_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
NAME=$(basename "${SOURCE%.*}")
DESKTOP_NAME="XMC Build ${NAME}"
DESKTOP_FILE="${SOURCE%.*}.desktop"
APPLICATIONS_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/applications"

mkdir -p "$APPLICATIONS_DIR"

cat > "$DESKTOP_FILE" <<EOF
[Desktop Entry]
Type=Application
Name=$DESKTOP_NAME
Comment=Build $NAME with XMC and create a localized ASYSMA package
Terminal=true
Exec=$XMC_DIR/xmc-build --verbose $SOURCE
Categories=Development;
EOF

cp "$DESKTOP_FILE" "$APPLICATIONS_DIR/"
chmod 0644 "$DESKTOP_FILE" "$APPLICATIONS_DIR/$(basename "$DESKTOP_FILE")"

if command -v update-desktop-database >/dev/null 2>&1; then
    update-desktop-database "$APPLICATIONS_DIR" >/dev/null 2>&1 || true
fi

echo "xmc-install-desktop: installed $DESKTOP_FILE"
echo "xmc-install-desktop: application entry $APPLICATIONS_DIR/$(basename "$DESKTOP_FILE")"
echo "xmc-install-desktop: build output will remain beside $SOURCE"
