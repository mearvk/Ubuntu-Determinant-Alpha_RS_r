#!/usr/bin/make -f
# -*- makefile -*-
#
# Define some useful variables for debian/rules files of r-(cran|bioc) packages
# Copied from debian/r-cran.mk of r-base-dev 3.3.3 source

include /usr/share/dpkg/default.mk

debRreposname	:= $(shell echo $(DEB_SOURCE) | sed 's/r-\([a-z]\+\)-.*/\1/')
# apply it to the upstream meta-info file DESCRIPTION (seems to be some helpful trick to keep the quoting)
cranNameOrig    := $(shell awk '/^(Package|Bundle):/ {print $$2 }' DESCRIPTION)
# generate a lc version
cranName	:= $(shell echo "$(cranNameOrig)" | tr A-Z a-z)
package		:= r-$(debRreposname)-$(cranName)

## awk command to extract word after Priority
priority        := $(shell awk '/^Priority:/ {print tolower($$2) }' DESCRIPTION)
  
ifeq ($(priority),recommended)
  debRdir	:= usr/lib/R/library
else
  debRdir	:= usr/lib/R/site-library
endif

## current R version in Debian, with thanks to Charles Plessy for the dpkg-query call
#rversion	:= $(shell zcat /usr/share/doc/r-base-dev/changelog.Debian.gz | \
#			dpkg-parsechangelog -l- --count 1  | \
#			awk '/^Version/ {print $$2}')
rversion	:= $(shell dpkg-query -W -f='$${Version}' r-base-dev)
rapiversion	:= $(shell dpkg-query -W -f='$${Provides}' r-base-core | grep -o 'r-api[^, ]*')

debRlib		:= $(CURDIR)/debian/$(package)/$(debRdir)

## optional installation of a lintian silencer
lintiandir	:= $(CURDIR)/debian/$(package)/usr/share/lintian/overrides

## Bug report #782764 with patch by Philipp Rinn building on what we had above
## if no builttimeStamp is supplied, set built-time (to be set in DESCRIPTION).
## to time of created source package based on stamp in changelog..
## See discussion in http://bugs.debian.org/774031

ifeq ($(builttimeStamp),)
  builttime       := $(shell dpkg-parsechangelog -l$(CURDIR)/debian/changelog | awk -F': ' '/Date/ {print $$2}')
  builttimeStamp  := "--built-timestamp=\"$(builttime)\""
endif
