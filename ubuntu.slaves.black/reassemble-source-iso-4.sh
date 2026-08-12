#!/bin/bash
# reassemble-source-iso-4.sh — Reassemble Ubuntu 22.04.3 LTS Source Disc 4
# Part of Ubuntu Determinant Alpha RS — Galactic Cherry Marvell Edition 98
#
# Reconstructs the Source 4 ISO from split chunks in ubuntu.slaves.black/4/
# Contains: Linux kernel, dictionaries, OpenStack nova/neutron, system tools
#
# Usage:
#   ./reassemble-source-iso-4.sh [output_directory]
#
# Default output: ./ubuntu-22.04.3-source-4.iso

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CHUNK_DIR="${SCRIPT_DIR}/4"
OUTPUT_DIR="${1:-${SCRIPT_DIR}}"
OUTPUT_FILE="${OUTPUT_DIR}/ubuntu-22.04.3-source-4.iso"

echo "╔══════════════════════════════════════════════════════════════╗"
echo "║  Reassemble: Ubuntu 22.04.3 LTS Source Disc 4              ║"
echo "║  Chunks: ${CHUNK_DIR}                                      ║"
echo "╚══════════════════════════════════════════════════════════════╝"

if [ ! -d "$CHUNK_DIR" ]; then
    echo "ERROR: Chunk directory not found: $CHUNK_DIR"
    exit 1
fi

CHUNK_COUNT=$(ls "$CHUNK_DIR"/ubuntu_4_* 2>/dev/null | wc -l)
if [ "$CHUNK_COUNT" -eq 0 ]; then
    echo "ERROR: No chunks found matching ubuntu_4_* in $CHUNK_DIR"
    exit 1
fi

echo "  Found $CHUNK_COUNT chunks"
echo "  Output: $OUTPUT_FILE"
echo ""

AVAILABLE_KB=$(df --output=avail "$OUTPUT_DIR" 2>/dev/null | tail -1)
NEEDED_KB=$((1500000))
if [ -n "$AVAILABLE_KB" ] && [ "$AVAILABLE_KB" -lt "$NEEDED_KB" ]; then
    echo "WARNING: Low disk space. Need ~1.4 GB, have $(( AVAILABLE_KB / 1024 / 1024 )) GB"
    echo "Continue? (y/N)"
    read -r REPLY
    [ "$REPLY" = "y" ] || exit 1
fi

echo "  Reassembling..."
cat "$CHUNK_DIR"/ubuntu_4_* > "$OUTPUT_FILE"
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
