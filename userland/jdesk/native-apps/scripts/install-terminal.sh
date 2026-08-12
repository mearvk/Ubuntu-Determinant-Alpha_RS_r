#!/bin/bash
# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2026 MEARVK LLC
# Author: Maximilian Eric Alexander Rupplin von Keffikon
#
# install-terminal.sh — Install terminal environment for JDesk
# Size estimate: ~2 MB

set -euo pipefail

# --- Colors ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# --- Configuration ---
INSTALL_DIR="${1:-/opt/jdesk/apps/terminal}"

info()    { echo -e "${GREEN}[INFO]${NC} $*"; }
warn()    { echo -e "${YELLOW}[SKIP]${NC} $*"; }
error()   { echo -e "${RED}[ERROR]${NC} $*"; exit 1; }

# --- Check if already installed ---
if [ -d "$INSTALL_DIR" ] && [ -x "$INSTALL_DIR/jdesk-terminal" ]; then
    warn "JDesk terminal is already installed. Nothing to do."
    echo "  Wrapper: $INSTALL_DIR/jdesk-terminal"
    exit 0
fi

# --- Create INSTALL_DIR ---
mkdir -p "$INSTALL_DIR"

# --- Symlink shells ---
SHELLS_LINKED=0

if [ -x /bin/bash ]; then
    ln -sf /bin/bash "$INSTALL_DIR/bash"
    info "Symlink: $INSTALL_DIR/bash -> /bin/bash"
    SHELLS_LINKED=$((SHELLS_LINKED + 1))
fi

if [ -x /bin/sh ]; then
    ln -sf /bin/sh "$INSTALL_DIR/sh"
    info "Symlink: $INSTALL_DIR/sh -> /bin/sh"
    SHELLS_LINKED=$((SHELLS_LINKED + 1))
fi

if [ -x /usr/bin/zsh ]; then
    ln -sf /usr/bin/zsh "$INSTALL_DIR/zsh"
    info "Symlink: $INSTALL_DIR/zsh -> /usr/bin/zsh"
    SHELLS_LINKED=$((SHELLS_LINKED + 1))
elif [ -x /bin/zsh ]; then
    ln -sf /bin/zsh "$INSTALL_DIR/zsh"
    info "Symlink: $INSTALL_DIR/zsh -> /bin/zsh"
    SHELLS_LINKED=$((SHELLS_LINKED + 1))
else
    warn "zsh not found — skipping (optional)"
fi

# --- Install tmux if not present ---
if command -v tmux >/dev/null 2>&1; then
    TMUX_BIN=$(command -v tmux)
    warn "tmux already installed at $TMUX_BIN"
else
    info "Installing tmux via apt..."
    export DEBIAN_FRONTEND=noninteractive
    apt-get update -qq
    apt-get install -y --no-install-recommends tmux \
        || error "Failed to install tmux"
    TMUX_BIN=$(command -v tmux)
    info "tmux installed: $TMUX_BIN"
fi

ln -sf "$TMUX_BIN" "$INSTALL_DIR/tmux"
info "Symlink: $INSTALL_DIR/tmux -> $TMUX_BIN"

# --- Create JDesk terminal wrapper script ---
cat > "$INSTALL_DIR/jdesk-terminal" << 'WRAPPER'
#!/bin/bash
# JDesk Terminal Wrapper
# Launches bash in the JDesk desktop environment.

export TERM="${TERM:-xterm-256color}"
export COLORTERM="truecolor"
export JDESK_TERMINAL=1
export JDESK_SESSION="${JDESK_SESSION:-default}"

# Use user's preferred shell, fallback to bash
USER_SHELL="${SHELL:-/bin/bash}"
if [ ! -x "$USER_SHELL" ]; then
    USER_SHELL="/bin/bash"
fi

# If arguments provided, execute them
if [ $# -gt 0 ]; then
    exec "$USER_SHELL" -c "$*"
fi

# Interactive login shell
exec "$USER_SHELL" --login
WRAPPER

chmod +x "$INSTALL_DIR/jdesk-terminal"
info "JDesk terminal wrapper created: $INSTALL_DIR/jdesk-terminal"

# --- Verify ---
if "$INSTALL_DIR/jdesk-terminal" -c 'echo OK' >/dev/null 2>&1; then
    info "Verification passed: jdesk-terminal executes correctly"
else
    warn "Wrapper created but verification inconclusive (may need tty)"
fi

BASH_VER=$(bash --version | head -1 || echo "unknown")
TMUX_VER=$(tmux -V 2>/dev/null || echo "unknown")

# --- Summary ---
echo ""
echo "========================================"
info "JDesk terminal installation complete"
echo "  Install dir   : $INSTALL_DIR"
echo "  Wrapper       : $INSTALL_DIR/jdesk-terminal"
echo "  Shells linked : $SHELLS_LINKED"
echo "  tmux          : $TMUX_VER"
echo "  bash          : $BASH_VER"
echo "  Size est.     : ~2 MB"
echo "========================================"
