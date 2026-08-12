# xmc — XML Metaclass Compiler
# Copyright (C) 2026 MEARVK LLC
# SPDX-License-Identifier: GPL-2.0 WITH Classpath-exception-2.0

CC      ?= gcc
CFLAGS  ?= -Wall -Wextra -Werror -O2 -std=c11 -D_GNU_SOURCE \
           -Wno-stringop-truncation -Wno-format-truncation
LDFLAGS ?= -lm
PREFIX  ?= /usr/local

BIN     = xmc
SRC     = xmc.c
OBJ     = $(SRC:.c=.o)

.PHONY: all clean install uninstall test

all: $(BIN)

$(BIN): $(SRC)
	$(CC) $(CFLAGS) -o $@ $< $(LDFLAGS)

clean:
	rm -f $(BIN) $(OBJ) *.xclass

install: $(BIN)
	install -d $(DESTDIR)$(PREFIX)/bin
	install -m 0755 $(BIN) $(DESTDIR)$(PREFIX)/bin/$(BIN)

uninstall:
	rm -f $(DESTDIR)$(PREFIX)/bin/$(BIN)

# Quick smoke test
test: $(BIN)
	@echo "--- xmc smoke test ---"
	@echo 'public class TestClass implements Runnable {' > /tmp/TestClass.java
	@echo '    private int count;' >> /tmp/TestClass.java
	@echo '    public void run() { System.out.println("hello"); }' >> /tmp/TestClass.java
	@echo '    public int getCount() { return count; }' >> /tmp/TestClass.java
	@echo '    private void helper() { if (count > 0) count--; }' >> /tmp/TestClass.java
	@echo '}' >> /tmp/TestClass.java
	./$(BIN) --verbose /tmp/TestClass.java
	@echo ""
	@echo "--- Generated .xclass ---"
	@cat /tmp/TestClass.xclass
	@echo ""
	@echo "--- Python test ---"
	@echo 'class Engine:' > /tmp/Engine.py
	@echo '    def __init__(self, power):' >> /tmp/Engine.py
	@echo '        self.power = power' >> /tmp/Engine.py
	@echo '    def start(self):' >> /tmp/Engine.py
	@echo '        return True' >> /tmp/Engine.py
	@echo '    def stop(self):' >> /tmp/Engine.py
	@echo '        self.power = 0' >> /tmp/Engine.py
	./$(BIN) --verbose --frame=eu /tmp/Engine.py
	@echo ""
	@cat /tmp/Engine.xclass
	@echo ""
	@echo "--- All tests passed ---"
	@rm -f /tmp/TestClass.java /tmp/TestClass.xclass /tmp/Engine.py /tmp/Engine.xclass
