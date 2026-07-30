# SPDX-License-Identifier: GPL-2.0
#
# Makefile for OpenJDK 28 - Galactic Cherry Marvell Edition 98
#
# Supports two modes:
#   1. Build from included source (make build-from-source)
#   2. Fetch prebuilt binary for quick install (make fetch)
#
# Source: OpenJDK 28 EA Build 8 (GPL-2.0 + Classpath Exception)
# Copyright (C) 2026 MEARVK LLC

SHELL := /bin/bash

PREFIX  ?= /usr
DESTDIR ?=

VERSION := 28
BUILD   := 8
ARCH    := linux-x64
TARBALL := openjdk-$(VERSION)-ea+$(BUILD)_$(ARCH)_bin.tar.gz
SRC_DIR := openjdk-28-src

.PHONY: all fetch build-from-source install install-from-source uninstall clean help

all: fetch

help:
	@echo "OpenJDK $(VERSION) Early Access (Build $(BUILD))"
	@echo ""
	@echo "Targets:"
	@echo "  fetch              - Download prebuilt JDK binary (~227 MB)"
	@echo "  build-from-source  - Compile JDK from included source (requires boot JDK)"
	@echo "  install            - Install prebuilt binary to DESTDIR"
	@echo "  install-from-source- Install source-built JDK to DESTDIR"
	@echo "  clean              - Remove downloaded tarball and build output"
	@echo ""
	@echo "Source: $(SRC_DIR)/ (25,230 files, 451 MB, all < 50 MB)"
	@echo "Install: /usr/lib/jvm/jdk-$(VERSION)"
	@echo ""
	@echo "To build from source you need a boot JDK (JDK 26 or 27):"
	@echo "  make build-from-source BOOT_JDK=/usr/lib/jvm/jdk-27"

# ==============================================================================
# Prebuilt Binary (quick install, ~227 MB download)
# ==============================================================================

fetch: $(TARBALL)

$(TARBALL):
	bash fetch-openjdk.sh "$(CURDIR)"

install: $(TARBALL)
	@if [ -z "$(DESTDIR)" ]; then \
		echo "ERROR: Set DESTDIR (e.g., make install DESTDIR=/mnt/rootfs)"; \
		exit 1; \
	fi
	bash fetch-openjdk.sh "$(CURDIR)" "$(DESTDIR)"

# ==============================================================================
# Build from Source (included in repo)
# ==============================================================================

BOOT_JDK ?= /usr/lib/jvm/jdk-27

build-from-source:
	@if [ ! -d "$(SRC_DIR)/src" ]; then \
		echo "ERROR: Source directory $(SRC_DIR)/src not found"; exit 1; fi
	@if [ ! -x "$(BOOT_JDK)/bin/java" ]; then \
		echo "ERROR: Boot JDK not found at $(BOOT_JDK)"; \
		echo "Set BOOT_JDK=/path/to/jdk-26-or-27"; exit 1; fi
	cd $(SRC_DIR) && \
		bash configure \
			--with-boot-jdk=$(BOOT_JDK) \
			--with-native-debug-symbols=none \
			--enable-unlimited-crypto && \
		make images -j$$(nproc)
	@echo ""
	@echo "JDK built: $(SRC_DIR)/build/linux-x86_64-server-release/images/jdk/"

install-from-source:
	@if [ -z "$(DESTDIR)" ]; then \
		echo "ERROR: Set DESTDIR"; exit 1; fi
	@BUILD_IMG="$(SRC_DIR)/build/linux-x86_64-server-release/images/jdk"; \
	if [ ! -d "$$BUILD_IMG" ]; then \
		echo "ERROR: JDK not built yet. Run 'make build-from-source' first."; exit 1; fi; \
	echo "Installing source-built JDK $(VERSION) to $(DESTDIR)..."; \
	mkdir -p $(DESTDIR)$(PREFIX)/lib/jvm/jdk-$(VERSION); \
	cp -a $$BUILD_IMG/* $(DESTDIR)$(PREFIX)/lib/jvm/jdk-$(VERSION)/; \
	mkdir -p $(DESTDIR)$(PREFIX)/bin; \
	for bin in java javac jar jshell javadoc jlink jpackage; do \
		ln -sf $(PREFIX)/lib/jvm/jdk-$(VERSION)/bin/$$bin $(DESTDIR)$(PREFIX)/bin/$$bin; \
	done; \
	mkdir -p $(DESTDIR)/etc/profile.d; \
	echo 'export JAVA_HOME=$(PREFIX)/lib/jvm/jdk-$(VERSION)' > $(DESTDIR)/etc/profile.d/java.sh; \
	echo 'export PATH=$$JAVA_HOME/bin:$$PATH' >> $(DESTDIR)/etc/profile.d/java.sh; \
	echo "  ✓ Installed to $(DESTDIR)$(PREFIX)/lib/jvm/jdk-$(VERSION)"

# ==============================================================================
# Clean
# ==============================================================================

uninstall:
	rm -rf $(DESTDIR)$(PREFIX)/lib/jvm/jdk-$(VERSION)
	rm -f $(DESTDIR)$(PREFIX)/bin/java
	rm -f $(DESTDIR)$(PREFIX)/bin/javac
	rm -f $(DESTDIR)$(PREFIX)/bin/jar
	rm -f $(DESTDIR)$(PREFIX)/bin/jshell
	rm -f $(DESTDIR)$(PREFIX)/bin/javadoc
	rm -f $(DESTDIR)$(PREFIX)/bin/jlink
	rm -f $(DESTDIR)$(PREFIX)/bin/jpackage
	rm -f $(DESTDIR)/etc/profile.d/java.sh

clean:
	rm -f $(TARBALL)
	rm -rf $(SRC_DIR)/build
