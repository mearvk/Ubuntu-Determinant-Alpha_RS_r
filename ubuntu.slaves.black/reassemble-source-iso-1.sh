#!/bin/bash
# reassemble-source-iso-1.sh — Reassemble Ubuntu 22.04.3 LTS Source Disc 1
# Part of Ubuntu Determinant Alpha RS — Galactic Cherry Marvell Edition 98
#
# Reconstructs the Source 1 ISO from split chunks in ubuntu.slaves.black/1/
# Contains: core system, compilers, security, desktop, fonts, OpenStack, browsers
#
# Usage:
#   ./reassemble-source-iso-1.sh [output_directory]
#
# Default output: ./ubuntu-22.04.3-source-1.iso

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CHUNK_DIR="${SCRIPT_DIR}/1"
OUTPUT_DIR="${1:-${SCRIPT_DIR}}"
OUTPUT_FILE="${OUTPUT_DIR}/ubuntu-22.04.3-source-1.iso"

echo "╔══════════════════════════════════════════════════════════════╗"
echo "║  Reassemble: Ubuntu 22.04.3 LTS Source Disc 1              ║"
echo "║  Chunks: ${CHUNK_DIR}                                      ║"
echo "╚══════════════════════════════════════════════════════════════╝"

# Verify chunk directory exists
if [ ! -d "$CHUNK_DIR" ]; then
    echo "ERROR: Chunk directory not found: $CHUNK_DIR"
    exit 1
fi

# Count chunks
CHUNK_COUNT=$(ls "$CHUNK_DIR"/ubuntu_1_* 2>/dev/null | wc -l)
if [ "$CHUNK_COUNT" -eq 0 ]; then
    echo "ERROR: No chunks found matching ubuntu_1_* in $CHUNK_DIR"
    exit 1
fi

echo "  Found $CHUNK_COUNT chunks"
echo "  Output: $OUTPUT_FILE"
echo ""

# Check available disk space (rough estimate: 4.5 GB needed)
AVAILABLE_KB=$(df --output=avail "$OUTPUT_DIR" 2>/dev/null | tail -1)
NEEDED_KB=$((4700000))  # ~4.5 GB
if [ -n "$AVAILABLE_KB" ] && [ "$AVAILABLE_KB" -lt "$NEEDED_KB" ]; then
    echo "WARNING: Low disk space. Need ~4.5 GB, have $(( AVAILABLE_KB / 1024 / 1024 )) GB"
    echo "Continue? (y/N)"
    read -r REPLY
    [ "$REPLY" = "y" ] || exit 1
fi

# Reassemble
echo "  Reassembling..."
cat "$CHUNK_DIR"/ubuntu_1_* > "$OUTPUT_FILE"
echo "  Done: $(du -h "$OUTPUT_FILE" | cut -f1)"

# Verify ISO signature
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
