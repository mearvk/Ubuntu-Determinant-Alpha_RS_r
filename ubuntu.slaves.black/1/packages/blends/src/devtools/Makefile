#!/usr/bin/make -f

# This Makefile is used to build a debian/control file
# for a Debian Pure Blend.
#
# Copyright (C) Andreas Tille <tille@debian.org>
# License: GPL

# TARGET_DIST is one of stable, sarge, etch, unstable, or any other available
# sources.list file available
TARGET_DIST := $(shell head -1 debian/changelog |awk '{print $$3}'|tr -d ';')

# using unstable as target distribution for the meta package dependencies
# does actually not sound reasonable.  The idea is to enable a smooth transition
# to testing for all meta packages and thus here testing is used as target
# distribution.
ifeq "$(TARGET_DIST)" "unstable"
	TARGET_DIST := "testing"
endif

# It is a good practice to use UNRELEASED in the changelog as target
# distribution for not yet finished packages and blends-dev should
# also work in this case.
ifeq "$(TARGET_DIST)" "UNRELEASED"
	TARGET_DIST := "unstable"
endif

BLEND := $(shell /usr/share/blends-dev/blend-get-names blendname)
VERSION  := $(shell dpkg-parsechangelog -ldebian/changelog | grep Version: | cut -f2 -d' ' | cut -f1 -d- )
GENCONTROL := /usr/share/blends-dev/blend-gen-control
TASKSDIFF := /usr/share/blends-dev/tasks_diff
DEPENDENCIES_DATA := dependency_data
TASKSELOPTS := $(shell grep TASKSELOPTS Makefile | cut -d '=' -f2)

# Verify whether config/control exists, if yes, add it to the depends of debian/control
CONFIGCONTROL := $(shell if [ -d config -a -e config/control ] ; then echo config/control; fi)

#get two latest releases
RELEASES   := $(shell grep '^$(BLEND)' debian/changelog | head -2 | awk '{print $$2}' | tr -d '[(,)]')
LATEST    := $(shell echo "$(RELEASES)" | cut -d ' ' -f1)
PREVIOUS   := $(shell echo $(RELEASES) | cut -d ' ' -f2)

ifneq "$(LATEST)" "$(PREVIOUS)"
	LINEEND   := $(shell lineend=`grep '^$(BLEND)' debian/changelog -n | sed -n 2p | cut -d ':' -f1`; echo "$$((lineend - 3))")
	LINESTART  := $(shell linestart=`grep "* start of automatic changelog entry *" debian/changelog -n | head -1 | awk '{print $$1}' | tr -d ':'`; if [ -z "$$linestart" ]; then echo "0"; else echo "$$((linestart - 1))"; fi)

	ISGREATER := $(shell expr $(LINESTART) \> $(LINEEND))

	ifeq "$(LINESTART)" "0"
		LINESTART := $(LINEEND)
	else ifeq "$(ISGREATER)" "1"
		LINESTART := $(LINEEND)
	endif
endif

all: $(BLEND)-tasks.desc debian/control

debian/control: debian/control.stub debian/changelog tasks/* $(CONFIGCONTROL)
	$(GENCONTROL) -r $(TARGET_DIST) -S -c -m

tasksel: $(BLEND)-tasks.desc
$(BLEND)-tasks.desc: tasks/* debian/changelog
	$(GENCONTROL) $(TASKSELOPTS) -r $(TARGET_DIST) -S -t

dependency_data:
	if [ ! -d $(DEPENDENCIES_DATA) ]; then \
		echo "$(DEPENDENCIES_DATA) directory does not exist, creating it now."; \
		mkdir $(DEPENDENCIES_DATA); \
	fi

statusdump: dependency_data
	$(TASKSDIFF) --status-dump --tasks .  --output $(DEPENDENCIES_DATA)/$(BLEND)_$(VERSION).json

#update changelog with dependencies changes
changelogentry: debian/changelog statusdump
ifneq "$(LATEST)" "$(PREVIOUS)"
	if [ ! -f $(DEPENDENCIES_DATA)/$(BLEND)_$(LATEST).json ]; then \
		echo "$(DEPENDENCIES_DATA)/$(BLEND)_$(LATEST).json does not exist, can not generate changelog dependencies-changes entry"; \
		exit -1; \
	fi
	if [ ! -f $(DEPENDENCIES_DATA)/$(BLEND)_$(PREVIOUS).json ]; then \
		echo "$(DEPENDENCIES_DATA)/$(BLEND)_$(PREVIOUS).json does not exist, can not generate changelog dependencies-changes entry"; \
		exit -1; \
	fi

	(sed $(LINESTART)q debian/changelog; \
	 $(TASKSDIFF) --compare $(DEPENDENCIES_DATA)/$(BLEND)_$(LATEST).json,$(DEPENDENCIES_DATA)/$(BLEND)_$(PREVIOUS).json | sed 's/^/  /'; \
	 sed -n '$(LINEEND),$$p' debian/changelog; ) > debian/changelog.new && mv debian/changelog.new debian/changelog
else
	echo "It is the first release, skip the changelog entry"
endif

packages.txt: tasks/*
	$(GENCONTROL) -r $(TARGET_DIST) -a > packages.txt.$$$$ && mv packages.txt.$$$$ packages.txt

avoidpackages.txt: tasks/* sources.list.$(TARGET_DIST)
	$(GENCONTROL) -r $(TARGET_DIST) -e > avoidpackages.txt.$$$$ && mv avoidpackages.txt.$$$$ avoidpackages.txt

by_vote:
	rm -f by_vote
	wget http://developer.skolelinux.no/popcon/by_vote

packages-sorted.txt: packages.txt by_vote
	for pkg in `cat packages.txt` ; do \
		grep " $$pkg " by_vote ; \
	done | LANG=C sort -r -n -k 4 -k 3 > packages-sorted.txt
usage: packages-sorted.txt

clean:
	rm -rf tmp
	rm -f tasks/*~
	rm -rf tasksel
	rm -f packages.txt by_vote packages-sorted.txt
	rm -f debian/*-config.postinst debian/*-config.preinst debian/*-config.postrm debian/*-config.prerm

distclean: clean

proper: distclean
	rm -f debian/control
	rm -f $(BLEND)-tasks.desc

dist:
	rm -f $(BLEND)-tasks.desc debian/control
	make -f debian/rules get-orig-source
