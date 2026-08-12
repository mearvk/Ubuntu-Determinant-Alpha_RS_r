#!/bin/bash
# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2026 MEARVK LLC
# Author: Maximilian Eric Alexander Rupplin von Keffikon
#
# install-pcmanfm.sh — Install PCManFM file manager for JDesk
# Size estimate: ~45 MB

set -euo pipefail

# --- Colors ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# --- Configuration ---
INSTALL_DIR="${1:-/opt/jdesk/apps/pcmanfm}"

info()    { echo -e "${GREEN}[INFO]${NC} $*"; }
warn()    { echo -e "${YELLOW}[SKIP]${NC} $*"; }
error()   { echo -e "${RED}[ERROR]${NC} $*"; exit 1; }

# --- Determine which variant is available ---
PCMANFM_PKG=""
PCMANFM_BIN=""

if dpkg -l pcmanfm-qt 2>/dev/null | grep -q '^ii'; then
    PCMANFM_PKG="pcmanfm-qt"
    PCMANFM_BIN="/usr/bin/pcmanfm-qt"
elif dpkg -l pcmanfm 2>/dev/null | grep -q '^ii'; then
    PCMANFM_PKG="pcmanfm"
    PCMANFM_BIN="/usr/bin/pcmanfm"
fi

# --- Check if already installed ---
if [ -n "$PCMANFM_BIN" ] && [ -x "$PCMANFM_BIN" ] && [ -d "$INSTALL_DIR" ]; then
    if [ -L "$INSTALL_DIR/pcmanfm-qt" ] || [ -L "$INSTALL_DIR/pcmanfm" ]; then
        warn "PCManFM is already installed and symlinked. Nothing to do."
        exit 0
    fi
fi

# --- Install via apt ---
if [ -z "$PCMANFM_BIN" ]; then
    info "Installing PCManFM via apt..."
    export DEBIAN_FRONTEND=noninteractive
    apt-get update -qq

    if apt-cache show pcmanfm-qt >/dev/null 2>&1; then
        PCMANFM_PKG="pcmanfm-qt"
        apt-get install -y --no-install-recommends pcmanfm-qt \
            || error "Failed to install pcmanfm-qt"
        PCMANFM_BIN="/usr/bin/pcmanfm-qt"
    elif apt-cache show pcmanfm >/dev/null 2>&1; then
        PCMANFM_PKG="pcmanfm"
        apt-get install -y --no-install-recommends pcmanfm \
            || error "Failed to install pcmanfm"
        PCMANFM_BIN="/usr/bin/pcmanfm"
    else
        error "Neither 'pcmanfm-qt' nor 'pcmanfm' available in apt"
    fi
fi

# --- Verify binary exists ---
if [ ! -x "$PCMANFM_BIN" ]; then
    for candidate in /usr/bin/pcmanfm-qt /usr/bin/pcmanfm; do
        if [ -x "$candidate" ]; then
            PCMANFM_BIN="$candidate"
            break
        fi
    done
fi

[ -x "$PCMANFM_BIN" ] || error "Cannot locate PCManFM binary after installation"

# --- Create INSTALL_DIR and symlinks ---
mkdir -p "$INSTALL_DIR"

LINK_NAME=$(basename "$PCMANFM_BIN")
ln -sf "$PCMANFM_BIN" "$INSTALL_DIR/$LINK_NAME"
info "Symlink created: $INSTALL_DIR/$LINK_NAME -> $PCMANFM_BIN"

ln -sf "$PCMANFM_BIN" "$INSTALL_DIR/filemanager"
info "Symlink created: $INSTALL_DIR/filemanager -> $PCMANFM_BIN"

# --- Verify ---
VERSION=$("$PCMANFM_BIN" --version 2>/dev/null | head -1 || echo "unknown")
if [ "$VERSION" != "unknown" ]; then
    info "Verification: $VERSION"
else
    info "Binary installed at $PCMANFM_BIN (version check requires display)"
fi

# --- Summary ---
echo ""
echo "========================================"
info "PCManFM installation complete"
echo "  Install dir : $INSTALL_DIR"
echo "  Symlink     : $INSTALL_DIR/$LINK_NAME -> $PCMANFM_BIN"
echo "  Package     : $PCMANFM_PKG"
echo "  Version     : $VERSION"
echo "  Size est.   : ~45 MB"
echo "========================================"
