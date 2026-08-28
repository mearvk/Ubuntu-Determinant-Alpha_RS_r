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
# The script searches PATH and common local installation locations so a
# legacy ImageMagick 6 command earlier in PATH does not hide ImageMagick 8.
# Existing set-002 files are replaced.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$SCRIPT_DIR"

SOURCE_DIR="$REPO_ROOT/images/desktop-icons/set-001"
TARGET_DIR="$REPO_ROOT/images/desktop-icons/set-002"

MAGICK_CMD=()
IDENTIFY_CMD=()
MAGICK_VERSION=""

# Test a candidate unified ImageMagick launcher and accept it only if it is 8.x.
try_magick8() {
    local candidate="$1"
    [[ -x "$candidate" ]] || return 1

    local version
    version="$("$candidate" -version 2>/dev/null | head -n 1 || true)"
    [[ "$version" == *"ImageMagick 8."* ]] || return 1

    MAGICK_CMD=("$candidate")
    IDENTIFY_CMD=("$candidate" identify)
    MAGICK_VERSION="$version"
    return 0
}

# First inspect every `magick` visible through PATH, not just the first one.
while IFS= read -r candidate; do
    [[ -n "$candidate" ]] || continue
    if try_magick8 "$candidate"; then
        break
    fi
done < <(type -P -a magick 2>/dev/null | awk '!seen[$0]++')

# Common locations for locally compiled/versioned ImageMagick installations.
if [[ -z "$MAGICK_VERSION" ]]; then
    while IFS= read -r candidate; do
        [[ -n "$candidate" ]] || continue
        if try_magick8 "$candidate"; then
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

# Some package layouts expose ImageMagick 8 through convert/identify rather
# than the unified launcher. Search those commands as a secondary fallback.
if [[ -z "$MAGICK_VERSION" ]]; then
    while IFS= read -r convert_candidate; do
        [[ -x "$convert_candidate" ]] || continue
        version="$("$convert_candidate" -version 2>/dev/null | head -n 1 || true)"
        [[ "$version" == *"ImageMagick 8."* ]] || continue

        identify_candidate="$(dirname "$convert_candidate")/identify"
        if [[ -x "$identify_candidate" ]]; then
            MAGICK_CMD=("$convert_candidate")
            IDENTIFY_CMD=("$identify_candidate")
            MAGICK_VERSION="$version"
            break
        fi
    done < <(
        type -P -a convert 2>/dev/null | awk '!seen[$0]++'
        for dir in /usr/local/bin /usr/local/sbin /opt/bin /opt/local/bin; do
            [[ -d "$dir" ]] || continue
            find "$dir" -maxdepth 1 -type f -name convert -print 2>/dev/null
        done
    )
fi

if [[ -z "$MAGICK_VERSION" ]]; then
    echo "ERROR: ImageMagick 8 is required."
    echo
    echo "No ImageMagick 8 command was found."
    echo "A legacy ImageMagick installation may be earlier in PATH."
    echo "Searched PATH, /usr/local/bin, /usr/local/sbin, /opt/bin,"
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
