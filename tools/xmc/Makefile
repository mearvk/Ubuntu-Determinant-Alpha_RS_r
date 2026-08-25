# xmc — XML Metaclass Compiler
# Copyright (C) 2026 MEARVK LLC
# SPDX-License-Identifier: GPL-2.0 WITH Classpath-exception-2.0

CC      ?= cc
CFLAGS  ?= -Wall -Wextra -Werror -O2 -std=c11
CPPFLAGS ?=
LDFLAGS ?= -lm
PREFIX  ?= /usr/local

BIN        = xmc
CORE       = xmc-core
PACKER     = asysma_pack
BOOTSTRAP  = asysma-bootstrap
DRIVER_SRC = xmc-driver.c
REG_SRC    = xmc-os-register.c
REG_HDR    = xmc-os-register.h
SRC        = xmc.c
PACKSRC    = asysma_pack.c
BOOT_SRC   = asysma-bootstrap.c

COMMON_CPPFLAGS = $(CPPFLAGS) -DXMC_INSTALL_PREFIX=\"$(PREFIX)\"
COMMON_CFLAGS   = $(CFLAGS) $(COMMON_CPPFLAGS)

.PHONY: all clean install uninstall test process-test clean-user-integration

all: $(BIN) $(PACKER) $(BOOTSTRAP)

$(CORE): $(SRC)
	$(CC) $(COMMON_CFLAGS) -o $@ $< $(LDFLAGS)

$(PACKER): $(PACKSRC) asysma_native_layout.h
	$(CC) $(COMMON_CFLAGS) -o $@ $< $(LDFLAGS)

$(BOOTSTRAP): $(BOOT_SRC) asysma_native_layout.h
	$(CC) $(COMMON_CFLAGS) -o $@ $(BOOT_SRC)

$(BIN): $(DRIVER_SRC) $(REG_SRC) $(REG_HDR) $(CORE) $(PACKER) $(BOOTSTRAP)
	$(CC) $(COMMON_CFLAGS) -o $@ $(DRIVER_SRC) $(REG_SRC) $(LDFLAGS)

clean:
	rm -f $(BIN) $(CORE) $(PACKER) $(BOOTSTRAP) *.o *.xclass *.asysma *.desktop

install: all
	install -d $(DESTDIR)$(PREFIX)/bin
	install -m 0755 $(BIN) $(DESTDIR)$(PREFIX)/bin/$(BIN)
	install -m 0755 $(CORE) $(DESTDIR)$(PREFIX)/bin/$(CORE)
	install -m 0755 $(PACKER) $(DESTDIR)$(PREFIX)/bin/$(PACKER)
	install -m 0755 $(BOOTSTRAP) $(DESTDIR)$(PREFIX)/bin/$(BOOTSTRAP)
	install -d $(DESTDIR)$(PREFIX)/share/icons/hicolor/scalable/apps
	install -m 0644 xmc-icon.svg $(DESTDIR)$(PREFIX)/share/icons/hicolor/scalable/apps/xmc-asysma.svg
	install -d $(DESTDIR)$(PREFIX)/share/mime/packages
	install -m 0644 asysma-mime.xml $(DESTDIR)$(PREFIX)/share/mime/packages/xmc-asysma.xml

clean-user-integration:
	@true

uninstall:
	rm -f $(DESTDIR)$(PREFIX)/bin/$(BIN) $(DESTDIR)$(PREFIX)/bin/$(CORE) \
	      $(DESTDIR)$(PREFIX)/bin/$(PACKER) $(DESTDIR)$(PREFIX)/bin/$(BOOTSTRAP) \
	      $(DESTDIR)$(PREFIX)/share/icons/hicolor/scalable/apps/xmc-asysma.svg \
	      $(DESTDIR)$(PREFIX)/share/mime/packages/xmc-asysma.xml

test: all
	@printf '%s\n' 'public class TestClass { public static void main(String[] a) {} }' > /tmp/TestClass.java
	./$(BIN) /tmp/TestClass.java || test $$? -eq 1
	@rm -f /tmp/TestClass.java /tmp/TestClass.xclass /tmp/TestClass.asysma /tmp/TestClass.asysma.desktop

process-test: all
	@chmod +x ./tests/run-xmc-process.sh
	@./tests/run-xmc-process.sh
