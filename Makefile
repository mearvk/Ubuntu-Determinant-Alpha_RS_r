# SPDX-License-Identifier: GPL-2.0
#
# Top-level Makefile for Ubuntu Determinant Alpha RS
# Galactic Cherry Marvell Edition 98
#
# Copyright (C) 2026 MEARVK LLC
# Author: Maximilian Eric Alexander Rupplin von Keffikon
#

SHELL := /bin/bash

# Edition
EDITION_NAME    := Galactic Cherry Marvell
EDITION_VERSION := 98
KERNEL_VER      := 5.15.204

# Paths
KERNEL_DIR    := kernels/linux-5.15.204/linux-5.15.204
USERLAND_DIR  := userland
X11_DIR       := $(USERLAND_DIR)/x11
TOOLS_DIR     := $(KERNEL_DIR)/tools
SCRIPTS_DIR   := scripts
ROOTFS_TAR    := $(USERLAND_DIR)/ubuntu-base-24.04.4-base-amd64.tar.gz
WINE_DIR      := $(USERLAND_DIR)/wine
WINE_VERSION  := 9.0
WINE_TAG      := wine-$(WINE_VERSION)
WINE_GIT_URL  := https://gitlab.winehq.org/wine/wine.git
DARLING_DIR   := $(USERLAND_DIR)/darling

# Build output
BUILD_DIR     := build
ROOTFS_DIR    := $(BUILD_DIR)/rootfs

# Warning/note display control
# By default, compiler warnings and notes are silenced.
# Run with WARNINGS=1 to display them:
#   make WARNINGS=1
#   make WARNINGS=1 x11
WARNINGS      ?= 0
ifeq ($(WARNINGS),0)
  WARN_CFLAGS   := -w
  WARN_REDIRECT := 2>&1 | grep -v "^.*warning:\|^.*note:\|^.*Warning:\|^In file included" || true
else
  WARN_CFLAGS   :=
  WARN_REDIRECT :=
endif
export WARN_CFLAGS

# Install prefix for userland builds (inside rootfs)
PREFIX        := /usr

.PHONY: all deps \
        kernel kernel-defconfig kernel-menuconfig kernel-modules kernel-install \
        asm asm-list asm-clean \
        userland x11 x11-install wallpapers wallpapers-install \
        tools tools-install tools-all tools-all-install \
        tools-drm tools-drm-install \
        tools-tandem-equals tools-tandem-equals-install \
        tools-palladium-grooves tools-palladium-grooves-install \
        tools-palladium-grooves-iv tools-palladium-grooves-iv-install \
        tools-rebate-certificates tools-rebate-certificates-install \
        tools-chkrootkit tools-chkrootkit-install \
        tools-rkhunter tools-rkhunter-install \
        wine wine-fetch wine-build wine-install wine-binary wine-clean wine-distclean \
        darling darling-build darling-install darling-clean \
        vault-rootkits \
        desktop rootfs rootfs-full initramfs grub iso \
        clean distclean help

all: asm kernel userland

# ==============================================================================
# Help
# ==============================================================================

help:
	@echo "╔══════════════════════════════════════════════════════════════╗"
	@echo "║  Ubuntu Determinant Alpha RS                                ║"
	@echo "║  $(EDITION_NAME) Edition $(EDITION_VERSION)               ║"
	@echo "║  Kernel $(KERNEL_VER)                                      ║"
	@echo "╚══════════════════════════════════════════════════════════════╝"
	@echo ""
	@echo "Build Targets:"
	@echo "  deps             - Install all host build dependencies (requires sudo)"
	@echo "  all              - Build asm + kernel + userland (incl. Wine + Darling)"
	@echo "  asm              - Compile x86_64 .S files (from linux base compressed)"
	@echo "  asm-list         - List all .S assembly sources by directory"
	@echo "  kernel           - Build Linux $(KERNEL_VER) with all extensions"
	@echo "  kernel-defconfig - Apply Galactic Cherry defconfig"
	@echo "  kernel-menuconfig- Interactive kernel configuration"
	@echo "  userland         - Build X11, wallpapers, Wine, Darling, and custom tools"
	@echo "  x11              - Build X.Org Server 21.1.24 and libraries"
	@echo "  wallpapers       - Prepare desktop wallpapers"
	@echo "  java             - Apply OpenJDK 28 source overlay (build with java-build)"
	@echo "  chromium         - Fetch Chromium browser source (~5-8 GB shallow clone)"
	@echo "  wine             - Shallow-clone and build Wine (Windows compatibility layer)"
	@echo "  wine-fetch       - Shallow-clone Wine repo only (--depth 1)"
	@echo "  wine-binary      - Install Wine from WineHQ APT repository"
	@echo "  darling          - Build Darling (macOS compatibility layer)"
	@echo "  darling-install  - Install Darling + Mach-O handlers into rootfs"
	@echo "  desktop          - Install MATE Desktop + LightDM (requires network)"
	@echo "  tools            - Build custom tools (sudo_gate, chat, nnet)"
	@echo "  tools-all        - Build all tools (incl. cronie, clamav, mysql, chkrootkit, rkhunter)"
	@echo "  jwstf-install    - Install Java Web Server (NitroWebExpress) into rootfs"
	@echo ""
	@echo "Assembly Targets:"
	@echo "  rootfs           - Extract Ubuntu Base rootfs"
	@echo "  rootfs-full      - Full system assembly (kernel + userland + tools)"
	@echo "  initramfs        - Generate boot initramfs image"
	@echo "  grub             - Generate GRUB bootloader config"
	@echo "  iso              - Generate bootable ISO (CD/USB install media)"
	@echo ""
	@echo "Clean:"
	@echo "  clean            - Clean build artifacts"
	@echo "  distclean        - Deep clean (kernel distclean)"
	@echo ""
	@echo "Full Build (from scratch):"
	@echo "  make kernel-defconfig && make all && make rootfs-full && make iso"
	@echo ""
	@echo "Kernel Extensions:"
	@echo "  EPMP, HPM, EPERM, USB_SWAP, USB_FAST_DMA,"
	@echo "  NEGAMANE, USER_KO, WHITE_ETHICS, CPUBOOST"
	@echo ""
	@echo "Security Tools:"
	@echo "  chkrootkit  - Rootkit detection (shell + C helpers)"
	@echo "  rkhunter    - Rootkit Hunter (shell-based scanner)"
	@echo ""
	@echo "Prerequisites:"
	@echo "  kernel  - gcc, make, flex, bison, libelf-dev, bc, libssl-dev"
	@echo "  x11     - meson, ninja, pkg-config, gcc"
	@echo "  cronie  - autoconf, automake, libtool"
	@echo "  clamav  - cmake, rustc, cargo, libssl-dev, libjson-c-dev"
	@echo "  mysql   - cmake, g++, libssl-dev, libncurses-dev"
	@echo "  rootfs  - fakeroot, cpio, gzip"
	@echo "  iso     - xorriso, squashfs-tools, grub-pc-bin, grub-efi-amd64-bin, mtools"
	@echo "  wine    - git, libfreetype-dev, libfontconfig-dev, libvulkan-dev, mingw-w64"
	@echo "  darling - cmake, clang, libfuse-dev, libbsd-dev, linux-headers"
	@echo ""
	@echo "Options:"
	@echo "  WARNINGS=1       - Show compiler warnings and notes (silent by default)"
	@echo "                     Example: make WARNINGS=1 x11"

# ==============================================================================
# Build Dependencies (install host packages)
# ==============================================================================

deps:
	@echo "Installing build dependencies..."
	sudo apt-get update
	sudo apt-get install -y \
		gcc g++ make flex bison libelf-dev bc libssl-dev \
		meson ninja-build pkg-config \
		libxfont-dev libxcvt-dev libseat-dev libdbus-1-dev libudev-dev \
		libsystemd-dev libgbm-dev libdrm-dev libepoxy-dev \
		libxkbcommon-dev libxkbcommon-x11-dev xkb-data \
		libpixman-1-dev libpciaccess-dev libgl-dev \
		nettle-dev libgcrypt20-dev libselinux1-dev libaudit-dev \
		mesa-common-dev libgles2-mesa-dev \
		libxau-dev libxdmcp-dev libxcb1-dev libx11-dev libxext-dev \
		libxrender-dev libxrandr-dev libxi-dev libxtst-dev \
		libxinerama-dev libxcomposite-dev libxdamage-dev libxfixes-dev \
		libxcursor-dev libxss-dev libxxf86vm-dev \
		libxmu-dev libxt-dev libsm-dev libice-dev \
		xmlto xsltproc fop \
		autoconf automake libtool \
		cmake rustc cargo libjson-c-dev libncurses-dev \
		fakeroot cpio gzip \
		xorriso squashfs-tools grub-pc-bin grub-efi-amd64-bin mtools \
		python3 python3-pip \
		libfreetype-dev libfontconfig-dev libgstreamer1.0-dev \
		libvulkan-dev libsdl2-dev libpulse-dev libasound2-dev \
		libcups2-dev libgnutls28-dev libusb-1.0-0-dev libunwind-dev \
		libgphoto2-dev liblcms2-dev libldap2-dev libsane-dev libpcap-dev \
		mingw-w64 gettext
	@echo "Build dependencies installed."

# ==============================================================================
# Kernel
# ==============================================================================

kernel:
	$(MAKE) -C $(KERNEL_DIR) -j$$(nproc)

kernel-defconfig:
	$(MAKE) -C $(KERNEL_DIR) galactic_cherry_defconfig

kernel-menuconfig:
	$(MAKE) -C $(KERNEL_DIR) menuconfig

kernel-modules:
	$(MAKE) -C $(KERNEL_DIR) modules -j$$(nproc)

kernel-install: kernel
	$(MAKE) -C $(KERNEL_DIR) modules_install INSTALL_MOD_PATH=$(abspath $(ROOTFS_DIR))
	@mkdir -p $(ROOTFS_DIR)/boot
	cp $(KERNEL_DIR)/arch/x86/boot/bzImage $(ROOTFS_DIR)/boot/vmlinuz-$(KERNEL_VER)
	cp $(KERNEL_DIR)/System.map $(ROOTFS_DIR)/boot/System.map-$(KERNEL_VER)
	@echo "Kernel and modules installed to $(ROOTFS_DIR)"

# ==============================================================================
# Assembly (.S) Global Compile — from linux base compressed source
# ==============================================================================
#
# Compiles all x86_64 architecture .S files from the linux-5.15.204 kernel
# source (extracted from the base compressed archive). These provide:
#   - Boot entry points (head_64.S, head_32.S)
#   - Interrupt/syscall trampolines (entry_64.S, entry_64_compat.S)
#   - Context switching (process_64.S)
#   - Cryptographic acceleration (AES-NI, SHA, GHASH, etc.)
#   - Low-level memory/string operations (memcpy, memset, copy_user)
#   - FPU/SSE/AVX state handling
#   - Power management (hibernate, wakeup)
#   - Boot decompression (arch/x86/boot/compressed/)
#
# The kernel build system (kbuild) compiles these automatically during
# 'make kernel'. This target provides a standalone assembly pass for
# verification and object inspection.

# Assembler flags matching kernel build
KERNEL_AS      := gcc
KERNEL_ASFLAGS := -c -m64 -D__ASSEMBLY__ -D__KERNEL__ \
                  -I$(KERNEL_DIR)/include \
                  -I$(KERNEL_DIR)/include/generated \
                  -I$(KERNEL_DIR)/arch/x86/include \
                  -I$(KERNEL_DIR)/arch/x86/include/generated \
                  -I$(KERNEL_DIR)/arch/x86/include/uapi \
                  -I$(KERNEL_DIR)/include/uapi \
                  -nostdinc -isystem $(shell gcc -print-file-name=include)

# Assembly source directories (x86_64 architecture)
ASM_DIRS := $(KERNEL_DIR)/arch/x86/kernel \
            $(KERNEL_DIR)/arch/x86/entry \
            $(KERNEL_DIR)/arch/x86/lib \
            $(KERNEL_DIR)/arch/x86/crypto \
            $(KERNEL_DIR)/arch/x86/mm \
            $(KERNEL_DIR)/arch/x86/power \
            $(KERNEL_DIR)/arch/x86/boot/compressed \
            $(KERNEL_DIR)/arch/x86/platform \
            $(KERNEL_DIR)/arch/x86/realmode

# Collect all .S files
ASM_SRCS := $(foreach dir,$(ASM_DIRS),$(wildcard $(dir)/*.S))
ASM_OBJS := $(ASM_SRCS:.S=.o)

# Build directory for standalone assembly objects
ASM_BUILD_DIR := $(BUILD_DIR)/asm-objs

.PHONY: asm asm-list asm-clean

asm:
	@echo "=== Global Assembly Compile (x86_64 .S files from linux base) ==="
	@echo "  Source: $(KERNEL_DIR) (linux-$(KERNEL_VER) base compressed)"
	@echo "  Architecture: x86_64"
	@mkdir -p $(ASM_BUILD_DIR)
	@count=0; total=$$(find $(ASM_DIRS) -maxdepth 1 -name "*.S" 2>/dev/null | wc -l); \
	for src in $$(find $(ASM_DIRS) -maxdepth 1 -name "*.S" 2>/dev/null | sort); do \
		obj="$(ASM_BUILD_DIR)/$$(basename $${src%.S}.o)"; \
		count=$$((count + 1)); \
		printf "  [%3d/%3d] Assembling %s\n" "$$count" "$$total" "$$(basename $$src)"; \
		$(KERNEL_AS) $(KERNEL_ASFLAGS) -o "$$obj" "$$src" 2>/dev/null || \
			printf "           ⚠ skipped (missing generated headers)\n"; \
	done
	@echo ""
	@echo "  ✓ Assembly objects: $(ASM_BUILD_DIR)/"
	@echo "  ✓ Files compiled: $$(ls $(ASM_BUILD_DIR)/*.o 2>/dev/null | wc -l)"

asm-list:
	@echo "=== x86_64 Assembly Sources (.S) ==="
	@for dir in $(ASM_DIRS); do \
		files=$$(find $$dir -maxdepth 1 -name "*.S" 2>/dev/null | wc -l); \
		if [ "$$files" -gt 0 ]; then \
			echo "  $${dir#$(KERNEL_DIR)/} ($$files files)"; \
		fi; \
	done
	@echo ""
	@echo "  Total: $$(find $(ASM_DIRS) -maxdepth 1 -name '*.S' 2>/dev/null | wc -l) assembly files"

asm-clean:
	rm -rf $(ASM_BUILD_DIR)

# ==============================================================================
# Userland (all user-space components)
# ==============================================================================

userland: x11 wallpapers java wine darling tools

# ==============================================================================
# X11 Display System
# ==============================================================================

x11:
	$(MAKE) -C $(X11_DIR)

x11-install:
	$(MAKE) -C $(X11_DIR) install DESTDIR=$(abspath $(ROOTFS_DIR))

# ==============================================================================
# Desktop Wallpapers
# ==============================================================================

wallpapers:
	$(MAKE) -C $(USERLAND_DIR)/wallpapers

wallpapers-install:
	$(MAKE) -C $(USERLAND_DIR)/wallpapers install DESTDIR=$(abspath $(ROOTFS_DIR))

# ==============================================================================
# OpenJDK 28 (fetched at build time, ~227 MB)
# ==============================================================================

java:
	$(MAKE) -C $(USERLAND_DIR)/java overlay

java-build:
	$(MAKE) -C $(USERLAND_DIR)/java build-from-source

java-install:
	$(MAKE) -C $(USERLAND_DIR)/java overlay
	$(MAKE) -C $(USERLAND_DIR)/java build-from-source
	$(MAKE) -C $(USERLAND_DIR)/java install-from-source DESTDIR=$(abspath $(ROOTFS_DIR))

java-install-from-source:
	$(MAKE) -C $(USERLAND_DIR)/java overlay
	$(MAKE) -C $(USERLAND_DIR)/java build-from-source
	$(MAKE) -C $(USERLAND_DIR)/java install-from-source DESTDIR=$(abspath $(ROOTFS_DIR))

# ==============================================================================
# Chromium Browser (fetched at build time, ~5-8 GB shallow clone)
# ==============================================================================

chromium:
	$(MAKE) -C $(USERLAND_DIR)/chromium fetch

chromium-build:
	$(MAKE) -C $(USERLAND_DIR)/chromium build

chromium-install:
	$(MAKE) -C $(USERLAND_DIR)/chromium install DESTDIR=$(abspath $(ROOTFS_DIR))

# ==============================================================================
# Wine (Windows Compatibility Layer)
# ==============================================================================
#
# Wine allows running Windows applications on Linux. Uses a shallow git clone
# of the official WineHQ repository for minimal disk usage while keeping full
# compilability.
#
# Targets:
#   wine-fetch   — Shallow clone Wine repo (--depth 1, single tag)
#   wine-build   — Configure and compile Wine 64-bit (+ WoW64 if multiarch)
#   wine         — Full clone + build
#   wine-install — Install compiled Wine into rootfs
#   wine-binary  — Install prebuilt Wine from WineHQ APT (requires network)
#
# Configuration:
#   WINE_VERSION=9.0                       (override version)
#   WINE_TAG=wine-9.0                      (override git tag)
#   WINE_GIT_URL=https://gitlab.winehq.org/wine/wine.git

wine: wine-fetch wine-build

wine-fetch:
	@echo "=== Shallow-cloning Wine (tag: $(WINE_TAG)) ==="
	@if [ -d "$(WINE_DIR)/.git" ]; then \
		echo "  Wine repo already exists at $(WINE_DIR)"; \
		echo "  Current tag: $$(cd $(WINE_DIR) && git describe --tags --exact-match 2>/dev/null || echo 'detached')"; \
	else \
		echo "  Cloning $(WINE_GIT_URL) (depth=1, tag=$(WINE_TAG))..."; \
		git clone --depth 1 --branch "$(WINE_TAG)" --single-branch \
			"$(WINE_GIT_URL)" "$(WINE_DIR)"; \
		echo "  ✓ Wine source: $(WINE_DIR) ($$(du -sh $(WINE_DIR) | cut -f1))"; \
	fi
	@# Verify configure script exists (compilability check)
	@if [ ! -f "$(WINE_DIR)/configure" ]; then \
		echo "  ERROR: configure not found in cloned source"; exit 1; \
	fi
	@echo "  ✓ Wine source ready (configure present)"

wine-build:
	@echo "=== Building Wine $(WINE_VERSION) (64-bit) ==="
	@if [ ! -f "$(WINE_DIR)/configure" ]; then \
		echo "  ERROR: Wine source not found. Run 'make wine-fetch' first."; exit 1; \
	fi
	@mkdir -p $(WINE_DIR)/build64
	cd $(WINE_DIR)/build64 && \
		../configure \
			--prefix=/usr/local \
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
			--with-fontconfig \
			--with-freetype \
			--with-pcap \
			--with-unwind \
			--with-mingw && \
		$(MAKE) -j$$(nproc)
	@echo "  ✓ Wine 64-bit build complete"

wine-install:
	@echo "=== Installing Wine to $(ROOTFS_DIR) ==="
	@if [ ! -d "$(WINE_DIR)/build64" ] || [ ! -f "$(WINE_DIR)/build64/Makefile" ]; then \
		echo "  ERROR: Wine not built. Run 'make wine' first."; exit 1; \
	fi
	@$(MAKE) -C $(WINE_DIR)/build64 install DESTDIR=$(abspath $(ROOTFS_DIR))
	@# Install native .exe handlers (desktop + CLI binfmt_misc)
	@bash $(SCRIPTS_DIR)/install-wine-handlers.sh "$(ROOTFS_DIR)"
	@# Install environment and desktop integration
	@install -d $(ROOTFS_DIR)/etc/profile.d
	@cat > $(ROOTFS_DIR)/etc/profile.d/wine.sh <<'WINEPROFILE'
# Wine environment — Galactic Cherry Marvell Edition 98
export WINEARCH="$${WINEARCH:-win64}"
export WINEPREFIX="$${WINEPREFIX:-$$HOME/.wine}"
export WINEDLLOVERRIDES="winemenubuilder.exe=d"
WINEPROFILE
	@echo "  ✓ Wine installed to $(ROOTFS_DIR)/usr/local"
	@echo "  ✓ Native .exe handlers active (desktop + CLI)"

wine-binary:
	@echo "=== Installing Wine from WineHQ binary repository ==="
	@if [ ! -d "$(ROOTFS_DIR)/usr" ]; then \
		echo "  ERROR: rootfs not found. Run 'make rootfs' first."; exit 1; \
	fi
	@bash $(SCRIPTS_DIR)/install-wine.sh "$(ROOTFS_DIR)" --binary
	@echo "  ✓ Wine binary install complete (or staged for first boot)"

wine-clean:
	@echo "=== Cleaning Wine build ==="
	@rm -rf $(WINE_DIR)/build64 $(WINE_DIR)/build32
	@echo "  ✓ Wine build directories removed"

wine-distclean:
	@echo "=== Removing Wine source (shallow clone) ==="
	@rm -rf $(WINE_DIR)
	@echo "  ✓ Wine source removed"

# ==============================================================================
# Darling (macOS Compatibility Layer)
# ==============================================================================
#
# Darling translates Darwin/macOS API calls to Linux, allowing Mach-O
# binaries to run natively. Uses a kernel module (darling-mach) for
# Mach system call translation.
#
# Targets:
#   darling         — Build Darling from source (CMake)
#   darling-install — Install Darling + native Mach-O handlers into rootfs
#   darling-clean   — Remove build directory
#
# Source is pre-committed at userland/darling/ (shallow clone from GitHub).

darling: darling-build

darling-build:
	@echo "=== Building Darling (macOS compatibility layer) ==="
	@if [ ! -f "$(DARLING_DIR)/CMakeLists.txt" ]; then \
		echo "  ERROR: Darling source not found at $(DARLING_DIR)"; exit 1; \
	fi
	@mkdir -p $(DARLING_DIR)/build
	cd $(DARLING_DIR)/build && \
		cmake .. \
			-DCMAKE_INSTALL_PREFIX=/usr/local \
			-DCMAKE_BUILD_TYPE=Release \
			-DTARGET_i386=OFF \
			-DENABLE_TESTS=OFF && \
		$(MAKE) -j$$(nproc)
	@echo "  ✓ Darling build complete"

darling-install:
	@echo "=== Installing Darling to $(ROOTFS_DIR) ==="
	@if [ ! -d "$(DARLING_DIR)/build" ]; then \
		echo "  ERROR: Darling not built. Run 'make darling' first."; exit 1; \
	fi
	@if [ -f "$(DARLING_DIR)/build/Makefile" ]; then \
		$(MAKE) -C $(DARLING_DIR)/build install DESTDIR=$(abspath $(ROOTFS_DIR)) 2>/dev/null || true; \
	fi
	@# Run the installer script for configuration
	@bash $(SCRIPTS_DIR)/install-darling.sh "$(ROOTFS_DIR)" --install-only
	@# Install native Mach-O handlers (desktop + CLI binfmt_misc)
	@bash $(SCRIPTS_DIR)/install-darling-handlers.sh "$(ROOTFS_DIR)"
	@echo "  ✓ Darling installed to $(ROOTFS_DIR)/usr/local"
	@echo "  ✓ Native Mach-O handlers active (desktop + CLI)"

darling-clean:
	@echo "=== Cleaning Darling build ==="
	@rm -rf $(DARLING_DIR)/build
	@echo "  ✓ Darling build directory removed"

# ==============================================================================
# Negamane Vault — Rootkit Study Material
# ==============================================================================
#
# Disassembles rootkit detection signatures from chkrootkit and rkhunter
# into a negamane-branded immutable vault. The material is:
#   - Fragmented into 3 non-functional parts each
#   - Branded immutable (cannot be modified)
#   - Cannot be quickly installed (no reassembly script provided)
#   - Requires sudo_gate level 7 + negamane passphrase to access
#
# Rootkits vaulted: Reptile, BPFDoor, Symbiote, Lightning, Orbit,
#   FontOnLake, RotaJakiro, Pandora, Melofee, Kinsing, Perfctl, Bootkitty

vault-rootkits:
	@echo "=== Securing rootkit study material in negamane vault ==="
	@bash $(SCRIPTS_DIR)/vault-rootkit-references.sh "$(ROOTFS_DIR)"
	@echo "  ✓ Rootkit references disassembled and vaulted"
	@echo "  ✓ Quick install: BLOCKED"
	@echo "  ✓ Negamane brand: IMMUTABLE"

# ==============================================================================
# Custom Tools - Core (simple Makefile-based)
# ==============================================================================

tools:
	@echo "=== Building core custom tools ==="
	@if [ -d "$(TOOLS_DIR)/sudo_gate" ]; then \
		echo "  Building sudo_gate..."; $(MAKE) -C $(TOOLS_DIR)/sudo_gate; fi
	@if [ -d "$(TOOLS_DIR)/chat" ]; then \
		echo "  Building chat..."; $(MAKE) -C $(TOOLS_DIR)/chat; fi
	@if [ -d "$(TOOLS_DIR)/nnet" ]; then \
		echo "  Building nnet..."; $(MAKE) -C $(TOOLS_DIR)/nnet; fi
	@if [ -d "$(TOOLS_DIR)/negamane" ]; then \
		echo "  Building negamane..."; $(MAKE) -C $(TOOLS_DIR)/negamane; fi
	@if [ -d "$(TOOLS_DIR)/accounts" ]; then \
		echo "  Building accounts..."; $(MAKE) -C $(TOOLS_DIR)/accounts; fi

tools-install:
	@echo "=== Installing core tools to rootfs ==="
	@if [ -d "$(TOOLS_DIR)/sudo_gate" ]; then \
		$(MAKE) -C $(TOOLS_DIR)/sudo_gate install DESTDIR=$(abspath $(ROOTFS_DIR)); fi
	@if [ -d "$(TOOLS_DIR)/chat" ]; then \
		$(MAKE) -C $(TOOLS_DIR)/chat install DESTDIR=$(abspath $(ROOTFS_DIR)); fi
	@if [ -d "$(TOOLS_DIR)/nnet" ]; then \
		$(MAKE) -C $(TOOLS_DIR)/nnet install DESTDIR=$(abspath $(ROOTFS_DIR)); fi
	@if [ -d "$(TOOLS_DIR)/negamane" ]; then \
		$(MAKE) -C $(TOOLS_DIR)/negamane install DESTDIR=$(abspath $(ROOTFS_DIR)); fi
	@if [ -d "$(TOOLS_DIR)/accounts" ]; then \
		$(MAKE) -C $(TOOLS_DIR)/accounts install DESTDIR=$(abspath $(ROOTFS_DIR)); fi

# ==============================================================================
# Tools - Extended (autotools/cmake-based, longer builds)
# ==============================================================================

tools-all: tools tools-drm tools-tandem-equals tools-palladium-grooves tools-palladium-grooves-iv tools-rebate-certificates tools-cronie tools-clamav tools-mysql tools-ai tools-chkrootkit tools-rkhunter

# DRM (Deferred Remove) - undo-capable file deletion
tools-drm:
	@echo "=== Building DRM (Deferred Remove) ==="
	@if [ -d "$(TOOLS_DIR)/drm" ] && [ -f "$(TOOLS_DIR)/drm/Makefile" ]; then \
		$(MAKE) -C $(TOOLS_DIR)/drm; \
	fi

tools-drm-install:
	@echo "=== Installing DRM ==="
	@if [ -d "$(TOOLS_DIR)/drm" ] && [ -f "$(TOOLS_DIR)/drm/drm" ]; then \
		install -d $(ROOTFS_DIR)/usr/local/bin; \
		install -m 755 $(TOOLS_DIR)/drm/drm $(ROOTFS_DIR)/usr/local/bin/; \
		echo "  ✓ drm installed to /usr/local/bin/"; \
	fi

# TandemEquals - Outward dilemma resolution via saimptom matrix
tools-tandem-equals:
	@echo "=== Building TandemEquals ==="
	@if [ -d "$(TOOLS_DIR)/tandem_equals" ] && [ -f "$(TOOLS_DIR)/tandem_equals/Makefile" ]; then \
		$(MAKE) -C $(TOOLS_DIR)/tandem_equals; \
	fi

tools-tandem-equals-install:
	@echo "=== Installing TandemEquals ==="
	@if [ -d "$(TOOLS_DIR)/tandem_equals" ] && [ -f "$(TOOLS_DIR)/tandem_equals/tandem_equals" ]; then \
		install -d $(ROOTFS_DIR)/usr/local/bin; \
		install -m 755 $(TOOLS_DIR)/tandem_equals/tandem_equals $(ROOTFS_DIR)/usr/local/bin/; \
		echo "  ✓ tandem_equals installed to /usr/local/bin/"; \
	fi

# PalladiumGrooves III - Social characterizability scoring in Pi ratio
tools-palladium-grooves:
	@echo "=== Building PalladiumGrooves III ==="
	@if [ -d "$(TOOLS_DIR)/palladium_grooves" ] && [ -f "$(TOOLS_DIR)/palladium_grooves/Makefile" ]; then \
		$(MAKE) -C $(TOOLS_DIR)/palladium_grooves; \
	fi

tools-palladium-grooves-install:
	@echo "=== Installing PalladiumGrooves III ==="
	@if [ -d "$(TOOLS_DIR)/palladium_grooves" ] && [ -f "$(TOOLS_DIR)/palladium_grooves/palladium_grooves" ]; then \
		install -d $(ROOTFS_DIR)/usr/local/bin; \
		install -m 755 $(TOOLS_DIR)/palladium_grooves/palladium_grooves $(ROOTFS_DIR)/usr/local/bin/; \
		echo "  ✓ palladium_grooves installed to /usr/local/bin/"; \
	fi

# PalladiumGrooves IV - Mill Matter: INT advantages and replacement of similars
tools-palladium-grooves-iv:
	@echo "=== Building PalladiumGrooves IV ==="
	@if [ -d "$(TOOLS_DIR)/palladium_grooves_iv" ] && [ -f "$(TOOLS_DIR)/palladium_grooves_iv/Makefile" ]; then \
		$(MAKE) -C $(TOOLS_DIR)/palladium_grooves_iv; \
	fi

tools-palladium-grooves-iv-install:
	@echo "=== Installing PalladiumGrooves IV ==="
	@if [ -d "$(TOOLS_DIR)/palladium_grooves_iv" ] && [ -f "$(TOOLS_DIR)/palladium_grooves_iv/palladium_grooves_iv" ]; then \
		install -d $(ROOTFS_DIR)/usr/local/bin; \
		install -m 755 $(TOOLS_DIR)/palladium_grooves_iv/palladium_grooves_iv $(ROOTFS_DIR)/usr/local/bin/; \
		echo "  ✓ palladium_grooves_iv installed to /usr/local/bin/"; \
	fi

# RebateCertificates VIII - Longs as unnecessaries, moral equations, Save Me
tools-rebate-certificates:
	@echo "=== Building RebateCertificates VIII ==="
	@if [ -d "$(TOOLS_DIR)/rebate_certificates" ] && [ -f "$(TOOLS_DIR)/rebate_certificates/Makefile" ]; then \
		$(MAKE) -C $(TOOLS_DIR)/rebate_certificates; \
	fi

tools-rebate-certificates-install:
	@echo "=== Installing RebateCertificates VIII ==="
	@if [ -d "$(TOOLS_DIR)/rebate_certificates" ] && [ -f "$(TOOLS_DIR)/rebate_certificates/rebate_certificates" ]; then \
		install -d $(ROOTFS_DIR)/usr/local/bin; \
		install -m 755 $(TOOLS_DIR)/rebate_certificates/rebate_certificates $(ROOTFS_DIR)/usr/local/bin/; \
		echo "  ✓ rebate_certificates installed to /usr/local/bin/"; \
	fi

# Cronie (cron with callback extension) - autotools
tools-cronie:
	@echo "=== Building cronie ==="
	@if [ -d "$(TOOLS_DIR)/cronie" ] && [ -f "$(TOOLS_DIR)/cronie/configure.ac" ]; then \
		cd $(TOOLS_DIR)/cronie && \
		if [ ! -f configure ]; then ./autogen.sh; fi && \
		if [ ! -f Makefile ]; then ./configure --prefix=/usr --sysconfdir=/etc; fi && \
		$(MAKE) -j$$(nproc); \
	fi

tools-cronie-install:
	@if [ -d "$(TOOLS_DIR)/cronie" ] && [ -f "$(TOOLS_DIR)/cronie/Makefile" ]; then \
		$(MAKE) -C $(TOOLS_DIR)/cronie install DESTDIR=$(abspath $(ROOTFS_DIR)); fi

# ClamAV (antivirus) - cmake
tools-clamav:
	@echo "=== Building ClamAV ==="
	@if [ -d "$(TOOLS_DIR)/clamav" ] && [ -f "$(TOOLS_DIR)/clamav/CMakeLists.txt" ]; then \
		mkdir -p $(TOOLS_DIR)/clamav/build && \
		cd $(TOOLS_DIR)/clamav/build && \
		cmake .. -DCMAKE_INSTALL_PREFIX=/usr \
			-DENABLE_MILTER=OFF -DENABLE_EXAMPLES=OFF \
			-DENABLE_STATIC_LIB=OFF -DENABLE_SYSTEMD=ON && \
		$(MAKE) -j$$(nproc); \
	fi

tools-clamav-install:
	@if [ -d "$(TOOLS_DIR)/clamav/build" ]; then \
		$(MAKE) -C $(TOOLS_DIR)/clamav/build install DESTDIR=$(abspath $(ROOTFS_DIR)); fi
	@if [ -f "$(TOOLS_DIR)/clamav/install_clamav.sh" ]; then \
		echo "  (Run install_clamav.sh in chroot for service setup)"; fi

# MySQL (database + package registry) - cmake
tools-mysql:
	@echo "=== Building MySQL ==="
	@if [ -d "$(TOOLS_DIR)/mysql" ] && [ -f "$(TOOLS_DIR)/mysql/CMakeLists.txt" ]; then \
		mkdir -p $(TOOLS_DIR)/mysql/build && \
		cd $(TOOLS_DIR)/mysql/build && \
		cmake .. -DCMAKE_INSTALL_PREFIX=/usr \
			-DMYSQL_DATADIR=/var/lib/mysql \
			-DSYSCONFDIR=/etc/mysql \
			-DWITH_BOOST=$(TOOLS_DIR)/mysql/boost \
			-DDOWNLOAD_BOOST=0 \
			-DWITH_UNIT_TESTS=OFF && \
		$(MAKE) -j$$(nproc); \
	fi

tools-mysql-install:
	@if [ -d "$(TOOLS_DIR)/mysql/build" ]; then \
		$(MAKE) -C $(TOOLS_DIR)/mysql/build install DESTDIR=$(abspath $(ROOTFS_DIR)); fi
	@if [ -f "$(TOOLS_DIR)/mysql/install_mysql.sh" ]; then \
		install -m 755 $(TOOLS_DIR)/mysql/install_mysql.sh $(ROOTFS_DIR)/usr/sbin/; fi
	@if [ -f "$(TOOLS_DIR)/mysql/pkg-info" ]; then \
		install -m 755 $(TOOLS_DIR)/mysql/pkg-info $(ROOTFS_DIR)/usr/bin/; fi
	@if [ -f "$(TOOLS_DIR)/mysql/apt_mysql_hook.sh" ]; then \
		install -d $(ROOTFS_DIR)/etc/apt/apt.conf.d && \
		install -m 755 $(TOOLS_DIR)/mysql/apt_mysql_hook.sh $(ROOTFS_DIR)/usr/lib/apt/; fi
	@if [ -f "$(TOOLS_DIR)/mysql/file_integrity_schema.sql" ]; then \
		install -d $(ROOTFS_DIR)/usr/share/file-integrity && \
		install -m 644 $(TOOLS_DIR)/mysql/file_integrity_schema.sql $(ROOTFS_DIR)/usr/share/file-integrity/; fi
	@if [ -f "$(TOOLS_DIR)/mysql/integrity-baseline" ]; then \
		install -m 755 $(TOOLS_DIR)/mysql/integrity-baseline $(ROOTFS_DIR)/usr/local/sbin/; fi
	@if [ -f "$(TOOLS_DIR)/mysql/integrity-check" ]; then \
		install -m 755 $(TOOLS_DIR)/mysql/integrity-check $(ROOTFS_DIR)/usr/local/bin/; fi
	@install -d -m 700 $(ROOTFS_DIR)/etc/integrity

# Dave (AI system intelligence) - llama.cpp based
tools-ai:
	@echo "=== Building Dave (System Intelligence) ==="
	@if [ -d "$(TOOLS_DIR)/ai/llama.cpp" ] && [ -f "$(TOOLS_DIR)/ai/llama.cpp/Makefile" ]; then \
		$(MAKE) -C $(TOOLS_DIR)/ai/llama.cpp -j$$(nproc); \
	elif [ -d "$(TOOLS_DIR)/ai/llama.cpp" ] && [ -f "$(TOOLS_DIR)/ai/llama.cpp/CMakeLists.txt" ]; then \
		mkdir -p $(TOOLS_DIR)/ai/llama.cpp/build && \
		cd $(TOOLS_DIR)/ai/llama.cpp/build && \
		cmake .. -DCMAKE_INSTALL_PREFIX=/usr && \
		$(MAKE) -j$$(nproc); \
	else \
		echo "  (llama.cpp not found or no build system - skipping)"; \
	fi

tools-ai-install:
	@echo "=== Installing Dave ==="
	@install -d $(ROOTFS_DIR)/usr/lib/dave
	@install -d $(ROOTFS_DIR)/usr/lib/dave/library
	@if [ -d "$(TOOLS_DIR)/ai/llama.cpp/build" ]; then \
		$(MAKE) -C $(TOOLS_DIR)/ai/llama.cpp/build install DESTDIR=$(abspath $(ROOTFS_DIR)) 2>/dev/null || true; fi
	@if [ -f "$(TOOLS_DIR)/ai/install_kernel_ai.sh" ]; then \
		install -m 755 $(TOOLS_DIR)/ai/install_kernel_ai.sh $(ROOTFS_DIR)/usr/sbin/; fi
	@if [ -f "$(TOOLS_DIR)/ai/dave_capabilities.json" ]; then \
		install -m 644 $(TOOLS_DIR)/ai/dave_capabilities.json $(ROOTFS_DIR)/usr/lib/dave/; fi
	@if [ -f "$(TOOLS_DIR)/ai/dave_external_awareness.json" ]; then \
		install -m 644 $(TOOLS_DIR)/ai/dave_external_awareness.json $(ROOTFS_DIR)/usr/lib/dave/; fi
	@if [ -f "$(TOOLS_DIR)/ai/dave_schema.sql" ]; then \
		install -m 644 $(TOOLS_DIR)/ai/dave_schema.sql $(ROOTFS_DIR)/usr/lib/dave/; fi
	@for lib in $(TOOLS_DIR)/ai/library/*.lib; do \
		[ -f "$$lib" ] && install -m 644 "$$lib" $(ROOTFS_DIR)/usr/lib/dave/library/; \
	done
	@echo "  Dave installed ($(shell ls $(TOOLS_DIR)/ai/library/*.lib 2>/dev/null | wc -l) library books)"

# chkrootkit (rootkit detection) - simple C compilation
tools-chkrootkit:
	@echo "=== Building chkrootkit ==="
	@if [ -d "$(TOOLS_DIR)/chkrootkit" ] && [ -f "$(TOOLS_DIR)/chkrootkit/Makefile" ]; then \
		$(MAKE) -C $(TOOLS_DIR)/chkrootkit sense; \
	fi

tools-chkrootkit-install:
	@echo "=== Installing chkrootkit ==="
	@if [ -d "$(TOOLS_DIR)/chkrootkit" ]; then \
		install -d $(ROOTFS_DIR)/usr/local/sbin; \
		install -d $(ROOTFS_DIR)/usr/local/lib/chkrootkit; \
		install -m 755 $(TOOLS_DIR)/chkrootkit/chkrootkit $(ROOTFS_DIR)/usr/local/sbin/; \
		for bin in chklastlog chkwtmp ifpromisc chkproc chkdirs check_wtmpx strings-static chkutmp; do \
			if [ -f "$(TOOLS_DIR)/chkrootkit/$$bin" ]; then \
				install -m 755 "$(TOOLS_DIR)/chkrootkit/$$bin" $(ROOTFS_DIR)/usr/local/lib/chkrootkit/; \
			fi; \
		done; \
		echo "  ✓ chkrootkit installed to /usr/local/sbin/"; \
	fi

# rkhunter (Rootkit Hunter) - shell-based, uses installer.sh
tools-rkhunter:
	@echo "=== Preparing rkhunter (no compilation needed) ==="
	@if [ -d "$(TOOLS_DIR)/rkhunter" ] && [ -f "$(TOOLS_DIR)/rkhunter/installer.sh" ]; then \
		echo "  rkhunter $(shell grep '^APPVERSION=' $(TOOLS_DIR)/rkhunter/installer.sh 2>/dev/null | cut -d'"' -f2) ready for install"; \
	fi

tools-rkhunter-install:
	@echo "=== Installing rkhunter ==="
	@if [ -d "$(TOOLS_DIR)/rkhunter" ] && [ -f "$(TOOLS_DIR)/rkhunter/installer.sh" ]; then \
		install -d $(ROOTFS_DIR)/usr/local/bin; \
		install -d $(ROOTFS_DIR)/usr/local/lib/rkhunter; \
		install -d $(ROOTFS_DIR)/usr/local/lib/rkhunter/scripts; \
		install -d $(ROOTFS_DIR)/usr/local/share/man/man8; \
		install -d $(ROOTFS_DIR)/etc/rkhunter; \
		install -d $(ROOTFS_DIR)/var/lib/rkhunter/db; \
		install -d $(ROOTFS_DIR)/var/lib/rkhunter/tmp; \
		install -m 755 $(TOOLS_DIR)/rkhunter/files/rkhunter $(ROOTFS_DIR)/usr/local/bin/; \
		install -m 644 $(TOOLS_DIR)/rkhunter/files/rkhunter.conf $(ROOTFS_DIR)/etc/rkhunter/; \
		install -m 644 $(TOOLS_DIR)/rkhunter/files/rkhunter.8 $(ROOTFS_DIR)/usr/local/share/man/man8/ 2>/dev/null || true; \
		for dat in backdoorports.dat mirrors.dat programs_bad.dat suspscan.dat; do \
			if [ -f "$(TOOLS_DIR)/rkhunter/files/$$dat" ]; then \
				install -m 644 "$(TOOLS_DIR)/rkhunter/files/$$dat" $(ROOTFS_DIR)/var/lib/rkhunter/db/; \
			fi; \
		done; \
		for script in $(TOOLS_DIR)/rkhunter/files/*.pl $(TOOLS_DIR)/rkhunter/files/*.sh; do \
			if [ -f "$$script" ]; then \
				install -m 755 "$$script" $(ROOTFS_DIR)/usr/local/lib/rkhunter/scripts/; \
			fi; \
		done; \
		echo "  ✓ rkhunter installed to /usr/local/bin/"; \
	fi

# Full tools install (all)
tools-all-install: tools-install tools-drm-install tools-tandem-equals-install tools-palladium-grooves-install tools-palladium-grooves-iv-install tools-rebate-certificates-install tools-cronie-install tools-clamav-install tools-mysql-install tools-ai-install tools-chkrootkit-install tools-rkhunter-install

# ==============================================================================
# Desktop Environment (MATE + LightDM + Red Cherry Theme)
# ==============================================================================

desktop:
	@echo "=== Installing MATE Desktop ==="
	@if [ ! -d "$(ROOTFS_DIR)/usr" ]; then \
		echo "  ERROR: rootfs not found. Run 'make rootfs' first."; exit 1; \
	fi
	@# Stage the install script for use during first boot or manual chroot
	@install -d $(ROOTFS_DIR)/tmp
	@install -m 755 $(SCRIPTS_DIR)/install-mate-desktop.sh $(ROOTFS_DIR)/tmp/
	@install -d $(ROOTFS_DIR)/usr/sbin
	@install -m 755 $(SCRIPTS_DIR)/install-mate-desktop.sh $(ROOTFS_DIR)/usr/sbin/
	@echo "  ✓ install-mate-desktop.sh staged"
	@# Install graphical installer script
	@if [ -f "$(SCRIPTS_DIR)/install-ubuntu-installer.sh" ]; then \
		install -m 755 $(SCRIPTS_DIR)/install-ubuntu-installer.sh $(ROOTFS_DIR)/tmp/; \
		install -m 755 $(SCRIPTS_DIR)/install-ubuntu-installer.sh $(ROOTFS_DIR)/usr/sbin/; \
		echo "  ✓ install-ubuntu-installer.sh staged"; \
	fi
	@# Install TUI fallback installer
	@if [ -f "$(SCRIPTS_DIR)/galactic-cherry-installer" ]; then \
		install -m 755 $(SCRIPTS_DIR)/galactic-cherry-installer $(ROOTFS_DIR)/usr/sbin/; \
		echo "  ✓ galactic-cherry-installer installed"; \
	fi
	@# Autostart hook
	@if [ -f "$(SCRIPTS_DIR)/galactic-cherry-installer-autostart.sh" ]; then \
		install -d $(ROOTFS_DIR)/etc/profile.d; \
		install -m 644 $(SCRIPTS_DIR)/galactic-cherry-installer-autostart.sh $(ROOTFS_DIR)/etc/profile.d/; \
		echo "  ✓ autostart hook installed"; \
	fi
	@# Run chroot install if we have root (e.g., in CI or sudo context)
	@if [ "$$(id -u)" = "0" ]; then \
		echo "  Running MATE install in chroot (root detected)..."; \
		chroot $(ROOTFS_DIR) /tmp/install-mate-desktop.sh; \
		rm -f $(ROOTFS_DIR)/tmp/install-mate-desktop.sh; \
		if [ -f "$(ROOTFS_DIR)/tmp/install-ubuntu-installer.sh" ]; then \
			chroot $(ROOTFS_DIR) /tmp/install-ubuntu-installer.sh || \
				echo "  WARNING: Graphical installer setup incomplete (snapd may need live boot)"; \
			rm -f $(ROOTFS_DIR)/tmp/install-ubuntu-installer.sh; \
		fi; \
	else \
		echo ""; \
		echo "  NOTE: chroot requires root. Desktop packages not installed."; \
		echo "  Scripts are staged — run one of:"; \
		echo "    sudo make desktop        (to install packages now)"; \
		echo "    chroot into rootfs and run /tmp/install-mate-desktop.sh"; \
		echo "    Or packages install on first boot of the live image."; \
	fi

# ==============================================================================
# JWSTF / NitroWebExpress — Java Web Server Install
# ==============================================================================

jwstf-install:
	@echo "=== Installing JWSTF (NitroWebExpress) ==="
	@if [ ! -d "$(ROOTFS_DIR)/usr" ]; then \
		echo "  ERROR: rootfs not found. Run 'make rootfs' first."; exit 1; \
	fi
	@# Copy JWSTF source into rootfs for use by the installer
	@echo "  Staging JWSTF source into rootfs..."
	@install -d $(ROOTFS_DIR)/usr/local/src/jwstf
	@if [ -d "userland/java-web-server/source" ]; then \
		cp -a userland/java-web-server/* $(ROOTFS_DIR)/usr/local/src/jwstf/; \
		echo "  ✓ JWSTF source staged ($$(find userland/java-web-server/source -name '*.java' | wc -l) Java files)"; \
	else \
		echo "  WARNING: userland/java-web-server/source not found"; \
	fi
	@# Install the JWSTF installer script
	@install -m 755 $(SCRIPTS_DIR)/install-jwstf.sh $(ROOTFS_DIR)/usr/sbin/
	@echo "  ✓ install-jwstf.sh installed to /usr/sbin/"
	@# Run in chroot if we have root (packages need network)
	@if [ "$$(id -u)" = "0" ]; then \
		echo "  Running JWSTF install in chroot (root detected)..."; \
		chroot $(ROOTFS_DIR) /usr/sbin/install-jwstf.sh || \
			echo "  NOTE: JWSTF install incomplete (may need network on first boot)"; \
	else \
		echo ""; \
		echo "  NOTE: chroot install requires root."; \
		echo "  The installer will run during OS installation (galactic-cherry-installer)"; \
		echo "  or on first boot via: sudo /usr/sbin/install-jwstf.sh"; \
	fi

# ==============================================================================
# Root Filesystem Assembly
# ==============================================================================

rootfs: $(ROOTFS_DIR)

$(ROOTFS_DIR): $(ROOTFS_TAR)
	@echo "=== Extracting Ubuntu Base rootfs ==="
	mkdir -p $(ROOTFS_DIR)
	fakeroot tar -xzf $(ROOTFS_TAR) -C $(ROOTFS_DIR)
	@echo "Rootfs extracted to $(ROOTFS_DIR)"

rootfs-full: rootfs kernel-install x11-install wallpapers-install java-install-from-source wine-install darling-install tools-all-install vault-rootkits desktop jwstf-install initramfs grub
	@echo ""
	@echo "╔══════════════════════════════════════════════════════════════╗"
	@echo "║  FULL SYSTEM ASSEMBLED                                      ║"
	@echo "║  $(EDITION_NAME) Edition $(EDITION_VERSION)               ║"
	@echo "╚══════════════════════════════════════════════════════════════╝"
	@echo ""
	@echo "  Root filesystem:  $(ROOTFS_DIR)"
	@echo "  Kernel:           $(ROOTFS_DIR)/boot/vmlinuz-$(KERNEL_VER)"
	@echo "  Initramfs:        $(BUILD_DIR)/initramfs.img"
	@echo "  GRUB config:      $(ROOTFS_DIR)/boot/grub/grub.cfg"
	@echo ""
	@echo "  Components:"
	@echo "    ✓ Ubuntu Base 24.04.4 (Noble Numbat)"
	@echo "    ✓ Linux kernel $(KERNEL_VER) + 9 custom extensions"
	@echo "    ✓ X.Org Server 21.1.24 + libs + icons"
	@echo "    ✓ 9 Galactic Cherry wallpapers"
	@echo "    ✓ 10 Marvell JPEG wallpapers (4K)"
	@echo "    ✓ MATE Desktop (Red Cherry theme)"
	@echo "    ✓ LightDM (graphical login)"
	@echo "    ✓ OpenJDK 28 (default Java runtime)"
	@echo "    ✓ Wine $(WINE_VERSION) (Windows compatibility layer)"
	@echo "    ✓ Darling (macOS compatibility layer)"
	@echo "    ✓ sudo_gate, chat, nnet, negamane"
	@echo "    ✓ Cronie (cron with callbacks)"
	@echo "    ✓ ClamAV (protected antivirus)"
	@echo "    ✓ MySQL (protected database + package registry)"
	@echo "    ✓ Dave (system intelligence, 75-book library)"
	@echo "    ✓ chkrootkit (rootkit detection)"
	@echo "    ✓ rkhunter (Rootkit Hunter)"
	@echo "    ✓ Initramfs with custom module loading"
	@echo "    ✓ GRUB bootloader configuration"

# ==============================================================================
# Boot Components
# ==============================================================================

initramfs:
	@echo "=== Generating initramfs ==="
	bash $(SCRIPTS_DIR)/gen-initramfs.sh \
		"$(KERNEL_DIR)" "$(ROOTFS_DIR)" "$(BUILD_DIR)/initramfs.img"
	@if [ -f "$(BUILD_DIR)/initramfs.img" ]; then \
		cp $(BUILD_DIR)/initramfs.img $(ROOTFS_DIR)/boot/initramfs.img; fi

grub:
	@echo "=== Generating GRUB configuration ==="
	bash $(SCRIPTS_DIR)/gen-grub-cfg.sh "$(ROOTFS_DIR)"

# ISO image (bootable CD/USB installer)
iso: rootfs-full
	@echo "=== Generating bootable ISO ==="
	bash $(SCRIPTS_DIR)/gen-iso.sh "$(ROOTFS_DIR)" "$(BUILD_DIR)/galactic-cherry-98.iso"

# Manifest-driven build (reads build-manifest.xml for subcomponent selection)
MANIFEST ?= build-manifest.xml

.PHONY: manifest manifest-list manifest-dry-run

manifest:
	@bash $(SCRIPTS_DIR)/build-from-manifest.sh $(MANIFEST) --profile $(or $(ISO_PROFILE),full)

manifest-list:
	@bash $(SCRIPTS_DIR)/build-from-manifest.sh $(MANIFEST) --list --profile $(or $(ISO_PROFILE),full)

manifest-dry-run:
	@bash $(SCRIPTS_DIR)/build-from-manifest.sh $(MANIFEST) --dry-run --profile $(or $(ISO_PROFILE),full)

# Build ISO using manifest (selects components, then generates ISO)
iso-manifest: manifest
	@echo "=== Generating bootable ISO (manifest-driven) ==="
	bash $(SCRIPTS_DIR)/gen-iso.sh "$(ROOTFS_DIR)" "$(BUILD_DIR)/galactic-cherry-98.iso"

# ==============================================================================
# Clean
# ==============================================================================

clean:
	rm -rf $(ASM_BUILD_DIR)
	$(MAKE) -C $(KERNEL_DIR) clean 2>/dev/null || true
	$(MAKE) -C $(X11_DIR) clean 2>/dev/null || true
	rm -rf $(BUILD_DIR)

distclean: clean
	$(MAKE) -C $(KERNEL_DIR) distclean 2>/dev/null || true
	@if [ -d "$(TOOLS_DIR)/cronie" ] && [ -f "$(TOOLS_DIR)/cronie/Makefile" ]; then \
		$(MAKE) -C $(TOOLS_DIR)/cronie distclean 2>/dev/null || true; fi
	@if [ -d "$(TOOLS_DIR)/clamav/build" ]; then rm -rf $(TOOLS_DIR)/clamav/build; fi
	@if [ -d "$(TOOLS_DIR)/mysql/build" ]; then rm -rf $(TOOLS_DIR)/mysql/build; fi
	@if [ -d "$(TOOLS_DIR)/ai/llama.cpp/build" ]; then rm -rf $(TOOLS_DIR)/ai/llama.cpp/build; fi
	@if [ -d "$(TOOLS_DIR)/chkrootkit" ] && [ -f "$(TOOLS_DIR)/chkrootkit/Makefile" ]; then \
		$(MAKE) -C $(TOOLS_DIR)/chkrootkit clean 2>/dev/null || true; fi
	@if [ -d "$(WINE_DIR)/build64" ]; then rm -rf $(WINE_DIR)/build64; fi
	@if [ -d "$(WINE_DIR)/build32" ]; then rm -rf $(WINE_DIR)/build32; fi
	@if [ -d "$(DARLING_DIR)/build" ]; then rm -rf $(DARLING_DIR)/build; fi
