#!/bin/bash
# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2026 MEARVK LLC
# Author: Maximilian Eric Alexander Rupplin von Keffikon
#
# install-wine.sh — Install Wine (Windows compatibility layer) for JDesk
# Size estimate: ~400 MB

set -euo pipefail

# --- Colors ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# --- Configuration ---
INSTALL_DIR="${1:-/opt/jdesk/apps}"
WINE_PREFIX="/opt/jdesk/wine-prefix"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DLLHOST_SRC="${SCRIPT_DIR}/../launcher/jdesk-dllhost.exe"

info()    { echo -e "${GREEN}[INFO]${NC} $*"; }
warn()    { echo -e "${YELLOW}[SKIP]${NC} $*"; }
error()   { echo -e "${RED}[ERROR]${NC} $*"; exit 1; }

# --- Check if already installed ---
if command -v wine64 >/dev/null 2>&1 && [ -d "$WINE_PREFIX" ]; then
    if [ -f "$WINE_PREFIX/system.reg" ]; then
        warn "Wine is already installed and prefix initialized. Nothing to do."
        wine64 --version 2>/dev/null || true
        exit 0
    fi
fi

# --- Add i386 architecture if needed ---
if ! dpkg --print-foreign-architectures 2>/dev/null | grep -q i386; then
    info "Adding i386 architecture for Wine32 support..."
    dpkg --add-architecture i386
    apt-get update -qq
fi

# --- Install Wine packages ---
info "Installing Wine packages..."
export DEBIAN_FRONTEND=noninteractive
apt-get update -qq
apt-get install -y --no-install-recommends wine64 wine32 \
    || error "Failed to install wine64 wine32"

# --- Verify Wine binary ---
WINE_BIN=""
if [ -x /usr/bin/wine64 ]; then
    WINE_BIN="/usr/bin/wine64"
elif command -v wine64 >/dev/null 2>&1; then
    WINE_BIN=$(command -v wine64)
else
    error "Cannot locate wine64 binary after installation"
fi

info "Wine binary: $WINE_BIN"

# --- Create directories ---
mkdir -p "$INSTALL_DIR"
mkdir -p "$WINE_PREFIX"

# --- Initialize Wine prefix ---
info "Initializing Wine prefix at $WINE_PREFIX..."
export WINEPREFIX="$WINE_PREFIX"
export WINEDEBUG="-all"

# wineboot --init creates the prefix structure
wineboot --init 2>/dev/null || warn "wineboot --init had warnings (non-fatal)"

# Wait for wineserver to finish
wineserver --wait 2>/dev/null || true

if [ -f "$WINE_PREFIX/system.reg" ]; then
    info "Wine prefix initialized successfully"
else
    warn "Wine prefix may be incomplete — system.reg not found"
fi

# --- Create symlink ---
ln -sf "$WINE_BIN" "$INSTALL_DIR/wine64"
info "Symlink created: $INSTALL_DIR/wine64 -> $WINE_BIN"

# --- Install jdesk-dllhost.exe if available ---
if [ -f "$DLLHOST_SRC" ]; then
    info "Installing jdesk-dllhost.exe into Wine prefix..."
    mkdir -p "$WINE_PREFIX/drive_c/jdesk"
    cp "$DLLHOST_SRC" "$WINE_PREFIX/drive_c/jdesk/jdesk-dllhost.exe"
    info "Installed: $WINE_PREFIX/drive_c/jdesk/jdesk-dllhost.exe"
else
    warn "jdesk-dllhost.exe not found at $DLLHOST_SRC — skipping"
fi

# --- Verify ---
VERSION=$(wine64 --version 2>/dev/null || echo "unknown")
info "Verification: $VERSION"

# --- Summary ---
echo ""
echo "========================================"
info "Wine installation complete"
echo "  Install dir  : $INSTALL_DIR"
echo "  Wine prefix  : $WINE_PREFIX"
echo "  Symlink      : $INSTALL_DIR/wine64 -> $WINE_BIN"
echo "  Version      : $VERSION"
echo "  WINEPREFIX   : $WINE_PREFIX"
echo "  DLL host     : $([ -f "$WINE_PREFIX/drive_c/jdesk/jdesk-dllhost.exe" ] && echo 'installed' || echo 'not available')"
echo "  Size est.    : ~400 MB"
echo "========================================"
