# SPDX-License-Identifier: GPL-2.0

CC ?= gcc
CFLAGS := -Wall -Wextra -O2
PREFIX ?= /usr/local
BINDIR := $(PREFIX)/bin

.PHONY: all clean install provision

all: chat

chat: chat.c
	$(CC) $(CFLAGS) -o chat chat.c

clean:
	rm -f chat

install: chat
	install -m 755 chat $(BINDIR)/chat
	mkdir -p /var/lib/chat/users
	mkdir -p /var/lib/chat/groups
	chmod 1777 /var/lib/chat
	chmod 1777 /var/lib/chat/users
	chmod 1777 /var/lib/chat/groups
	@echo "chat installed to $(BINDIR)/chat"
	@echo "Data directory: /var/lib/chat/"

provision:
	@echo "Creating default group 'general'..."
	mkdir -p /var/lib/chat/groups/general
	echo "system" > /var/lib/chat/groups/general/members
	echo "[`date '+%Y-%m-%d %H:%M:%S'`] *** Group 'general' created (default) ***" > /var/lib/chat/groups/general/log
	@echo "Done. All users can: chat join general"
