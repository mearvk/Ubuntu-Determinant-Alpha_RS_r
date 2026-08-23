#!/bin/sh
set -eu

# Generate every icon directly from the canonical master. ImageMagick is used
# only as a build-time rasterizer; reduced images are never used as sources.
MASTER="${1:-cmd-master.svg}"
OUT="${2:-.}"

command -v magick >/dev/null 2>&1 || {
    echo "error: ImageMagick 'magick' is required" >&2
    exit 127
}

mkdir -p "$OUT"

for size in 48 32 24 16 12; do
    magick "$MASTER" \
        -background none \
        -alpha on \
        -filter Lanczos \
        -resize "${size}x${size}" \
        -define png:color-type=6 \
        "$OUT/jspec-${size}x${size}.png"
done

echo "generated JSpec icons from $MASTER at 48, 32, 24, 16, and 12 pixels"
