##  -*- Mode: Makefile -*-
## ---------------------------------------------------------------------
## Makefile.am -- process this file with automake to produce Makefile.in
##
## Author:          Bruce Korb <bkorb@gnu.org>
##
## This file is part of AutoGen.
##  AutoGen Copyright (C) 1992-2018 by Bruce Korb - all rights reserved
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
##
TARG = xml2ag

bin_PROGRAMS    = xml2ag
csrcs           = xml2ag.c
gsrcs           = xmlopts.c fork.c
BUILT_SOURCES   = x.c
nodist_xml2ag_SOURCES = $(BUILT_SOURCES)
SUBDIRS         = test
EXTRA_DIST      = xmlopts.def fork.tpl $(gsrcs) $(csrcs)
xml2ag_LDADD    = $(top_builddir)/autoopts/libopts.la $(LIBXML2_LIBS)
man_MANS        = $(TARG).1
TEXI_FILES      = invoke-$(TARG).texi invoke-$(TARG).menu
DOCFILES        = $(TEXI_FILES) $(man_MANS)
DISTCLEANFILES  = $(DOCFILES) $(nodist_xml2ag_SOURCES) stamp-*
AM_CPPFLAGS     = @INCLIST@ $(LIBXML2_CFLAGS)
AM_CFLAGS       = @WARN_CFLAGS@
AG_ENV          =  top_builddir="$(top_builddir)" top_srcdir="$(top_srcdir)" \
	VERBOSE="$(V)"
RUN_AG       = $(AG_ENV) $(SHELL) "${top_srcdir}/build-aux/run-ag.sh"
DOC_TIMEOUT     = -DLEVEL=section --timeout=`expr $(AG_TIMEOUT) '*' 3`

all 	    : gen
gen 	    : $(gsrcs) $(DOCFILES)

if AMDEP
DEPFL_OPTS      = $(DEPDIR)/opts-dep.mk
DEPFL_MAN       = $(DEPDIR)/man-dep.mk
DEPFL_TEXI      = $(DEPDIR)/texi-dep.mk
DEPFL_FORK      = $(DEPDIR)/fork-dep.mk

$(DEPFL_OPTS) :
	$(RUN_AG) "$@"

$(DEPFL_MAN)  :
	$(RUN_AG) "$@"

$(DEPFL_TEXI) :
	$(RUN_AG) "$@"

$(DEPFL_FORK) :
	$(RUN_AG) "$@"

include $(DEPDIR)/opts-dep.mk
include $(DEPDIR)/man-dep.mk
include $(DEPDIR)/texi-dep.mk
include $(DEPDIR)/fork-dep.mk
else
DEPFL_OPTS      = $@
DEPFL_MAN       = $@
DEPFL_TEXI      = $@
DEPFL_FORK      = $@
endif

AGARG_OPTS      = -MF$(DEPFL_OPTS) -MT$@ -MP
AGARG_MAN       = -MF$(DEPFL_MAN)  -MT$@ -MP -Tagman-cmd
AGARG_TEXI      = -MF$(DEPFL_TEXI) -MT$@ -MP -Tagtexi-cmd $(DOC_TIMEOUT)
AGARG_FORK      = -MF$(DEPFL_FORK) -MT$@ -MP -L$(srcdir) -Tfork.tpl

$(getdefs_OBJECTS) xmlopts.c xmlopts.h : stamp-opts
stamp-opts  : xmlopts.def
	$(RUN_AG) $(AGARG_OPTS) "$(srcdir)/xmlopts.def"

$(TARG).1   : stamp-man
stamp-man   : xmlopts.def $(TARG)$(EXEEXT) ../columns/columns$(EXEEXT)
	$(RUN_AG) $(AGARG_MAN) "$(srcdir)/xmlopts.def"

invoke-$(TARG).texi invoke-$(TARG).menu : stamp-texi
stamp-texi  : xmlopts.def $(TARG)$(EXEEXT) ../columns/columns$(EXEEXT)
	$(RUN_AG) $(AGARG_TEXI) "$(srcdir)/xmlopts.def"

fork.c      : stamp-fork
stamp-fork  : fork.tpl xmlopts.def $(CLexe)
	$(RUN_AG) $(AGARG_FORK) "$(srcdir)/xmlopts.def"

$(CLexe)    :
	cd ../columns ; $(MAKE) $(CLnam)

x.c 	    : $(gsrcs) $(csrcs)
	exec > $@ ; \
	echo '#undef   PKGDATADIR' ; \
	echo '#define  PKGDATADIR "$(pkgdatadir)"' ; \
	echo ; echo '#define  DEFINING 1' ; \
	echo '#include "autoopts/project.h"' ; \
	for f in $(gsrcs) $(csrcs) ; \
	do echo "#include \"$$f\"" ; done

.NOTPARALLEL:

# end of Makefile.am
