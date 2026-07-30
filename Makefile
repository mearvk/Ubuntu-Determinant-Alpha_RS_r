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

# Paths
KERNEL_DIR    := kernels/linux-5.15.204/linux-5.15.204
USERLAND_DIR  := userland
X11_DIR       := $(USERLAND_DIR)/x11
TOOLS_DIR     := $(KERNEL_DIR)/tools
ROOTFS_TAR    := $(USERLAND_DIR)/ubuntu-base-24.04.4-base-amd64.tar.gz

# Build output
BUILD_DIR     := build
ROOTFS_DIR    := $(BUILD_DIR)/rootfs

# Install prefix for userland builds (inside rootfs)
PREFIX        := /usr

.PHONY: all kernel userland x11 wallpapers rootfs tools clean help

all: kernel userland

help:
	@echo "Ubuntu Determinant Alpha RS - $(EDITION_NAME) Edition $(EDITION_VERSION)"
	@echo ""
	@echo "Targets:"
	@echo "  kernel       - Build the Linux 5.15.204 kernel with extensions"
	@echo "  userland     - Build all userland components (x11, wallpapers, tools)"
	@echo "  x11          - Build X11 display server and libraries"
	@echo "  wallpapers   - Install desktop wallpapers"
	@echo "  rootfs       - Create root filesystem from Ubuntu Base"
	@echo "  tools        - Build custom tools (sudo_gate, chat, nnet, negamane)"
	@echo "  clean        - Clean build artifacts"
	@echo ""
	@echo "Edition: $(EDITION_NAME) $(EDITION_VERSION)"
	@echo ""
	@echo "Kernel extensions enabled:"
	@echo "  CONFIG_EPMP, CONFIG_HPM, CONFIG_SECURITY_EPERM,"
	@echo "  CONFIG_USB_SWAP, CONFIG_USB_FAST_DMA, CONFIG_NEGAMANE,"
	@echo "  CONFIG_USER_KO, CONFIG_WHITE_ETHICS, CONFIG_CPUBOOST"
	@echo ""
	@echo "Prerequisites:"
	@echo "  kernel     - gcc, make, flex, bison, libelf-dev, bc"
	@echo "  x11        - meson, ninja, pkg-config, gcc"
	@echo "  rootfs     - root or fakeroot"

# ==============================================================================
# Kernel
# ==============================================================================

kernel:
	$(MAKE) -C $(KERNEL_DIR) -j$$(nproc)

kernel-menuconfig:
	$(MAKE) -C $(KERNEL_DIR) menuconfig

kernel-defconfig:
	$(MAKE) -C $(KERNEL_DIR) defconfig

kernel-modules:
	$(MAKE) -C $(KERNEL_DIR) modules

kernel-install: kernel
	$(MAKE) -C $(KERNEL_DIR) modules_install INSTALL_MOD_PATH=$(abspath $(ROOTFS_DIR))

# ==============================================================================
# Userland
# ==============================================================================

userland: x11 tools

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
# Custom Tools (sudo_gate, chat, nnet, negamane)
# ==============================================================================

tools:
	@echo "Building custom tools..."
	@if [ -d "$(TOOLS_DIR)/sudo_gate" ]; then $(MAKE) -C $(TOOLS_DIR)/sudo_gate; fi
	@if [ -d "$(TOOLS_DIR)/chat" ]; then $(MAKE) -C $(TOOLS_DIR)/chat; fi
	@if [ -d "$(TOOLS_DIR)/nnet" ]; then $(MAKE) -C $(TOOLS_DIR)/nnet; fi

tools-install:
	@if [ -d "$(TOOLS_DIR)/sudo_gate" ]; then \
		$(MAKE) -C $(TOOLS_DIR)/sudo_gate install DESTDIR=$(abspath $(ROOTFS_DIR)); fi
	@if [ -d "$(TOOLS_DIR)/chat" ]; then \
		$(MAKE) -C $(TOOLS_DIR)/chat install DESTDIR=$(abspath $(ROOTFS_DIR)); fi
	@if [ -d "$(TOOLS_DIR)/nnet" ]; then \
		$(MAKE) -C $(TOOLS_DIR)/nnet install DESTDIR=$(abspath $(ROOTFS_DIR)); fi

# ==============================================================================
# Root Filesystem Assembly
# ==============================================================================

rootfs: $(ROOTFS_DIR)

$(ROOTFS_DIR): $(ROOTFS_TAR)
	@echo "Extracting Ubuntu Base rootfs..."
	mkdir -p $(ROOTFS_DIR)
	fakeroot tar -xzf $(ROOTFS_TAR) -C $(ROOTFS_DIR)
	@echo "Rootfs extracted to $(ROOTFS_DIR)"

rootfs-full: rootfs kernel-install x11-install wallpapers-install tools-install
	@echo ""
	@echo "Full rootfs assembled in $(ROOTFS_DIR)"
	@echo "  Edition: $(EDITION_NAME) $(EDITION_VERSION)"
	@echo "  - Ubuntu Base 24.04.4"
	@echo "  - Kernel modules installed"
	@echo "  - X11 display system installed"
	@echo "  - Galactic Cherry wallpapers installed"
	@echo "  - Custom tools installed"

# ==============================================================================
# Clean
# ==============================================================================

clean:
	$(MAKE) -C $(KERNEL_DIR) clean 2>/dev/null || true
	$(MAKE) -C $(X11_DIR) clean 2>/dev/null || true
	rm -rf $(BUILD_DIR)

distclean: clean
	$(MAKE) -C $(KERNEL_DIR) distclean 2>/dev/null || true
