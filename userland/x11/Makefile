# SPDX-License-Identifier: MIT
#
# Makefile for X11 Display System - Ubuntu Determinant Alpha RS
#
# Builds X11 from source tarballs in dependency order.
#
# Copyright (C) 2026 MEARVK LLC
#

SHELL := /bin/bash

# Install prefix
PREFIX   ?= /usr
DESTDIR  ?=

# Build directory (extracted sources built here)
BUILD    := $(CURDIR)/_build
SYSROOT  := $(BUILD)/sysroot

# Package versions
XORGPROTO_VER   := 2024.1
XTRANS_VER      := 1.5.0
LIBXCB_VER      := 1.17.0
LIBX11_VER      := 1.8.13
LIBXEXT_VER     := 1.3.6
LIBXRENDER_VER  := 0.9.11
PIXMAN_VER      := 0.43.4
XSHMFENCE_VER  := 1.3.2
LIBMD_VER       := 1.1.0
LIBBSD_VER      := 0.12.2
XKBFILE_VER     := 1.1.3
XSERVER_VER     := 21.1.24
XINIT_VER       := 1.4.2
TWM_VER         := 1.0.12
XTERM_VER       := 394
XCBPROTO_VER    := 1.17.0

# Source tarballs
XORGPROTO_TAR   := xorgproto-$(XORGPROTO_VER).tar.xz
XCBPROTO_TAR    := xcb-proto-$(XCBPROTO_VER).tar.xz
XTRANS_TAR      := xtrans-$(XTRANS_VER).tar.xz
LIBXCB_TAR      := libxcb-$(LIBXCB_VER).tar.xz
LIBX11_TAR      := libX11-$(LIBX11_VER).tar.xz
LIBXEXT_TAR     := libXext-$(LIBXEXT_VER).tar.xz
LIBXRENDER_TAR  := libXrender-$(LIBXRENDER_VER).tar.xz
PIXMAN_TAR      := pixman-$(PIXMAN_VER).tar.gz
XSHMFENCE_TAR  := libxshmfence-$(XSHMFENCE_VER).tar.xz
LIBMD_TAR       := libmd-$(LIBMD_VER).tar.xz
LIBBSD_TAR      := libbsd-$(LIBBSD_VER).tar.xz
XKBFILE_TAR     := libxkbfile-$(XKBFILE_VER).tar.xz
XSERVER_TAR     := xorg-server-$(XSERVER_VER).tar.xz
XINIT_TAR       := xinit-$(XINIT_VER).tar.xz
TWM_TAR         := twm-$(TWM_VER).tar.xz
XTERM_TAR       := xterm-$(XTERM_VER).tgz

# Icon themes (install-only, no build)
HUMANITY_TAR    := humanity-icon-theme_0.6.16.tar.xz
ADWAITA_TAR     := adwaita-icon-theme-46.2.tar.xz

# Stamp files track completed builds
STAMPS := $(BUILD)/.stamps
$(shell mkdir -p $(STAMPS))

# pkg-config must find our sysroot libs
export PKG_CONFIG_PATH := $(SYSROOT)$(PREFIX)/lib/pkgconfig:$(SYSROOT)$(PREFIX)/lib/x86_64-linux-gnu/pkgconfig:$(SYSROOT)$(PREFIX)/share/pkgconfig
export PKG_CONFIG_SYSROOT_DIR := $(SYSROOT)

# Remove .la files after install — they break libtool in sysroot builds
REMOVE_LA = find $(SYSROOT) -name "*.la" -delete 2>/dev/null || true

# Build components in dependency order
.PHONY: all libs server apps icons install clean help

all: libs server apps icons

help:
	@echo "X11 Build System"
	@echo ""
	@echo "Targets:"
	@echo "  all      - Build everything (libs, server, apps, icons)"
	@echo "  libs     - Build X11 protocol headers and libraries"
	@echo "  server   - Build Xorg server"
	@echo "  apps     - Build xinit, twm, xterm"
	@echo "  icons    - Install icon themes"
	@echo "  install  - Install all to DESTDIR"
	@echo "  clean    - Remove build directory"
	@echo ""
	@echo "Variables:"
	@echo "  PREFIX=$(PREFIX)"
	@echo "  DESTDIR=$(DESTDIR)"

# ==============================================================================
# Libraries (in dependency order)
# ==============================================================================

libs: $(STAMPS)/xorgproto $(STAMPS)/xcb-proto $(STAMPS)/xtrans $(STAMPS)/libxcb $(STAMPS)/libX11 \
      $(STAMPS)/libXext $(STAMPS)/libXrender $(STAMPS)/pixman $(STAMPS)/xshmfence \
      $(STAMPS)/libmd $(STAMPS)/libbsd $(STAMPS)/libxkbfile

# 1. Protocol headers (no dependencies)
$(STAMPS)/xorgproto: $(XORGPROTO_TAR)
	@echo "=== Building xorgproto $(XORGPROTO_VER) ==="
	mkdir -p $(BUILD) && cd $(BUILD) && \
	tar xf $(CURDIR)/$(XORGPROTO_TAR) && \
	cd xorgproto-$(XORGPROTO_VER) && \
	meson setup build --prefix=$(PREFIX) --libdir=lib && \
	DESTDIR=$(SYSROOT) ninja -C build install
	@touch $@

# 1b. XCB Protocol descriptions (required by libxcb)
$(STAMPS)/xcb-proto: $(XCBPROTO_TAR) $(STAMPS)/xorgproto
	@echo "=== Building xcb-proto $(XCBPROTO_VER) ==="
	cd $(BUILD) && \
	tar xf $(CURDIR)/$(XCBPROTO_TAR) && \
	cd xcb-proto-$(XCBPROTO_VER) && \
	./configure --prefix=$(PREFIX) \
		PKG_CONFIG_PATH="$(PKG_CONFIG_PATH)" && \
	make -j$$(nproc) && \
	make install DESTDIR=$(SYSROOT)
	@touch $@

# 2. Transport abstraction
$(STAMPS)/xtrans: $(XTRANS_TAR) $(STAMPS)/xorgproto
	@echo "=== Building xtrans $(XTRANS_VER) ==="
	cd $(BUILD) && \
	tar xf $(CURDIR)/$(XTRANS_TAR) && \
	cd xtrans-$(XTRANS_VER) && \
	./configure --prefix=$(PREFIX) \
		PKG_CONFIG_PATH="$(PKG_CONFIG_PATH)" && \
	make -j$$(nproc) && \
	make install DESTDIR=$(SYSROOT)
	@touch $@

# 3. X C Bindings (required by libX11)
$(STAMPS)/libxcb: $(LIBXCB_TAR) $(STAMPS)/xcb-proto $(STAMPS)/xorgproto
	@echo "=== Building libxcb $(LIBXCB_VER) ==="
	cd $(BUILD) && \
	tar xf $(CURDIR)/$(LIBXCB_TAR) && \
	cd libxcb-$(LIBXCB_VER) && \
	./configure --prefix=$(PREFIX) --libdir=$(PREFIX)/lib \
		PKG_CONFIG_PATH="$(PKG_CONFIG_PATH)" && \
	make -j$$(nproc) && \
	make install DESTDIR=$(SYSROOT)
	@$(REMOVE_LA)
	@touch $@

# 4. Core X11 library
$(STAMPS)/libX11: $(LIBX11_TAR) $(STAMPS)/libxcb $(STAMPS)/xtrans
	@echo "=== Building libX11 $(LIBX11_VER) ==="
	cd $(BUILD) && \
	tar xf $(CURDIR)/$(LIBX11_TAR) && \
	cd libX11-$(LIBX11_VER) && \
	./configure --prefix=$(PREFIX) --libdir=$(PREFIX)/lib \
		PKG_CONFIG_PATH="$(PKG_CONFIG_PATH)" && \
	make -j$$(nproc) && \
	make install DESTDIR=$(SYSROOT)
	@$(REMOVE_LA)
	@touch $@

# 5. X11 protocol extensions
$(STAMPS)/libXext: $(LIBXEXT_TAR) $(STAMPS)/libX11
	@echo "=== Building libXext $(LIBXEXT_VER) ==="
	cd $(BUILD) && \
	tar xf $(CURDIR)/$(LIBXEXT_TAR) && \
	cd libXext-$(LIBXEXT_VER) && \
	./configure --prefix=$(PREFIX) --libdir=$(PREFIX)/lib \
		PKG_CONFIG_PATH="$(PKG_CONFIG_PATH)" && \
	make -j$$(nproc) && \
	make install DESTDIR=$(SYSROOT)
	@$(REMOVE_LA)
	@touch $@

# 6. X Render extension
$(STAMPS)/libXrender: $(LIBXRENDER_TAR) $(STAMPS)/libXext
	@echo "=== Building libXrender $(LIBXRENDER_VER) ==="
	cd $(BUILD) && \
	tar xf $(CURDIR)/$(LIBXRENDER_TAR) && \
	cd libXrender-$(LIBXRENDER_VER) && \
	sed -i 's/BufAlloc (xGlyphElt \*, elt, SIZEOF(xGlyphElt))$$/BufAlloc (xGlyphElt *, elt, SIZEOF(xGlyphElt));/' src/Glyph.c && \
	./configure --prefix=$(PREFIX) --libdir=$(PREFIX)/lib \
		PKG_CONFIG_PATH="$(PKG_CONFIG_PATH)" && \
	make -j$$(nproc) && \
	make install DESTDIR=$(SYSROOT)
	@$(REMOVE_LA)
	@touch $@

# 7. Pixman - pixel manipulation library (required by xorg-server)
$(STAMPS)/pixman: $(PIXMAN_TAR)
	@echo "=== Building pixman $(PIXMAN_VER) ==="
	cd $(BUILD) && \
	tar xf $(CURDIR)/$(PIXMAN_TAR) && \
	cd pixman-$(PIXMAN_VER) && \
	meson setup build --prefix=$(PREFIX) --libdir=lib && \
	DESTDIR=$(SYSROOT) ninja -C build install
	@$(REMOVE_LA)
	@touch $@

# 8. xshmfence - shared memory fences (required by xorg-server)
$(STAMPS)/xshmfence: $(XSHMFENCE_TAR) $(STAMPS)/xorgproto
	@echo "=== Building libxshmfence $(XSHMFENCE_VER) ==="
	cd $(BUILD) && \
	tar xf $(CURDIR)/$(XSHMFENCE_TAR) && \
	cd libxshmfence-$(XSHMFENCE_VER) && \
	./configure --prefix=$(PREFIX) --libdir=$(PREFIX)/lib \
		PKG_CONFIG_PATH="$(PKG_CONFIG_PATH)" && \
	make -j$$(nproc) && \
	make install DESTDIR=$(SYSROOT)
	@$(REMOVE_LA)
	@touch $@

# 9. libmd - message digest library (required by libbsd)
$(STAMPS)/libmd: $(LIBMD_TAR)
	@echo "=== Building libmd $(LIBMD_VER) ==="
	cd $(BUILD) && \
	tar xf $(CURDIR)/$(LIBMD_TAR) && \
	cd libmd-$(LIBMD_VER) && \
	./configure --prefix=$(PREFIX) --libdir=$(PREFIX)/lib \
		PKG_CONFIG_PATH="$(PKG_CONFIG_PATH)" && \
	make -j$$(nproc) && \
	make install DESTDIR=$(SYSROOT)
	@$(REMOVE_LA)
	@touch $@

# 10. libbsd - BSD compatibility library (required by xorg-server)
$(STAMPS)/libbsd: $(LIBBSD_TAR) $(STAMPS)/libmd
	@echo "=== Building libbsd $(LIBBSD_VER) ==="
	cd $(BUILD) && \
	tar xf $(CURDIR)/$(LIBBSD_TAR) && \
	cd libbsd-$(LIBBSD_VER) && \
	./configure --prefix=$(PREFIX) --libdir=$(PREFIX)/lib \
		PKG_CONFIG_PATH="$(PKG_CONFIG_PATH)" && \
	make -j$$(nproc) && \
	make install DESTDIR=$(SYSROOT)
	@$(REMOVE_LA)
	@touch $@

# 11. libxkbfile - XKB file handling (required by xorg-server)
$(STAMPS)/libxkbfile: $(XKBFILE_TAR) $(STAMPS)/libX11
	@echo "=== Building libxkbfile $(XKBFILE_VER) ==="
	cd $(BUILD) && \
	tar xf $(CURDIR)/$(XKBFILE_TAR) && \
	cd libxkbfile-$(XKBFILE_VER) && \
	./configure --prefix=$(PREFIX) --libdir=$(PREFIX)/lib \
		PKG_CONFIG_PATH="$(PKG_CONFIG_PATH)" && \
	make -j$$(nproc) && \
	make install DESTDIR=$(SYSROOT)
	@$(REMOVE_LA)
	@touch $@

# ==============================================================================
# X Server
# ==============================================================================

server: $(STAMPS)/xorg-server

$(STAMPS)/xorg-server: $(XSERVER_TAR) $(STAMPS)/libXrender $(STAMPS)/pixman $(STAMPS)/xshmfence $(STAMPS)/libbsd $(STAMPS)/libxkbfile
	@echo "=== Building xorg-server $(XSERVER_VER) ==="
	cd $(BUILD) && \
	tar xf $(CURDIR)/$(XSERVER_TAR) && \
	cd xorg-server-$(XSERVER_VER) && \
	meson setup build --prefix=$(PREFIX) --libdir=lib \
		-Dxorg=true -Dxephyr=false -Dxnest=false \
		-Dxvfb=true -Dxwin=false -Ddocs=false && \
	DESTDIR=$(SYSROOT) ninja -C build install
	@touch $@

# ==============================================================================
# Applications
# ==============================================================================

apps: $(STAMPS)/xinit $(STAMPS)/twm $(STAMPS)/xterm

$(STAMPS)/xinit: $(XINIT_TAR) $(STAMPS)/libX11
	@echo "=== Building xinit $(XINIT_VER) ==="
	cd $(BUILD) && \
	tar xf $(CURDIR)/$(XINIT_TAR) && \
	cd xinit-$(XINIT_VER) && \
	./configure --prefix=$(PREFIX) \
		PKG_CONFIG_PATH="$(PKG_CONFIG_PATH)" && \
	make -j$$(nproc) && \
	make install DESTDIR=$(SYSROOT)
	@touch $@

$(STAMPS)/twm: $(TWM_TAR) $(STAMPS)/libXext
	@echo "=== Building twm $(TWM_VER) ==="
	cd $(BUILD) && \
	tar xf $(CURDIR)/$(TWM_TAR) && \
	cd twm-$(TWM_VER) && \
	./configure --prefix=$(PREFIX) \
		PKG_CONFIG_PATH="$(PKG_CONFIG_PATH)" && \
	make -j$$(nproc) && \
	make install DESTDIR=$(SYSROOT)
	@touch $@

$(STAMPS)/xterm: $(XTERM_TAR) $(STAMPS)/libX11
	@echo "=== Building xterm $(XTERM_VER) ==="
	cd $(BUILD) && \
	tar xzf $(CURDIR)/$(XTERM_TAR) && \
	cd xterm-$(XTERM_VER) && \
	./configure --prefix=$(PREFIX) \
		PKG_CONFIG_PATH="$(PKG_CONFIG_PATH)" && \
	make -j$$(nproc) && \
	make install DESTDIR=$(SYSROOT)
	@touch $@

# ==============================================================================
# Icon Themes
# ==============================================================================

icons: $(STAMPS)/humanity-icons $(STAMPS)/adwaita-icons

$(STAMPS)/humanity-icons: $(HUMANITY_TAR)
	@echo "=== Installing Humanity icon theme ==="
	cd $(BUILD) && \
	tar xf $(CURDIR)/$(HUMANITY_TAR) && \
	mkdir -p $(SYSROOT)$(PREFIX)/share/icons && \
	cp -r humanity-icon-theme-0.6.16/Humanity $(SYSROOT)$(PREFIX)/share/icons/ && \
	cp -r humanity-icon-theme-0.6.16/Humanity-Dark $(SYSROOT)$(PREFIX)/share/icons/ 2>/dev/null || true
	@touch $@

$(STAMPS)/adwaita-icons: $(ADWAITA_TAR) $(STAMPS)/xorgproto
	@echo "=== Building Adwaita icon theme ==="
	cd $(BUILD) && \
	tar xf $(CURDIR)/$(ADWAITA_TAR) && \
	cd adwaita-icon-theme-46.2 && \
	meson setup build --prefix=$(PREFIX) && \
	DESTDIR=$(SYSROOT) ninja -C build install
	@touch $@

# ==============================================================================
# Install to DESTDIR (for rootfs assembly)
# ==============================================================================

install: all
	@echo "=== Installing X11 to $(DESTDIR)$(PREFIX) ==="
	@if [ -z "$(DESTDIR)" ]; then \
		echo "ERROR: DESTDIR must be set (e.g., make install DESTDIR=/mnt/rootfs)"; \
		exit 1; \
	fi
	cp -a $(SYSROOT)/* $(DESTDIR)/
	@echo "X11 installed to $(DESTDIR)"

# ==============================================================================
# Clean
# ==============================================================================

clean:
	rm -rf $(BUILD)
