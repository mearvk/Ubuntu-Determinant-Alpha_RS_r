# SPDX-License-Identifier: GPL-2.0
#
# tools/ — userspace tool build chain
#
# The repository-level tools tree contains explicitly selected userspace
# utilities. Keep pcopy and pmove in the same build/install chain so pmove
# remains a first-class tool rather than only a compatibility symlink.

SHELL := /bin/sh

TOOLS := pcopy pmove

.PHONY: all pcopy pmove install uninstall clean

all: $(TOOLS)

pcopy:
	$(MAKE) -C pcopy all

pmove: pcopy
	$(MAKE) -C pmove all

install: all
	$(MAKE) -C pcopy install
	$(MAKE) -C pmove install

uninstall:
	$(MAKE) -C pmove uninstall
	$(MAKE) -C pcopy uninstall

clean:
	$(MAKE) -C pmove clean
	$(MAKE) -C pcopy clean
