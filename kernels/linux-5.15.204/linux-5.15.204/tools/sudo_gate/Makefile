# SPDX-License-Identifier: GPL-2.0
#
# sudo_gate - Privilege Grade Wrapper for sudo
#

CC ?= gcc
CFLAGS := -Wall -Wextra -O2 -D_FORTIFY_SOURCE=2 -fstack-protector-strong $(WARN_CFLAGS)
LDFLAGS := -Wl,-z,relro,-z,now

DESTDIR ?=
PREFIX ?= /usr/local
BINDIR := $(DESTDIR)$(PREFIX)/bin
SYSCONFDIR := $(DESTDIR)/etc
LOGDIR := $(DESTDIR)/var/log

TARGET := sudo_gate

.PHONY: all clean install uninstall

all: $(TARGET)

$(TARGET): sudo_gate.c
	$(CC) $(CFLAGS) -o $@ $< $(LDFLAGS)

clean:
	rm -f $(TARGET)

install: $(TARGET)
	@echo "Installing sudo_gate..."
	install -d $(BINDIR)
	install -d $(SYSCONFDIR)
	install -d $(LOGDIR)
	install -m 755 $(TARGET) $(BINDIR)/sudo_gate
	@if [ ! -f $(DESTDIR)/usr/bin/sudo.real ] && [ -f $(DESTDIR)/usr/bin/sudo ]; then \
		mv $(DESTDIR)/usr/bin/sudo $(DESTDIR)/usr/bin/sudo.real; \
	fi
	@if [ -d $(DESTDIR)/usr/bin ]; then \
		ln -sf $(PREFIX)/bin/sudo_gate $(DESTDIR)/usr/bin/sudo; \
	fi
	install -m 644 sudo_gate.conf $(SYSCONFDIR)/sudo_gate.conf
	touch $(LOGDIR)/sudo_gate.log
	chmod 640 $(LOGDIR)/sudo_gate.log
	@echo "sudo_gate installed."

uninstall:
	@echo "Restoring original sudo..."
	rm -f $(DESTDIR)/usr/bin/sudo
	@if [ -f $(DESTDIR)/usr/bin/sudo.real ]; then \
		mv $(DESTDIR)/usr/bin/sudo.real $(DESTDIR)/usr/bin/sudo; \
	fi
	rm -f $(BINDIR)/sudo_gate
	@echo "Original sudo restored."
