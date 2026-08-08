# driverctl — Hardware Driver Discovery, Scan & Installation Manager
# Build: gcc -O2 -o driverctl driverctl.c -lcurl -lmysqlclient
#
# Copyright (C) 2026 MEARVK LLC

PREFIX ?= /usr/local
BINDIR = $(PREFIX)/bin

CC = gcc
CFLAGS = -O2 -Wall -Wextra -D_GNU_SOURCE
LDFLAGS = -lcurl -lm

MYSQL_CFLAGS = $(shell mysql_config --cflags 2>/dev/null)
MYSQL_LIBS = $(shell mysql_config --libs 2>/dev/null)

ifeq ($(MYSQL_LIBS),)
    MYSQL_CFLAGS = -I/usr/include/mysql
    MYSQL_LIBS = -lmysqlclient
endif

CURL_CFLAGS = $(shell pkg-config --cflags libcurl 2>/dev/null)
CURL_LIBS = $(shell pkg-config --libs libcurl 2>/dev/null)

ifeq ($(CURL_LIBS),)
    CURL_CFLAGS =
    CURL_LIBS = -lcurl
endif

TARGET = driverctl
SRCS = driverctl.c
OBJS = $(SRCS:.c=.o)

.PHONY: all clean install uninstall

all: $(TARGET)

$(TARGET): $(OBJS)
	$(CC) -o $@ $^ $(MYSQL_LIBS) $(CURL_LIBS) $(LDFLAGS)

%.o: %.c
	$(CC) $(CFLAGS) $(MYSQL_CFLAGS) $(CURL_CFLAGS) -c -o $@ $<

install: $(TARGET)
	install -d $(DESTDIR)$(BINDIR)
	install -m 755 $(TARGET) $(DESTDIR)$(BINDIR)/$(TARGET)
	install -d $(DESTDIR)/var/cache/driverctl
	install -d $(DESTDIR)/var/lib/driverctl
	@echo ""
	@echo "Installed: $(DESTDIR)$(BINDIR)/$(TARGET)"
	@echo ""
	@echo "Usage:"
	@echo "  driverctl scan              # Discover hardware + driver status"
	@echo "  driverctl install --all     # Install best drivers for all devices"
	@echo "  driverctl update --install  # Check and install updates"
	@echo "  driverctl sources           # Show upstream repositories"
	@echo "  driverctl tree              # Kernel device tree reference"
	@echo ""

uninstall:
	rm -f $(DESTDIR)$(BINDIR)/$(TARGET)

clean:
	rm -f $(TARGET) $(OBJS)
