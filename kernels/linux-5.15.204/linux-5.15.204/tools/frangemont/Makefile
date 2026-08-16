# SPDX-License-Identifier: GPL-2.0
#
# Makefile for frangemont-postmail-ps
# Byte-Level Package Safety Inspection Daemon
#
# Copyright (C) 2026 MEARVK LLC

CC      = gcc
CFLAGS  = -Wall -Wextra -Wno-unused-result -Wno-unused-function -O2 -D_GNU_SOURCE -D_FILE_OFFSET_BITS=64
LDFLAGS = -lpthread -lcrypto -lm
PREFIX  = /usr/local
BINDIR  = $(PREFIX)/sbin
CONFDIR = /etc
UNITDIR = /etc/systemd/system
APTDIR  = /etc/apt/apt.conf.d
LOGDIR  = /var/log/frangemont
SPOOLDIR = /var/spool/frangemont

TARGET  = frangemont-postmail-ps

.PHONY: all clean install uninstall

all: $(TARGET)

$(TARGET): frangemont_postmail_ps.c
	$(CC) $(CFLAGS) -o $@ $< $(LDFLAGS)

clean:
	rm -f $(TARGET)

install: $(TARGET)
	@echo "Installing $(TARGET)..."
	install -Dm755 $(TARGET) $(DESTDIR)$(BINDIR)/$(TARGET)
	install -Dm644 frangemont-postmail-ps.conf $(DESTDIR)$(CONFDIR)/frangemont-postmail-ps.conf
	install -Dm644 frangemont-postmail-ps.service $(DESTDIR)$(UNITDIR)/frangemont-postmail-ps.service
	install -Dm644 98frangemont-pre $(DESTDIR)$(APTDIR)/98frangemont-pre
	install -Dm644 99frangemont-post $(DESTDIR)$(APTDIR)/99frangemont-post
	install -Dm755 frangemont-apt-hook $(DESTDIR)$(PREFIX)/lib/frangemont-apt-hook
	install -d $(DESTDIR)$(LOGDIR)
	install -d $(DESTDIR)$(SPOOLDIR)
	@echo ""
	@echo "Installed. Enable with:"
	@echo "  systemctl daemon-reload"
	@echo "  systemctl enable --now frangemont-postmail-ps"
	@echo ""

uninstall:
	rm -f $(DESTDIR)$(BINDIR)/$(TARGET)
	rm -f $(DESTDIR)$(CONFDIR)/frangemont-postmail-ps.conf
	rm -f $(DESTDIR)$(UNITDIR)/frangemont-postmail-ps.service
	rm -f $(DESTDIR)$(APTDIR)/98frangemont-pre
	rm -f $(DESTDIR)$(APTDIR)/99frangemont-post
	rm -f $(DESTDIR)$(PREFIX)/lib/frangemont-apt-hook
	systemctl disable frangemont-postmail-ps 2>/dev/null || true
	@echo "Uninstalled."
