# SPDX-License-Identifier: GPL-2.0
#
# Makefile for tandem_equals userspace tool
#
# Copyright (C) 2026 MEARVK LLC
#

CC      := gcc
CFLAGS  := -Wall -Wextra -O2
LDFLAGS :=

PREFIX  ?= /usr/local
BINDIR  := $(PREFIX)/bin

TARGET  := tandem_equals
SRCS    := tandem_equals.c
OBJS    := $(SRCS:.c=.o)

.PHONY: all clean install uninstall

all: $(TARGET)

$(TARGET): $(OBJS)
	$(CC) $(LDFLAGS) -o $@ $^

%.o: %.c
	$(CC) $(CFLAGS) -c -o $@ $<

install: $(TARGET)
	install -d $(DESTDIR)$(BINDIR)
	install -m 755 $(TARGET) $(DESTDIR)$(BINDIR)/$(TARGET)

uninstall:
	rm -f $(DESTDIR)$(BINDIR)/$(TARGET)

clean:
	rm -f $(TARGET) $(OBJS)
