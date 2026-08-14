# vim:ts=2:et
# common Makefile includes for apt-listchanges
#
override TOPDIR   := $(dir $(CURDIR)/$(lastword $(MAKEFILE_LIST)))
override PACKAGE  := apt-listchanges

ifndef VERSION
  CHANGELOGFILE   := $(TOPDIR)/debian/changelog
  VERSION         := $(shell LC_ALL=C dpkg-parsechangelog -l$(CHANGELOGFILE) -SVersion | sed -e 's/~$$//')
  SHELL           := $(SHELL) -e

  export VERSION SHELL
  unexport CDPATH
endif

XGETTEXT_COMMON_OPTIONS  := --msgid-bugs-address $(PACKAGE)@packages.debian.org  \
                            --package-name $(PACKAGE)                            \
                            --package-version $(VERSION)
