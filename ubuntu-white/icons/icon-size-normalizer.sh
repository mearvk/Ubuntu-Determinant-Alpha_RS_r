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
# ImageMagick 6+ is supported. The script prefers the unified `magick`
# launcher when available, but also supports the legacy `convert` and
# `identify` commands shipped by ImageMagick 6.
# Existing set-002 files are replaced.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$SCRIPT_DIR"

SOURCE_DIR="$REPO_ROOT/images/desktop-icons/set-001"
TARGET_DIR="$REPO_ROOT/images/desktop-icons/set-002"

MAGICK_CMD=()
IDENTIFY_CMD=()
MAGICK_VERSION=""

# Accept ImageMagick 6.x or newer through a unified `magick` executable.
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

# Accept ImageMagick 6.x or newer through the legacy `convert` executable.
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

# First inspect every `magick` visible through PATH, not just the first one.
while IFS= read -r candidate; do
    [[ -n "$candidate" ]] || continue
    if try_magick "$candidate"; then
        break
    fi
done < <(type -P -a magick 2>/dev/null | awk '!seen[$0]++')

# Explicitly inspect /usr/bin as well. This matters on systems where the
# ImageMagick executable exists there but is not exposed through PATH.
if [[ -z "$MAGICK_VERSION" ]]; then
    for candidate in /usr/bin/magick /usr/bin/ImageMagick-8 /usr/bin/ImageMagick8 /usr/bin/ImageMagick-7 /usr/bin/ImageMagick7 /usr/bin/ImageMagick-6 /usr/bin/ImageMagick6; do
        if try_magick "$candidate"; then
            break
        fi
    done
fi

# Common locations for locally compiled/versioned ImageMagick installations.
if [[ -z "$MAGICK_VERSION" ]]; then
    while IFS= read -r candidate; do
        [[ -n "$candidate" ]] || continue
        if try_magick "$candidate"; then
            break
        fi
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

# ImageMagick 6 commonly provides `convert` and `identify` instead of the
# unified `magick` launcher. Search PATH and explicit system locations.
if [[ -z "$MAGICK_VERSION" ]]; then
    while IFS= read -r convert_candidate; do
        [[ -n "$convert_candidate" ]] || continue
        if try_convert "$convert_candidate"; then
            break
        fi
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
    echo
    echo "No compatible ImageMagick command was found."
    echo "Searched PATH, /usr/bin, /usr/local/bin, /usr/local/sbin, /opt/bin,"
    echo "/opt/local/bin, and common /opt or /usr/local ImageMagick trees."
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
