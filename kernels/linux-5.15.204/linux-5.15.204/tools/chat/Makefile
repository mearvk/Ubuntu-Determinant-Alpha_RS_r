# SPDX-License-Identifier: GPL-2.0

CC ?= gcc
CFLAGS := -Wall -Wextra -O2 $(WARN_CFLAGS)
DESTDIR ?=
PREFIX ?= /usr/local
BINDIR := $(DESTDIR)$(PREFIX)/bin

.PHONY: all clean install provision

all: chat

chat: chat.c
	$(CC) $(CFLAGS) -o chat chat.c

clean:
	rm -f chat

install: chat
	install -d $(BINDIR)
	install -m 755 chat $(BINDIR)/chat
	install -d $(DESTDIR)/var/lib/chat/users
	install -d $(DESTDIR)/var/lib/chat/groups
	chmod 1777 $(DESTDIR)/var/lib/chat
	chmod 1777 $(DESTDIR)/var/lib/chat/users
	chmod 1777 $(DESTDIR)/var/lib/chat/groups
	@echo "chat installed to $(BINDIR)/chat"
	@echo "Data directory: $(DESTDIR)/var/lib/chat/"

provision:
	@echo "Creating default group 'general'..."
	mkdir -p $(DESTDIR)/var/lib/chat/groups/general
	echo "system" > $(DESTDIR)/var/lib/chat/groups/general/members
	echo "[`date '+%Y-%m-%d %H:%M:%S'`] *** Group 'general' created (default) ***" > $(DESTDIR)/var/lib/chat/groups/general/log
	@echo "Done. All users can: chat join general"
