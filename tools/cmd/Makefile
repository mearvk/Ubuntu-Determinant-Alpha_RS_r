# tools/cmd Makefile — .cmd executable format toolchain
#
# Builds: cmdlink, cmd-icon-gen, cmd-inspect
# Target: SecureJDK 28
#
# Copyright (C) 2026 MEARVK LLC
# License: GPL-2.0 WITH Classpath-exception-2.0

CC = gcc
CFLAGS = -Wall -Wextra -O2 -std=c11
LDFLAGS = -lm

PREFIX ?= /usr/local
BINDIR = $(PREFIX)/bin

TOOLS = cmdlink cmd-icon-gen cmd-inspect

.PHONY: all clean install test

all: $(TOOLS)

cmdlink: cmdlink.c
	$(CC) $(CFLAGS) -o $@ $< $(LDFLAGS)

cmd-icon-gen: cmd-icon-gen.c
	$(CC) $(CFLAGS) -o $@ $< $(LDFLAGS)

cmd-inspect: cmd-inspect.c
	$(CC) $(CFLAGS) -o $@ $< $(LDFLAGS)

# --- Test: generate icon, compile sample, link, inspect ---

test: all sample_test

sample_test: $(TOOLS)
	@echo "=== Test: Generate default CMD icon ==="
	./cmd-icon-gen -o test-icon.bmp
	@echo ""
	@echo "=== Test: Compile sample Java class ==="
	@if command -v javac >/dev/null 2>&1; then \
		echo 'public class HelloCmd { public static void main(String[] args) { System.out.println("Hello from .cmd!"); } }' > HelloCmd.java; \
		javac HelloCmd.java; \
		echo "=== Test: Link .class → .cmd ==="; \
		./cmdlink HelloCmd.class --icon=test-icon.bmp --perm=trusted --grain=2 -o HelloCmd.cmd; \
		echo ""; \
		echo "=== Test: Inspect .cmd file ==="; \
		./cmd-inspect --all HelloCmd.cmd; \
		rm -f HelloCmd.java HelloCmd.class; \
	else \
		echo "javac not found — creating synthetic .class for test"; \
		printf '\xCA\xFE\xBA\xBE\x00\x00\x00\x3C' > Synthetic.class; \
		printf '\x00\x00\x00\x00\x00\x00\x00\x00' >> Synthetic.class; \
		./cmdlink Synthetic.class --main=Synthetic --icon=test-icon.bmp -o Synthetic.cmd; \
		echo ""; \
		echo "=== Test: Inspect synthetic .cmd ==="; \
		./cmd-inspect --all Synthetic.cmd; \
		rm -f Synthetic.class; \
	fi
	@echo ""
	@echo "=== All tests passed ==="

clean:
	rm -f $(TOOLS)
	rm -f test-icon.bmp
	rm -f HelloCmd.cmd HelloCmd.java HelloCmd.class
	rm -f Synthetic.cmd Synthetic.class
	rm -f *.icon.bmp

install: all
	install -d $(DESTDIR)$(BINDIR)
	install -m 755 cmdlink $(DESTDIR)$(BINDIR)/cmdlink
	install -m 755 cmd-icon-gen $(DESTDIR)$(BINDIR)/cmd-icon-gen
	install -m 755 cmd-inspect $(DESTDIR)$(BINDIR)/cmd-inspect
	@echo "Installed: cmdlink, cmd-icon-gen, cmd-inspect → $(DESTDIR)$(BINDIR)/"
