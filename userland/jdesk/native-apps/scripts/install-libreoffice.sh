#!/bin/bash
# SPDX-License-Identifier: GPL-2.0
#
# install-libreoffice.sh — Install LibreOffice for JDesk
#
# Copyright (C) 2026 MEARVK LLC
# Author: Maximilian Eric Alexander Rupplin von Keffikon

set -euo pipefail

INSTALL_DIR="${1:-/opt/jdesk/apps/libreoffice}"
GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; NC='\033[0m'

echo -e "${GREEN}[JDesk]${NC} LibreOffice Installer"
echo "  Target: $INSTALL_DIR"
echo "  Size:   ~350 MB"
echo ""

# Check if already installed
if command -v soffice &>/dev/null && [ -L "$INSTALL_DIR/soffice" ]; then
    echo -e "${YELLOW}[SKIP]${NC} LibreOffice already installed."
    soffice --version 2>/dev/null | head -1 || true
    exit 0
fi

# Install via apt
echo -e "${GREEN}[1/3]${NC} Installing LibreOffice Writer, Calc, Impress..."
apt-get update -qq
apt-get install -y --no-install-recommends \
    libreoffice-writer \
    libreoffice-calc \
    libreoffice-impress \
    libreoffice-common

# Create directory and symlinks
echo -e "${GREEN}[2/3]${NC} Creating JDesk symlinks..."
mkdir -p "$INSTALL_DIR"
ln -sf /usr/bin/soffice "$INSTALL_DIR/soffice"
ln -sf /usr/bin/lowriter "$INSTALL_DIR/lowriter"
ln -sf /usr/bin/localc "$INSTALL_DIR/localc"
ln -sf /usr/bin/loimpress "$INSTALL_DIR/loimpress"

# Verify
echo -e "${GREEN}[3/3]${NC} Verifying..."
if soffice --version &>/dev/null; then
    VERSION=$(soffice --version 2>/dev/null | head -1)
    echo -e "${GREEN}[OK]${NC} LibreOffice installed: $VERSION"
else
    echo -e "${RED}[ERROR]${NC} soffice --version failed"
    exit 1
fi

echo ""
echo "═══════════════════════════════════════════════════"
echo "  ✓ LibreOffice installed to $INSTALL_DIR"
echo "  Binary:  $INSTALL_DIR/soffice"
echo "  Profile: writer"
echo "═══════════════════════════════════════════════════"
