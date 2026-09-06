# SPDX-License-Identifier: GPL-2.0
#
# tools/ — userspace tool build chain
#
# The repository-level tools tree contains explicitly selected userspace
# utilities. Keep pcopy and pmove in the same build/install chain so pmove
# remains a first-class tool rather than only a compatibility symlink.

SHELL := /bin/sh

TOOLS := pcopy pmove muntutils tac3

.PHONY: all pcopy pmove muntutils tac3 install uninstall clean

all: $(TOOLS)

pcopy:
	$(MAKE) -C pcopy all

pmove: pcopy
	$(MAKE) -C pmove all

# muntutils is independent of pcopy/pmove and must not depend on them, so it
# can build even when the pcopy/pmove chain does not.
muntutils:
	$(MAKE) -C muntutils all

# tac3ctl — userspace diagnostic for the in-kernel TAC3 filesystem. Independent
# of the pcopy/pmove chain; builds from its own portable C++ engine.
tac3:
	$(MAKE) -C tac3 all

install: all
	$(MAKE) -C pcopy install
	$(MAKE) -C pmove install
	$(MAKE) -C muntutils install
	$(MAKE) -C tac3 install

uninstall:
	$(MAKE) -C pmove uninstall
	$(MAKE) -C pcopy uninstall
	$(MAKE) -C muntutils uninstall
	$(MAKE) -C tac3 uninstall

clean:
	$(MAKE) -C pmove clean
	$(MAKE) -C pcopy clean
	$(MAKE) -C muntutils clean
	$(MAKE) -C tac3 clean
