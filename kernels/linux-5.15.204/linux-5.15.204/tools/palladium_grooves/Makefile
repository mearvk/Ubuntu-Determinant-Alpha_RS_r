# SPDX-License-Identifier: GPL-2.0
#
# Makefile for palladium_grooves userspace tool
#
# Copyright (C) 2026 MEARVK LLC
#

CC      := gcc
CFLAGS  := -Wall -Wextra -O2 -lm $(WARN_CFLAGS)
LDFLAGS := -lm

PREFIX  ?= /usr/local
BINDIR  := $(PREFIX)/bin

TARGET  := palladium_grooves
SRCS    := palladium_grooves.c
OBJS    := $(SRCS:.c=.o)

.PHONY: all clean install uninstall

all: $(TARGET)

$(TARGET): $(OBJS)
	$(CC) -o $@ $^ $(LDFLAGS)

%.o: %.c
	$(CC) $(CFLAGS) -c -o $@ $<

install: $(TARGET)
	install -d $(DESTDIR)$(BINDIR)
	install -m 755 $(TARGET) $(DESTDIR)$(BINDIR)/$(TARGET)

uninstall:
	rm -f $(DESTDIR)$(BINDIR)/$(TARGET)

clean:
	rm -f $(TARGET) $(OBJS)
