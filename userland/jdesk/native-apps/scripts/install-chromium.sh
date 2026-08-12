#!/bin/bash
# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2026 MEARVK LLC
# Author: Maximilian Eric Alexander Rupplin von Keffikon
#
# install-chromium.sh — Install Chromium browser for JDesk
# Size estimate: ~180 MB

set -euo pipefail

# --- Colors ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# --- Configuration ---
INSTALL_DIR="${1:-/opt/jdesk/apps/chromium}"

info()    { echo -e "${GREEN}[INFO]${NC} $*"; }
warn()    { echo -e "${YELLOW}[SKIP]${NC} $*"; }
error()   { echo -e "${RED}[ERROR]${NC} $*"; exit 1; }

# --- Determine package name ---
CHROMIUM_PKG=""
CHROMIUM_BIN=""

if dpkg -l chromium-browser 2>/dev/null | grep -q '^ii'; then
    CHROMIUM_PKG="chromium-browser"
    CHROMIUM_BIN="/usr/bin/chromium-browser"
elif dpkg -l chromium 2>/dev/null | grep -q '^ii'; then
    CHROMIUM_PKG="chromium"
    CHROMIUM_BIN="/usr/bin/chromium"
fi

# --- Check if already installed ---
if [ -n "$CHROMIUM_BIN" ] && [ -x "$CHROMIUM_BIN" ] && [ -L "$INSTALL_DIR/chrome" ]; then
    warn "Chromium is already installed and symlinked. Nothing to do."
    "$CHROMIUM_BIN" --version 2>/dev/null || true
    exit 0
fi

# --- Install via apt ---
if [ -z "$CHROMIUM_BIN" ]; then
    info "Installing Chromium via apt..."
    export DEBIAN_FRONTEND=noninteractive
    apt-get update -qq

    if apt-cache show chromium-browser >/dev/null 2>&1; then
        CHROMIUM_PKG="chromium-browser"
        apt-get install -y --no-install-recommends chromium-browser \
            || error "Failed to install chromium-browser"
        CHROMIUM_BIN="/usr/bin/chromium-browser"
    elif apt-cache show chromium >/dev/null 2>&1; then
        CHROMIUM_PKG="chromium"
        apt-get install -y --no-install-recommends chromium \
            || error "Failed to install chromium"
        CHROMIUM_BIN="/usr/bin/chromium"
    else
        error "Neither 'chromium-browser' nor 'chromium' available in apt"
    fi
fi

# --- Verify binary exists ---
if [ ! -x "$CHROMIUM_BIN" ]; then
    for candidate in /usr/bin/chromium-browser /usr/bin/chromium /snap/bin/chromium; do
        if [ -x "$candidate" ]; then
            CHROMIUM_BIN="$candidate"
            break
        fi
    done
fi

[ -x "$CHROMIUM_BIN" ] || error "Cannot locate Chromium binary after installation"

# --- Create INSTALL_DIR and symlink ---
mkdir -p "$INSTALL_DIR"
ln -sf "$CHROMIUM_BIN" "$INSTALL_DIR/chrome"
info "Symlink created: $INSTALL_DIR/chrome -> $CHROMIUM_BIN"

# --- Verify ---
VERSION=$("$CHROMIUM_BIN" --version 2>/dev/null || echo "unknown")
if [ "$VERSION" != "unknown" ]; then
    info "Verification passed: $VERSION"
else
    warn "Version check needs display. Binary exists at $CHROMIUM_BIN."
fi

# --- Summary ---
echo ""
echo "========================================"
info "Chromium installation complete"
echo "  Install dir : $INSTALL_DIR"
echo "  Symlink     : $INSTALL_DIR/chrome -> $CHROMIUM_BIN"
echo "  Package     : $CHROMIUM_PKG"
echo "  Version     : $VERSION"
echo "  Size est.   : ~180 MB"
echo "========================================"
