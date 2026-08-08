#!/bin/bash
# =============================================================================
# install-darling-handlers.sh — Native Mach-O handlers for Desktop and CLI
#
# Ubuntu Determinant Alpha RS — Galactic Cherry Marvell Edition 98
# Copyright (C) 2026 MEARVK LLC
# Author: Maximilian Eric Alexander Rupplin von Keffikon
#
# Installs two layers of native macOS executable handling:
#
#   1. DESKTOP (GUI): MIME types + .desktop handler so .app bundles
#      and Mach-O files open with Darling from any file manager.
#
#   2. COMMAND LINE (binfmt_misc): Kernel binary format registration so
#      ./macos_program runs transparently via Darling from any shell.
#
# Usage:
#   scripts/install-darling-handlers.sh <rootfs_dir>
#
# =============================================================================

set -euo pipefail

ROOTFS_DIR="${1:-build/rootfs}"
DARLING_BIN="/usr/local/bin/darling"

log() {
    echo "  [DARLING-HANDLER] $*"
}


# =============================================================================
# 1. DESKTOP HANDLER — GUI file manager integration
# =============================================================================

install_desktop_handler() {
    log "Installing desktop Mach-O / .app handler..."

    # --- MIME type definitions ---
    install -d "${ROOTFS_DIR}/usr/share/mime/packages"
    cat > "${ROOTFS_DIR}/usr/share/mime/packages/darling-extensions.xml" <<'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<mime-info xmlns="http://www.freedesktop.org/standards/shared-mime-info">

  <!-- macOS Application Bundle (.app) -->
  <mime-type type="application/x-apple-application">
    <comment>macOS Application Bundle</comment>
    <glob pattern="*.app"/>
  </mime-type>

  <!-- Mach-O executable (64-bit) -->
  <mime-type type="application/x-mach-binary">
    <comment>macOS Mach-O Executable</comment>
    <magic priority="60">
      <!-- Mach-O 64-bit magic: 0xFEEDFACF -->
      <match type="big32" offset="0" value="0xFEEDFACF"/>
      <!-- Mach-O 32-bit magic: 0xFEEDFACE -->
      <match type="big32" offset="0" value="0xFEEDFACE"/>
      <!-- Mach-O fat/universal: 0xCAFEBABE -->
      <match type="big32" offset="0" value="0xCAFEBABE"/>
    </magic>
  </mime-type>

  <!-- macOS Disk Image (.dmg) -->
  <mime-type type="application/x-apple-diskimage">
    <comment>macOS Disk Image</comment>
    <glob pattern="*.dmg"/>
  </mime-type>

  <!-- macOS Package (.pkg) -->
  <mime-type type="application/x-apple-installer-package">
    <comment>macOS Installer Package</comment>
    <glob pattern="*.pkg"/>
  </mime-type>

</mime-info>
EOF


    # --- .desktop application entry (the handler) ---
    install -d "${ROOTFS_DIR}/usr/share/applications"
    cat > "${ROOTFS_DIR}/usr/share/applications/darling-run.desktop" <<EOF
[Desktop Entry]
Name=Darling macOS Program Loader
Comment=Run macOS programs with Darling
Exec=${DARLING_BIN} %f
Terminal=false
Type=Application
Icon=darling
MimeType=application/x-apple-application;application/x-mach-binary;application/x-apple-diskimage;application/x-apple-installer-package;
NoDisplay=true
Categories=System;
StartupNotify=true
EOF

    # --- Set Darling as default handler for macOS MIME types ---
    # Append to existing mimeapps.list (Wine may have created it)
    local mimeapps="${ROOTFS_DIR}/etc/xdg/mimeapps.list"
    install -d "${ROOTFS_DIR}/etc/xdg"
    if [[ -f "$mimeapps" ]]; then
        # Append Darling entries
        grep -q "x-apple-application" "$mimeapps" || \
        cat >> "$mimeapps" <<'EOF'
application/x-apple-application=darling-run.desktop
application/x-mach-binary=darling-run.desktop
application/x-apple-diskimage=darling-run.desktop
application/x-apple-installer-package=darling-run.desktop
EOF
    else
        cat > "$mimeapps" <<'EOF'
[Default Applications]
application/x-apple-application=darling-run.desktop
application/x-mach-binary=darling-run.desktop
application/x-apple-diskimage=darling-run.desktop
application/x-apple-installer-package=darling-run.desktop
EOF
    fi

    log "Desktop handler installed:"
    log "  - MIME types: .app, Mach-O, .dmg, .pkg"
    log "  - Default app: darling-run.desktop"
}


# =============================================================================
# 2. COMMAND LINE HANDLER — binfmt_misc kernel integration
# =============================================================================

install_cli_handler() {
    log "Installing CLI binfmt_misc Mach-O handler..."

    # --- systemd-binfmt drop-in ---
    install -d "${ROOTFS_DIR}/usr/lib/binfmt.d"
    cat > "${ROOTFS_DIR}/usr/lib/binfmt.d/darling.conf" <<EOF
# Darling macOS executable handler — Galactic Cherry Marvell Edition 98
# Allows transparent execution of Mach-O files from the command line:
#   $ ./macos_program        (runs via darling)
#   $ chmod +x macos_tool && ./macos_tool
#
# Format: :name:type:offset:magic:mask:interpreter:flags

# Mach-O 64-bit (magic: 0xFEEDFACF, little-endian on disk: CF FA ED FE)
:darling-mach64:M::\\xcf\\xfa\\xed\\xfe::\\xff\\xff\\xff\\xff:${DARLING_BIN}:FC

# Mach-O 32-bit (magic: 0xFEEDFACE, little-endian on disk: CE FA ED FE)
:darling-mach32:M::\\xce\\xfa\\xed\\xfe::\\xff\\xff\\xff\\xff:${DARLING_BIN}:FC

# Mach-O fat/universal binary (magic: 0xCAFEBABE, big-endian)
:darling-fat:M::\\xca\\xfe\\xba\\xbe::\\xff\\xff\\xff\\xff:${DARLING_BIN}:FC
EOF

    # --- Legacy init.d script ---
    install -d "${ROOTFS_DIR}/etc/init.d"
    cat > "${ROOTFS_DIR}/etc/init.d/darling-binfmt" <<'INITSCRIPT'
#!/bin/bash
### BEGIN INIT INFO
# Provides:          darling-binfmt
# Required-Start:    $local_fs
# Required-Stop:
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Register Darling as Mach-O handler via binfmt_misc
### END INIT INFO

DARLING_BIN="/usr/local/bin/darling"
BINFMT_DIR="/proc/sys/fs/binfmt_misc"

case "$1" in
    start)
        if [ ! -d "$BINFMT_DIR" ]; then
            mount -t binfmt_misc binfmt_misc "$BINFMT_DIR" 2>/dev/null || true
        fi
        if [ -f "$BINFMT_DIR/register" ]; then
            # Mach-O 64-bit (little-endian: CF FA ED FE)
            echo ":darling-mach64:M::\xcf\xfa\xed\xfe::\xff\xff\xff\xff:${DARLING_BIN}:" \
                > "$BINFMT_DIR/register" 2>/dev/null || true
            # Mach-O 32-bit (little-endian: CE FA ED FE)
            echo ":darling-mach32:M::\xce\xfa\xed\xfe::\xff\xff\xff\xff:${DARLING_BIN}:" \
                > "$BINFMT_DIR/register" 2>/dev/null || true
            # Fat/universal (big-endian: CA FE BA BE)
            echo ":darling-fat:M::\xca\xfe\xba\xbe::\xff\xff\xff\xff:${DARLING_BIN}:" \
                > "$BINFMT_DIR/register" 2>/dev/null || true
            echo "[darling-binfmt] Registered Mach-O handlers"
        fi
        ;;
    stop)
        for name in darling-mach64 darling-mach32 darling-fat; do
            [ -f "$BINFMT_DIR/$name" ] && echo -1 > "$BINFMT_DIR/$name"
        done
        ;;
    status)
        for name in darling-mach64 darling-mach32 darling-fat; do
            if [ -f "$BINFMT_DIR/$name" ]; then
                echo "$name: registered"
            else
                echo "$name: not registered"
            fi
        done
        ;;
    restart)
        $0 stop; $0 start ;;
    *)
        echo "Usage: $0 {start|stop|restart|status}"; exit 1 ;;
esac
INITSCRIPT
    chmod 755 "${ROOTFS_DIR}/etc/init.d/darling-binfmt"

    # --- Runlevel symlinks ---
    for rc in rc2.d rc3.d rc4.d rc5.d; do
        install -d "${ROOTFS_DIR}/etc/${rc}"
        ln -sf ../init.d/darling-binfmt "${ROOTFS_DIR}/etc/${rc}/S91darling-binfmt"
    done


    # --- CLI wrapper command ---
    install -d "${ROOTFS_DIR}/usr/local/bin"
    cat > "${ROOTFS_DIR}/usr/local/bin/macexec" <<'WRAPPER'
#!/bin/bash
# macexec — Run a macOS executable with enhanced CLI integration
# Usage: macexec <program> [args...]
#        macexec --shell
#        macexec --mount image.dmg
#
# Part of Galactic Cherry Marvell Edition 98

DARLING="/usr/local/bin/darling"

case "${1:-}" in
    --help|-h)
        echo "Usage: macexec [OPTIONS] <program> [args...]"
        echo ""
        echo "Options:"
        echo "  --shell          Enter Darling macOS shell"
        echo "  --mount FILE.dmg Mount a macOS disk image"
        echo "  --prefix PATH    Use alternate Darling prefix"
        echo "  --version        Show Darling version"
        echo ""
        echo "Examples:"
        echo "  macexec ./macos_tool --flag"
        echo "  macexec --shell"
        echo "  macexec --mount installer.dmg"
        exit 0
        ;;
    --shell)
        exec "$DARLING" shell
        ;;
    --mount)
        shift
        if command -v darling-dmg &>/dev/null; then
            exec darling-dmg "$@"
        else
            echo "macexec: darling-dmg not available. Use hdiutil inside darling shell."
            exec "$DARLING" shell -c "hdiutil attach '$1'"
        fi
        ;;
    --prefix)
        export DARLING_PREFIX="$2"
        shift 2
        exec "$DARLING" "$@"
        ;;
    --version)
        exec "$DARLING" --version 2>/dev/null || echo "darling (version unknown)"
        ;;
    "")
        echo "macexec: no program specified. Use --help for usage."
        exit 1
        ;;
    *)
        exec "$DARLING" "$@"
        ;;
esac
WRAPPER
    chmod 755 "${ROOTFS_DIR}/usr/local/bin/macexec"

    log "CLI handler installed:"
    log "  - binfmt_misc: ./macos_binary runs transparently"
    log "  - systemd-binfmt: /usr/lib/binfmt.d/darling.conf"
    log "  - init.d fallback: /etc/init.d/darling-binfmt"
    log "  - macexec command: enhanced CLI wrapper"
}

# =============================================================================
# Main
# =============================================================================

main() {
    echo ""
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║  Darling Native Mach-O Handlers                              ║"
    echo "║  Galactic Cherry Marvell Edition 98                          ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo ""
    log "Target: ${ROOTFS_DIR}"
    echo ""

    install_desktop_handler
    echo ""
    install_cli_handler

    echo ""
    log "════════════════════════════════════════════════════════════════"
    log "Native Mach-O handlers installed."
    log ""
    log "DESKTOP (GUI):"
    log "  Double-click .app  → launches with Darling"
    log "  Double-click .dmg  → mounts with Darling"
    log "  Mach-O binaries    → 'Open with Darling' option"
    log ""
    log "COMMAND LINE (CLI):"
    log "  ./macos_program         → runs via binfmt_misc + Darling"
    log "  macexec program [args]  → enhanced Darling wrapper"
    log "  macexec --shell         → macOS-like shell environment"
    log "  macexec --mount x.dmg   → mount disk image"
    log ""
    log "Both methods provide EQUAL access to macOS executables."
    log "════════════════════════════════════════════════════════════════"
}

main "$@"
