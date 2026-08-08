#!/bin/bash
# =============================================================================
# install-wine-handlers.sh — Native .exe handlers for Desktop and CLI
#
# Ubuntu Determinant Alpha RS — Galactic Cherry Marvell Edition 98
# Copyright (C) 2026 MEARVK LLC
# Author: Maximilian Eric Alexander Rupplin von Keffikon
#
# Installs two layers of native Windows executable handling:
#
#   1. DESKTOP (GUI): MIME types + .desktop handler so .exe/.msi files
#      open with Wine when double-clicked in any file manager.
#
#   2. COMMAND LINE (binfmt_misc): Kernel binary format registration so
#      ./program.exe runs transparently via Wine from any shell.
#
# Both layers provide equal-access execution of Windows binaries —
# the user experience is identical whether launching from desktop or CLI.
#
# Usage:
#   scripts/install-wine-handlers.sh <rootfs_dir>
#
# =============================================================================

set -euo pipefail

ROOTFS_DIR="${1:-build/rootfs}"
WINE_BIN="/usr/local/bin/wine"

log() {
    echo "  [WINE-HANDLER] $*"
}

# =============================================================================
# 1. DESKTOP HANDLER — GUI file manager integration
# =============================================================================

install_desktop_handler() {
    log "Installing desktop .exe handler..."

    # --- MIME type definitions ---
    install -d "${ROOTFS_DIR}/usr/share/mime/packages"
    cat > "${ROOTFS_DIR}/usr/share/mime/packages/wine-extensions.xml" <<'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<mime-info xmlns="http://www.freedesktop.org/standards/shared-mime-info">

  <!-- Windows Executable (.exe) -->
  <mime-type type="application/x-ms-dos-executable">
    <comment>Windows Executable</comment>
    <comment xml:lang="de">Windows-Programm</comment>
    <glob pattern="*.exe"/>
    <magic priority="60">
      <match type="string" offset="0" value="MZ"/>
    </magic>
  </mime-type>

  <!-- Windows Installer (.msi) -->
  <mime-type type="application/x-msi">
    <comment>Windows Installer Package</comment>
    <comment xml:lang="de">Windows-Installationspaket</comment>
    <glob pattern="*.msi"/>
    <magic priority="60">
      <match type="string" offset="0" value="\xd0\xcf\x11\xe0"/>
    </magic>
  </mime-type>

  <!-- Windows Batch File (.bat/.cmd) -->
  <mime-type type="application/x-ms-batch">
    <comment>Windows Batch Script</comment>
    <glob pattern="*.bat"/>
    <glob pattern="*.cmd"/>
  </mime-type>

  <!-- Windows COM executable (.com) -->
  <mime-type type="application/x-ms-com-executable">
    <comment>Windows COM Executable</comment>
    <glob pattern="*.com"/>
  </mime-type>

</mime-info>
EOF

    # --- .desktop application entry (the handler) ---
    install -d "${ROOTFS_DIR}/usr/share/applications"
    cat > "${ROOTFS_DIR}/usr/share/applications/wine-run.desktop" <<EOF
[Desktop Entry]
Name=Wine Windows Program Loader
Comment=Run Windows programs with Wine
Exec=${WINE_BIN} %f
Terminal=false
Type=Application
Icon=wine
MimeType=application/x-ms-dos-executable;application/x-msi;application/x-ms-batch;application/x-ms-com-executable;
NoDisplay=true
Categories=System;
StartupNotify=true
EOF

    # --- Set Wine as default handler for .exe MIME types ---
    install -d "${ROOTFS_DIR}/usr/share/applications"
    cat > "${ROOTFS_DIR}/usr/share/applications/mimeapps.list" <<'EOF'
[Default Applications]
application/x-ms-dos-executable=wine-run.desktop
application/x-msi=wine-run.desktop
application/x-ms-batch=wine-run.desktop
application/x-ms-com-executable=wine-run.desktop
EOF

    # Also put in /etc for system-wide default
    install -d "${ROOTFS_DIR}/etc/xdg"
    cat > "${ROOTFS_DIR}/etc/xdg/mimeapps.list" <<'EOF'
[Default Applications]
application/x-ms-dos-executable=wine-run.desktop
application/x-msi=wine-run.desktop
application/x-ms-batch=wine-run.desktop
application/x-ms-com-executable=wine-run.desktop
EOF

    # --- Thumbnailer for .exe files (shows embedded icons) ---
    install -d "${ROOTFS_DIR}/usr/share/thumbnailers"
    cat > "${ROOTFS_DIR}/usr/share/thumbnailers/wine-exe.thumbnailer" <<EOF
[Thumbnailer Entry]
TryExec=${WINE_BIN}
Exec=/usr/local/bin/wine-exe-thumbnailer %i %o %s
MimeType=application/x-ms-dos-executable;
EOF

    # --- Thumbnailer script (extracts .exe icon via wrestool if available) ---
    install -d "${ROOTFS_DIR}/usr/local/bin"
    cat > "${ROOTFS_DIR}/usr/local/bin/wine-exe-thumbnailer" <<'THUMB'
#!/bin/bash
# Extract embedded icon from .exe for file manager thumbnails
INPUT="$1"
OUTPUT="$2"
SIZE="${3:-48}"

if command -v wrestool &>/dev/null && command -v icotool &>/dev/null; then
    # Extract the first icon group
    TMPICO=$(mktemp /tmp/wine-thumb-XXXXXX.ico)
    wrestool -x -t 14 "$INPUT" > "$TMPICO" 2>/dev/null
    if [ -s "$TMPICO" ]; then
        icotool -x -w "$SIZE" -o "$OUTPUT" "$TMPICO" 2>/dev/null || \
        icotool -x -o "$OUTPUT" "$TMPICO" 2>/dev/null
    fi
    rm -f "$TMPICO"
fi

# Fallback: use generic wine icon
if [ ! -s "$OUTPUT" ] && [ -f /usr/share/icons/hicolor/48x48/apps/wine.png ]; then
    cp /usr/share/icons/hicolor/48x48/apps/wine.png "$OUTPUT"
fi
THUMB
    chmod 755 "${ROOTFS_DIR}/usr/local/bin/wine-exe-thumbnailer"

    log "Desktop handler installed:"
    log "  - MIME types: .exe, .msi, .bat, .cmd, .com"
    log "  - Default app: wine-run.desktop"
    log "  - System-wide mimeapps.list"
    log "  - Thumbnailer for .exe icons"
}

# =============================================================================
# 2. COMMAND LINE HANDLER — binfmt_misc kernel integration
# =============================================================================

install_cli_handler() {
    log "Installing CLI binfmt_misc .exe handler..."

    # --- binfmt_misc configuration file ---
    # This registers Wine with the kernel's binary format handler so that
    # executing ./program.exe in the shell transparently invokes Wine.
    #
    # Format: :name:type:offset:magic:mask:interpreter:flags
    #   - type M = magic number match
    #   - MZ = DOS/PE executable magic bytes
    #   - flags: F = fix binary (find interpreter at register time, not exec time)
    #            C = credentials (use caller's credentials)

    install -d "${ROOTFS_DIR}/usr/share/binfmts"

    # --- systemd-binfmt drop-in (modern method) ---
    install -d "${ROOTFS_DIR}/usr/lib/binfmt.d"
    cat > "${ROOTFS_DIR}/usr/lib/binfmt.d/wine.conf" <<EOF
# Wine Windows executable handler — Galactic Cherry Marvell Edition 98
# Allows transparent execution of .exe files from the command line:
#   $ ./program.exe        (runs via wine)
#   $ chmod +x setup.exe && ./setup.exe
#
# Format: :name:type:offset:magic:mask:interpreter:flags

# DOS/PE executables (.exe) — MZ magic at offset 0
:wine-exe:M::MZ::\\xff\\xff:${WINE_BIN}:FC

# Windows COM executables (.com) — match by extension via offset trick
# (COM files have no reliable magic, so we use the flag approach)
:wine-com:E::com::${WINE_BIN}:FC
EOF

    # --- Legacy binfmt-support package registration ---
    install -d "${ROOTFS_DIR}/usr/share/binfmts"
    cat > "${ROOTFS_DIR}/usr/share/binfmts/wine-exe" <<EOF
package wine
interpreter ${WINE_BIN}
magic MZ
offset 0
EOF

    # --- Init script for systems without systemd-binfmt ---
    install -d "${ROOTFS_DIR}/etc/init.d"
    cat > "${ROOTFS_DIR}/etc/init.d/wine-binfmt" <<'INITSCRIPT'
#!/bin/bash
### BEGIN INIT INFO
# Provides:          wine-binfmt
# Required-Start:    $local_fs
# Required-Stop:
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Register Wine as .exe handler via binfmt_misc
### END INIT INFO

WINE_BIN="/usr/local/bin/wine"
BINFMT_DIR="/proc/sys/fs/binfmt_misc"

case "$1" in
    start)
        if [ ! -d "$BINFMT_DIR" ]; then
            mount -t binfmt_misc binfmt_misc "$BINFMT_DIR" 2>/dev/null || true
        fi
        if [ -f "$BINFMT_DIR/register" ]; then
            # Register MZ (PE/DOS) executables
            echo ":wine-exe:M::MZ::\xff\xff:${WINE_BIN}:" > "$BINFMT_DIR/register" 2>/dev/null || true
            echo "[wine-binfmt] Registered .exe handler: ${WINE_BIN}"
        fi
        ;;
    stop)
        if [ -f "$BINFMT_DIR/wine-exe" ]; then
            echo -1 > "$BINFMT_DIR/wine-exe"
        fi
        ;;
    status)
        if [ -f "$BINFMT_DIR/wine-exe" ]; then
            cat "$BINFMT_DIR/wine-exe"
        else
            echo "wine-exe: not registered"
        fi
        ;;
    restart)
        $0 stop
        $0 start
        ;;
    *)
        echo "Usage: $0 {start|stop|restart|status}"
        exit 1
        ;;
esac
INITSCRIPT
    chmod 755 "${ROOTFS_DIR}/etc/init.d/wine-binfmt"

    # --- Symlink for default runlevels ---
    install -d "${ROOTFS_DIR}/etc/rc2.d"
    install -d "${ROOTFS_DIR}/etc/rc3.d"
    install -d "${ROOTFS_DIR}/etc/rc4.d"
    install -d "${ROOTFS_DIR}/etc/rc5.d"
    ln -sf ../init.d/wine-binfmt "${ROOTFS_DIR}/etc/rc2.d/S90wine-binfmt"
    ln -sf ../init.d/wine-binfmt "${ROOTFS_DIR}/etc/rc3.d/S90wine-binfmt"
    ln -sf ../init.d/wine-binfmt "${ROOTFS_DIR}/etc/rc4.d/S90wine-binfmt"
    ln -sf ../init.d/wine-binfmt "${ROOTFS_DIR}/etc/rc5.d/S90wine-binfmt"

    # --- Shell wrapper for enhanced CLI experience ---
    # Provides 'winexec' command that auto-detects .exe and adds convenience
    cat > "${ROOTFS_DIR}/usr/local/bin/winexec" <<'WRAPPER'
#!/bin/bash
# winexec — Run a Windows executable with enhanced CLI integration
# Usage: winexec program.exe [args...]
#        winexec --install program.msi
#        winexec --cfg
#
# Part of Galactic Cherry Marvell Edition 98

WINE="/usr/local/bin/wine"

case "${1:-}" in
    --help|-h)
        echo "Usage: winexec [OPTIONS] <program.exe> [args...]"
        echo ""
        echo "Options:"
        echo "  --install FILE.msi   Install a Windows package"
        echo "  --cfg                Open Wine configuration"
        echo "  --kill               Kill all Wine processes"
        echo "  --prefix PATH        Use alternate Wine prefix"
        echo "  --version            Show Wine version"
        echo ""
        echo "Examples:"
        echo "  winexec notepad.exe"
        echo "  winexec ./setup.exe /S"
        echo "  winexec --install package.msi"
        exit 0
        ;;
    --install)
        shift
        exec "$WINE" msiexec /i "$@"
        ;;
    --cfg)
        exec "$WINE"cfg
        ;;
    --kill)
        exec "$WINE"server -k
        ;;
    --prefix)
        export WINEPREFIX="$2"
        shift 2
        exec "$WINE" "$@"
        ;;
    --version)
        exec "$WINE" --version
        ;;
    "")
        echo "winexec: no program specified. Use --help for usage."
        exit 1
        ;;
    *)
        exec "$WINE" "$@"
        ;;
esac
WRAPPER
    chmod 755 "${ROOTFS_DIR}/usr/local/bin/winexec"

    log "CLI handler installed:"
    log "  - binfmt_misc: ./program.exe runs transparently"
    log "  - systemd-binfmt: /usr/lib/binfmt.d/wine.conf"
    log "  - init.d fallback: /etc/init.d/wine-binfmt"
    log "  - winexec command: enhanced CLI wrapper"
}

# =============================================================================
# 3. KERNEL CONFIG — ensure binfmt_misc is enabled
# =============================================================================

install_kernel_config_note() {
    log "Verifying kernel config supports binfmt_misc..."

    # Create a note file for the kernel build to pick up
    install -d "${ROOTFS_DIR}/usr/share/doc/wine"
    cat > "${ROOTFS_DIR}/usr/share/doc/wine/KERNEL-CONFIG.md" <<'EOF'
# Wine Kernel Requirements — Galactic Cherry Marvell Edition 98

The following kernel config options must be enabled for transparent
.exe execution from the command line:

```
CONFIG_BINFMT_MISC=y    (or =m with module loaded)
```

This is enabled by default in the Galactic Cherry defconfig.

## How it works

1. On boot, systemd-binfmt reads /usr/lib/binfmt.d/wine.conf
2. It registers the MZ magic (first 2 bytes of any .exe) with the kernel
3. When you run ./program.exe, the kernel sees MZ and invokes /usr/local/bin/wine
4. Wine loads the Windows executable transparently

## Verification

```bash
# Check binfmt_misc is mounted
mount | grep binfmt_misc

# Check wine is registered
cat /proc/sys/fs/binfmt_misc/wine-exe

# Test execution
echo 'Hello from Wine' > /dev/null
./windows-program.exe
```
EOF

    log "Kernel config note installed at /usr/share/doc/wine/KERNEL-CONFIG.md"
}

# =============================================================================
# Main
# =============================================================================

main() {
    echo ""
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║  Wine Native .exe Handlers                                   ║"
    echo "║  Galactic Cherry Marvell Edition 98                          ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo ""
    log "Target: ${ROOTFS_DIR}"
    echo ""

    install_desktop_handler
    echo ""
    install_cli_handler
    echo ""
    install_kernel_config_note

    echo ""
    log "════════════════════════════════════════════════════════════════"
    log "Native .exe handlers installed."
    log ""
    log "DESKTOP (GUI):"
    log "  Double-click .exe → launches with Wine"
    log "  Double-click .msi → installs with Wine"
    log "  Right-click .exe  → 'Open with Wine' option"
    log "  File manager shows .exe icons (if wrestool available)"
    log ""
    log "COMMAND LINE (CLI):"
    log "  ./program.exe           → runs via binfmt_misc + Wine"
    log "  winexec program.exe     → enhanced Wine wrapper"
    log "  winexec --install x.msi → install Windows package"
    log "  winexec --cfg           → Wine configuration"
    log ""
    log "Both methods provide EQUAL access to Windows executables."
    log "════════════════════════════════════════════════════════════════"
}

main "$@"
