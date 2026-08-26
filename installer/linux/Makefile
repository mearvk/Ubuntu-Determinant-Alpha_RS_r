.PHONY: all clean install uninstall

CC ?= cc
CFLAGS ?= -std=c11 -O2 -Wall -Wextra -Wpedantic
TARGET := desktop_install_probe
SRC := desktop_install_probe.c
PREFIX ?= $(HOME)/.local
BINDIR := $(PREFIX)/bin

all: $(TARGET)

$(TARGET): $(SRC)
	$(CC) $(CFLAGS) -o $@ $<

install: $(TARGET)
	install -d $(BINDIR)
	install -m 0755 $(TARGET) $(BINDIR)/$(TARGET)

uninstall:
	rm -f $(BINDIR)/$(TARGET)

clean:
	rm -f $(TARGET)
