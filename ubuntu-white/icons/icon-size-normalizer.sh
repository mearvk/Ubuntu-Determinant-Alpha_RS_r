#!/usr/bin/env bash
set -euo pipefail

# Ubuntu White — Desktop Icon Normalizer
#
# Converts:
#   images/desktop-icons/set-001/icon-001.png ... icon-012.png
#
# Into:
#   images/desktop-icons/set-002/icon-001.png ... icon-012.png
#
# Normalization:
#   Canvas:       96 x 96 pixels
#   Background:   transparent
#   Artwork:      aspect ratio preserved
#   Placement:    centered
#   Filtering:    high-quality Lanczos
#
# ImageMagick 8 is the required image-processing backend.
# Existing set-002 files are replaced.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$SCRIPT_DIR"

SOURCE_DIR="$REPO_ROOT/images/desktop-icons/set-001"
TARGET_DIR="$REPO_ROOT/images/desktop-icons/set-002"

# ImageMagick 8 uses the unified `magick` command. Do not require the
# legacy `convert` executable or ImageMagick 7 specifically.
if ! command -v magick >/dev/null 2>&1; then
    echo "ERROR: ImageMagick 8 is required."
    echo
    echo "The ImageMagick 8 'magick' command was not found in PATH."
    echo "Install ImageMagick 8 and make sure 'magick' is available."
    exit 1
fi

MAGICK_VERSION="$(magick -version 2>/dev/null | head -n 1 || true)"
if [[ "$MAGICK_VERSION" != *"ImageMagick 8."* ]]; then
    echo "ERROR: ImageMagick 8 is required."
    echo "Detected: ${MAGICK_VERSION:-unknown}"
    echo
    echo "This normalizer is configured to use ImageMagick 8 via 'magick'."
    exit 1
fi

if [[ ! -d "$SOURCE_DIR" ]]; then
    echo "ERROR: Source directory not found:"
    echo "  $SOURCE_DIR"
    exit 1
fi

mkdir -p "$TARGET_DIR"

echo "Ubuntu White — Icon Normalizer"
echo "ImageMagick: $MAGICK_VERSION"
echo "Source: $SOURCE_DIR"
echo "Target: $TARGET_DIR"
echo "Canvas: 96x96 transparent"
echo

for i in $(seq -w 1 12); do
    source="$SOURCE_DIR/icon-$i.png"
    target="$TARGET_DIR/icon-$i.png"

    if [[ ! -f "$source" ]]; then
        echo "WARNING: Missing $source"
        continue
    fi

    echo "Normalizing icon-$i.png..."

    magick "$source" \
        -auto-orient \
        -alpha on \
        -background none \
        -resize '96x96>' \
        -gravity center \
        -extent 96x96 \
        -filter Lanczos \
        -define png:color-type=6 \
        "$target"
done

echo
echo "Normalization complete."
echo
echo "Generated files:"
find "$TARGET_DIR" -maxdepth 1 -type f -name 'icon-*.png' -print | sort

echo
echo "Image dimensions:"
for file in "$TARGET_DIR"/icon-*.png; do
    [[ -f "$file" ]] || continue
    magick identify -format '%f: %wx%h\n' "$file"
done
