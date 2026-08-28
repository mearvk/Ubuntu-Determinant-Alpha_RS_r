#!/usr/bin/env bash
set -euo pipefail

# Ubuntu White — Desktop Icon Normalizer
#
# All project paths are relative to the CURRENT WORKING DIRECTORY.
# Run this script from the repository root:
#   ./ubuntu-white/icons/icon-size-normalizer.sh
#
# ImageMagick 6+ is supported through either `magick` or legacy `convert`.

SOURCE_DIR="./images/desktop-icons/set-001"
TARGET_DIR="./images/desktop-icons/set-002"

MAGICK_CMD=()
IDENTIFY_CMD=()
MAGICK_VERSION=""

try_magick() {
    local candidate="$1"
    [[ -x "$candidate" ]] || return 1
    local version
    version="$("$candidate" -version 2>/dev/null | head -n 1 || true)"
    [[ "$version" == *"ImageMagick "* ]] || return 1
    MAGICK_CMD=("$candidate")
    IDENTIFY_CMD=("$candidate" identify)
    MAGICK_VERSION="$version"
    return 0
}

try_convert() {
    local candidate="$1"
    [[ -x "$candidate" ]] || return 1
    local version
    version="$("$candidate" -version 2>/dev/null | head -n 1 || true)"
    [[ "$version" == *"ImageMagick "* ]] || return 1
    local identify_candidate="$(dirname "$candidate")/identify"
    [[ -x "$identify_candidate" ]] || return 1
    MAGICK_CMD=("$candidate")
    IDENTIFY_CMD=("$identify_candidate")
    MAGICK_VERSION="$version"
    return 0
}

# Search PATH first.
while IFS= read -r candidate; do
    [[ -n "$candidate" ]] || continue
    if try_magick "$candidate"; then break; fi
done < <(type -P -a magick 2>/dev/null | awk '!seen[$0]++')

# Explicitly inspect /usr/bin.
if [[ -z "$MAGICK_VERSION" ]]; then
    for candidate in /usr/bin/magick /usr/bin/ImageMagick-8 /usr/bin/ImageMagick8 /usr/bin/ImageMagick-7 /usr/bin/ImageMagick7 /usr/bin/ImageMagick-6 /usr/bin/ImageMagick6; do
        if try_magick "$candidate"; then break; fi
    done
fi

# Common local installations.
if [[ -z "$MAGICK_VERSION" ]]; then
    while IFS= read -r candidate; do
        [[ -n "$candidate" ]] || continue
        if try_magick "$candidate"; then break; fi
    done < <(
        for dir in /usr/local/bin /usr/local/sbin /opt/bin /opt/local/bin; do
            [[ -d "$dir" ]] || continue
            find "$dir" -maxdepth 1 -type f -name magick -print 2>/dev/null
        done
        for dir in /opt /usr/local/ImageMagick* /usr/local/imagemagick*; do
            [[ -d "$dir" ]] || continue
            find "$dir" -maxdepth 4 -type f -name magick -print 2>/dev/null
        done
    )
fi

# ImageMagick 6 commonly provides convert/identify.
if [[ -z "$MAGICK_VERSION" ]]; then
    while IFS= read -r convert_candidate; do
        [[ -n "$convert_candidate" ]] || continue
        if try_convert "$convert_candidate"; then break; fi
    done < <(
        type -P -a convert 2>/dev/null | awk '!seen[$0]++'
        for dir in /usr/bin /usr/local/bin /usr/local/sbin /opt/bin /opt/local/bin; do
            [[ -d "$dir" ]] || continue
            find "$dir" -maxdepth 1 -type f -name convert -print 2>/dev/null
        done
    )
fi

if [[ -z "$MAGICK_VERSION" ]]; then
    echo "ERROR: ImageMagick 6 or newer is required."
    echo "Searched PATH, /usr/bin, /usr/local/bin, /usr/local/sbin, /opt/bin,"
    echo "/opt/local/bin, and common /opt or /usr/local ImageMagick trees."
    exit 1
fi

if [[ ! -d "$SOURCE_DIR" ]]; then
    echo "ERROR: Source directory not found:"
    echo "  $SOURCE_DIR"
    echo
    echo "Run this script from the repository root."
    exit 1
fi

mkdir -p "$TARGET_DIR"

echo "Ubuntu White — Icon Normalizer"
echo "Current directory: $(pwd -P)"
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
