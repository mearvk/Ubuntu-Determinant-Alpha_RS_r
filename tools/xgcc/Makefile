# xgcc — Metal-Thin C/C++ Source Interpreter
# Makefile for userspace tools
#
# Builds two binaries:
#   xgcc       — Thin client that submits to kernel module (/dev/xgcc)
#   xgcc-user  — Standalone userland interpreter (no kernel module needed)

CC = gcc
CFLAGS = -O2 -Wall -Wextra -std=c11
LDFLAGS =
PREFIX = /usr/local

TARGETS = xgcc xgcc-user

all: $(TARGETS)

xgcc: xgcc.c
	$(CC) $(CFLAGS) -o $@ $< $(LDFLAGS)

xgcc-user: xgcc-user.c
	$(CC) $(CFLAGS) -o $@ $< $(LDFLAGS) -lrt

install: $(TARGETS)
	install -Dm755 xgcc $(DESTDIR)$(PREFIX)/bin/xgcc
	install -Dm755 xgcc-user $(DESTDIR)$(PREFIX)/bin/xgcc-user

uninstall:
	rm -f $(DESTDIR)$(PREFIX)/bin/xgcc
	rm -f $(DESTDIR)$(PREFIX)/bin/xgcc-user

clean:
	rm -f $(TARGETS)

.PHONY: all install uninstall clean
