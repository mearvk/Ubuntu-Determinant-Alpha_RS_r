#!/bin/bash
# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2026 MEARVK LLC
# Author: Maximilian Eric Alexander Rupplin von Keffikon
#
# install-vscodium.sh — Install VSCodium (open-source VS Code) for JDesk
# Size estimate: ~300 MB

set -euo pipefail

# --- Colors ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# --- Configuration ---
INSTALL_DIR="${1:-/opt/jdesk/apps/vscodium}"
GITHUB_REPO="VSCodium/vscodium"
ASSET_PATTERN="VSCodium-linux-x64-"
TMP_DIR="/tmp/jdesk-vscodium-$$"

info()    { echo -e "${GREEN}[INFO]${NC} $*"; }
warn()    { echo -e "${YELLOW}[SKIP]${NC} $*"; }
error()   { echo -e "${RED}[ERROR]${NC} $*"; exit 1; }

cleanup() { rm -rf "$TMP_DIR"; }
trap cleanup EXIT

# --- Check if already installed ---
if [ -x "$INSTALL_DIR/bin/codium" ]; then
    warn "VSCodium is already installed at $INSTALL_DIR/bin/codium. Nothing to do."
    "$INSTALL_DIR/bin/codium" --version 2>/dev/null || true
    exit 0
fi

# --- Ensure dependencies ---
for cmd in curl tar; do
    command -v "$cmd" >/dev/null 2>&1 || error "Required command '$cmd' not found."
done

# --- Query GitHub API for latest release ---
info "Querying GitHub API for latest VSCodium release..."
LATEST_TAG=$(curl -fsSL "https://api.github.com/repos/${GITHUB_REPO}/releases/latest" \
    | grep '"tag_name"' | head -1 | sed 's/.*"tag_name": *"\([^"]*\)".*/\1/')

if [ -z "$LATEST_TAG" ]; then
    error "Failed to determine latest VSCodium release tag"
fi
info "Latest release: $LATEST_TAG"

# --- Construct download URL ---
TARBALL_NAME="${ASSET_PATTERN}${LATEST_TAG}.tar.gz"
DOWNLOAD_URL="https://github.com/${GITHUB_REPO}/releases/download/${LATEST_TAG}/${TARBALL_NAME}"
SHA256_URL="${DOWNLOAD_URL}.sha256"

# --- Download ---
mkdir -p "$TMP_DIR"
info "Downloading: $TARBALL_NAME"
curl -fSL --progress-bar -o "$TMP_DIR/$TARBALL_NAME" "$DOWNLOAD_URL" \
    || error "Failed to download $DOWNLOAD_URL"

# --- Verify SHA256 if available ---
if curl -fsSL -o "$TMP_DIR/${TARBALL_NAME}.sha256" "$SHA256_URL" 2>/dev/null; then
    info "Verifying SHA256 checksum..."
    EXPECTED=$(awk '{print $1}' "$TMP_DIR/${TARBALL_NAME}.sha256")
    ACTUAL=$(sha256sum "$TMP_DIR/$TARBALL_NAME" | awk '{print $1}')
    if [ "$EXPECTED" != "$ACTUAL" ]; then
        error "SHA256 mismatch! Expected: $EXPECTED, Got: $ACTUAL"
    fi
    info "SHA256 verification passed"
else
    warn "SHA256 file not available — skipping checksum verification"
fi

# --- Extract ---
mkdir -p "$INSTALL_DIR"
info "Extracting to $INSTALL_DIR..."
tar -xzf "$TMP_DIR/$TARBALL_NAME" -C "$INSTALL_DIR" --strip-components=0 \
    || error "Failed to extract tarball"

# --- Create symlink ---
CODIUM_BIN=""
if [ -x "$INSTALL_DIR/bin/codium" ]; then
    CODIUM_BIN="$INSTALL_DIR/bin/codium"
elif [ -x "$INSTALL_DIR/codium" ]; then
    mkdir -p "$INSTALL_DIR/bin"
    ln -sf "$INSTALL_DIR/codium" "$INSTALL_DIR/bin/codium"
    CODIUM_BIN="$INSTALL_DIR/bin/codium"
else
    error "Cannot locate codium binary after extraction"
fi

ln -sf "$CODIUM_BIN" /usr/local/bin/codium 2>/dev/null || true
info "Symlink created: /usr/local/bin/codium -> $CODIUM_BIN"

# --- Verify ---
VERSION=$("$CODIUM_BIN" --version 2>/dev/null | head -1 || echo "unknown")
info "Verification: VSCodium $VERSION"

# --- Summary ---
echo ""
echo "========================================"
info "VSCodium installation complete"
echo "  Install dir : $INSTALL_DIR"
echo "  Binary      : $CODIUM_BIN"
echo "  Symlink     : /usr/local/bin/codium"
echo "  Version     : $VERSION"
echo "  Release tag : $LATEST_TAG"
echo "  Size est.   : ~300 MB"
echo "========================================"
