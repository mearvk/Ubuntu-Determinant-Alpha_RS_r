# xmc — XML Metaclass Compiler
# Copyright (C) 2026 MEARVK LLC
# SPDX-License-Identifier: GPL-2.0 WITH Classpath-exception-2.0

CC      ?= gcc
CFLAGS  ?= -Wall -Wextra -Werror -O2 -std=c11 -D_GNU_SOURCE \
           -Wno-stringop-truncation -Wno-format-truncation
LDFLAGS ?= -lm
PREFIX  ?= /usr/local

BIN        = xmc
CORE       = xmc-core
PACKER     = asysma_pack
BOOTSTRAP  = asysma-bootstrap
DRIVER_SRC = xmc-driver.c
REG_SRC    = xmc-os-register.c
REG_HDR    = xmc-os-register.h
DRIVER     = xmc-build
DESKTOP    = xmc-install-desktop.sh
SRC        = xmc.c
PACKSRC    = asysma_pack.c
BOOT_SRC   = asysma-bootstrap.c

.PHONY: all clean install uninstall test process-test

# Public xmc is the integrated compiler/package driver.
# The OS registration helper is linked into xmc so every ASYSMA build has
# access to the Linux/Windows/macOS registration handshake.
all: $(BIN) $(PACKER) $(BOOTSTRAP) $(DRIVER)

$(CORE): $(SRC)
	$(CC) $(CFLAGS) -o $@ $< $(LDFLAGS)

$(PACKER): $(PACKSRC) asysma_native_layout.h
	$(CC) $(CFLAGS) -o $@ $< $(LDFLAGS)

$(BOOTSTRAP): $(BOOT_SRC) asysma_native_layout.h
	$(CC) $(CFLAGS) -o $@ $(BOOT_SRC)

$(BIN): $(DRIVER_SRC) $(REG_SRC) $(REG_HDR) $(CORE) $(PACKER) $(BOOTSTRAP)
	$(CC) $(CFLAGS) -o $@ $(DRIVER_SRC) $(REG_SRC) $(LDFLAGS)

$(DRIVER):
	chmod +x $@

clean:
	rm -f $(BIN) $(CORE) $(PACKER) $(BOOTSTRAP) *.o *.xclass *.asysma

install: all
	install -d $(DESTDIR)$(PREFIX)/bin
	install -m 0755 $(BIN) $(DESTDIR)$(PREFIX)/bin/$(BIN)
	install -m 0755 $(CORE) $(DESTDIR)$(PREFIX)/bin/$(CORE)
	install -m 0755 $(PACKER) $(DESTDIR)$(PREFIX)/bin/$(PACKER)
	install -m 0755 $(BOOTSTRAP) $(DESTDIR)$(PREFIX)/bin/$(BOOTSTRAP)
	install -m 0755 $(DRIVER) $(DESTDIR)$(PREFIX)/bin/$(DRIVER)
	install -m 0755 xmc-asysma-launcher.sh $(DESTDIR)$(PREFIX)/bin/xmc-asysma-launcher.sh
	install -d $(DESTDIR)$(PREFIX)/share/icons $(DESTDIR)$(PREFIX)/share/mime/packages
	install -m 0644 xmc-icon.svg $(DESTDIR)$(PREFIX)/share/icons/xmc-asysma.svg
	install -m 0644 asysma-mime.xml $(DESTDIR)$(PREFIX)/share/mime/packages/asysma.xml

uninstall:
	rm -f $(DESTDIR)$(PREFIX)/bin/$(BIN) $(DESTDIR)$(PREFIX)/bin/$(CORE) \
	      $(DESTDIR)$(PREFIX)/bin/$(PACKER) $(DESTDIR)$(PREFIX)/bin/$(BOOTSTRAP) \
	      $(DESTDIR)$(PREFIX)/bin/$(DRIVER) $(DESTDIR)$(PREFIX)/bin/xmc-asysma-launcher.sh \
	      $(DESTDIR)$(PREFIX)/share/icons/xmc-asysma.svg \
	      $(DESTDIR)$(PREFIX)/share/mime/packages/asysma.xml

test: all
	@printf '%s\n' 'public class TestClass { public static void main(String[] a) {} }' > /tmp/TestClass.java
	./$(BIN) --verbose /tmp/TestClass.java || test $$? -eq 1
	@ls -l /tmp/TestClass.xclass /tmp/TestClass.asysma.desktop
	@rm -f /tmp/TestClass.java /tmp/TestClass.xclass /tmp/TestClass.asysma /tmp/TestClass.asysma.desktop

process-test: all
	@chmod +x $(DESKTOP) tests/run-xmc-process.sh 2>/dev/null || true
	@./tests/run-xmc-process.sh
