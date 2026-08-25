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
SRC     = xmc.c
PACKSRC = asysma_pack.c
OBJ     = $(SRC:.c=.o)
PACKOBJ = $(PACKSRC:.c=.o)

.PHONY: all clean install uninstall test

# A normal XMC build produces the compiler, packager, and unified driver.
# The unified driver gives developers one compile action that emits both
# .xclass and .asysma without an output-selection flag.
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

uninstall:
	rm -f $(DESTDIR)$(PREFIX)/bin/$(BIN) \
	      $(DESTDIR)$(PREFIX)/bin/$(PACKER) \
	      $(DESTDIR)$(PREFIX)/bin/$(DRIVER)

# Quick smoke test. The unified driver produces both artifacts from one
# developer invocation.
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
	@printf '%s\n' \
	 'class Engine:' \
	 '    def __init__(self, power):' \
	 '        self.power = power' \
	 '    def start(self):' \
	 '        return True' \
	 '    def stop(self):' \
	 '        self.power = 0' > /tmp/Engine.py
	./$(DRIVER) --verbose --frame=eu /tmp/Engine.py
	@echo "--- Generated Python artifacts ---"
	@ls -l /tmp/Engine.xclass /tmp/Engine.asysma
	@echo "--- All tests passed ---"
	@rm -f /tmp/TestClass.java /tmp/TestClass.xclass /tmp/TestClass.asysma /tmp/Engine.py /tmp/Engine.xclass /tmp/Engine.asysma
