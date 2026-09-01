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

# cJSON dependency (MIT license). The real implementation (~1700 lines) is
# NOT vendored in this tree; only the header plus a placeholder cJSON.c that
# intentionally fails to compile ship here. This rule fetches the real source
# when network access is available. If the fetch fails we do NOT overwrite the
# placeholder with a broken one-line stub (which produced a confusing later
# error); instead we fail loudly with an actionable message so the builder
# knows exactly what to do. See README.md ("cJSON dependency").
CJSON_BASE_URL := https://raw.githubusercontent.com/DaveGamble/cJSON/master

# Only (re)fetch when cJSON.c is missing or is still the placeholder. The
# placeholder is detectable by its "#error" marker.
.PHONY: cjson-fetch
cjson-fetch:
	@mkdir -p cjson
	@if [ -f cjson/cJSON.c ] && ! grep -q '#error' cjson/cJSON.c; then \
		echo "cJSON already present (cjson/cJSON.c)."; \
	else \
		echo "Fetching cJSON (MIT license) from $(CJSON_BASE_URL) ..."; \
		if curl -fsSL "$(CJSON_BASE_URL)/cJSON.c" -o cjson/cJSON.c.tmp && \
		   curl -fsSL "$(CJSON_BASE_URL)/cJSON.h" -o cjson/cJSON.h.tmp; then \
			mv cjson/cJSON.c.tmp cjson/cJSON.c; \
			mv cjson/cJSON.h.tmp cjson/cJSON.h; \
			echo "cJSON fetched into cjson/."; \
		else \
			rm -f cjson/cJSON.c.tmp cjson/cJSON.h.tmp; \
			echo ""; \
			echo "ERROR: could not fetch cJSON (no network access?)."; \
			echo "dave_web needs the real cJSON source. Vendor it manually:"; \
			echo "  curl -fsSL $(CJSON_BASE_URL)/cJSON.c -o cjson/cJSON.c"; \
			echo "  curl -fsSL $(CJSON_BASE_URL)/cJSON.h -o cjson/cJSON.h"; \
			echo "or copy cJSON.c/cJSON.h from github.com/DaveGamble/cJSON (MIT)."; \
			echo "The placeholder cjson/cJSON.c has NOT been modified."; \
			exit 1; \
		fi; \
	fi

# Building the object requires a real cJSON.c. If the placeholder is still in
# place, run 'make cjson-fetch' first (needs network) or vendor it manually.
cjson/cJSON.o: cjson/cJSON.c
	@if grep -q '#error' cjson/cJSON.c; then \
		echo "ERROR: cjson/cJSON.c is still the placeholder."; \
		echo "Run 'make cjson-fetch' (needs network) or vendor cJSON manually."; \
		echo "See README.md ('cJSON dependency') for the exact commands."; \
		exit 1; \
	fi
	$(CC) $(CFLAGS) -c -o $@ $<

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
