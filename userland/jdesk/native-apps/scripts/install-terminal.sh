#!/bin/bash
# SPDX-License-Identifier: GPL-2.0
#
# install-terminal.sh — Install JDesk Terminal components
#
# Mostly symlinks (bash is already present). Also installs tmux
# and creates a JDesk terminal wrapper script.
#
# Copyright (C) 2026 MEARVK LLC
# Author: Maximilian Eric Alexander Rupplin von Keffikon

set -euo pipefail

INSTALL_DIR="${1:-/opt/jdesk/apps/terminal}"
GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; NC='\033[0m'

echo -e "${GREEN}[JDesk]${NC} Terminal Components Installer"
echo "  Target: $INSTALL_DIR"
echo "  Size:   ~2 MB (symlinks + tmux)"
echo ""

# Check if already set up
if [ -x "$INSTALL_DIR/jdesk-terminal" ]; then
    echo -e "${YELLOW}[SKIP]${NC} JDesk terminal already configured."
    exit 0
fi

# Create directory
echo -e "${GREEN}[1/4]${NC} Creating terminal directory..."
mkdir -p "$INSTALL_DIR"

# Symlink shells
echo -e "${GREEN}[2/4]${NC} Creating shell symlinks..."
ln -sf /usr/bin/bash "$INSTALL_DIR/bash"
ln -sf /usr/bin/sh "$INSTALL_DIR/sh"

if command -v zsh &>/dev/null; then
    ln -sf "$(which zsh)" "$INSTALL_DIR/zsh"
    echo "  ✓ zsh"
fi

if command -v fish &>/dev/null; then
    ln -sf "$(which fish)" "$INSTALL_DIR/fish"
    echo "  ✓ fish"
fi

echo "  ✓ bash"
echo "  ✓ sh"

# Install tmux if not present
echo -e "${GREEN}[3/4]${NC} Ensuring tmux is installed..."
if command -v tmux &>/dev/null; then
    echo -e "  ${YELLOW}[ALREADY]${NC} tmux present"
    ln -sf "$(which tmux)" "$INSTALL_DIR/tmux"
else
    apt-get update -qq
    apt-get install -y --no-install-recommends tmux
    ln -sf /usr/bin/tmux "$INSTALL_DIR/tmux"
    echo -e "  ${GREEN}✓${NC} tmux installed"
fi

# Create JDesk terminal wrapper
echo -e "${GREEN}[4/4]${NC} Creating JDesk terminal wrapper..."
cat > "$INSTALL_DIR/jdesk-terminal" << 'WRAPPER'
#!/bin/bash
# JDesk Terminal Wrapper
# Launches a shell session with JDesk environment configured.

export TERM="${TERM:-xterm-256color}"
export JDESK_TERMINAL=1
export PS1='\[\033[01;34m\]jdesk\[\033[00m\]:\[\033[01;36m\]\w\[\033[00m\]\$ '

# Use user's preferred shell, or bash
SHELL_BIN="${SHELL:-/bin/bash}"

if [ "$1" = "--tmux" ] || [ "$1" = "-t" ]; then
    shift
    exec tmux new-session -s "jdesk-$$" "$SHELL_BIN" "$@"
else
    exec "$SHELL_BIN" "$@"
fi
WRAPPER
chmod +x "$INSTALL_DIR/jdesk-terminal"

# Also link into /opt/jdesk/bin for PATH
mkdir -p /opt/jdesk/bin
ln -sf "$INSTALL_DIR/jdesk-terminal" /opt/jdesk/bin/jdesk-terminal

echo ""
echo "═══════════════════════════════════════════════════"
echo "  ✓ JDesk Terminal installed to $INSTALL_DIR"
echo "  Shells: bash, sh$(command -v zsh &>/dev/null && echo ', zsh')$(command -v fish &>/dev/null && echo ', fish')"
echo "  Extras: tmux"
echo "  Wrapper: $INSTALL_DIR/jdesk-terminal"
echo "  Profile: terminal"
echo "═══════════════════════════════════════════════════"
