#!/bin/bash
# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2026 MEARVK LLC
# Author: Maximilian Eric Alexander Rupplin von Keffikon
#
# install-libreoffice.sh — Install LibreOffice suite for JDesk
# Size estimate: ~350 MB

set -euo pipefail

# --- Colors ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# --- Configuration ---
INSTALL_DIR="${1:-/opt/jdesk/apps/libreoffice}"
PACKAGES="libreoffice-writer libreoffice-calc libreoffice-impress"

info()    { echo -e "${GREEN}[INFO]${NC} $*"; }
warn()    { echo -e "${YELLOW}[SKIP]${NC} $*"; }
error()   { echo -e "${RED}[ERROR]${NC} $*"; exit 1; }

# --- Check if already installed ---
already_installed=true
for pkg in $PACKAGES; do
    if ! dpkg -l "$pkg" 2>/dev/null | grep -q '^ii'; then
        already_installed=false
        break
    fi
done

if [ "$already_installed" = true ] && [ -L "$INSTALL_DIR/soffice" ]; then
    warn "LibreOffice is already installed and symlinked. Nothing to do."
    soffice --version 2>/dev/null || true
    exit 0
fi

# --- Install via apt ---
info "Installing LibreOffice packages: $PACKAGES"
export DEBIAN_FRONTEND=noninteractive
apt-get update -qq
apt-get install -y --no-install-recommends $PACKAGES || error "Failed to install LibreOffice packages"

# --- Create INSTALL_DIR and symlink ---
mkdir -p "$INSTALL_DIR"

SOFFICE_BIN=""
if [ -x /usr/bin/soffice ]; then
    SOFFICE_BIN="/usr/bin/soffice"
elif [ -x /usr/lib/libreoffice/program/soffice ]; then
    SOFFICE_BIN="/usr/lib/libreoffice/program/soffice"
else
    error "Cannot locate soffice binary after installation"
fi

ln -sf "$SOFFICE_BIN" "$INSTALL_DIR/soffice"
info "Symlink created: $INSTALL_DIR/soffice -> $SOFFICE_BIN"

# --- Verify ---
if "$INSTALL_DIR/soffice" --version >/dev/null 2>&1; then
    VERSION=$("$INSTALL_DIR/soffice" --version 2>/dev/null || echo "unknown")
    info "Verification passed: $VERSION"
else
    error "soffice --version failed after installation"
fi

# --- Summary ---
echo ""
echo "========================================"
info "LibreOffice installation complete"
echo "  Install dir : $INSTALL_DIR"
echo "  Symlink     : $INSTALL_DIR/soffice -> $SOFFICE_BIN"
echo "  Packages    : $PACKAGES"
echo "  Version     : $VERSION"
echo "  Size est.   : ~350 MB"
echo "========================================"
