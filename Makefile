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

# Install prefix for userland builds (inside rootfs)
PREFIX        := /usr

.PHONY: all kernel kernel-defconfig kernel-menuconfig kernel-modules kernel-install \
        userland x11 x11-install wallpapers wallpapers-install \
        tools tools-install tools-all tools-all-install \
        rootfs rootfs-full initramfs grub iso \
        clean distclean help

all: kernel userland

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
	@echo "  all              - Build kernel + userland"
	@echo "  kernel           - Build Linux $(KERNEL_VER) with all extensions"
	@echo "  kernel-defconfig - Apply Galactic Cherry defconfig"
	@echo "  kernel-menuconfig- Interactive kernel configuration"
	@echo "  userland         - Build X11, wallpapers, and custom tools"
	@echo "  x11              - Build X.Org Server 21.1.24 and libraries"
	@echo "  wallpapers       - Prepare desktop wallpapers"
	@echo "  java             - Fetch OpenJDK 28 (~227 MB download)"
	@echo "  tools            - Build custom tools (sudo_gate, chat, nnet)"
	@echo "  tools-all        - Build all tools (incl. cronie, clamav, mysql)"
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
	@echo "Prerequisites:"
	@echo "  kernel  - gcc, make, flex, bison, libelf-dev, bc, libssl-dev"
	@echo "  x11     - meson, ninja, pkg-config, gcc"
	@echo "  cronie  - autoconf, automake, libtool"
	@echo "  clamav  - cmake, rustc, cargo, libssl-dev, libjson-c-dev"
	@echo "  mysql   - cmake, g++, libssl-dev, libncurses-dev"
	@echo "  rootfs  - fakeroot, cpio, gzip"
	@echo "  iso     - xorriso, squashfs-tools, grub-pc-bin, grub-efi-amd64-bin, mtools"

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
# Userland (all user-space components)
# ==============================================================================

userland: x11 wallpapers tools

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
	$(MAKE) -C $(USERLAND_DIR)/java

java-install:
	$(MAKE) -C $(USERLAND_DIR)/java install DESTDIR=$(abspath $(ROOTFS_DIR))

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

tools-all: tools tools-cronie tools-clamav tools-mysql tools-ai

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

# Full tools install (all)
tools-all-install: tools-install tools-cronie-install tools-clamav-install tools-mysql-install tools-ai-install

# ==============================================================================
# Root Filesystem Assembly
# ==============================================================================

rootfs: $(ROOTFS_DIR)

$(ROOTFS_DIR): $(ROOTFS_TAR)
	@echo "=== Extracting Ubuntu Base rootfs ==="
	mkdir -p $(ROOTFS_DIR)
	fakeroot tar -xzf $(ROOTFS_TAR) -C $(ROOTFS_DIR)
	@echo "Rootfs extracted to $(ROOTFS_DIR)"

rootfs-full: rootfs kernel-install x11-install wallpapers-install java-install tools-all-install initramfs grub
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
	@echo "    ✓ OpenJDK 28 (default Java runtime)"
	@echo "    ✓ sudo_gate, chat, nnet, negamane"
	@echo "    ✓ Cronie (cron with callbacks)"
	@echo "    ✓ ClamAV (protected antivirus)"
	@echo "    ✓ MySQL (protected database + package registry)"
	@echo "    ✓ Dave (system intelligence, 75-book library)"
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

# ==============================================================================
# Clean
# ==============================================================================

clean:
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
