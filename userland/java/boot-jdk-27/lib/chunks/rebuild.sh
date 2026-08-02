#!/bin/bash
# rebuild.sh — Reassemble large boot-jdk files from chunks
#
# GitHub has a 100MB file size limit. The following files exceed it:
#   - modules   (142 MB) → split into modules.00–03.chunk
#   - src.zip   ( 52 MB) → split into src.zip.00–01.chunk
#
# Run this script after cloning to reconstruct the original files.
#
# Copyright (C) 2026 MEARVK LLC

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIB_DIR="$(dirname "$SCRIPT_DIR")"

echo "=== Rebuilding boot-jdk-27 large files from chunks ==="
echo "  Chunks dir: $SCRIPT_DIR"
echo "  Target dir: $LIB_DIR"
echo ""

# --- Rebuild modules (142 MB) ---
MODULES_TARGET="$LIB_DIR/modules"
if [ -f "$MODULES_TARGET" ]; then
    echo "  [skip] modules already exists ($(du -h "$MODULES_TARGET" | cut -f1))"
else
    echo "  [build] Reassembling modules..."
    cat "$SCRIPT_DIR"/modules.*.chunk > "$MODULES_TARGET"
    echo "  [done]  modules rebuilt ($(du -h "$MODULES_TARGET" | cut -f1))"
fi

# --- Rebuild src.zip (52 MB) ---
SRCZIP_TARGET="$LIB_DIR/src.zip"
if [ -f "$SRCZIP_TARGET" ]; then
    echo "  [skip] src.zip already exists ($(du -h "$SRCZIP_TARGET" | cut -f1))"
else
    echo "  [build] Reassembling src.zip..."
    cat "$SCRIPT_DIR"/src.zip.*.chunk > "$SRCZIP_TARGET"
    echo "  [done]  src.zip rebuilt ($(du -h "$SRCZIP_TARGET" | cut -f1))"
fi

echo ""
echo "=== Verification ==="

# Verify sizes
MODULES_SIZE=$(stat -c%s "$MODULES_TARGET" 2>/dev/null || stat -f%z "$MODULES_TARGET" 2>/dev/null)
SRCZIP_SIZE=$(stat -c%s "$SRCZIP_TARGET" 2>/dev/null || stat -f%z "$SRCZIP_TARGET" 2>/dev/null)

MODULES_EXPECTED=147996784   # 142 MB (exact bytes from original)
SRCZIP_EXPECTED=53563483     # 52 MB (exact bytes from original)

echo "  modules: $MODULES_SIZE bytes"
echo "  src.zip: $SRCZIP_SIZE bytes"

PASS=true
if [ "$MODULES_SIZE" -lt 140000000 ]; then
    echo "  WARNING: modules seems too small — expected ~142 MB"
    PASS=false
fi
if [ "$SRCZIP_SIZE" -lt 50000000 ]; then
    echo "  WARNING: src.zip seems too small — expected ~52 MB"
    PASS=false
fi

if [ "$PASS" = true ]; then
    echo "  All files rebuilt successfully."
else
    echo "  Some files may be incomplete. Check chunks directory."
    exit 1
fi

echo ""
echo "=== Done ==="
