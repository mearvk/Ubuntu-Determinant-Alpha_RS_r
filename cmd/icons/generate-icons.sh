#!/bin/sh
set -eu

# Canonical source is cmd-master.svg. Every icon size is rendered directly
# from that source with Lanczos reconstruction; reduced icons are never
# recursively resized from another reduced raster.

ROOT=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
MASTER="$ROOT/cmd-master.svg"

command -v convert >/dev/null 2>&1 || {
    echo "ImageMagick 'convert' is required" >&2
    exit 127
}

for size in 48 32 24 16 12; do
    convert -background none "$MASTER" -filter Lanczos -resize "${size}x${size}" "$ROOT/cmd-${size}x${size}.png"
    convert -background white "$MASTER" -filter Lanczos -resize "${size}x${size}" -quality 95 "$ROOT/cmd-${size}x${size}.jpg"
    convert -background white "$MASTER" -filter Lanczos -resize "${size}x${size}" -quality 95 "$ROOT/cmd-${size}x${size}.jpeg"
done

# Keep a larger canonical raster for environments that do not consume SVG.
convert -background none "$MASTER" -filter Lanczos -resize 512x512 "$ROOT/cmd-master.png"

echo "Generated JSpec cmd icon family: 48, 32, 24, 16, 12 px in PNG/JPG/JPEG."
