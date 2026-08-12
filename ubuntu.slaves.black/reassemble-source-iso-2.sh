#!/bin/bash
# reassemble-source-iso-2.sh — Reassemble Ubuntu 22.04.3 LTS Source Disc 2
# Part of Ubuntu Determinant Alpha RS — Galactic Cherry Marvell Edition 98
#
# Reconstructs the Source 2 ISO from split chunks in ubuntu.slaves.black/2/
# Contains: libraries, GTK stack, language packs, boot/init, Java
#
# Usage:
#   ./reassemble-source-iso-2.sh [output_directory]
#
# Default output: ./ubuntu-22.04.3-source-2.iso

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CHUNK_DIR="${SCRIPT_DIR}/2"
OUTPUT_DIR="${1:-${SCRIPT_DIR}}"
OUTPUT_FILE="${OUTPUT_DIR}/ubuntu-22.04.3-source-2.iso"

echo "╔══════════════════════════════════════════════════════════════╗"
echo "║  Reassemble: Ubuntu 22.04.3 LTS Source Disc 2              ║"
echo "║  Chunks: ${CHUNK_DIR}                                      ║"
echo "╚══════════════════════════════════════════════════════════════╝"

if [ ! -d "$CHUNK_DIR" ]; then
    echo "ERROR: Chunk directory not found: $CHUNK_DIR"
    exit 1
fi

CHUNK_COUNT=$(ls "$CHUNK_DIR"/ubuntu_2_* 2>/dev/null | wc -l)
if [ "$CHUNK_COUNT" -eq 0 ]; then
    echo "ERROR: No chunks found matching ubuntu_2_* in $CHUNK_DIR"
    exit 1
fi

echo "  Found $CHUNK_COUNT chunks"
echo "  Output: $OUTPUT_FILE"
echo ""

AVAILABLE_KB=$(df --output=avail "$OUTPUT_DIR" 2>/dev/null | tail -1)
NEEDED_KB=$((4800000))
if [ -n "$AVAILABLE_KB" ] && [ "$AVAILABLE_KB" -lt "$NEEDED_KB" ]; then
    echo "WARNING: Low disk space. Need ~4.6 GB, have $(( AVAILABLE_KB / 1024 / 1024 )) GB"
    echo "Continue? (y/N)"
    read -r REPLY
    [ "$REPLY" = "y" ] || exit 1
fi

echo "  Reassembling..."
cat "$CHUNK_DIR"/ubuntu_2_* > "$OUTPUT_FILE"
echo "  Done: $(du -h "$OUTPUT_FILE" | cut -f1)"

FILE_TYPE=$(file "$OUTPUT_FILE")
if echo "$FILE_TYPE" | grep -q "ISO 9660"; then
    echo "  ✓ Valid ISO 9660 image"
    echo "  Label: $(echo "$FILE_TYPE" | grep -oP "'[^']+'" | head -1)"
else
    echo "  ✗ WARNING: Output does not appear to be a valid ISO image"
    echo "  File type: $FILE_TYPE"
    exit 1
fi

echo ""
echo "  To mount: sudo mount -o loop,ro $OUTPUT_FILE /mnt"
echo "  To browse packages: ls /mnt/pool/main/"
