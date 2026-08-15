## Process this file with automake to produce Makefile.in.

## Copyright (C) 2021 Mark J. Wielaard <mark@klomp.org>
##
## This program is free software: you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation; either version 3 of the License, or
## (at your option) any later version.
##
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with this program.  If not, see <https://www.gnu.org/licenses/>.

EXTRA_DIST = $(TESTSUITE_AT) testsuite package.m4
DISTCLEANFILES       = atconfig $(check_SCRIPTS)
MAINTAINERCLEANFILES = Makefile.in $(TESTSUITE)

$(srcdir)/package.m4: $(top_srcdir)/configure.ac
	{                                      \
	  echo '# Signature of the current package.'; \
	  echo 'm4_define([AT_PACKAGE_NAME],      [@PACKAGE_NAME@])'; \
	  echo 'm4_define([AT_PACKAGE_TARNAME],   [@PACKAGE_TARNAME@])'; \
	  echo 'm4_define([AT_PACKAGE_VERSION],   [@PACKAGE_VERSION@])'; \
	  echo 'm4_define([AT_PACKAGE_STRING],    [@PACKAGE_STRING@])'; \
	  echo 'm4_define([AT_PACKAGE_BUGREPORT], [@PACKAGE_BUGREPORT@])'; \
	} >$(srcdir)/package.m4

# The tests
TESTSUITE_AT = \
  testsuite.at \
  debugedit.at

# Some source files that are needed by the tests
EXTRA_DIST += data/SOURCES/foo.c \
	      data/SOURCES/bar.c \
	      data/SOURCES/baz.c \
	      data/SOURCES/foobar.h

TESTSUITE = $(srcdir)/testsuite

AUTOTEST = $(AUTOM4TE) --language=autotest
$(TESTSUITE): package.m4 $(TESTSUITE_AT)
	$(AUTOTEST) -I $(srcdir) testsuite.at -o $@.tmp
	mv $@.tmp $@

atconfig: $(top_builddir)/config.status
	cd $(top_builddir) && ./config.status tests/$@

clean-local:
	$(SHELL) $(TESTSUITE) --clean

check-local: atconfig atlocal $(TESTSUITE)
	$(SHELL) $(TESTSUITE) $(TESTSUITEFLAGS)

installcheck-local:
	$(SHELL) $(TESTSUITE) $(TESTSUITEFLAGS) \
	  AUTOTEST_PATH=$(exec_prefix)/bin
