# SPDX-License-Identifier: GPL-2.0
# Makefile for system accounts provisioning

PREFIX ?= /usr/local
DESTDIR ?=

.PHONY: all install uninstall clean

all:
	@echo "accounts: shell scripts, nothing to compile"

install:
	install -d $(DESTDIR)$(PREFIX)/sbin
	install -m 755 provision_accounts.sh $(DESTDIR)$(PREFIX)/sbin/provision_accounts

uninstall:
	rm -f $(DESTDIR)$(PREFIX)/sbin/provision_accounts

clean:
	@echo "Nothing to clean"
