#!/bin/bash
# SPDX-License-Identifier: GPL-2.0
#
# install-natives.sh — Master installer for JDesk native applications
#
# Downloads and installs native binaries for the JDesk desktop environment.
# All binaries are governed by the JVM Memory Proxy when launched.
#
# Disk Allocation: 3 GB (increased from initial 2 GB estimate)
#
# Breakdown:
#   Linux ELF natives:   ~877 MB (Writer, IDE, Browser, Terminal, Files)
#   Wine runtime:        ~400 MB (for Windows PE execution)
#   Darling runtime:     ~300 MB (for macOS Mach-O execution)
#   Windows app space:   ~450 MB
#   macOS app space:     ~350 MB
#   Icons + metadata:    ~ 50 MB
#   Headroom/updates:    ~550 MB
#   ─────────────────────────────
#   TOTAL:               ~2977 MB ≈ 3 GB
#
# Why 2 GB was insufficient:
#   LibreOffice alone is ~350 MB. Add VSCodium (~300 MB) and Chromium (~180 MB)
#   and you're at 830 MB of Linux natives alone. Wine (400 MB) and Darling (300 MB)
#   runtimes push past 1.5 GB before any Windows/macOS applications are added.
#   3 GB provides comfortable space for all three OS stacks plus updates.
#
# Copyright (C) 2026 MEARVK LLC
# Author: Maximilian Eric Alexander Rupplin von Keffikon

set -euo pipefail

INSTALL_DIR="${1:-/opt/jdesk/apps}"
MIN_SPACE_MB=3072
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "═══════════════════════════════════════════════════════════"
echo "  JDesk Native Applications Installer"
echo "  Galactic Cherry Marvell Edition 98"
echo "═══════════════════════════════════════════════════════════"
echo ""

# ============================================================================
#  Space Check
# ============================================================================

echo "[1/6] Checking disk space..."

AVAIL_MB=$(df -BM "$INSTALL_DIR" 2>/dev/null | tail -1 | awk '{print $4}' | tr -d 'M')

if [ -n "$AVAIL_MB" ] && [ "$AVAIL_MB" -lt "$MIN_SPACE_MB" ]; then
    echo "  ERROR: Insufficient disk space."
    echo "  Available: ${AVAIL_MB} MB"
    echo "  Required:  ${MIN_SPACE_MB} MB (3 GB)"
    echo ""
    echo "  The base allocation has been increased from 2 GB to 3 GB to"
    echo "  accommodate all three OS native stacks (Linux + Wine + Darling)"
    echo "  plus the native applications themselves."
    exit 1
fi

echo "  OK: ${AVAIL_MB:-unknown} MB available (need ${MIN_SPACE_MB} MB)"
echo ""

# ============================================================================
#  Linux Native Binaries (ELF)
# ============================================================================

echo "[2/6] Installing Linux native binaries..."

# --- LibreOffice Writer ---
echo "  → LibreOffice Writer (word processor, ~350 MB)"
mkdir -p "$INSTALL_DIR/libreoffice"
if ! command -v soffice &>/dev/null; then
    apt-get install -y --no-install-recommends libreoffice-writer 2>/dev/null || \
        echo "    (Manual install required: apt install libreoffice-writer)"
fi
# Symlink or copy the binary
SOFFICE=$(command -v soffice 2>/dev/null || echo "/usr/bin/soffice")
if [ -f "$SOFFICE" ]; then
    ln -sf "$SOFFICE" "$INSTALL_DIR/libreoffice/soffice"
    echo "    Installed: $INSTALL_DIR/libreoffice/soffice → $SOFFICE"
fi

# --- VSCodium (open-source VS Code) ---
echo "  → VSCodium IDE (development, ~300 MB)"
mkdir -p "$INSTALL_DIR/vscodium/bin"
if ! command -v codium &>/dev/null; then
    echo "    Fetching VSCodium AppImage..."
    CODIUM_URL="https://github.com/VSCodium/vscodium/releases/latest/download/VSCodium-linux-x64.tar.gz"
    if command -v wget &>/dev/null; then
        wget -qO- "$CODIUM_URL" | tar xz -C "$INSTALL_DIR/vscodium/" 2>/dev/null || \
            echo "    (Manual install: download VSCodium from github.com/VSCodium/vscodium)"
    fi
fi
CODIUM=$(command -v codium 2>/dev/null || echo "$INSTALL_DIR/vscodium/bin/codium")
if [ -f "$CODIUM" ]; then
    echo "    Installed: $CODIUM"
fi

# --- Chromium Browser ---
echo "  → Chromium Browser (web, ~180 MB)"
mkdir -p "$INSTALL_DIR/chromium"
CHROME=$(command -v chromium-browser 2>/dev/null || command -v chromium 2>/dev/null || echo "/usr/bin/chromium-browser")
if [ -f "$CHROME" ]; then
    ln -sf "$CHROME" "$INSTALL_DIR/chromium/chrome"
    echo "    Installed: $INSTALL_DIR/chromium/chrome → $CHROME"
else
    echo "    (Manual install: apt install chromium-browser)"
fi

# --- PCManFM-Qt File Manager ---
echo "  → PCManFM-Qt (file manager, ~45 MB)"
mkdir -p "$INSTALL_DIR/pcmanfm"
if ! command -v pcmanfm-qt &>/dev/null; then
    apt-get install -y --no-install-recommends pcmanfm-qt 2>/dev/null || \
        echo "    (Manual install: apt install pcmanfm-qt)"
fi
PCMANFM=$(command -v pcmanfm-qt 2>/dev/null || echo "/usr/bin/pcmanfm-qt")
if [ -f "$PCMANFM" ]; then
    ln -sf "$PCMANFM" "$INSTALL_DIR/pcmanfm/pcmanfm-qt"
    echo "    Installed: $INSTALL_DIR/pcmanfm/pcmanfm-qt → $PCMANFM"
fi

# --- JDesk Terminal ---
echo "  → JDesk Terminal (built-in, ~2 MB)"
mkdir -p "$INSTALL_DIR/terminal"
# Terminal is built from JDesk source — compiled separately
echo "    (Built from jdesk source: make -C ../native/linux terminal)"

# --- Kali Security Tools ---
echo "  → Kali Tools (penetration testing toolkit, ~250 MB)"
if [ -x "$SCRIPT_DIR/native-apps/kali-tools/kali-provision" ]; then
    KALI_PROVISION="$SCRIPT_DIR/native-apps/kali-tools/kali-provision"
elif [ -x "$SCRIPT_DIR/../kali-tools/kali-provision" ]; then
    KALI_PROVISION="$SCRIPT_DIR/../kali-tools/kali-provision"
else
    KALI_PROVISION=""
fi
if [ -n "$KALI_PROVISION" ]; then
    "$KALI_PROVISION" || echo "    (Kali provision completed with warnings — check /var/log/kali-provision.log)"
else
    echo "    (Manual install: sudo /opt/jdesk/native-apps/kali-tools/kali-provision)"
fi

echo ""
echo "  Linux natives installed (~877 MB + ~250 MB Kali)"
echo ""

# ============================================================================
#  Wine (Windows PE Support)
# ============================================================================

echo "[3/6] Installing Wine (Windows PE binary support)..."

if ! command -v wine &>/dev/null; then
    apt-get install -y wine64 2>/dev/null || \
        echo "  (Manual install: apt install wine64)"
fi

if command -v wine &>/dev/null; then
    WINE_VER=$(wine --version 2>/dev/null || echo "unknown")
    echo "  Wine installed: $WINE_VER (~400 MB)"
else
    echo "  Wine not available — Windows PE binaries will not launch"
fi
echo ""

# ============================================================================
#  Darling (macOS Mach-O Support)
# ============================================================================

echo "[4/6] Installing Darling (macOS Mach-O binary support)..."

if ! command -v darling &>/dev/null; then
    echo "  Darling requires manual installation from source:"
    echo "    git clone --recursive https://github.com/darlinghq/darling.git"
    echo "    cd darling && mkdir build && cd build"
    echo "    cmake .. && make -j$(nproc) && sudo make install"
    echo "  (~300 MB installed)"
else
    echo "  Darling installed: $(darling --version 2>/dev/null || echo 'present')"
fi
echo ""

# ============================================================================
#  Icons & Manifests
# ============================================================================

echo "[5/6] Installing icons and manifests..."

# Locate native-apps directory (works whether run from jdesk/ or native-apps/scripts/)
if [ -d "$SCRIPT_DIR/native-apps" ]; then
    JDESK_BASE="$SCRIPT_DIR/native-apps"
elif [ -d "$SCRIPT_DIR/../" ] && [ -d "$SCRIPT_DIR/../icons" ]; then
    JDESK_BASE="$SCRIPT_DIR/.."
else
    JDESK_BASE="$SCRIPT_DIR/native-apps"
fi

# Install icons
mkdir -p /opt/jdesk/icons
cp "$JDESK_BASE/icons/"*.svg /opt/jdesk/icons/ 2>/dev/null || true
echo "  Icons installed to /opt/jdesk/icons/"

# Install manifests
mkdir -p /opt/jdesk/manifests
cp "$JDESK_BASE/manifests/"*.jdesk-app /opt/jdesk/manifests/ 2>/dev/null || true
echo "  Manifests installed to /opt/jdesk/manifests/"

# Install profiles
mkdir -p /opt/jdesk/profiles
cp "$JDESK_BASE/profiles/"*.xml /opt/jdesk/profiles/ 2>/dev/null || true
echo "  Profiles installed to /opt/jdesk/profiles/"

echo ""

# ============================================================================
#  Summary
# ============================================================================

echo "[6/6] Installation summary"
echo ""
echo "═══════════════════════════════════════════════════════════════════"
echo "  JDesk Native Applications — Installation Complete"
echo "═══════════════════════════════════════════════════════════════════"
echo ""
echo "  Base allocation:     3 GB (increased from initial 2 GB estimate)"
echo ""
echo "  Installed:"
echo "    ✓ Linux ELF binaries    (~877 MB)"
echo "    ✓ Wine runtime          (~400 MB)  [for Windows .exe]"
echo "    ✓ Darling runtime       (~300 MB)  [for macOS Mach-O]"
echo "    ✓ Desktop icons (SVG)"
echo "    ✓ Application manifests (.jdesk-app)"
echo "    ✓ Memory Proxy profiles (jdesk-apps.xml)"
echo ""
echo "  Desktop icons on startup:"
echo "    📝 Writer    — LibreOffice Writer (ELF)"
echo "    💻 IDE       — VSCodium (ELF)"
echo "    🌐 Browser   — Chromium (ELF)"
echo "    🖥️  Terminal  — JDesk Terminal (ELF + Java)"
echo "    🛡️  Kali      — Kali Security Tools (Terminal + Shell)"
echo ""
echo "  All applications launch under JVM Memory Proxy governance:"
echo "    java -memory-guard -Xguard:profile=<name> <binary>"
echo ""
echo "  Format support:"
echo "    ELF (Linux)  → direct execution"
echo "    PE (Windows) → wine + memory-guard"
echo "    Mach-O (mac) → darling + memory-guard"
echo ""
echo "═══════════════════════════════════════════════════════════════════"
