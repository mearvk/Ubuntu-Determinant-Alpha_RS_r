```bash
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
# Existing set-002 files are replaced.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$SCRIPT_DIR"

SOURCE_DIR="$REPO_ROOT/images/desktop-icons/set-001"
TARGET_DIR="$REPO_ROOT/images/desktop-icons/set-002"

if ! command -v magick >/dev/null 2>&1; then
    echo "ERROR: ImageMagick is required."
    echo
    echo "Install it with:"
    echo "  Ubuntu/Debian: sudo apt install imagemagick"
    echo "  Fedora:        sudo dnf install ImageMagick"
    echo "  macOS:         brew install imagemagick"
    exit 1
fi

if [[ ! -d "$SOURCE_DIR" ]]; then
    echo "ERROR: Source directory not found:"
    echo "  $SOURCE_DIR"
    exit 1
fi

mkdir -p "$TARGET_DIR"

echo "Ubuntu White — Icon Normalizer"
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
    identify -format '%f: %wx%h\n' "$file"
done
```

