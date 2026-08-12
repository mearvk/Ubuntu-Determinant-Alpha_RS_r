#!/bin/bash
# SPDX-License-Identifier: GPL-2.0
#
# install-chromium.sh — Install Chromium Browser for JDesk
#
# Copyright (C) 2026 MEARVK LLC
# Author: Maximilian Eric Alexander Rupplin von Keffikon

set -euo pipefail

INSTALL_DIR="${1:-/opt/jdesk/apps/chromium}"
GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; NC='\033[0m'

echo -e "${GREEN}[JDesk]${NC} Chromium Browser Installer"
echo "  Target: $INSTALL_DIR"
echo "  Size:   ~180 MB"
echo ""

# Check if already installed
if [ -L "$INSTALL_DIR/chrome" ] && command -v chromium-browser &>/dev/null; then
    echo -e "${YELLOW}[SKIP]${NC} Chromium already installed."
    chromium-browser --version 2>/dev/null || true
    exit 0
fi

# Determine package name (varies by distro)
CHROMIUM_PKG=""
CHROMIUM_BIN=""

if apt-cache show chromium-browser &>/dev/null 2>&1; then
    CHROMIUM_PKG="chromium-browser"
    CHROMIUM_BIN="/usr/bin/chromium-browser"
elif apt-cache show chromium &>/dev/null 2>&1; then
    CHROMIUM_PKG="chromium"
    CHROMIUM_BIN="/usr/bin/chromium"
else
    echo -e "${RED}[ERROR]${NC} Neither chromium-browser nor chromium found in apt repos."
    echo "  Try: sudo add-apt-repository universe && sudo apt update"
    exit 1
fi

echo -e "${GREEN}[1/3]${NC} Installing $CHROMIUM_PKG..."
apt-get update -qq
apt-get install -y --no-install-recommends "$CHROMIUM_PKG"

# Create directory and symlinks
echo -e "${GREEN}[2/3]${NC} Creating JDesk symlinks..."
mkdir -p "$INSTALL_DIR"

if [ -x "$CHROMIUM_BIN" ]; then
    ln -sf "$CHROMIUM_BIN" "$INSTALL_DIR/chrome"
elif [ -x "/snap/bin/chromium" ]; then
    # Ubuntu may install as snap
    ln -sf "/snap/bin/chromium" "$INSTALL_DIR/chrome"
    CHROMIUM_BIN="/snap/bin/chromium"
else
    echo -e "${RED}[ERROR]${NC} Chromium binary not found after install."
    exit 1
fi

# Verify
echo -e "${GREEN}[3/3]${NC} Verifying..."
if "$CHROMIUM_BIN" --version &>/dev/null; then
    VERSION=$("$CHROMIUM_BIN" --version 2>/dev/null | head -1)
    echo -e "${GREEN}[OK]${NC} $VERSION"
else
    echo -e "${YELLOW}[WARN]${NC} --version check failed (may need display); binary exists."
fi

echo ""
echo "═══════════════════════════════════════════════════"
echo "  ✓ Chromium installed to $INSTALL_DIR"
echo "  Binary:  $INSTALL_DIR/chrome → $CHROMIUM_BIN"
echo "  Profile: browser"
echo "═══════════════════════════════════════════════════"
