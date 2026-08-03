# FiduciaryServices™ — Global Transfer Wealth & Architecture Advisor
# Build: gcc -O2 -o fiduciary fiduciary.c -lmysqlclient -lm

PREFIX ?= /usr/local
BINDIR = $(PREFIX)/bin

CC = gcc
CFLAGS = -O2 -Wall -Wextra
MYSQL_CFLAGS = $(shell mysql_config --cflags 2>/dev/null)
MYSQL_LIBS = $(shell mysql_config --libs 2>/dev/null)

ifeq ($(MYSQL_LIBS),)
    MYSQL_CFLAGS = -I/usr/include/mysql
    MYSQL_LIBS = -lmysqlclient
endif

all: fiduciary

fiduciary: fiduciary.c
	$(CC) $(CFLAGS) $(MYSQL_CFLAGS) -o $@ $< $(MYSQL_LIBS) -lm

install: fiduciary
	install -d $(DESTDIR)$(BINDIR)
	install -m 755 fiduciary $(DESTDIR)$(BINDIR)/fiduciary
	@echo "Installed: $(DESTDIR)$(BINDIR)/fiduciary"
	@echo "Run: fiduciary --populate   (first time)"
	@echo "Run: fiduciary              (interactive Q&A)"

uninstall:
	rm -f $(DESTDIR)$(BINDIR)/fiduciary

clean:
	rm -f fiduciary

.PHONY: all install uninstall clean
