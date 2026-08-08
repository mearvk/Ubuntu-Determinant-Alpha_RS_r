#!/bin/bash
# =============================================================================
# install-wine.sh — Download, build, and install Wine into the rootfs
#
# Ubuntu Determinant Alpha RS — Galactic Cherry Marvell Edition 98
# Copyright (C) 2026 MEARVK LLC
# Author: Maximilian Eric Alexander Rupplin von Keffikon
#
# Wine is the Windows compatibility layer that allows running Windows
# applications on Linux. This script fetches the Wine source, compiles
# it for both 64-bit and 32-bit targets (WoW64), and installs into
# the target rootfs or system prefix.
#
# Usage:
#   scripts/install-wine.sh <rootfs_dir>
#   scripts/install-wine.sh <rootfs_dir> --source-only
#   scripts/install-wine.sh <rootfs_dir> --binary
#
# Modes:
#   (default)      Build Wine from source and install
#   --source-only  Download source only (no build)
#   --binary       Install prebuilt Wine from WineHQ repository
#
# Prerequisites (host):
#   gcc, g++, make, flex, bison, pkg-config
#   libx11-dev, libfreetype-dev, libfontconfig-dev
#   libgstreamer1.0-dev, libvulkan-dev, libsdl2-dev
#   mingw-w64 (for WoW64 PE builds)
#
# =============================================================================

set -euo pipefail

# =============================================================================
# Configuration
# =============================================================================

WINE_VERSION="${WINE_VERSION:-9.0}"
WINE_BRANCH="${WINE_BRANCH:-stable}"
WINE_URL="https://dl.winehq.org/wine/source/${WINE_BRANCH}/wine-${WINE_VERSION}.tar.xz"
WINE_MONO_VERSION="9.0.0"
WINE_GECKO_VERSION="2.47.4"

# WineHQ APT repository (for binary install mode)
WINEHQ_REPO="https://dl.winehq.org/wine-builds/ubuntu/"
WINEHQ_KEY_URL="https://dl.winehq.org/wine-builds/winehq.key"

# Source build directory
WINE_SRC_DIR="userland/wine"
WINE_BUILD_DIR64="userland/wine/build64"
WINE_BUILD_DIR32="userland/wine/build32"

# Install prefix inside rootfs
WINE_PREFIX="/usr/local"

# =============================================================================
# Arguments
# =============================================================================

ROOTFS_DIR="${1:-build/rootfs}"
MODE="source"

shift || true
while [[ $# -gt 0 ]]; do
    case "$1" in
        --source-only)
            MODE="source-only"
            shift
            ;;
        --binary)
            MODE="binary"
            shift
            ;;
        --version)
            WINE_VERSION="$2"
            WINE_URL="https://dl.winehq.org/wine/source/${WINE_BRANCH}/wine-${WINE_VERSION}.tar.xz"
            shift 2
            ;;
        --branch)
            WINE_BRANCH="$2"
            WINE_URL="https://dl.winehq.org/wine/source/${WINE_BRANCH}/wine-${WINE_VERSION}.tar.xz"
            shift 2
            ;;
        --help|-h)
            echo "Usage: $0 <rootfs_dir> [--source-only|--binary] [--version X.Y] [--branch stable|devel]"
            exit 0
            ;;
        *)
            shift
            ;;
    esac
done

# =============================================================================
# Helper Functions
# =============================================================================

log() {
    echo "  [WINE] $*"
}

error() {
    echo "  [WINE] ERROR: $*" >&2
    exit 1
}

check_deps_source() {
    local missing=()
    for cmd in gcc g++ make flex bison pkg-config wget tar xz; do
        if ! command -v "$cmd" &>/dev/null; then
            missing+=("$cmd")
        fi
    done
    if [[ ${#missing[@]} -gt 0 ]]; then
        error "Missing build tools: ${missing[*]}"
    fi
}

install_wine_deps() {
    log "Installing Wine build dependencies..."
    if command -v apt-get &>/dev/null; then
        apt-get install -y \
            gcc-multilib g++-multilib \
            libx11-dev libx11-dev:i386 \
            libfreetype-dev libfreetype-dev:i386 \
            libfontconfig-dev \
            libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev \
            libvulkan-dev libvulkan-dev:i386 \
            libsdl2-dev \
            libpulse-dev libpulse-dev:i386 \
            libasound2-dev libasound2-dev:i386 \
            libcups2-dev \
            libdbus-1-dev \
            libgnutls28-dev libgnutls28-dev:i386 \
            libusb-1.0-0-dev \
            libv4l-dev \
            libgphoto2-dev \
            liblcms2-dev \
            libldap2-dev \
            libsane-dev \
            libpcap-dev \
            libunwind-dev \
            mingw-w64 \
            gettext \
            2>/dev/null || log "Some i386 packages unavailable (non-multiarch host)"
    fi
}

# =============================================================================
# Source Build Mode
# =============================================================================

fetch_wine_source() {
    log "Fetching Wine ${WINE_VERSION} (${WINE_BRANCH}) source..."
    mkdir -p "${WINE_SRC_DIR}"

    if [[ -d "${WINE_SRC_DIR}/wine-${WINE_VERSION}" ]]; then
        log "Source already exists at ${WINE_SRC_DIR}/wine-${WINE_VERSION}"
        return 0
    fi

    local tarball="${WINE_SRC_DIR}/wine-${WINE_VERSION}.tar.xz"
    if [[ ! -f "$tarball" ]]; then
        wget -q --show-progress -O "$tarball" "$WINE_URL" || \
            error "Failed to download Wine source from ${WINE_URL}"
    fi

    log "Extracting Wine source..."
    tar -xJf "$tarball" -C "${WINE_SRC_DIR}"
    log "Wine source extracted to ${WINE_SRC_DIR}/wine-${WINE_VERSION}"
}

build_wine_source() {
    local srcdir="${WINE_SRC_DIR}/wine-${WINE_VERSION}"

    if [[ ! -d "$srcdir" ]]; then
        error "Wine source not found at $srcdir. Run fetch first."
    fi

    log "Building Wine ${WINE_VERSION} (64-bit)..."
    mkdir -p "${WINE_BUILD_DIR64}"
    cd "${WINE_BUILD_DIR64}"

    "../../wine-${WINE_VERSION}/configure" \
        --prefix="${WINE_PREFIX}" \
        --enable-win64 \
        --with-x \
        --with-gstreamer \
        --with-vulkan \
        --with-pulse \
        --with-alsa \
        --with-cups \
        --with-dbus \
        --with-gnutls \
        --with-usb \
        --with-v4l2 \
        --with-fontconfig \
        --with-freetype \
        --with-pcap \
        --with-unwind \
        --with-mingw \
        2>&1 | tail -5

    make -j"$(nproc)" 2>&1 | tail -3
    cd - >/dev/null

    # 32-bit (WoW64) build — only if multilib available
    if dpkg --print-foreign-architectures 2>/dev/null | grep -q i386 || \
       [[ -f /usr/lib32/libc.so ]]; then
        log "Building Wine ${WINE_VERSION} (32-bit WoW64)..."
        mkdir -p "${WINE_BUILD_DIR32}"
        cd "${WINE_BUILD_DIR32}"

        "../../wine-${WINE_VERSION}/configure" \
            --prefix="${WINE_PREFIX}" \
            --with-wine64="../../${WINE_BUILD_DIR64}" \
            --with-x \
            --with-gstreamer \
            --with-pulse \
            --with-alsa \
            --with-gnutls \
            --with-freetype \
            2>&1 | tail -5

        make -j"$(nproc)" 2>&1 | tail -3
        cd - >/dev/null
    else
        log "Skipping 32-bit build (no multiarch/multilib detected)"
    fi

    log "Wine build complete."
}

install_wine_source() {
    log "Installing Wine to ${ROOTFS_DIR}${WINE_PREFIX}..."

    # Install 32-bit first (if built)
    if [[ -d "${WINE_BUILD_DIR32}" ]] && [[ -f "${WINE_BUILD_DIR32}/Makefile" ]]; then
        make -C "${WINE_BUILD_DIR32}" install DESTDIR="$(realpath "${ROOTFS_DIR}")" 2>/dev/null || true
    fi

    # Install 64-bit (overwrites wine64 binary properly)
    if [[ -d "${WINE_BUILD_DIR64}" ]] && [[ -f "${WINE_BUILD_DIR64}/Makefile" ]]; then
        make -C "${WINE_BUILD_DIR64}" install DESTDIR="$(realpath "${ROOTFS_DIR}")"
    fi

    log "Wine installed to ${ROOTFS_DIR}${WINE_PREFIX}"
}

# =============================================================================
# Binary Install Mode (from WineHQ APT repository)
# =============================================================================

install_wine_binary() {
    log "Installing Wine from WineHQ binary repository..."

    if [[ ! -d "${ROOTFS_DIR}/usr" ]]; then
        error "Rootfs not found at ${ROOTFS_DIR}. Run 'make rootfs' first."
    fi

    # If running as root with chroot access
    if [[ "$(id -u)" == "0" ]] && [[ -f "${ROOTFS_DIR}/bin/bash" ]]; then
        log "Installing via chroot..."

        # Add i386 architecture
        chroot "${ROOTFS_DIR}" dpkg --add-architecture i386

        # Add WineHQ repository key
        mkdir -p "${ROOTFS_DIR}/etc/apt/keyrings"
        wget -qO "${ROOTFS_DIR}/etc/apt/keyrings/winehq-archive.key" "${WINEHQ_KEY_URL}"

        # Add repository source
        local codename
        codename=$(chroot "${ROOTFS_DIR}" lsb_release -cs 2>/dev/null || echo "noble")
        cat > "${ROOTFS_DIR}/etc/apt/sources.list.d/winehq.list" <<EOF
deb [signed-by=/etc/apt/keyrings/winehq-archive.key] ${WINEHQ_REPO} ${codename} main
EOF

        # Install Wine
        chroot "${ROOTFS_DIR}" apt-get update
        chroot "${ROOTFS_DIR}" apt-get install -y --install-recommends winehq-${WINE_BRANCH}

        log "Wine (${WINE_BRANCH}) installed via APT in chroot."
    else
        # Prepare install script for first boot
        log "Preparing Wine install script for first boot..."
        install -d "${ROOTFS_DIR}/usr/sbin"
        cat > "${ROOTFS_DIR}/usr/sbin/install-wine-firstboot.sh" <<'FIRSTBOOT'
#!/bin/bash
# Wine first-boot installer — runs once to set up WineHQ
set -e
echo "[Wine] First-boot installation starting..."

dpkg --add-architecture i386
mkdir -p /etc/apt/keyrings
wget -qO /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key

CODENAME=$(lsb_release -cs 2>/dev/null || echo "noble")
cat > /etc/apt/sources.list.d/winehq.list <<EOF2
deb [signed-by=/etc/apt/keyrings/winehq-archive.key] https://dl.winehq.org/wine-builds/ubuntu/ ${CODENAME} main
EOF2

apt-get update
apt-get install -y --install-recommends winehq-stable

# Install Wine Mono and Gecko
WINE_MONO_VER="9.0.0"
WINE_GECKO_VER="2.47.4"
SHARE_DIR="/usr/share/wine"
mkdir -p "${SHARE_DIR}/mono" "${SHARE_DIR}/gecko"

wget -qO "${SHARE_DIR}/mono/wine-mono-${WINE_MONO_VER}-x86.msi" \
    "https://dl.winehq.org/wine/wine-mono/${WINE_MONO_VER}/wine-mono-${WINE_MONO_VER}-x86.msi" || true
wget -qO "${SHARE_DIR}/gecko/wine-gecko-${WINE_GECKO_VER}-x86.msi" \
    "https://dl.winehq.org/wine/wine-gecko/${WINE_GECKO_VER}/wine-gecko-${WINE_GECKO_VER}-x86.msi" || true
wget -qO "${SHARE_DIR}/gecko/wine-gecko-${WINE_GECKO_VER}-x86_64.msi" \
    "https://dl.winehq.org/wine/wine-gecko/${WINE_GECKO_VER}/wine-gecko-${WINE_GECKO_VER}-x86_64.msi" || true

echo "[Wine] Installation complete: $(wine --version 2>/dev/null || echo 'wine installed')"

# Self-disable
rm -f /etc/systemd/system/multi-user.target.wants/wine-firstboot.service
echo "[Wine] First-boot service disabled."
FIRSTBOOT
        chmod 755 "${ROOTFS_DIR}/usr/sbin/install-wine-firstboot.sh"

        # Create systemd service for first boot
        install -d "${ROOTFS_DIR}/etc/systemd/system"
        cat > "${ROOTFS_DIR}/etc/systemd/system/wine-firstboot.service" <<EOF
[Unit]
Description=Wine First-Boot Installation
After=network-online.target
Wants=network-online.target
ConditionPathExists=/usr/sbin/install-wine-firstboot.sh

[Service]
Type=oneshot
ExecStart=/usr/sbin/install-wine-firstboot.sh
RemainAfterExit=yes
StandardOutput=journal+console

[Install]
WantedBy=multi-user.target
EOF

        # Enable the service
        install -d "${ROOTFS_DIR}/etc/systemd/system/multi-user.target.wants"
        ln -sf /etc/systemd/system/wine-firstboot.service \
            "${ROOTFS_DIR}/etc/systemd/system/multi-user.target.wants/wine-firstboot.service"

        log "First-boot Wine installer staged."
        log "Wine will be installed automatically on first network-connected boot."
    fi
}

# =============================================================================
# Wine Mono and Gecko (runtime components)
# =============================================================================

install_wine_runtime_components() {
    log "Installing Wine runtime components (Mono, Gecko)..."

    local share_dir="${ROOTFS_DIR}/usr/share/wine"
    mkdir -p "${share_dir}/mono" "${share_dir}/gecko"

    # Wine Mono (.NET replacement)
    local mono_url="https://dl.winehq.org/wine/wine-mono/${WINE_MONO_VERSION}/wine-mono-${WINE_MONO_VERSION}-x86.msi"
    if [[ ! -f "${share_dir}/mono/wine-mono-${WINE_MONO_VERSION}-x86.msi" ]]; then
        wget -q --show-progress -O "${share_dir}/mono/wine-mono-${WINE_MONO_VERSION}-x86.msi" \
            "$mono_url" 2>/dev/null || log "Wine Mono download skipped (no network)"
    fi

    # Wine Gecko (IE replacement)
    local gecko_url32="https://dl.winehq.org/wine/wine-gecko/${WINE_GECKO_VERSION}/wine-gecko-${WINE_GECKO_VERSION}-x86.msi"
    local gecko_url64="https://dl.winehq.org/wine/wine-gecko/${WINE_GECKO_VERSION}/wine-gecko-${WINE_GECKO_VERSION}-x86_64.msi"
    if [[ ! -f "${share_dir}/gecko/wine-gecko-${WINE_GECKO_VERSION}-x86.msi" ]]; then
        wget -q --show-progress -O "${share_dir}/gecko/wine-gecko-${WINE_GECKO_VERSION}-x86.msi" \
            "$gecko_url32" 2>/dev/null || log "Wine Gecko (x86) download skipped"
    fi
    if [[ ! -f "${share_dir}/gecko/wine-gecko-${WINE_GECKO_VERSION}-x86_64.msi" ]]; then
        wget -q --show-progress -O "${share_dir}/gecko/wine-gecko-${WINE_GECKO_VERSION}-x86_64.msi" \
            "$gecko_url64" 2>/dev/null || log "Wine Gecko (x86_64) download skipped"
    fi

    log "Wine runtime components staged."
}

# =============================================================================
# Wine Configuration for Galactic Cherry
# =============================================================================

install_wine_config() {
    log "Installing Wine configuration for Galactic Cherry..."

    # Profile script to set WINE environment
    install -d "${ROOTFS_DIR}/etc/profile.d"
    cat > "${ROOTFS_DIR}/etc/profile.d/wine.sh" <<'EOF'
# Wine environment configuration — Galactic Cherry Marvell Edition 98
# Installed by: scripts/install-wine.sh

export WINEARCH="${WINEARCH:-win64}"
export WINEPREFIX="${WINEPREFIX:-$HOME/.wine}"

# Wine DLL overrides for stability
export WINEDLLOVERRIDES="winemenubuilder.exe=d"

# Add Wine to PATH if installed to /usr/local
if [ -d /usr/local/bin ] && echo "$PATH" | grep -qv /usr/local/bin; then
    export PATH="/usr/local/bin:$PATH"
fi
EOF

    # Wine binfmt support (run .exe directly from command line)
    install -d "${ROOTFS_DIR}/usr/share/binfmts"
    cat > "${ROOTFS_DIR}/usr/share/binfmts/wine" <<'EOF'
package wine
interpreter /usr/local/bin/wine
magic MZ
EOF

    # Desktop integration — .desktop file for Wine configuration
    install -d "${ROOTFS_DIR}/usr/share/applications"
    cat > "${ROOTFS_DIR}/usr/share/applications/wine-config.desktop" <<'EOF'
[Desktop Entry]
Name=Wine Configuration
Comment=Configure Wine Windows Compatibility Layer
Exec=winecfg
Terminal=false
Type=Application
Icon=wine
Categories=System;Settings;
StartupNotify=true
EOF

    cat > "${ROOTFS_DIR}/usr/share/applications/wine-filemanager.desktop" <<'EOF'
[Desktop Entry]
Name=Wine File Manager
Comment=Browse Windows drives in Wine
Exec=wine explorer
Terminal=false
Type=Application
Icon=wine
Categories=System;FileManager;
StartupNotify=true
EOF

    # MIME type association for .exe files
    install -d "${ROOTFS_DIR}/usr/share/mime/packages"
    cat > "${ROOTFS_DIR}/usr/share/mime/packages/wine.xml" <<'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<mime-info xmlns="http://www.freedesktop.org/standards/shared-mime-info">
  <mime-type type="application/x-ms-dos-executable">
    <comment>Windows Executable</comment>
    <glob pattern="*.exe"/>
    <magic priority="50">
      <match type="string" offset="0" value="MZ"/>
    </magic>
  </mime-type>
  <mime-type type="application/x-msi">
    <comment>Windows Installer Package</comment>
    <glob pattern="*.msi"/>
  </mime-type>
</mime-info>
EOF

    log "Wine configuration installed."
}

# =============================================================================
# Main
# =============================================================================

main() {
    echo ""
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║  Wine Integration — Galactic Cherry Marvell Edition 98      ║"
    echo "║  Wine ${WINE_VERSION} (${WINE_BRANCH})                     ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo ""
    log "Mode: ${MODE}"
    log "Target rootfs: ${ROOTFS_DIR}"
    echo ""

    case "${MODE}" in
        source)
            check_deps_source
            fetch_wine_source
            build_wine_source
            install_wine_source
            install_wine_runtime_components
            install_wine_config
            ;;
        source-only)
            fetch_wine_source
            log "Source downloaded. Build manually with:"
            log "  make wine-build"
            ;;
        binary)
            install_wine_binary
            install_wine_runtime_components
            install_wine_config
            ;;
    esac

    echo ""
    log "════════════════════════════════════════════════════════════════"
    log "Wine integration complete."
    log ""
    log "Installed components:"
    log "  - Wine ${WINE_VERSION} (${WINE_BRANCH}) — Windows compatibility layer"
    log "  - Wine Mono ${WINE_MONO_VERSION} — .NET Framework replacement"
    log "  - Wine Gecko ${WINE_GECKO_VERSION} — Internet Explorer replacement"
    log "  - Desktop integration (.desktop files, MIME types)"
    log "  - Environment configuration (/etc/profile.d/wine.sh)"
    log "  - binfmt support (run .exe directly)"
    log ""
    log "Usage:"
    log "  wine program.exe          — Run Windows program"
    log "  winecfg                   — Configure Wine"
    log "  wine explorer             — File manager"
    log "  wineboot --init           — Initialize Wine prefix"
    log "════════════════════════════════════════════════════════════════"
}

main "$@"
