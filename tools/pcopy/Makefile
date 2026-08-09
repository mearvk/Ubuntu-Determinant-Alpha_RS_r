# SPDX-License-Identifier: GPL-2.0
#
# pcopy/pmove — Parallel Copy/Move userspace tools
#

CC      = gcc
CFLAGS  = -Wall -Wextra -O2 -D_GNU_SOURCE
PREFIX  = /usr/local
BINDIR  = $(PREFIX)/bin

.PHONY: all install uninstall clean

all: pcopy

pcopy: pcopy.c
	$(CC) $(CFLAGS) -o $@ $<

install: pcopy
	install -m 755 pcopy $(DESTDIR)$(BINDIR)/pcopy
	ln -sf pcopy $(DESTDIR)$(BINDIR)/pmove

uninstall:
	rm -f $(DESTDIR)$(BINDIR)/pcopy
	rm -f $(DESTDIR)$(BINDIR)/pmove

clean:
	rm -f pcopy
