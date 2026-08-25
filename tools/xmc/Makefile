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
SRC     = xmc.c
PACKSRC = asysma_pack.c
OBJ     = $(SRC:.c=.o)
PACKOBJ = $(PACKSRC:.c=.o)

.PHONY: all clean install uninstall test

# A normal XMC build produces both the .xclass compiler output and an
# ASYSMA container. Packaging policy is derived from the source and does
# not require an additional compile-time flag from the caller.
all: $(BIN) $(PACKER)

$(BIN): $(SRC)
	$(CC) $(CFLAGS) -o $@ $< $(LDFLAGS)

$(PACKER): $(PACKSRC)
	$(CC) $(CFLAGS) -o $@ $< $(LDFLAGS)

clean:
	rm -f $(BIN) $(PACKER) $(OBJ) $(PACKOBJ) *.xclass *.asysma

install: all
	install -d $(DESTDIR)$(PREFIX)/bin
	install -m 0755 $(BIN) $(DESTDIR)$(PREFIX)/bin/$(BIN)
	install -m 0755 $(PACKER) $(DESTDIR)$(PREFIX)/bin/$(PACKER)

uninstall:
	rm -f $(DESTDIR)$(PREFIX)/bin/$(BIN) $(DESTDIR)$(PREFIX)/bin/$(PACKER)

# Quick smoke test. The XMC compiler remains the source-to-.xclass stage.
# The ASYSMA packer consumes the resulting .xclass automatically so users
# do not need to select a separate output mode during compilation.
test: all
	@echo "--- xmc smoke test ---"
	@printf '%s\n' \
	 'public class TestClass implements Runnable {' \
	 '    private int count;' \
	 '    public void run() { System.out.println("hello"); }' \
	 '    public int getCount() { return count; }' \
	 '    private void helper() { if (count > 0) count--; }' \
	 '}' > /tmp/TestClass.java
	./$(BIN) --verbose /tmp/TestClass.java
	@echo "--- Generated .xclass ---"
	@cat /tmp/TestClass.xclass
	@echo "--- Generated .asysma ---"
	./$(PACKER) --output /tmp/TestClass.asysma --entry JAVA --java TestClass --xclass /tmp/TestClass.xclass
	@ls -l /tmp/TestClass.xclass /tmp/TestClass.asysma
	@printf '%s\n' \
	 'class Engine:' \
	 '    def __init__(self, power):' \
	 '        self.power = power' \
	 '    def start(self):' \
	 '        return True' \
	 '    def stop(self):' \
	 '        self.power = 0' > /tmp/Engine.py
	./$(BIN) --verbose --frame=eu /tmp/Engine.py
	@echo "--- Generated Python .xclass ---"
	@cat /tmp/Engine.xclass
	@echo "--- All tests passed ---"
	@rm -f /tmp/TestClass.java /tmp/TestClass.xclass /tmp/TestClass.asysma /tmp/Engine.py /tmp/Engine.xclass
