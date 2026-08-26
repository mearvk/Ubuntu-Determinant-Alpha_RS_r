# XGCC — Metal-Thin C/C++ Source Interpreter
# Userspace tools and future-generation compile-roll binaries.
#
# Author: Max Rupplin - MEARVK LLC 2026

CC ?= gcc
CFLAGS ?= -O2 -Wall -Wextra -Wpedantic -std=c11
LDFLAGS ?=
PREFIX ?= /usr/local

TARGETS = xgcc xgcc-user xgcc-1 xgcc-2 xgcc-3

all: $(TARGETS)

xgcc: xgcc.c
	$(CC) $(CFLAGS) -o $@ $< $(LDFLAGS)

xgcc-user: xgcc-user.c
	$(CC) $(CFLAGS) -o $@ $< $(LDFLAGS) -lrt -ldl

xgcc-1: xgcc-generations.c
	$(CC) $(CFLAGS) -o $@ $< $(LDFLAGS)

xgcc-2: xgcc-generations.c
	$(CC) $(CFLAGS) -o $@ $< $(LDFLAGS)

xgcc-3: xgcc-generations.c
	$(CC) $(CFLAGS) -o $@ $< $(LDFLAGS)

install: $(TARGETS)
	install -Dm755 xgcc $(DESTDIR)$(PREFIX)/bin/xgcc
	install -Dm755 xgcc-user $(DESTDIR)$(PREFIX)/bin/xgcc-user
	install -Dm755 xgcc-1 $(DESTDIR)$(PREFIX)/bin/xgcc-1
	install -Dm755 xgcc-2 $(DESTDIR)$(PREFIX)/bin/xgcc-2
	install -Dm755 xgcc-3 $(DESTDIR)$(PREFIX)/bin/xgcc-3

uninstall:
	rm -f $(DESTDIR)$(PREFIX)/bin/xgcc
	rm -f $(DESTDIR)$(PREFIX)/bin/xgcc-user
	rm -f $(DESTDIR)$(PREFIX)/bin/xgcc-1
	rm -f $(DESTDIR)$(PREFIX)/bin/xgcc-2
	rm -f $(DESTDIR)$(PREFIX)/bin/xgcc-3

clean:
	rm -f $(TARGETS)

.PHONY: all install uninstall clean
