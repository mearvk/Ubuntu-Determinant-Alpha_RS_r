# SPDX-License-Identifier: GPL-2.0
#
# Makefile for Dave's Chrome Web Interface
#
# Builds dave_web: headless Chrome driver for Dave's web intelligence.
#
# Dependencies:
#   apt install libcurl4-openssl-dev libmysqlclient-dev
#
# Copyright (C) 2026 MEARVK LLC

CC       := gcc
CFLAGS   := -Wall -Wextra -O2 -std=c11 -D_GNU_SOURCE
LDFLAGS  := -lcurl -lmysqlclient -lrt

PREFIX   ?= /usr/local
BINDIR   := $(PREFIX)/bin
DATADIR  := /var/lib/kernel-ai

SRC      := dave_web.c cjson/cJSON.c
OBJ      := $(SRC:.c=.o)
TARGET   := dave_web

.PHONY: all clean install uninstall dirs schema help

all: $(TARGET)

help:
	@echo "Dave Web Interface — Chrome-based web intelligence for Dave AI"
	@echo ""
	@echo "Targets:"
	@echo "  all         - Build dave_web binary"
	@echo "  install     - Install binary + create directories + load schema"
	@echo "  uninstall   - Remove binary"
	@echo "  schema      - Load MySQL schema (dave_kb.web_findings)"
	@echo "  dirs        - Create required directories"
	@echo "  clean       - Remove build artifacts"
	@echo ""
	@echo "Dependencies:"
	@echo "  apt install libcurl4-openssl-dev libmysqlclient-dev"
	@echo "  chromium-browser (headless mode)"

$(TARGET): $(OBJ)
	$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS)

%.o: %.c
	$(CC) $(CFLAGS) -c -o $@ $<

# Ensure cJSON dependency exists (fetch if needed)
cjson/cJSON.c:
	@mkdir -p cjson
	@echo "Fetching cJSON (MIT license)..."
	@curl -sL https://raw.githubusercontent.com/DaveGamble/cJSON/master/cJSON.c \
		-o cjson/cJSON.c 2>/dev/null || \
		echo "// cJSON stub — fetch manually from github.com/DaveGamble/cJSON" > cjson/cJSON.c
	@curl -sL https://raw.githubusercontent.com/DaveGamble/cJSON/master/cJSON.h \
		-o cjson/cJSON.h 2>/dev/null || \
		echo "// cJSON stub — fetch manually from github.com/DaveGamble/cJSON" > cjson/cJSON.h

dirs:
	@mkdir -p $(DATADIR)/screenshots
	@mkdir -p $(DATADIR)/chrome-data
	@chown dave:dave $(DATADIR)/screenshots 2>/dev/null || true
	@chown dave:dave $(DATADIR)/chrome-data 2>/dev/null || true
	@echo "Directories created:"
	@echo "  $(DATADIR)/screenshots"
	@echo "  $(DATADIR)/chrome-data"

schema:
	@echo "Loading web schema into dave_kb..."
	mysql -u root < dave_web_schema.sql
	mysql -u root < dave_ssl_schema.sql
	@echo "Schema loaded. Tables: web_findings, web_sessions, web_monitors, ssl_certificates, site_auth_awareness, key_rotation_log"

install: $(TARGET) dirs
	install -m 755 $(TARGET) $(BINDIR)/$(TARGET)
	install -m 755 dave_post.sh $(BINDIR)/dave_post
	install -m 755 dave_ssl.sh $(BINDIR)/dave_ssl
	install -m 755 dave_web_monitor.sh $(BINDIR)/dave_web_monitor.sh
	@echo ""
	@echo "Installed:"
	@echo "  $(BINDIR)/$(TARGET)           — Chrome web interface"
	@echo "  $(BINDIR)/dave_post           — Public voice (GitHub Discussions)"
	@echo "  $(BINDIR)/dave_ssl            — SSL/TLS certificate intelligence"
	@echo "  $(BINDIR)/dave_web_monitor.sh — Periodic monitoring daemon"
	@echo ""
	@echo "Post-install:"
	@echo "  1. Run 'make schema' to create MySQL tables"
	@echo "  2. Ensure chromium-browser is installed"
	@echo "  3. Place GitHub token: echo 'ghp_...' > /var/lib/kernel-ai/.github_token"
	@echo "  4. Test: dave_web --status"
	@echo "  5. Test: dave_post --list-repos"
	@echo "  6. Test: dave_ssl --fetch github.com"

uninstall:
	rm -f $(BINDIR)/$(TARGET)

clean:
	rm -f $(OBJ) $(TARGET)
