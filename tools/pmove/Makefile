# SPDX-License-Identifier: GPL-2.0
#
# pmove — explicit Parallel Move userspace tool
#
# The implementation is shared with tools/pcopy/pcopy.c.

CC      = gcc
CFLAGS  = -Wall -Wextra -O2 -D_GNU_SOURCE
PREFIX  = /usr/local
BINDIR  = $(PREFIX)/bin

.PHONY: all install uninstall clean

all: pmove

pmove: pmove.c ../pcopy/pcopy.c
	$(CC) $(CFLAGS) -o $@ pmove.c

install: pmove
	install -m 755 pmove $(DESTDIR)$(BINDIR)/pmove

uninstall:
	rm -f $(DESTDIR)$(BINDIR)/pmove

clean:
	rm -f pmove
