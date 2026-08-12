#!/bin/bash
# SPDX-License-Identifier: GPL-2.0
#
# install-pcmanfm.sh — Install PCManFM-Qt File Manager for JDesk
#
# Copyright (C) 2026 MEARVK LLC
# Author: Maximilian Eric Alexander Rupplin von Keffikon

set -euo pipefail

INSTALL_DIR="${1:-/opt/jdesk/apps/pcmanfm}"
GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; NC='\033[0m'

echo -e "${GREEN}[JDesk]${NC} PCManFM-Qt File Manager Installer"
echo "  Target: $INSTALL_DIR"
echo "  Size:   ~45 MB"
echo ""

# Check if already installed
if [ -L "$INSTALL_DIR/pcmanfm-qt" ] && command -v pcmanfm-qt &>/dev/null; then
    echo -e "${YELLOW}[SKIP]${NC} PCManFM-Qt already installed."
    pcmanfm-qt --version 2>/dev/null | head -1 || true
    exit 0
fi

# Determine which variant to install
FM_PKG=""
FM_BIN=""

if apt-cache show pcmanfm-qt &>/dev/null 2>&1; then
    FM_PKG="pcmanfm-qt"
    FM_BIN="/usr/bin/pcmanfm-qt"
elif apt-cache show pcmanfm &>/dev/null 2>&1; then
    FM_PKG="pcmanfm"
    FM_BIN="/usr/bin/pcmanfm"
else
    # Fallback: try nautilus (GNOME default)
    echo -e "${YELLOW}[WARN]${NC} pcmanfm-qt not in repos. Trying nautilus..."
    FM_PKG="nautilus"
    FM_BIN="/usr/bin/nautilus"
fi

echo -e "${GREEN}[1/3]${NC} Installing $FM_PKG..."
apt-get update -qq
apt-get install -y --no-install-recommends "$FM_PKG"

# Create directory and symlinks
echo -e "${GREEN}[2/3]${NC} Creating JDesk symlinks..."
mkdir -p "$INSTALL_DIR"
ln -sf "$FM_BIN" "$INSTALL_DIR/$(basename "$FM_BIN")"

# Also create a generic 'files' symlink
ln -sf "$FM_BIN" "$INSTALL_DIR/files"

# Verify
echo -e "${GREEN}[3/3]${NC} Verifying..."
if [ -x "$FM_BIN" ]; then
    echo -e "${GREEN}[OK]${NC} File manager installed: $FM_BIN"
else
    echo -e "${RED}[ERROR]${NC} Binary not found: $FM_BIN"
    exit 1
fi

echo ""
echo "═══════════════════════════════════════════════════"
echo "  ✓ File manager installed to $INSTALL_DIR"
echo "  Binary:  $INSTALL_DIR/$(basename "$FM_BIN") → $FM_BIN"
echo "  Profile: files"
echo "═══════════════════════════════════════════════════"
