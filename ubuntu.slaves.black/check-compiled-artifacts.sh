#!/bin/bash
# check-compiled-artifacts.sh — Find and optionally clean compiled/reassembled artifacts
# Part of Ubuntu Determinant Alpha RS — Galactic Cherry Marvell Edition 98
#
# Checks for:
#   1. Reassembled ISOs (compiled from split chunks) in this directory
#   2. Split chunks (ubuntu_N_xx files) that produced those ISOs
#   3. Leftover build artifacts in /tmp (mount points, extracted packages)
#   4. Anything hidden in the filesystem from older compilation runs
#
# Usage:
#   ./check-compiled-artifacts.sh              # Report only
#   ./check-compiled-artifacts.sh --clean      # Remove oversized artifacts (interactive)
#   ./check-compiled-artifacts.sh --clean -y   # Remove without prompting

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CLEAN=0
YES=0
THRESHOLD_MB=50  # Files above this are "too large" for git

while [ $# -gt 0 ]; do
    case "$1" in
        --clean) CLEAN=1; shift ;;
        -y|--yes) YES=1; shift ;;
        --threshold) THRESHOLD_MB="$2"; shift 2 ;;
        -h|--help)
            echo "Usage: $0 [--clean] [-y] [--threshold MB]"
            echo ""
            echo "  --clean       Remove oversized artifacts (interactive)"
            echo "  -y, --yes     Skip confirmation prompts"
            echo "  --threshold   Size threshold in MB (default: 50)"
            exit 0 ;;
        *) echo "Unknown option: $1"; exit 1 ;;
    esac
done

THRESHOLD_BYTES=$((THRESHOLD_MB * 1024 * 1024))

echo "═══════════════════════════════════════════════════════════════"
echo "  COMPILED ARTIFACT CHECK"
echo "  Directory: $SCRIPT_DIR"
echo "  Threshold: ${THRESHOLD_MB} MB"
echo "  Date: $(date '+%Y-%m-%d %H:%M:%S')"
echo "═══════════════════════════════════════════════════════════════"
echo ""

TOTAL_FOUND=0
TOTAL_SIZE=0
declare -a FILES_TO_CLEAN=()

# --- Section 1: Reassembled ISOs ---
echo "┌─────────────────────────────────────────────────────────────┐"
echo "│  1. REASSEMBLED ISOs (compiled from split chunks)           │"
echo "└─────────────────────────────────────────────────────────────┘"

ISO_COUNT=0
ISO_SIZE=0
while IFS= read -r -d '' f; do
    SIZE=$(stat -c%s "$f")
    SIZE_MB=$((SIZE / 1024 / 1024))
    echo "  ✗ $(basename "$f")  (${SIZE_MB} MB)"
    ISO_COUNT=$((ISO_COUNT + 1))
    ISO_SIZE=$((ISO_SIZE + SIZE))
    FILES_TO_CLEAN+=("$f")
done < <(find "$SCRIPT_DIR" -maxdepth 1 -name "*.iso" -print0 2>/dev/null)

if [ "$ISO_COUNT" -eq 0 ]; then
    echo "  ✓ None found"
else
    echo "  ─────────────────────────────────────────"
    echo "  Total: $ISO_COUNT ISOs, $((ISO_SIZE / 1024 / 1024)) MB"
    TOTAL_FOUND=$((TOTAL_FOUND + ISO_COUNT))
    TOTAL_SIZE=$((TOTAL_SIZE + ISO_SIZE))
fi
echo ""

# --- Section 2: Split chunks (the compiled source pieces) ---
echo "┌─────────────────────────────────────────────────────────────┐"
echo "│  2. SPLIT CHUNKS (ubuntu_N_xx files per disc)               │"
echo "└─────────────────────────────────────────────────────────────┘"

for DISC in 1 2 3 4 5; do
    DISC_DIR="$SCRIPT_DIR/$DISC"
    if [ -d "$DISC_DIR" ]; then
        CHUNK_COUNT=0
        CHUNK_SIZE=0
        while IFS= read -r -d '' f; do
            SIZE=$(stat -c%s "$f")
            CHUNK_COUNT=$((CHUNK_COUNT + 1))
            CHUNK_SIZE=$((CHUNK_SIZE + SIZE))
            FILES_TO_CLEAN+=("$f")
        done < <(find "$DISC_DIR" -maxdepth 1 -name "ubuntu_${DISC}_*" -print0 2>/dev/null)

        if [ "$CHUNK_COUNT" -gt 0 ]; then
            echo "  ✗ Disc $DISC: $CHUNK_COUNT chunks, $((CHUNK_SIZE / 1024 / 1024)) MB"
            TOTAL_FOUND=$((TOTAL_FOUND + CHUNK_COUNT))
            TOTAL_SIZE=$((TOTAL_SIZE + CHUNK_SIZE))
        else
            echo "  ✓ Disc $DISC: no chunks"
        fi
    fi
done
echo ""

# --- Section 3: /tmp artifacts ---
echo "┌─────────────────────────────────────────────────────────────┐"
echo "│  3. /tmp BUILD ARTIFACTS                                    │"
echo "└─────────────────────────────────────────────────────────────┘"

TMP_COUNT=0
TMP_SIZE=0

# Check for mount remnants from extract scripts
while IFS= read -r -d '' f; do
    SIZE=$(du -sb "$f" 2>/dev/null | cut -f1)
    SIZE=${SIZE:-0}
    SIZE_MB=$((SIZE / 1024 / 1024))
    echo "  ✗ $f  (${SIZE_MB} MB)"
    TMP_COUNT=$((TMP_COUNT + 1))
    TMP_SIZE=$((TMP_SIZE + SIZE))
    FILES_TO_CLEAN+=("$f")
done < <(find /tmp -maxdepth 2 \( -name "ubuntu-source*" -o -name "ubuntu_source*" -o -name "*.iso" -o -name "ubuntu-22*" -o -name "ubuntu-24*" \) -print0 2>/dev/null)

# Check for leftover mount directories from the extract scripts
while IFS= read -r -d '' f; do
    if [ -d "$f" ]; then
        SIZE=$(du -sb "$f" 2>/dev/null | cut -f1)
        SIZE=${SIZE:-0}
        SIZE_MB=$((SIZE / 1024 / 1024))
        echo "  ✗ $f  (${SIZE_MB} MB) [mount remnant]"
        TMP_COUNT=$((TMP_COUNT + 1))
        TMP_SIZE=$((TMP_SIZE + SIZE))
        FILES_TO_CLEAN+=("$f")
    fi
done < <(find /tmp -maxdepth 1 -name "ubuntu-source-dev-*" -print0 2>/dev/null)

if [ "$TMP_COUNT" -eq 0 ]; then
    echo "  ✓ /tmp is clean"
else
    echo "  ─────────────────────────────────────────"
    echo "  Total: $TMP_COUNT items, $((TMP_SIZE / 1024 / 1024)) MB"
    TOTAL_FOUND=$((TOTAL_FOUND + TMP_COUNT))
    TOTAL_SIZE=$((TOTAL_SIZE + TMP_SIZE))
fi
echo ""

# --- Section 4: Hidden filesystem artifacts (older runs) ---
echo "┌─────────────────────────────────────────────────────────────┐"
echo "│  4. HIDDEN / STALE ARTIFACTS (common locations)             │"
echo "└─────────────────────────────────────────────────────────────┘"

HIDDEN_COUNT=0
HIDDEN_SIZE=0
SEARCH_PATHS=(
    "/var/tmp"
    "/mnt"
    "/media"
    "$HOME/.cache"
)

for SP in "${SEARCH_PATHS[@]}"; do
    if [ -d "$SP" ]; then
        while IFS= read -r -d '' f; do
            SIZE=$(stat -c%s "$f" 2>/dev/null || echo 0)
            if [ "$SIZE" -gt "$THRESHOLD_BYTES" ]; then
                SIZE_MB=$((SIZE / 1024 / 1024))
                echo "  ✗ $f  (${SIZE_MB} MB)"
                HIDDEN_COUNT=$((HIDDEN_COUNT + 1))
                HIDDEN_SIZE=$((HIDDEN_SIZE + SIZE))
                FILES_TO_CLEAN+=("$f")
            fi
        done < <(find "$SP" -maxdepth 3 \( -name "ubuntu*.iso" -o -name "ubuntu_[0-9]_*" -o -name "*.iso.part" \) -print0 2>/dev/null)
    fi
done

if [ "$HIDDEN_COUNT" -eq 0 ]; then
    echo "  ✓ No hidden artifacts found"
else
    echo "  ─────────────────────────────────────────"
    echo "  Total: $HIDDEN_COUNT items, $((HIDDEN_SIZE / 1024 / 1024)) MB"
    TOTAL_FOUND=$((TOTAL_FOUND + HIDDEN_COUNT))
    TOTAL_SIZE=$((TOTAL_SIZE + HIDDEN_SIZE))
fi
echo ""

# --- Summary ---
echo "═══════════════════════════════════════════════════════════════"
TOTAL_GB=$(echo "scale=2; $TOTAL_SIZE / 1024 / 1024 / 1024" | bc 2>/dev/null || echo "$((TOTAL_SIZE / 1024 / 1024)) MB")
if [ "$TOTAL_FOUND" -eq 0 ]; then
    echo "  VERDICT: CLEAN ✓  — No oversized compiled artifacts found."
else
    echo "  VERDICT: ${TOTAL_FOUND} artifacts found, ~${TOTAL_GB} total"
    echo ""
    echo "  These are too large for git (>${THRESHOLD_MB} MB each)."
    echo "  The split chunks can regenerate the ISOs at any time via:"
    echo "    ./reassemble-source-all.sh"
    echo ""
    echo "  The ISOs can re-extract packages via:"
    echo "    ./extract-source-packages.sh --all"
fi
echo "═══════════════════════════════════════════════════════════════"

# --- Clean mode ---
if [ "$CLEAN" -eq 1 ] && [ "$TOTAL_FOUND" -gt 0 ]; then
    echo ""
    echo "  CLEAN MODE ACTIVE"
    echo "  ─────────────────"

    if [ "$YES" -eq 0 ]; then
        echo ""
        echo "  About to remove ${TOTAL_FOUND} files (~${TOTAL_GB})."
        echo "  This is IRREVERSIBLE for the ISOs (but chunks can rebuild them)."
        echo ""
        read -rp "  Proceed? [y/N] " CONFIRM
        if [[ ! "$CONFIRM" =~ ^[Yy]$ ]]; then
            echo "  Aborted."
            exit 0
        fi
    fi

    REMOVED=0
    FREED=0
    for f in "${FILES_TO_CLEAN[@]}"; do
        if [ -e "$f" ]; then
            SIZE=$(stat -c%s "$f" 2>/dev/null || du -sb "$f" 2>/dev/null | cut -f1 || echo 0)
            rm -rf "$f" 2>/dev/null && {
                REMOVED=$((REMOVED + 1))
                FREED=$((FREED + SIZE))
                echo "  ✓ Removed: $(basename "$f")"
            } || {
                echo "  ✗ Failed:  $f (permission denied?)"
            }
        fi
    done

    FREED_GB=$(echo "scale=2; $FREED / 1024 / 1024 / 1024" | bc 2>/dev/null || echo "$((FREED / 1024 / 1024)) MB")
    echo ""
    echo "  Done: removed $REMOVED files, freed ~${FREED_GB}"
fi
