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
        tools-xgcc tools-xgcc-install \
        tools-muntutils tools-muntutils-install \
        jdesk-install \
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
	@echo "  all              - Build asm + kernel + userland"
	@echo "  asm              - Compile x86_64 .S files (from linux base compressed)"
	@echo "  asm-list         - List all .S assembly sources by directory"
	@echo "  kernel           - Build Linux $(KERNEL_VER) with all extensions"
	@echo "  kernel-defconfig - Apply Galactic Cherry defconfig"
	@echo "  kernel-menuconfig- Interactive kernel configuration"
	@echo "  userland         - Build X11, wallpapers, and custom tools"
	@echo "  x11              - Build X.Org Server 21.1.24 and libraries"
	@echo "  wallpapers       - Prepare desktop wallpapers"
	@echo "  java             - Apply OpenJDK 28 source overlay (build with java-build)"
	@echo "  chromium         - Fetch Chromium browser source (~5-8 GB shallow clone)"
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
		python3 python3-pip
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

userland: x11 wallpapers java tools

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
	@if [ -d "$(TOOLS_DIR)/psych-id" ]; then \
		echo "  Building psych-id..."; $(MAKE) -C $(TOOLS_DIR)/psych-id; fi
	@if [ -d "tools/xgcc" ]; then \
		echo "  Building xgcc (interpreter)..."; $(MAKE) -C tools/xgcc; fi

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
	@if [ -d "$(TOOLS_DIR)/psych-id" ]; then \
		$(MAKE) -C $(TOOLS_DIR)/psych-id install DESTDIR=$(abspath $(ROOTFS_DIR)); fi
	@if [ -d "tools/xgcc" ]; then \
		$(MAKE) -C tools/xgcc install DESTDIR=$(abspath $(ROOTFS_DIR)); fi

# ==============================================================================
# Tools - Extended (autotools/cmake-based, longer builds)
# ==============================================================================

tools-all: tools tools-drm tools-tandem-equals tools-palladium-grooves tools-palladium-grooves-iv tools-rebate-certificates tools-cronie tools-clamav tools-mysql tools-ai tools-chkrootkit tools-rkhunter tools-xgcc tools-muntutils

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

# xgcc — Metal-Thin C/C++ Source Interpreter
tools-xgcc:
	@echo "=== Building xgcc (interpreter) ==="
	@$(MAKE) -C tools/xgcc

tools-xgcc-install:
	@echo "=== Installing xgcc ==="
	@$(MAKE) -C tools/xgcc install DESTDIR=$(abspath $(ROOTFS_DIR))
	@echo "  ✓ xgcc + xgcc-user installed to /usr/local/bin/"

# muntutils - source reachability trimmer and raw-vs-compiled size reporter
tools-muntutils:
	@echo "=== Building muntutils ==="
	@if [ -d "tools/muntutils" ] && [ -f "tools/muntutils/Makefile" ]; then \
		$(MAKE) -C tools/muntutils all; \
	fi

tools-muntutils-install:
	@echo "=== Installing muntutils ==="
	@if [ -d "tools/muntutils" ] && [ -f "tools/muntutils/muntutils" ]; then \
		install -d $(ROOTFS_DIR)/usr/local/bin; \
		install -m 755 tools/muntutils/muntutils $(ROOTFS_DIR)/usr/local/bin/; \
		echo "  ✓ muntutils installed to /usr/local/bin/"; \
	fi

# Full tools install (all)
tools-all-install: tools-install tools-drm-install tools-tandem-equals-install tools-palladium-grooves-install tools-palladium-grooves-iv-install tools-rebate-certificates-install tools-cronie-install tools-clamav-install tools-mysql-install tools-ai-install tools-chkrootkit-install tools-rkhunter-install tools-xgcc-install tools-muntutils-install

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
# JDesk Desktop Environment — Stage provisioner and native library
# ==============================================================================

jdesk-install:
	@echo "=== Installing JDesk Desktop Framework ==="
	@if [ ! -d "$(ROOTFS_DIR)/usr" ]; then \
		echo "  ERROR: rootfs not found. Run 'make rootfs' first."; exit 1; \
	fi
	@# Install native library (libjdesk.so)
	@install -d $(ROOTFS_DIR)/usr/local/lib
	@if [ -f "$(USERLAND_DIR)/jdesk/native/linux/libjdesk.so" ]; then \
		install -m 755 $(USERLAND_DIR)/jdesk/native/linux/libjdesk.so $(ROOTFS_DIR)/usr/local/lib/; \
		echo "  ✓ libjdesk.so installed"; \
	else \
		echo "  NOTE: libjdesk.so not built — run: make -C $(USERLAND_DIR)/jdesk/native/linux"; \
	fi
	@# Install native launcher binary
	@install -d $(ROOTFS_DIR)/usr/local/bin
	@if [ -f "$(USERLAND_DIR)/jdesk/native/linux/jdesk-bin" ]; then \
		install -m 755 $(USERLAND_DIR)/jdesk/native/linux/jdesk-bin $(ROOTFS_DIR)/usr/local/bin/jdesk; \
		echo "  ✓ jdesk launcher installed to /usr/local/bin/jdesk"; \
	fi
	@# Stage the provisioner and its manifest for first-boot use
	@install -d $(ROOTFS_DIR)/opt/jdesk/native-apps
	@install -d $(ROOTFS_DIR)/opt/jdesk/native-apps/kali-tools
	@install -d $(ROOTFS_DIR)/opt/jdesk/native-apps/scripts
	@install -m 755 $(USERLAND_DIR)/jdesk/native-apps/jdesk-provision $(ROOTFS_DIR)/opt/jdesk/native-apps/
	@install -m 644 $(USERLAND_DIR)/jdesk/native-apps/jdesk-packages.json $(ROOTFS_DIR)/opt/jdesk/native-apps/
	@install -m 755 $(USERLAND_DIR)/jdesk/native-apps/scripts/predictive-install.sh $(ROOTFS_DIR)/opt/jdesk/native-apps/scripts/
	@install -m 755 $(USERLAND_DIR)/jdesk/native-apps/kali-tools/kali-provision $(ROOTFS_DIR)/opt/jdesk/native-apps/kali-tools/
	@echo "  ✓ jdesk-provision + jdesk-packages.json staged"
	@# Install icons, manifests, profiles
	@install -d $(ROOTFS_DIR)/opt/jdesk/icons
	@install -d $(ROOTFS_DIR)/opt/jdesk/manifests
	@install -d $(ROOTFS_DIR)/opt/jdesk/profiles
	@cp $(USERLAND_DIR)/jdesk/native-apps/icons/*.svg $(ROOTFS_DIR)/opt/jdesk/icons/ 2>/dev/null || true
	@cp $(USERLAND_DIR)/jdesk/native-apps/manifests/*.jdesk-app $(ROOTFS_DIR)/opt/jdesk/manifests/ 2>/dev/null || true
	@cp $(USERLAND_DIR)/jdesk/native-apps/profiles/*.xml $(ROOTFS_DIR)/opt/jdesk/profiles/ 2>/dev/null || true
	@echo "  ✓ Icons, manifests, profiles installed"
	@# Create systemd service for first-boot provisioning
	@install -d $(ROOTFS_DIR)/etc/systemd/system
	@if [ -f "$(USERLAND_DIR)/jdesk/native-apps/jdesk-provision.service" ]; then \
		install -m 644 $(USERLAND_DIR)/jdesk/native-apps/jdesk-provision.service $(ROOTFS_DIR)/etc/systemd/system/; \
		echo "  ✓ jdesk-provision.service installed (first-boot auto)"; \
	fi
	@# Symlink provisioner to sbin
	@install -d $(ROOTFS_DIR)/usr/local/sbin
	@ln -sf /opt/jdesk/native-apps/jdesk-provision $(ROOTFS_DIR)/usr/local/sbin/jdesk-provision
	@echo "  ✓ /usr/local/sbin/jdesk-provision → provisioner"
	@echo ""
	@echo "  JDesk staged for first-boot provisioning."
	@echo "  Native apps (Writer, IDE, Browser, Files, Kali, etc.) install on first boot."
	@echo "  Manual: sudo jdesk-provision"
	@echo "  Full:   sudo jdesk-provision --full"

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
	@echo "=== Creating /user hierarchy ==="
	mkdir -p $(ROOTFS_DIR)/user
	mkdir -p $(ROOTFS_DIR)/user/bin
	mkdir -p $(ROOTFS_DIR)/user/lib
	mkdir -p $(ROOTFS_DIR)/user/lib/games
	mkdir -p $(ROOTFS_DIR)/user/lib/ide
	mkdir -p $(ROOTFS_DIR)/user/lib/mysql
	mkdir -p $(ROOTFS_DIR)/user/lib/browser
	mkdir -p $(ROOTFS_DIR)/user/lib/python
	mkdir -p $(ROOTFS_DIR)/user/share
	mkdir -p $(ROOTFS_DIR)/user/share/accounts
	mkdir -p $(ROOTFS_DIR)/user/share/mail
	mkdir -p $(ROOTFS_DIR)/user/share/icons
	mkdir -p $(ROOTFS_DIR)/user/share/themes
	mkdir -p $(ROOTFS_DIR)/user/share/fonts
	mkdir -p $(ROOTFS_DIR)/user/share/db
	mkdir -p $(ROOTFS_DIR)/user/include
	mkdir -p $(ROOTFS_DIR)/user/etc
	mkdir -p $(ROOTFS_DIR)/user/etc/mysql
	mkdir -p $(ROOTFS_DIR)/user/etc/mail
	mkdir -p $(ROOTFS_DIR)/user/local
	mkdir -p $(ROOTFS_DIR)/user/local/bin
	mkdir -p $(ROOTFS_DIR)/user/local/lib
	mkdir -p $(ROOTFS_DIR)/user/local/share
	@echo "=== Creating /deck hierarchy ==="
	mkdir -p $(ROOTFS_DIR)/deck
	mkdir -p $(ROOTFS_DIR)/deck/bin
	mkdir -p $(ROOTFS_DIR)/deck/lib
	mkdir -p $(ROOTFS_DIR)/deck/share
	mkdir -p $(ROOTFS_DIR)/deck/include
	mkdir -p $(ROOTFS_DIR)/deck/local
	mkdir -p $(ROOTFS_DIR)/deck/local/bin
	mkdir -p $(ROOTFS_DIR)/deck/local/lib
	mkdir -p $(ROOTFS_DIR)/deck/local/share
	@echo "=== Adding /user and /deck to PATH ==="
	mkdir -p $(ROOTFS_DIR)/etc/profile.d
	printf '# /user hierarchy — owner/operator software\nexport PATH="/usr/local/bin:/user/local/bin:/user/bin:$$PATH"\nexport LD_LIBRARY_PATH="/user/lib:/user/local/lib:$$LD_LIBRARY_PATH"\n' \
		> $(ROOTFS_DIR)/etc/profile.d/user-path.sh
	chmod 644 $(ROOTFS_DIR)/etc/profile.d/user-path.sh
	printf '# /deck hierarchy\nexport PATH="/deck/local/bin:/deck/bin:$$PATH"\nexport LD_LIBRARY_PATH="/deck/lib:/deck/local/lib:$$LD_LIBRARY_PATH"\n' \
		> $(ROOTFS_DIR)/etc/profile.d/deck-path.sh
	chmod 644 $(ROOTFS_DIR)/etc/profile.d/deck-path.sh
	@echo "Rootfs extracted to $(ROOTFS_DIR)"
	@echo "/user and /deck hierarchies created (parallel to /usr)"

rootfs-full: rootfs kernel-install x11-install wallpapers-install java-install-from-source tools-all-install desktop jdesk-install jwstf-install initramfs grub
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
	@echo "    ✓ Ubuntu Base 24.04.4 (US Treasury & MEARVK LLC)"
	@echo "    ✓ Linux kernel $(KERNEL_VER) + 9 custom extensions"
	@echo "    ✓ X.Org Server 21.1.24 + libs + icons"
	@echo "    ✓ 9 Galactic Cherry wallpapers"
	@echo "    ✓ 10 Marvell JPEG wallpapers (4K)"
	@echo "    ✓ MATE Desktop (Red Cherry theme)"
	@echo "    ✓ LightDM (graphical login)"
	@echo "    ✓ OpenJDK 28 (default Java runtime)"
	@echo "    ✓ sudo_gate, chat, nnet, negamane"
	@echo "    ✓ Cronie (cron with callbacks)"
	@echo "    ✓ ClamAV (protected antivirus)"
	@echo "    ✓ MySQL (protected database + package registry)"
	@echo "    ✓ Dave (system intelligence, 75-book library)"
	@echo "    ✓ chkrootkit (rootkit detection)"
	@echo "    ✓ rkhunter (Rootkit Hunter)"
	@echo "    ✓ JDesk desktop framework (first-boot provisioner)"
	@echo "    ✓ /user hierarchy (owner/operator software space)"
	@echo "    ✓ /deck hierarchy (professional system software)"
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
