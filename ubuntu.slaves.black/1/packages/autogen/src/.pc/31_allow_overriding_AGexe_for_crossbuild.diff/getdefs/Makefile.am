##  -*- Mode: Makefile -*-
## ---------------------------------------------------------------------
## Makefile.am -- process this file with automake to produce Makefile.in
##
## Author:	    Bruce Korb <bkorb@gnu.org>
##
## This file is part of AutoGen.
## AutoGen Copyright (C) 1992-2018 by Bruce Korb - all rights reserved
##
## AutoGen is free software: you can redistribute it and/or modify it
## under the terms of the GNU General Public License as published by the
## Free Software Foundation, either version 3 of the License, or
## (at your option) any later version.
##
## AutoGen is distributed in the hope that it will be useful, but
## WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
## See the GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License along
## with this program.  If not, see <http://www.gnu.org/licenses/>.
## ---------------------------------------------------------------------
TARG = getdefs

bin_PROGRAMS    = getdefs
getdefs_LDFLAGS = -no-install
gdsrcs          = getdefs.h proto.h gdemit.c gdinit.c getdefs.c
getdefs_SOURCES = proto.h
BUILT_SOURCES   = gd.c
nodist_getdefs_SOURCES = $(BUILT_SOURCES)

SUBDIRS         = test
EXTRA_DIST      = opts.def $(gdsrcs)
AG_ENV          =  top_builddir="$(top_builddir)" top_srcdir="$(top_srcdir)" \
	VERBOSE="$(V)"
RUN_AG          = $(AG_ENV) $(SHELL) "${top_srcdir}/build-aux/run-ag.sh"

all : gen
gen : $(BUILT_SOURCES) $(DOCFILES)

if AMDEP
DEPFL_OPTS = $(DEPDIR)/opts-dep.mk
DEPFL_TEXI = $(DEPDIR)/info-dep.mk
DEPFL_MAN  = $(DEPDIR)/man-dep.mk

$(DEPFL_OPTS) :
	$(RUN_AG) "$@"
include $(DEPFL_OPTS)

$(DEPFL_MAN) :
	$(RUN_AG) "$@"
include $(DEPFL_MAN)

$(DEPFL_INFO) :
	$(RUN_AG) "$@"
include $(DEPFL_INFO)
else
DEPFL_OPTS = $@
DEPFL_TEXI = $@
DEPFL_MAN  = $@
endif

AGARG_OPTS = -MF$(DEPFL_OPTS) -MT$@ -MP
AGARG_TEXI = -MF$(DEPFL_TEXI) -MT$@ -MP -Tagtexi-cmd
AGARG_MAN  = -MF$(DEPFL_MAN)  -MT$@ -MP -Tagman-cmd

getdefs_LDADD   = $(top_builddir)/autoopts/libopts.la
man_MANS        = $(TARG).1
TEXI_FILES      = $(TARG).texi $(TARG).menu
DOCFILES        = $(TEXI_FILES) $(man_MANS)
DISTCLEANFILES  = $(DOCFILES) $(nodist_getdefs_SOURCES) *-stamp
AM_CPPFLAGS     = @INCLIST@
AM_CFLAGS       = @WARN_CFLAGS@

gd.c : $(gdsrcs)
	exec > $@ ; \
	echo '#undef   PKGDATADIR' ; \
	echo '#define  PKGDATADIR "$(pkgdatadir)"' ; \
	echo ; echo '#define  DEFINING 1' ; \
	echo '#include "autoopts/project.h"' ; \
	for f in opts.c $(gdsrcs) ; \
	do echo "#include \"$$f\"" ; done

$(getdefs_OBJECTS) opts.h opts.c : stamp-opts
stamp-opts : opts.def
	$(RUN_AG) $(AGARG_OPTS) $(srcdir)/opts.def

$(man_MANS) : stamp-man
stamp-man : $(TARG)$(EXEEXT)
	$(RUN_AG) $(AGARG_MAN)  $(srcdir)/opts.def

$(TEXI_FILES) : stamp-doc
stamp-doc : $(TARG)$(EXEEXT)
	$(RUN_AG) $(AGARG_TEXI) -DLEVEL=section $(srcdir)/opts.def

.NOTPARALLEL:

.PHONY : local-maintainer-clean stamp-man
local-maintainer-clean : clean-stamp-opts clean-stamp-doc clean-stamp-man
	rm -f *~

# end of getdefs/Makefile.am
