#!/bin/bash
# reassemble-source-all.sh — Reassemble all Ubuntu 22.04.3 LTS Source ISOs
# Part of Ubuntu Determinant Alpha RS — Galactic Cherry Marvell Edition 98
#
# Reconstructs all 4 source disc ISOs and optionally extracts source packages
# into a unified pool directory for OS development use.
#
# Usage:
#   ./reassemble-source-all.sh [output_directory]
#   ./reassemble-source-all.sh --extract-pool [output_directory]
#
# Options:
#   --extract-pool    After reassembly, mount each ISO and copy all source
#                     packages into output_directory/pool/ for direct access.
#
# Default output: ./

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
OUTPUT_DIR="${1:-${SCRIPT_DIR}}"
EXTRACT_POOL=0

# Parse flags
for arg in "$@"; do
    case "$arg" in
        --extract-pool) EXTRACT_POOL=1 ;;
        -*) echo "Unknown option: $arg"; exit 1 ;;
        *) OUTPUT_DIR="$arg" ;;
    esac
done

echo "╔══════════════════════════════════════════════════════════════╗"
echo "║  Reassemble ALL: Ubuntu 22.04.3 LTS Source Discs 1-4       ║"
echo "║  Total: ~12 GB reassembled ISOs                            ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""

mkdir -p "$OUTPUT_DIR"

FAILED=0

for DISC in 1 2 3 4; do
    SCRIPT="${SCRIPT_DIR}/reassemble-source-iso-${DISC}.sh"
    if [ -x "$SCRIPT" ]; then
        echo "━━━ Disc $DISC ━━━"
        "$SCRIPT" "$OUTPUT_DIR" || FAILED=$((FAILED + 1))
        echo ""
    else
        echo "  SKIP: $SCRIPT not found or not executable"
        FAILED=$((FAILED + 1))
    fi
done

if [ "$FAILED" -gt 0 ]; then
    echo "WARNING: $FAILED disc(s) failed to reassemble"
fi

# Optionally extract pool
if [ "$EXTRACT_POOL" -eq 1 ]; then
    echo "━━━ Extracting source pool ━━━"
    POOL_DIR="${OUTPUT_DIR}/pool"
    MOUNT_POINT="/tmp/ubuntu-source-mount-$$"
    mkdir -p "$POOL_DIR" "$MOUNT_POINT"

    for DISC in 1 2 3 4; do
        ISO="${OUTPUT_DIR}/ubuntu-22.04.3-source-${DISC}.iso"
        if [ -f "$ISO" ]; then
            echo "  Extracting disc $DISC..."
            sudo mount -o loop,ro "$ISO" "$MOUNT_POINT"
            if [ -d "$MOUNT_POINT/pool" ]; then
                cp -rn "$MOUNT_POINT/pool/"* "$POOL_DIR/" 2>/dev/null || true
            fi
            sudo umount "$MOUNT_POINT"
        fi
    done

    rmdir "$MOUNT_POINT" 2>/dev/null || true

    echo "  Pool extracted to: $POOL_DIR"
    echo "  Packages available: $(find "$POOL_DIR" -name "*.dsc" 2>/dev/null | wc -l) source packages"
fi

echo ""
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║  Complete                                                   ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""
echo "  ISOs in: $OUTPUT_DIR/"
ls -lh "$OUTPUT_DIR"/ubuntu-22.04.3-source-*.iso 2>/dev/null || echo "  (no ISOs found)"
