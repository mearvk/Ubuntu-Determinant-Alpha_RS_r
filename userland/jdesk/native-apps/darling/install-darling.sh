#!/bin/bash
# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2026 MEARVK LLC
# Author: Maximilian Eric Alexander Rupplin von Keffikon
#
# install-darling.sh — Install Darling (macOS translation layer) for JDesk
# Size estimate: ~300 MB
#
# NOTE: Darling is experimental and not in standard apt repositories.
# This script attempts automatic installation where possible, and provides
# manual instructions as fallback.

set -euo pipefail

# --- Colors ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# --- Configuration ---
INSTALL_DIR="${1:-/opt/jdesk/apps}"
DARLING_PREFIX="/opt/jdesk/darling-prefix"
GITHUB_REPO="darlinghq/darling"
TMP_DIR="/tmp/jdesk-darling-$$"

info()    { echo -e "${GREEN}[INFO]${NC} $*"; }
warn()    { echo -e "${YELLOW}[SKIP]${NC} $*"; }
error()   { echo -e "${RED}[ERROR]${NC} $*"; exit 1; }

cleanup() { rm -rf "$TMP_DIR"; }
trap cleanup EXIT

# --- Check architecture ---
ARCH=$(uname -m)
if [ "$ARCH" != "x86_64" ]; then
    error "Darling requires x86_64 architecture. Detected: $ARCH"
fi

# --- Check if already installed ---
if command -v darling >/dev/null 2>&1; then
    warn "Darling is already installed. Nothing to do."
    darling --version 2>/dev/null || true
    exit 0
fi

if [ -x "$INSTALL_DIR/darling" ]; then
    warn "Darling wrapper exists at $INSTALL_DIR/darling. Nothing to do."
    exit 0
fi

# --- Create directories ---
mkdir -p "$INSTALL_DIR"
mkdir -p "$TMP_DIR"

# --- Attempt to download .deb from GitHub releases ---
info "Checking GitHub for Darling releases..."
INSTALLED=false

DEB_URL=$(curl -fsSL "https://api.github.com/repos/${GITHUB_REPO}/releases/latest" 2>/dev/null \
    | grep '"browser_download_url"' \
    | grep -i '\.deb"' \
    | grep -i 'amd64\|x86_64' \
    | head -1 \
    | sed 's/.*"\(https[^"]*\)".*/\1/' || echo "")

if [ -n "$DEB_URL" ]; then
    info "Found .deb package: $DEB_URL"
    DEB_FILE="$TMP_DIR/darling.deb"

    info "Downloading..."
    if curl -fSL --progress-bar -o "$DEB_FILE" "$DEB_URL"; then
        info "Installing .deb package..."
        export DEBIAN_FRONTEND=noninteractive
        if dpkg -i "$DEB_FILE" 2>/dev/null; then
            apt-get install -f -y 2>/dev/null || true
            INSTALLED=true
            info "Darling installed from .deb package"
        else
            warn "dpkg install failed — attempting dependency fix..."
            apt-get install -f -y 2>/dev/null || true
            if dpkg -l darling 2>/dev/null | grep -q '^ii'; then
                INSTALLED=true
                info "Darling installed after dependency resolution"
            fi
        fi
    else
        warn "Download failed"
    fi
else
    warn "No .deb release found on GitHub"
fi

# --- Create Darling shell wrapper ---
mkdir -p "$DARLING_PREFIX"

if [ "$INSTALLED" = true ] && command -v darling >/dev/null 2>&1; then
    DARLING_BIN=$(command -v darling)
    ln -sf "$DARLING_BIN" "$INSTALL_DIR/darling"
    info "Symlink created: $INSTALL_DIR/darling -> $DARLING_BIN"

    VERSION=$(darling --version 2>/dev/null || echo "unknown")
    info "Verification: Darling $VERSION"
else
    # Create a wrapper script that provides instructions
    cat > "$INSTALL_DIR/darling" << 'DARLING_WRAPPER'
#!/bin/bash
# Darling shell wrapper — JDesk macOS translation layer
# Darling could not be auto-installed. This wrapper provides guidance.

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

if command -v darling >/dev/null 2>&1; then
    exec darling "$@"
fi

echo -e "${YELLOW}[DARLING]${NC} Darling is not installed on this system."
echo ""
echo "Darling (macOS translation layer) requires building from source:"
echo ""
echo "  1. Install build dependencies:"
echo "     sudo apt install cmake clang bison flex pkg-config"
echo "     sudo apt install libfuse-dev libbsd-dev linux-headers-\$(uname -r)"
echo ""
echo "  2. Clone and build:"
echo "     git clone --recursive https://github.com/darlinghq/darling.git"
echo "     cd darling && mkdir build && cd build"
echo "     cmake .. -DCMAKE_INSTALL_PREFIX=/opt/jdesk/apps"
echo "     make -j\$(nproc)"
echo "     sudo make install"
echo ""
echo "  3. Load kernel module:"
echo "     sudo modprobe darling-mach"
echo ""
echo "For more info: https://docs.darlinghq.org/build-instructions.html"
exit 1
DARLING_WRAPPER

    chmod +x "$INSTALL_DIR/darling"
    warn "Darling could not be auto-installed."
    warn "A guidance wrapper was created at $INSTALL_DIR/darling"
    INSTALLED=false
fi

# --- Summary ---
echo ""
echo "========================================"
if [ "$INSTALLED" = true ]; then
    info "Darling installation complete"
    echo "  Install dir   : $INSTALL_DIR"
    echo "  Prefix        : $DARLING_PREFIX"
    echo "  Status        : INSTALLED"
else
    warn "Darling installation incomplete (manual build required)"
    echo "  Install dir   : $INSTALL_DIR"
    echo "  Prefix        : $DARLING_PREFIX"
    echo "  Status        : WRAPPER ONLY (run $INSTALL_DIR/darling for instructions)"
fi
echo "  Architecture  : $ARCH"
echo "  Size est.     : ~300 MB"
echo "========================================"
