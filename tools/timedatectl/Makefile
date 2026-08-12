# SPDX-License-Identifier: GPL-2.0
#
# Makefile for timedatectl-extended
# Builds a replacement timedatectl that supports years up to 28808.
#
# Copyright (C) 2026 MEARVK LLC

CC      ?= gcc
CFLAGS   = -O2 -Wall -Wextra -std=gnu11
LDFLAGS  = $(shell pkg-config --libs libsystemd) -lm
CFLAGS  += $(shell pkg-config --cflags libsystemd)

PREFIX  ?= /usr/local
BINDIR   = $(PREFIX)/bin

TARGET   = timedatectl-extended
SOURCE   = timedatectl-extended.c
HEADER   = time-util-extended.h

.PHONY: all install uninstall clean check

all: $(TARGET)

$(TARGET): $(SOURCE) $(HEADER)
	$(CC) $(CFLAGS) -o $@ $(SOURCE) $(LDFLAGS)
	@echo ""
	@echo "Built: $(TARGET)"
	@echo "Year range: 1970–28808"
	@echo ""

install: $(TARGET)
	@echo "Installing timedatectl-extended..."
	install -m 755 $(TARGET) $(BINDIR)/timedatectl-extended
	@echo ""
	@echo "Installed to: $(BINDIR)/timedatectl-extended"
	@echo ""
	@echo "To replace system timedatectl:"
	@echo "  sudo cp /usr/bin/timedatectl /usr/bin/timedatectl.orig"
	@echo "  sudo ln -sf $(BINDIR)/timedatectl-extended /usr/bin/timedatectl"
	@echo ""
	@echo "To restore original:"
	@echo "  sudo cp /usr/bin/timedatectl.orig /usr/bin/timedatectl"

uninstall:
	rm -f $(BINDIR)/timedatectl-extended
	@echo "Uninstalled."

clean:
	rm -f $(TARGET)

# Quick sanity check: parse a far-future date
check: $(TARGET)
	@echo "=== Sanity Check ==="
	./$(TARGET) --version
	@echo ""
	@echo "--- Parsing year 2502 ---"
	./$(TARGET) set-time "2502-06-15 12:00:00" 2>&1 || true
	@echo ""
	@echo "--- Parsing year 28808 ---"
	./$(TARGET) set-time "28808-01-01 00:00:00" 2>&1 || true
	@echo ""
	@echo "--- Parsing invalid year 28809 (should fail) ---"
	./$(TARGET) set-time "28809-01-01 00:00:00" 2>&1 || true
	@echo ""
	@echo "=== Done ==="
