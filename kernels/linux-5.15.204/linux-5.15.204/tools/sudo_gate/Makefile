# SPDX-License-Identifier: GPL-2.0
#
# sudo_gate - Privilege Grade Wrapper for sudo
#

CC ?= gcc
CFLAGS := -Wall -Wextra -O2 -D_FORTIFY_SOURCE=2 -fstack-protector-strong
LDFLAGS := -Wl,-z,relro,-z,now

PREFIX ?= /usr/local
BINDIR := $(PREFIX)/bin
SYSCONFDIR := /etc
LOGDIR := /var/log

TARGET := sudo_gate

.PHONY: all clean install uninstall

all: $(TARGET)

$(TARGET): sudo_gate.c
	$(CC) $(CFLAGS) -o $@ $< $(LDFLAGS)

clean:
	rm -f $(TARGET)

install: $(TARGET)
	@echo "Installing sudo_gate..."
	@echo ""
	@echo "This will:"
	@echo "  1. Move /usr/bin/sudo -> /usr/bin/sudo.real"
	@echo "  2. Install sudo_gate as /usr/bin/sudo"
	@echo "  3. Install config to /etc/sudo_gate.conf"
	@echo ""
	@echo "Press Ctrl+C to abort, or Enter to continue..."
	@read dummy
	install -m 4755 -o root -g root $(TARGET) $(BINDIR)/sudo_gate
	@if [ ! -f /usr/bin/sudo.real ]; then \
		mv /usr/bin/sudo /usr/bin/sudo.real; \
	fi
	ln -sf $(BINDIR)/sudo_gate /usr/bin/sudo
	install -m 644 sudo_gate.conf $(SYSCONFDIR)/sudo_gate.conf
	touch $(LOGDIR)/sudo_gate.log
	chmod 640 $(LOGDIR)/sudo_gate.log
	@echo ""
	@echo "sudo_gate installed. Original sudo preserved at /usr/bin/sudo.real"
	@echo "To bypass gate: /usr/bin/sudo.real <cmd>"

uninstall:
	@echo "Restoring original sudo..."
	rm -f /usr/bin/sudo
	@if [ -f /usr/bin/sudo.real ]; then \
		mv /usr/bin/sudo.real /usr/bin/sudo; \
	fi
	rm -f $(BINDIR)/sudo_gate
	@echo "Original sudo restored."
