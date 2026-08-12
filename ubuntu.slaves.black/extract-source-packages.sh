#!/bin/bash
# extract-source-packages.sh — Extract and index source packages for development
# Part of Ubuntu Determinant Alpha RS — Galactic Cherry Marvell Edition 98
#
# Mounts the reassembled source ISOs and extracts individual source packages
# into a developer-friendly directory structure. Supports extracting specific
# packages by name or extracting all.
#
# Usage:
#   ./extract-source-packages.sh --all [output_directory]
#   ./extract-source-packages.sh --package <name> [output_directory]
#   ./extract-source-packages.sh --list
#   ./extract-source-packages.sh --search <pattern>
#
# Examples:
#   ./extract-source-packages.sh --package linux /tmp/kernel-src
#   ./extract-source-packages.sh --package gcc-12 ./gcc-build
#   ./extract-source-packages.sh --search "python*"
#   ./extract-source-packages.sh --all ./all-sources
#
# Prerequisites:
#   - Reassembled ISOs must exist (run reassemble-source-all.sh first)
#   - dpkg-source (from dpkg-dev package) for extraction
#   - sudo access for mounting ISOs

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ISO_DIR="${SCRIPT_DIR}"
MOUNT_BASE="/tmp/ubuntu-source-dev-$$"

MODE=""
PACKAGE_NAME=""
OUTPUT_DIR=""
SEARCH_PATTERN=""

# Parse arguments
while [ $# -gt 0 ]; do
    case "$1" in
        --all)       MODE="all"; shift ;;
        --package)   MODE="package"; PACKAGE_NAME="$2"; shift 2 ;;
        --list)      MODE="list"; shift ;;
        --search)    MODE="search"; SEARCH_PATTERN="$2"; shift 2 ;;
        --help|-h)   MODE="help"; shift ;;
        *)           OUTPUT_DIR="$1"; shift ;;
    esac
done

if [ -z "$MODE" ] || [ "$MODE" = "help" ]; then
    echo "Usage:"
    echo "  $0 --all [output_dir]           Extract all source packages"
    echo "  $0 --package <name> [output_dir] Extract a specific source package"
    echo "  $0 --list                        List all available source packages"
    echo "  $0 --search <pattern>            Search for packages by name"
    exit 0
fi

# Verify ISOs exist
check_isos() {
    local FOUND=0
    for DISC in 1 2 3 4; do
        if [ -f "${ISO_DIR}/ubuntu-22.04.3-source-${DISC}.iso" ]; then
            FOUND=$((FOUND + 1))
        fi
    done
    if [ "$FOUND" -eq 0 ]; then
        echo "ERROR: No reassembled ISOs found in $ISO_DIR"
        echo "Run reassemble-source-all.sh first."
        exit 1
    fi
    echo "  Found $FOUND source disc ISO(s)"
}

# Mount all available ISOs
mount_isos() {
    mkdir -p "$MOUNT_BASE"
    for DISC in 1 2 3 4; do
        local ISO="${ISO_DIR}/ubuntu-22.04.3-source-${DISC}.iso"
        if [ -f "$ISO" ]; then
            local MNT="${MOUNT_BASE}/disc${DISC}"
            mkdir -p "$MNT"
            sudo mount -o loop,ro "$ISO" "$MNT" 2>/dev/null || true
        fi
    done
}

# Unmount all
unmount_isos() {
    for DISC in 1 2 3 4; do
        local MNT="${MOUNT_BASE}/disc${DISC}"
        if mountpoint -q "$MNT" 2>/dev/null; then
            sudo umount "$MNT" 2>/dev/null || true
        fi
    done
    rm -rf "$MOUNT_BASE" 2>/dev/null || true
}

trap unmount_isos EXIT

# List all .dsc files across all mounted discs
list_packages() {
    for DISC in 1 2 3 4; do
        local MNT="${MOUNT_BASE}/disc${DISC}"
        if [ -d "$MNT/pool" ]; then
            find "$MNT/pool" -name "*.dsc" -printf "%f\n" 2>/dev/null
        fi
    done | sed 's/_[0-9].*//' | sort -u
}

# Find a specific package's .dsc file
find_package_dsc() {
    local PKG="$1"
    for DISC in 1 2 3 4; do
        local MNT="${MOUNT_BASE}/disc${DISC}"
        if [ -d "$MNT/pool" ]; then
            local DSC
            DSC=$(find "$MNT/pool" -name "${PKG}_*.dsc" 2>/dev/null | head -1)
            if [ -n "$DSC" ]; then
                echo "$DSC"
                return 0
            fi
        fi
    done
    return 1
}

case "$MODE" in
    list)
        check_isos
        mount_isos
        echo ""
        echo "Available source packages:"
        echo "=========================="
        list_packages | column
        echo ""
        echo "Total: $(list_packages | wc -l) packages"
        ;;

    search)
        check_isos
        mount_isos
        echo ""
        echo "Searching for: $SEARCH_PATTERN"
        echo "=============================="
        list_packages | grep -i "$SEARCH_PATTERN" || echo "  No matches found."
        ;;

    package)
        check_isos
        mount_isos
        OUTPUT_DIR="${OUTPUT_DIR:-./source-packages/${PACKAGE_NAME}}"
        mkdir -p "$OUTPUT_DIR"

        echo ""
        echo "  Searching for package: $PACKAGE_NAME"

        DSC_PATH=$(find_package_dsc "$PACKAGE_NAME") || {
            echo "  ERROR: Package '$PACKAGE_NAME' not found on any disc."
            echo "  Try: $0 --search \"${PACKAGE_NAME}*\""
            exit 1
        }

        DSC_DIR=$(dirname "$DSC_PATH")
        echo "  Found: $DSC_PATH"
        echo "  Extracting to: $OUTPUT_DIR"
        echo ""

        # Copy all related source files
        BASENAME=$(basename "$DSC_PATH" .dsc)
        PKG_PREFIX=$(echo "$BASENAME" | sed 's/_[0-9].*//')
        cp "$DSC_DIR"/${PKG_PREFIX}_* "$OUTPUT_DIR/" 2>/dev/null || true

        # Extract with dpkg-source if available
        if command -v dpkg-source &>/dev/null; then
            cd "$OUTPUT_DIR"
            dpkg-source -x "$(basename "$DSC_PATH")" "${PKG_PREFIX}-src" 2>/dev/null && \
                echo "  ✓ Source extracted to: $OUTPUT_DIR/${PKG_PREFIX}-src" || \
                echo "  Note: dpkg-source extraction failed (files still copied raw)"
        else
            echo "  Note: dpkg-source not available. Raw source files copied."
            echo "  Install dpkg-dev for automatic extraction: apt install dpkg-dev"
        fi

        echo ""
        echo "  Files in $OUTPUT_DIR:"
        ls -lh "$OUTPUT_DIR/"
        ;;

    all)
        check_isos
        mount_isos
        OUTPUT_DIR="${OUTPUT_DIR:-./source-packages}"
        mkdir -p "$OUTPUT_DIR"

        echo ""
        echo "  Extracting all source packages to: $OUTPUT_DIR"
        echo "  This may take a while..."
        echo ""

        TOTAL=0
        for DISC in 1 2 3 4; do
            local MNT="${MOUNT_BASE}/disc${DISC}"
            if [ -d "$MNT/pool" ]; then
                echo "  Copying disc $DISC pool..."
                cp -rn "$MNT/pool/"* "$OUTPUT_DIR/" 2>/dev/null || true
                COUNT=$(find "$MNT/pool" -name "*.dsc" 2>/dev/null | wc -l)
                TOTAL=$((TOTAL + COUNT))
                echo "    $COUNT packages from disc $DISC"
            fi
        done

        echo ""
        echo "  ✓ Complete: $TOTAL source packages copied to $OUTPUT_DIR"
        echo "  Structure: $OUTPUT_DIR/{main,universe,multiverse,restricted}/..."
        ;;
esac
