# Makefile for Psych-ID — Network Intelligence & Web Analysis
# Including: 3rd Order Congregation Sorter (binding reagent)
#
# Part of Ubuntu Determinant Alpha RS — Galactic Cherry Marvell Edition 98
# Copyright (C) 2026 MEARVK LLC
# License: GPL-2.0

CC      = gcc
CFLAGS  = -Wall -Wextra -O2 -std=c11 -D_GNU_SOURCE
LDFLAGS = -lsqlite3 -lssl -lcrypto -lpthread
PREFIX  = /usr/local
BINDIR  = $(PREFIX)/bin
CONFDIR = /etc/psych-id
DATADIR = /var/lib/psych-id
LOGDIR  = /var/log

SOURCES = psych_id.c congregation_sorter.c
HEADERS = psych_id.h congregation_sorter.h
TARGET  = psych-id

.PHONY: all clean install uninstall

all: $(TARGET)

$(TARGET): $(SOURCES) $(HEADERS)
	$(CC) $(CFLAGS) -o $@ $(SOURCES) $(LDFLAGS)

clean:
	rm -f $(TARGET)

install: $(TARGET)
	@echo "Installing Psych-ID + Congregation Sorter..."
	install -d $(DESTDIR)$(BINDIR)
	install -d $(DESTDIR)$(CONFDIR)
	install -d $(DESTDIR)$(DATADIR)
	install -m 755 $(TARGET) $(DESTDIR)$(BINDIR)/$(TARGET)
	@if [ ! -f $(DESTDIR)$(CONFDIR)/psych-id.conf ]; then \
		install -m 644 psych_id.conf $(DESTDIR)$(CONFDIR)/psych-id.conf; \
	fi
	@if [ ! -f $(DESTDIR)$(CONFDIR)/targets.txt ]; then \
		echo "# Psych-ID scan targets (one host per line)" > $(DESTDIR)$(CONFDIR)/targets.txt; \
		echo "# Example:" >> $(DESTDIR)$(CONFDIR)/targets.txt; \
		echo "# 192.168.1.1" >> $(DESTDIR)$(CONFDIR)/targets.txt; \
		echo "# example.com" >> $(DESTDIR)$(CONFDIR)/targets.txt; \
		chmod 644 $(DESTDIR)$(CONFDIR)/targets.txt; \
	fi
	@echo "Psych-ID installed to $(DESTDIR)$(BINDIR)/$(TARGET)"
	@echo "  Includes: 3rd Order Congregation Sorter (binding reagent)"
	@echo "Config: $(DESTDIR)$(CONFDIR)/psych-id.conf"
	@echo "Targets: $(DESTDIR)$(CONFDIR)/targets.txt"
	@echo "Database: $(DESTDIR)$(DATADIR)/suspects.db (created on first run)"

uninstall:
	rm -f $(DESTDIR)$(BINDIR)/$(TARGET)
	@echo "Binary removed. Config and database preserved."
	@echo "To fully remove: rm -rf $(CONFDIR) $(DATADIR)"
