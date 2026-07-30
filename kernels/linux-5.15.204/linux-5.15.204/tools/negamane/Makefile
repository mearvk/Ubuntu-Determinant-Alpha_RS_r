# SPDX-License-Identifier: GPL-2.0
# Makefile for negamane userspace tool

PREFIX ?= /usr/local
DESTDIR ?=

.PHONY: all install uninstall clean

all:
	@echo "negamane: prebuilt binary, nothing to compile"

install:
	install -d $(DESTDIR)$(PREFIX)/bin
	install -m 755 negamane $(DESTDIR)$(PREFIX)/bin/negamane

uninstall:
	rm -f $(DESTDIR)$(PREFIX)/bin/negamane

clean:
	@echo "Nothing to clean"
