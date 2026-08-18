#!/bin/bash
# delete-full-isos.sh — Remove reassembled full ISOs (chunks remain for rebuild)
# Part of Ubuntu Determinant Alpha RS — Galactic Cherry Marvell Edition 98
#
# The split chunks (ubuntu_N_xx) can always regenerate these via:
#   ./reassemble-source-all.sh
#
# Usage:
#   ./delete-full-isos.sh        # Interactive (confirms before delete)
#   ./delete-full-isos.sh -y     # No prompt

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
YES=0

[ "${1:-}" = "-y" ] || [ "${1:-}" = "--yes" ] && YES=1

echo "═══════════════════════════════════════════════════════════════"
echo "  DELETE FULL ISOs"
echo "═══════════════════════════════════════════════════════════════"
echo ""

# Find ISOs
declare -a ISOS=()
TOTAL_SIZE=0

while IFS= read -r -d '' f; do
    SIZE=$(stat -c%s "$f")
    SIZE_MB=$((SIZE / 1024 / 1024))
    echo "  $(basename "$f")  — ${SIZE_MB} MB"
    ISOS+=("$f")
    TOTAL_SIZE=$((TOTAL_SIZE + SIZE))
done < <(find "$SCRIPT_DIR" -maxdepth 1 -name "*.iso" -print0 2>/dev/null | sort -z)

if [ ${#ISOS[@]} -eq 0 ]; then
    echo "  No ISOs found. Nothing to do."
    exit 0
fi

TOTAL_GB=$(echo "scale=2; $TOTAL_SIZE / 1024 / 1024 / 1024" | bc)
echo ""
echo "  Total: ${#ISOS[@]} ISOs, ~${TOTAL_GB} GB"
echo "  Split chunks remain — rebuild anytime with ./reassemble-source-all.sh"
echo ""

if [ "$YES" -eq 0 ]; then
    read -rp "  Delete these ISOs? [y/N] " CONFIRM
    if [[ ! "$CONFIRM" =~ ^[Yy]$ ]]; then
        echo "  Aborted."
        exit 0
    fi
fi

for f in "${ISOS[@]}"; do
    rm -f "$f" && echo "  ✓ Removed: $(basename "$f")" || echo "  ✗ Failed:  $(basename "$f")"
done

echo ""
echo "  Done. Freed ~${TOTAL_GB} GB."
echo "═══════════════════════════════════════════════════════════════"
