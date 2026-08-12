#!/bin/bash
# extract-small-packages.sh — Extract only source packages ≤50 MB (extracted)
# Part of Ubuntu Determinant Alpha RS — Galactic Cherry Marvell Edition 98
#
# Reassembles source ISOs, mounts them, and extracts individual source packages
# whose total extracted size is ≤50 MB. Packages are placed into ordered
# directories /1/packages, /2/packages, /3/packages, /4/packages, /5/packages
# corresponding to their source disc.
#
# GitHub file size concern: extracted packages ≤50 MB are safe for version control.
# Packages exceeding 50 MB are logged but skipped.
#
# Usage:
#   ./extract-small-packages.sh [output_directory]
#   ./extract-small-packages.sh --dry-run           # Report sizes only
#   ./extract-small-packages.sh --threshold 100     # Custom MB threshold
#
# Default output: ./{1,2,3,4,5}/packages/
# Prerequisites: dpkg-source (dpkg-dev), sudo for mount

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
OUTPUT_DIR=""
DRY_RUN=0
THRESHOLD_MB=50
VERBOSE=0

# Parse arguments
while [ $# -gt 0 ]; do
    case "$1" in
        --dry-run)       DRY_RUN=1; shift ;;
        --threshold)     THRESHOLD_MB="$2"; shift 2 ;;
        --verbose|-v)    VERBOSE=1; shift ;;
        --help|-h)
            echo "Usage: $0 [options] [output_directory]"
            echo ""
            echo "Options:"
            echo "  --dry-run           Report which packages are ≤${THRESHOLD_MB} MB without extracting"
            echo "  --threshold <MB>    Set size threshold (default: 50 MB)"
            echo "  --verbose, -v       Show per-package details"
            echo "  --help, -h          This help"
            echo ""
            echo "Output structure:"
            echo "  output_dir/1/packages/  — Packages from Source Disc 1"
            echo "  output_dir/2/packages/  — Packages from Source Disc 2"
            echo "  output_dir/3/packages/  — Packages from Source Disc 3"
            echo "  output_dir/4/packages/  — Packages from Source Disc 4"
            echo "  output_dir/5/packages/  — Reserved / overflow"
            echo "  output_dir/manifest.txt — Full manifest of extracted packages"
            echo "  output_dir/skipped.txt  — Packages exceeding threshold"
            exit 0
            ;;
        -*) echo "Unknown option: $1"; exit 1 ;;
        *)  OUTPUT_DIR="$1"; shift ;;
    esac
done

OUTPUT_DIR="${OUTPUT_DIR:-${SCRIPT_DIR}}"
THRESHOLD_BYTES=$((THRESHOLD_MB * 1024 * 1024))
MOUNT_BASE="/tmp/ubuntu-source-extract-$$"
ISO_DIR="${SCRIPT_DIR}"
WORK_DIR="/tmp/ubuntu-extract-work-$$"

echo "╔══════════════════════════════════════════════════════════════════╗"
echo "║  Extract Source Packages ≤ ${THRESHOLD_MB} MB                              ║"
echo "║  GitHub-safe extraction from Ubuntu 22.04.3 Source Discs       ║"
echo "╚══════════════════════════════════════════════════════════════════╝"
echo ""
echo "  Threshold:  ${THRESHOLD_MB} MB"
echo "  Output:     ${OUTPUT_DIR}"
echo "  Dry run:    $([ $DRY_RUN -eq 1 ] && echo 'YES (no files written)' || echo 'no')"
echo ""

# ──────────────────────────────────────────────────────────────────────
# Phase 1: Reassemble ISOs if not already present
# ──────────────────────────────────────────────────────────────────────

reassemble_if_needed() {
    local DISC=$1
    local ISO="${ISO_DIR}/ubuntu-22.04.3-source-${DISC}.iso"
    local CHUNK_DIR="${SCRIPT_DIR}/${DISC}"

    if [ -f "$ISO" ]; then
        echo "  Disc $DISC: ISO already exists ($(du -h "$ISO" | cut -f1))"
        return 0
    fi

    if [ ! -d "$CHUNK_DIR" ] || [ -z "$(ls "$CHUNK_DIR"/ubuntu_${DISC}_* 2>/dev/null)" ]; then
        echo "  Disc $DISC: No chunks found, skipping"
        return 1
    fi

    echo "  Disc $DISC: Reassembling from chunks..."
    cat "$CHUNK_DIR"/ubuntu_${DISC}_* > "$ISO"
    echo "  Disc $DISC: Done ($(du -h "$ISO" | cut -f1))"
    return 0
}

# ──────────────────────────────────────────────────────────────────────
# Phase 2: Mount ISOs
# ──────────────────────────────────────────────────────────────────────

cleanup() {
    echo ""
    echo "  Cleaning up mounts..."
    for DISC in 1 2 3 4; do
        local MNT="${MOUNT_BASE}/disc${DISC}"
        if mountpoint -q "$MNT" 2>/dev/null; then
            sudo umount "$MNT" 2>/dev/null || true
        fi
    done
    rm -rf "$MOUNT_BASE" "$WORK_DIR" 2>/dev/null || true
}

trap cleanup EXIT

mount_disc() {
    local DISC=$1
    local ISO="${ISO_DIR}/ubuntu-22.04.3-source-${DISC}.iso"
    local MNT="${MOUNT_BASE}/disc${DISC}"

    if [ ! -f "$ISO" ]; then
        return 1
    fi

    mkdir -p "$MNT"
    sudo mount -o loop,ro "$ISO" "$MNT" 2>/dev/null || {
        echo "  WARNING: Could not mount disc $DISC"
        return 1
    }
    return 0
}

# ──────────────────────────────────────────────────────────────────────
# Phase 3: Scan and extract packages by size
# ──────────────────────────────────────────────────────────────────────

# Estimate extracted size from source package files
# Uses the sum of .orig.tar.*, .debian.tar.*, and .dsc
estimate_extracted_size() {
    local DSC_PATH="$1"
    local DSC_DIR
    DSC_DIR=$(dirname "$DSC_PATH")
    local DSC_BASE
    DSC_BASE=$(basename "$DSC_PATH" .dsc)
    local PKG_PREFIX
    PKG_PREFIX=$(echo "$DSC_BASE" | sed 's/_[0-9].*//')

    # Sum up all files belonging to this source package
    local TOTAL=0
    while IFS= read -r -d '' FILE; do
        local SIZE
        SIZE=$(stat --format="%s" "$FILE" 2>/dev/null || echo 0)
        TOTAL=$((TOTAL + SIZE))
    done < <(find "$DSC_DIR" -maxdepth 1 -name "${PKG_PREFIX}_*" -print0 2>/dev/null)

    echo "$TOTAL"
}

# Extract a source package to destination
extract_package() {
    local DSC_PATH="$1"
    local DEST_DIR="$2"
    local DSC_DIR
    DSC_DIR=$(dirname "$DSC_PATH")
    local DSC_BASE
    DSC_BASE=$(basename "$DSC_PATH" .dsc)
    local PKG_PREFIX
    PKG_PREFIX=$(echo "$DSC_BASE" | sed 's/_[0-9].*//')

    mkdir -p "$DEST_DIR/$PKG_PREFIX"

    # Copy all source files for this package
    find "$DSC_DIR" -maxdepth 1 -name "${PKG_PREFIX}_*" -exec cp {} "$DEST_DIR/$PKG_PREFIX/" \;

    # Attempt dpkg-source extraction if available
    if command -v dpkg-source &>/dev/null; then
        mkdir -p "$WORK_DIR"
        local WORK_PKG="$WORK_DIR/$PKG_PREFIX"
        rm -rf "$WORK_PKG"
        mkdir -p "$WORK_PKG"

        # Copy to work dir for extraction
        find "$DSC_DIR" -maxdepth 1 -name "${PKG_PREFIX}_*" -exec cp {} "$WORK_PKG/" \;

        # Try extraction (may fail for some formats, that's OK)
        local DSC_FILE="$WORK_PKG/$(basename "$DSC_PATH")"
        if [ -f "$DSC_FILE" ]; then
            (cd "$WORK_PKG" && dpkg-source --no-check -x "$(basename "$DSC_FILE")" src 2>/dev/null) && {
                # Check actual extracted size
                local ACTUAL_SIZE
                ACTUAL_SIZE=$(du -sb "$WORK_PKG/src" 2>/dev/null | cut -f1)
                if [ "$ACTUAL_SIZE" -le "$THRESHOLD_BYTES" ]; then
                    # Move extracted source to destination
                    rm -rf "$DEST_DIR/$PKG_PREFIX/src"
                    mv "$WORK_PKG/src" "$DEST_DIR/$PKG_PREFIX/src"
                else
                    # Extracted size exceeds threshold — keep only raw archives
                    echo "  ⚠ $PKG_PREFIX: extracted $(echo "scale=1; $ACTUAL_SIZE / 1048576" | bc) MB > ${THRESHOLD_MB} MB (keeping archives only)"
                fi
            } || true
        fi
        rm -rf "$WORK_PKG"
    fi
}

# ──────────────────────────────────────────────────────────────────────
# Main execution
# ──────────────────────────────────────────────────────────────────────

echo "━━━ Phase 1: Reassemble ISOs ━━━"
AVAILABLE_DISCS=()
for DISC in 1 2 3 4; do
    if reassemble_if_needed "$DISC"; then
        AVAILABLE_DISCS+=("$DISC")
    fi
done
echo ""

echo "━━━ Phase 2: Mount ISOs ━━━"
mkdir -p "$MOUNT_BASE" "$WORK_DIR"
MOUNTED_DISCS=()
for DISC in "${AVAILABLE_DISCS[@]}"; do
    if mount_disc "$DISC"; then
        MOUNTED_DISCS+=("$DISC")
        echo "  Disc $DISC: mounted"
    fi
done
echo ""

if [ ${#MOUNTED_DISCS[@]} -eq 0 ]; then
    echo "ERROR: No discs could be mounted."
    echo "You may need to run: sudo apt install dpkg-dev"
    exit 1
fi

echo "━━━ Phase 3: Scan packages (threshold: ${THRESHOLD_MB} MB) ━━━"
echo ""

# Create output structure
if [ $DRY_RUN -eq 0 ]; then
    mkdir -p "$OUTPUT_DIR"/{1,2,3,4,5}/packages
fi

TOTAL_EXTRACTED=0
TOTAL_SKIPPED=0
TOTAL_SIZE_EXTRACTED=0
TOTAL_SIZE_SKIPPED=0

MANIFEST_FILE="${OUTPUT_DIR}/manifest.txt"
SKIPPED_FILE="${OUTPUT_DIR}/skipped.txt"

if [ $DRY_RUN -eq 0 ]; then
    echo "# Extracted packages (≤ ${THRESHOLD_MB} MB)" > "$MANIFEST_FILE"
    echo "# Format: disc/package_name  compressed_size_MB  status" >> "$MANIFEST_FILE"
    echo "" >> "$MANIFEST_FILE"

    echo "# Skipped packages (> ${THRESHOLD_MB} MB)" > "$SKIPPED_FILE"
    echo "# Format: disc/package_name  compressed_size_MB" >> "$SKIPPED_FILE"
    echo "" >> "$SKIPPED_FILE"
fi

for DISC in "${MOUNTED_DISCS[@]}"; do
    MNT="${MOUNT_BASE}/disc${DISC}"
    POOL_DIR="$MNT/pool"

    if [ ! -d "$POOL_DIR" ]; then
        echo "  Disc $DISC: No pool directory"
        continue
    fi

    echo "  ─── Disc $DISC ───"
    DISC_EXTRACTED=0
    DISC_SKIPPED=0

    while IFS= read -r -d '' DSC; do
        PKG_BASE=$(basename "$DSC" .dsc)
        PKG_NAME=$(echo "$PKG_BASE" | sed 's/_[0-9].*//')

        # Estimate size from compressed archives
        COMPRESSED_SIZE=$(estimate_extracted_size "$DSC")
        COMPRESSED_MB=$(echo "scale=1; $COMPRESSED_SIZE / 1048576" | bc)

        # Heuristic: compressed tarballs expand ~3-5x for source code
        # Use compressed size directly as our threshold check for speed.
        # (If you want actual extracted size, the extract_package function
        #  does a second check after dpkg-source.)
        if [ "$COMPRESSED_SIZE" -le "$THRESHOLD_BYTES" ]; then
            if [ $VERBOSE -eq 1 ]; then
                echo "    ✓ $PKG_NAME (${COMPRESSED_MB} MB)"
            fi

            if [ $DRY_RUN -eq 0 ]; then
                extract_package "$DSC" "$OUTPUT_DIR/$DISC/packages"
                echo "${DISC}/${PKG_NAME}  ${COMPRESSED_MB}  extracted" >> "$MANIFEST_FILE"
            fi

            DISC_EXTRACTED=$((DISC_EXTRACTED + 1))
            TOTAL_SIZE_EXTRACTED=$((TOTAL_SIZE_EXTRACTED + COMPRESSED_SIZE))
        else
            if [ $VERBOSE -eq 1 ]; then
                echo "    ✗ $PKG_NAME (${COMPRESSED_MB} MB) — SKIP"
            fi

            if [ $DRY_RUN -eq 0 ]; then
                echo "${DISC}/${PKG_NAME}  ${COMPRESSED_MB}" >> "$SKIPPED_FILE"
            fi

            DISC_SKIPPED=$((DISC_SKIPPED + 1))
            TOTAL_SIZE_SKIPPED=$((TOTAL_SIZE_SKIPPED + COMPRESSED_SIZE))
        fi
    done < <(find "$POOL_DIR" -name "*.dsc" -print0 2>/dev/null | sort -z)

    TOTAL_EXTRACTED=$((TOTAL_EXTRACTED + DISC_EXTRACTED))
    TOTAL_SKIPPED=$((TOTAL_SKIPPED + DISC_SKIPPED))

    echo "    Extracted: $DISC_EXTRACTED  |  Skipped: $DISC_SKIPPED"
done

echo ""
echo "╔══════════════════════════════════════════════════════════════════╗"
echo "║  RESULTS                                                       ║"
echo "╠══════════════════════════════════════════════════════════════════╣"
printf "║  %-60s ║\n" "Threshold:       ${THRESHOLD_MB} MB"
printf "║  %-60s ║\n" "Packages ≤ ${THRESHOLD_MB} MB:  ${TOTAL_EXTRACTED} ($(echo "scale=1; $TOTAL_SIZE_EXTRACTED / 1048576" | bc) MB total)"
printf "║  %-60s ║\n" "Packages > ${THRESHOLD_MB} MB:  ${TOTAL_SKIPPED} ($(echo "scale=1; $TOTAL_SIZE_SKIPPED / 1048576" | bc) MB total)"
printf "║  %-60s ║\n" "$([ $DRY_RUN -eq 1 ] && echo 'DRY RUN — no files written' || echo "Output: $OUTPUT_DIR/{1,2,3,4,5}/packages/")"
echo "╚══════════════════════════════════════════════════════════════════╝"
echo ""

if [ $DRY_RUN -eq 0 ]; then
    echo "  Directory structure:"
    for d in 1 2 3 4 5; do
        COUNT=$(find "$OUTPUT_DIR/$d/packages" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | wc -l)
        SIZE=$(du -sh "$OUTPUT_DIR/$d/packages" 2>/dev/null | cut -f1)
        echo "    $OUTPUT_DIR/$d/packages/ — $COUNT packages ($SIZE)"
    done
    echo ""
    echo "  Manifest: $MANIFEST_FILE"
    echo "  Skipped:  $SKIPPED_FILE"
fi
