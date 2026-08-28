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
# The script accepts either the unified `magick` launcher or the
# versioned installation's `convert`/`identify` compatibility commands.
# Existing set-002 files are replaced.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$SCRIPT_DIR"

SOURCE_DIR="$REPO_ROOT/images/desktop-icons/set-001"
TARGET_DIR="$REPO_ROOT/images/desktop-icons/set-002"

# ImageMagick 8 installations can expose the unified `magick` command,
# or expose `convert` and `identify` directly. Prefer the unified launcher,
# but do not reject a valid ImageMagick 8 installation merely because its
# packaging does not provide `magick` in PATH.
MAGICK_CMD=()
IDENTIFY_CMD=()
MAGICK_VERSION=""

if command -v magick >/dev/null 2>&1; then
    MAGICK_CMD=(magick)
    IDENTIFY_CMD=(magick identify)
    MAGICK_VERSION="$(magick -version 2>/dev/null | head -n 1 || true)"
elif command -v convert >/dev/null 2>&1 && command -v identify >/dev/null 2>&1; then
    MAGICK_CMD=(convert)
    IDENTIFY_CMD=(identify)
    MAGICK_VERSION="$(identify -version 2>/dev/null | head -n 1 || true)"
    if [[ -z "$MAGICK_VERSION" ]]; then
        MAGICK_VERSION="$(convert -version 2>/dev/null | head -n 1 || true)"
    fi
fi

if [[ -z "$MAGICK_VERSION" ]]; then
    echo "ERROR: ImageMagick 8 is required."
    echo
    echo "Could not find a usable ImageMagick command."
    echo "Supported command layouts:"
    echo "  magick"
    echo "  convert + identify"
    exit 1
fi

if [[ "$MAGICK_VERSION" != *"ImageMagick 8."* ]]; then
    echo "ERROR: ImageMagick 8 is required."
    echo "Detected: ${MAGICK_VERSION:-unknown}"
    echo
    echo "A usable ImageMagick installation was found, but it is not version 8."
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
echo "ImageMagick command: ${MAGICK_CMD[*]}"
echo "Identify command: ${IDENTIFY_CMD[*]}"
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

    "${MAGICK_CMD[@]}" "$source" \
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
    "${IDENTIFY_CMD[@]}" -format '%f: %wx%h\n' "$file"
done
