# xmc — XML Metaclass Compiler
# Copyright (C) 2026 MEARVK LLC
# SPDX-License-Identifier: GPL-2.0 WITH Classpath-exception-2.0

CC      ?= gcc
CFLAGS  ?= -Wall -Wextra -Werror -O2 -std=c11 -D_GNU_SOURCE \
           -Wno-stringop-truncation -Wno-format-truncation
LDFLAGS ?= -lm
PREFIX  ?= /usr/local

BIN     = xmc
PACKER  = asysma_pack
DRIVER  = xmc-build
DESKTOP = xmc-install-desktop.sh
SRC     = xmc.c
PACKSRC = asysma_pack.c
OBJ     = $(SRC:.c=.o)
PACKOBJ = $(PACKSRC:.c=.o)

.PHONY: all clean install uninstall test process-test

# A normal XMC build produces the compiler, packager, and unified driver.
# The unified driver gives developers one compile action that emits both
# .xclass and a localized .asysma beside the input source.
all: $(BIN) $(PACKER) $(DRIVER)

$(BIN): $(SRC)
	$(CC) $(CFLAGS) -o $@ $< $(LDFLAGS)

$(PACKER): $(PACKSRC)
	$(CC) $(CFLAGS) -o $@ $< $(LDFLAGS)

$(DRIVER):
	chmod +x $@

clean:
	rm -f $(BIN) $(PACKER) $(OBJ) $(PACKOBJ) *.xclass *.asysma

install: all
	install -d $(DESTDIR)$(PREFIX)/bin
	install -m 0755 $(BIN) $(DESTDIR)$(PREFIX)/bin/$(BIN)
	install -m 0755 $(PACKER) $(DESTDIR)$(PREFIX)/bin/$(PACKER)
	install -m 0755 $(DRIVER) $(DESTDIR)$(PREFIX)/bin/$(DRIVER)
	install -m 0755 $(DESKTOP) $(DESTDIR)$(PREFIX)/bin/$(DESKTOP)

uninstall:
	rm -f $(DESTDIR)$(PREFIX)/bin/$(BIN) \
	      $(DESTDIR)$(PREFIX)/bin/$(PACKER) \
	      $(DESTDIR)$(PREFIX)/bin/$(DRIVER) \
	      $(DESTDIR)$(PREFIX)/bin/$(DESKTOP)

# Original lightweight smoke test.
test: all
	@echo "--- xmc unified dual-output smoke test ---"
	@printf '%s\n' \
	 'public class TestClass implements Runnable {' \
	 '    private int count;' \
	 '    public void run() { System.out.println("hello"); }' \
	 '    public int getCount() { return count; }' \
	 '    private void helper() { if (count > 0) count--; }' \
	 '}' > /tmp/TestClass.java
	./$(DRIVER) --verbose /tmp/TestClass.java
	@echo "--- Generated artifacts ---"
	@ls -l /tmp/TestClass.xclass /tmp/TestClass.asysma
	@rm -f /tmp/TestClass.java /tmp/TestClass.xclass /tmp/TestClass.asysma

# Full Java/C/C++ and desktop-localization rehearsal.
process-test: all
	@chmod +x $(DESKTOP) tools/xmc/tests/run-xmc-process.sh 2>/dev/null || true
	@./tests/run-xmc-process.sh
