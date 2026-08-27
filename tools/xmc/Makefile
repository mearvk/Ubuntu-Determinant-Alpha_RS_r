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
SHA_SRC    = xmc-sha256.c
SHA_HDR    = xmc-sha256.h
SRC        = xmc.c
PACKSRC    = asysma_pack.c
BOOT_SRC   = asysma-bootstrap.c

COMMON_CPPFLAGS = $(CPPFLAGS) -DXMC_INSTALL_PREFIX=\"$(PREFIX)\"
COMMON_CFLAGS   = $(CFLAGS) $(COMMON_CPPFLAGS) -include BUILD-POSIX-COMPAT.h \
                  -Wno-error=stringop-truncation -Wno-error=format-truncation

SANITIZER_CFLAGS  = -fsanitize=address,undefined -fno-omit-frame-pointer -g -O1
SANITIZER_LDFLAGS = -fsanitize=address,undefined -lm

.PHONY: all clean install uninstall test process-test sanitize-test check-version security-test clean-user-integration

all: $(BIN) $(PACKER) $(BOOTSTRAP)

$(CORE): $(SRC) BUILD-POSIX-COMPAT.h
	$(CC) $(COMMON_CFLAGS) -o $@ $< $(LDFLAGS)

$(PACKER): $(PACKSRC) asysma_native_layout.h
	$(CC) $(COMMON_CFLAGS) -o $@ $< $(LDFLAGS)

$(BOOTSTRAP): $(BOOT_SRC) asysma_native_layout.h
	$(CC) $(COMMON_CFLAGS) -o $@ $(BOOT_SRC) $(LDFLAGS)

$(BIN): $(DRIVER_SRC) $(REG_SRC) $(REG_HDR) $(SHA_SRC) $(SHA_HDR) $(CORE) $(PACKER) $(BOOTSTRAP)
	$(CC) $(COMMON_CFLAGS) -o $@ $(DRIVER_SRC) $(REG_SRC) $(SHA_SRC) $(LDFLAGS)

check-version:
	@sh ./tests/test_version.sh

security-test: all
	@sh ./tests/test_security.sh

clean:
	rm -f $(BIN) $(CORE) $(PACKER) $(BOOTSTRAP) *.o

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
	rm -f $(DESTDIR)$(PREFIX)/share/icons/hicolor/scalable/mimetypes/xmc-asysma.svg

# Development-only sanitizer build. This deliberately does not overwrite the
# normal release binaries.
sanitize-test:
	@set -e; \
	$(CC) $(COMMON_CFLAGS) $(SANITIZER_CFLAGS) -o xmc-core-sanitize $(SRC) $(SANITIZER_LDFLAGS); \
	$(CC) $(COMMON_CFLAGS) $(SANITIZER_CFLAGS) -o asysma_pack-sanitize $(PACKSRC) $(SANITIZER_LDFLAGS); \
	$(CC) $(COMMON_CFLAGS) $(SANITIZER_CFLAGS) -o asysma-bootstrap-sanitize $(BOOT_SRC) $(SANITIZER_LDFLAGS); \
	$(CC) $(COMMON_CFLAGS) $(SANITIZER_CFLAGS) -o xmc-sha256-test xmc-sha256.c tests/test_sha256.c $(SANITIZER_LDFLAGS); \
	sh ./tests/test_sanitized.sh ./xmc-core-sanitize; \
	./xmc-sha256-test; \
	rm -f xmc-core-sanitize asysma_pack-sanitize asysma-bootstrap-sanitize xmc-sha256-test

test: all check-version
	@sh ./tests/test_xmc.sh

process-test: all
	@sh ./tests/test_xmc_process.sh
