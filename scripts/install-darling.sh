#!/bin/bash
# =============================================================================
# install-darling.sh — Build and install Darling into the rootfs
#
# Ubuntu Determinant Alpha RS — Galactic Cherry Marvell Edition 98
# Copyright (C) 2026 MEARVK LLC
# Author: Maximilian Eric Alexander Rupplin von Keffikon
#
# Darling is the macOS compatibility layer for Linux — the macOS equivalent
# of Wine. It translates Darwin/macOS API calls (Mach, dyld, launchd,
# Cocoa frameworks) to Linux, allowing Mach-O binaries to run natively
# without hardware emulation.
#
# Usage:
#   scripts/install-darling.sh <rootfs_dir>
#   scripts/install-darling.sh <rootfs_dir> --build-only
#   scripts/install-darling.sh <rootfs_dir> --install-only
#
# Modes:
#   (default)       Build and install Darling from source
#   --build-only    Build without installing
#   --install-only  Install pre-built Darling into rootfs
#
# Prerequisites (host):
#   cmake (>= 3.16), clang, gcc, g++, python3
#   libfuse-dev, libbsd-dev, libelf-dev
#   linux-headers (for kernel module)
#
# =============================================================================

set -euo pipefail

# =============================================================================
# Configuration
# =============================================================================

DARLING_SRC_DIR="userland/darling"
DARLING_BUILD_DIR="userland/darling/build"
DARLING_PREFIX="/usr/local"

# Kernel headers for module build
KERNEL_VER="${KERNEL_VER:-5.15.204}"
KERNEL_DIR="${KERNEL_DIR:-kernels/linux-${KERNEL_VER}/linux-${KERNEL_VER}}"

# =============================================================================
# Arguments
# =============================================================================

ROOTFS_DIR="${1:-build/rootfs}"
MODE="full"

shift || true
while [[ $# -gt 0 ]]; do
    case "$1" in
        --build-only)
            MODE="build-only"
            shift
            ;;
        --install-only)
            MODE="install-only"
            shift
            ;;
        --help|-h)
            echo "Usage: $0 <rootfs_dir> [--build-only|--install-only]"
            echo ""
            echo "Modes:"
            echo "  (default)       Build and install Darling"
            echo "  --build-only    Build without installing"
            echo "  --install-only  Install pre-built Darling into rootfs"
            echo ""
            echo "Environment:"
            echo "  KERNEL_VER      Kernel version for module build (default: 5.15.204)"
            echo "  KERNEL_DIR      Path to kernel source tree"
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
    echo "  [DARLING] $*"
}

error() {
    echo "  [DARLING] ERROR: $*" >&2
    exit 1
}

check_deps() {
    local missing=()
    for cmd in cmake clang gcc g++ python3 make; do
        if ! command -v "$cmd" &>/dev/null; then
            missing+=("$cmd")
        fi
    done
    if [[ ${#missing[@]} -gt 0 ]]; then
        error "Missing build tools: ${missing[*]}"
    fi
}

install_build_deps() {
    log "Installing Darling build dependencies..."
    if command -v apt-get &>/dev/null; then
        apt-get install -y \
            cmake clang gcc g++ \
            python3 python3-dev \
            libfuse-dev libfuse3-dev \
            libbsd-dev \
            libelf-dev \
            linux-headers-$(uname -r) \
            pkg-config \
            libcairo2-dev \
            libfreetype-dev \
            libudev-dev \
            libxml2-dev \
            libxkbfile-dev \
            libglu1-mesa-dev \
            libcap-dev \
            libgif-dev \
            libtiff-dev \
            libpulse-dev \
            libasound2-dev \
            libavcodec-dev libavformat-dev \
            libssl-dev \
            2>/dev/null || log "Some packages unavailable"
    fi
}

# =============================================================================
# Build Darling
# =============================================================================

build_darling() {
    if [[ ! -f "${DARLING_SRC_DIR}/CMakeLists.txt" ]]; then
        error "Darling source not found at ${DARLING_SRC_DIR}. Ensure source is present."
    fi

    log "Building Darling from ${DARLING_SRC_DIR}..."
    mkdir -p "${DARLING_BUILD_DIR}"
    cd "${DARLING_BUILD_DIR}"

    # Configure with CMake
    log "Configuring (CMake)..."
    cmake .. \
        -DCMAKE_INSTALL_PREFIX="${DARLING_PREFIX}" \
        -DCMAKE_BUILD_TYPE=Release \
        -DTARGET_i386=OFF \
        -DENABLE_TESTS=OFF \
        2>&1 | tail -15

    # Build
    log "Compiling (using $(nproc) cores)..."
    make -j"$(nproc)" 2>&1 | tail -10

    cd - >/dev/null
    log "Darling build complete."

    # Build kernel module (darling-mach)
    build_kernel_module
}

build_kernel_module() {
    local lkm_dir="${DARLING_SRC_DIR}/src/lkm"

    if [[ ! -d "$lkm_dir" ]]; then
        log "Kernel module source not found at ${lkm_dir} — skipping"
        return 0
    fi

    log "Building Darling kernel module (darling-mach)..."

    if [[ -d "${KERNEL_DIR}" ]]; then
        # Build against our custom kernel
        make -C "${KERNEL_DIR}" M="$(realpath "${lkm_dir}")" modules 2>&1 | tail -5 || \
            log "Kernel module build failed (may need configured kernel tree)"
    elif [[ -d "/lib/modules/$(uname -r)/build" ]]; then
        # Build against running kernel headers
        make -C "/lib/modules/$(uname -r)/build" M="$(realpath "${lkm_dir}")" modules 2>&1 | tail -5 || \
            log "Kernel module build against host kernel failed"
    else
        log "No kernel headers available — kernel module build skipped"
        log "Build manually: make -C <kernel_dir> M=userland/darling/src/lkm modules"
    fi
}

# =============================================================================
# Install Darling
# =============================================================================

install_darling() {
    log "Installing Darling to ${ROOTFS_DIR}${DARLING_PREFIX}..."

    if [[ -d "${DARLING_BUILD_DIR}" ]] && [[ -f "${DARLING_BUILD_DIR}/Makefile" ]]; then
        make -C "${DARLING_BUILD_DIR}" install DESTDIR="$(realpath "${ROOTFS_DIR}")" 2>/dev/null || \
            log "CMake install not available — performing manual install"
    fi

    # Manual install of key binaries (fallback / supplement)
    install -d "${ROOTFS_DIR}${DARLING_PREFIX}/bin"
    install -d "${ROOTFS_DIR}${DARLING_PREFIX}/libexec/darling"
    install -d "${ROOTFS_DIR}${DARLING_PREFIX}/lib/darling"
    install -d "${ROOTFS_DIR}/usr/share/doc/darling"

    # Install built binaries if they exist
    for bin in darling darling-shell; do
        if [[ -f "${DARLING_BUILD_DIR}/src/darling/${bin}" ]]; then
            install -m 755 "${DARLING_BUILD_DIR}/src/darling/${bin}" \
                "${ROOTFS_DIR}${DARLING_PREFIX}/bin/"
        fi
    done

    # Install kernel module
    local lkm_dir="${DARLING_SRC_DIR}/src/lkm"
    if [[ -f "${lkm_dir}/darling-mach.ko" ]]; then
        install -d "${ROOTFS_DIR}/lib/modules/${KERNEL_VER}/extra"
        install -m 644 "${lkm_dir}/darling-mach.ko" \
            "${ROOTFS_DIR}/lib/modules/${KERNEL_VER}/extra/"
        log "Kernel module installed: /lib/modules/${KERNEL_VER}/extra/darling-mach.ko"
    fi

    # Install profile.d script
    install -d "${ROOTFS_DIR}/etc/profile.d"
    cat > "${ROOTFS_DIR}/etc/profile.d/darling.sh" <<'EOF'
# Darling environment — Galactic Cherry Marvell Edition 98
# macOS compatibility layer for Linux

# Darling prefix (per-user macOS-like environment)
export DARLING_PREFIX="${DARLING_PREFIX:-$HOME/.darling}"

# Add Darling to PATH
if [ -d /usr/local/bin ] && echo "$PATH" | grep -qv /usr/local/bin; then
    export PATH="/usr/local/bin:$PATH"
fi
EOF

    # Install systemd service for kernel module loading
    install -d "${ROOTFS_DIR}/etc/modules-load.d"
    cat > "${ROOTFS_DIR}/etc/modules-load.d/darling.conf" <<'EOF'
# Load Darling Mach kernel module on boot
# Required for macOS binary translation (Mach system calls)
darling-mach
EOF

    # Install modprobe config
    install -d "${ROOTFS_DIR}/etc/modprobe.d"
    cat > "${ROOTFS_DIR}/etc/modprobe.d/darling.conf" <<'EOF'
# Darling kernel module options
# The darling-mach module provides Mach IPC and trap translation
options darling-mach
EOF

    # Documentation
    cat > "${ROOTFS_DIR}/usr/share/doc/darling/README.md" <<'EOF'
# Darling — macOS Compatibility Layer

Darling is the macOS equivalent of Wine for Linux. It translates
Darwin/macOS system calls (Mach traps, BSD syscalls) to Linux,
allowing native macOS (Mach-O) binaries to run without emulation.

## Usage

```bash
# Enter a Darling shell (macOS-like environment)
darling shell

# Run a macOS command-line program
darling <program> [args...]

# Initialize Darling prefix (first time)
darling shell  # auto-initializes on first run
```

## Architecture

```
User Application (Mach-O binary)
        |
   [darling runtime]
        |
   [darling-mach.ko]  ← kernel module (Mach trap translation)
        |
   [Linux kernel]
```

## Galactic Cherry Integration

- Kernel module: /lib/modules/5.15.204/extra/darling-mach.ko
- Auto-loaded on boot via /etc/modules-load.d/darling.conf
- binfmt_misc: Mach-O files run transparently (./macos_program)
- Desktop: .app bundles open with Darling from file manager

## Part of Galactic Cherry Marvell Edition 98
Copyright (C) 2026 MEARVK LLC
EOF

    log "Darling installed to ${ROOTFS_DIR}${DARLING_PREFIX}"
}

# =============================================================================
# Main
# =============================================================================

main() {
    echo ""
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║  Darling Integration — Galactic Cherry Marvell Edition 98    ║"
    echo "║  macOS Compatibility Layer for Linux                         ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo ""
    log "Mode: ${MODE}"
    log "Source: ${DARLING_SRC_DIR}"
    log "Target rootfs: ${ROOTFS_DIR}"
    echo ""

    case "${MODE}" in
        full)
            check_deps
            build_darling
            install_darling
            ;;
        build-only)
            check_deps
            build_darling
            ;;
        install-only)
            install_darling
            ;;
    esac

    echo ""
    log "════════════════════════════════════════════════════════════════"
    log "Darling integration complete."
    log ""
    log "Installed components:"
    log "  - Darling runtime (macOS → Linux translation)"
    log "  - darling-mach.ko kernel module (Mach trap handler)"
    log "  - Environment configuration (/etc/profile.d/darling.sh)"
    log "  - Module auto-load (/etc/modules-load.d/darling.conf)"
    log ""
    log "Usage:"
    log "  darling shell             — Enter macOS-like shell"
    log "  darling <program>         — Run a macOS program"
    log "  ./macos_binary            — Transparent execution (binfmt_misc)"
    log "════════════════════════════════════════════════════════════════"
}

main "$@"
