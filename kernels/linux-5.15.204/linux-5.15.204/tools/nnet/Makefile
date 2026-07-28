# SPDX-License-Identifier: GPL-2.0

CC ?= gcc
CFLAGS := -Wall -Wextra -O2
PREFIX ?= /usr/local
BINDIR := $(PREFIX)/bin

.PHONY: all clean install provision

all: nnet

nnet: nnet.c
	$(CC) $(CFLAGS) -o nnet nnet.c

clean:
	rm -f nnet

install: nnet
	install -m 755 nnet $(BINDIR)/nnet
	ln -sf $(BINDIR)/nnet $(BINDIR)/nnot
	@echo "Installed nnet and nnot to $(BINDIR)"

provision:
	@echo "Provisioning nnet data directories..."
	bash provision_nnet_data.sh
	@echo "Done."
