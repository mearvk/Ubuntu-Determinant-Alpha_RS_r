##  -*- Mode: Makefile -*-
##
## Makefile.am -- process this file with automake to produce Makefile.in
##
##  This file is part of AutoGen.
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

libdatadir      = $(libdir)/@PACKAGE@
SUBDIRS         = test
AM_CPPFLAGS     = @INCLIST@
AM_CFLAGS       = @WARN_CFLAGS@
FSMTPL          = fsm.tpl  fsm-macro.tlib fsm-trans.tlib
templates       = snarf.tpl $(FSMTPL) guile-iface.tpl
definitions     = cgi.def opts.def pseudo.def guile-iface.def defParse.def \
		  ag-text.def
ghdr            = ag-text.h cgi-fsm.h defParse-fsm.h directive.h expr.h \
		  functions.h guile-iface.h opts.h proto.h pseudo-fsm.h
gen_csrc        = expr.ini defParse.x $(ghdr)
pkgdata_DATA    = $(FSMTPL)
man_MANS        = autogen.1
DISTCLEANFILES  = stamp-* ag.c
bin_PROGRAMS    = autogen

# The list of source files with AutoGen functions
#
FUNCLIST = funcCase.c funcDef.c funcEval.c funcFor.c funcIf.c functions.c

# The list of source files with Guile expression functions defined,
# plus the parse/lex modules that must be in this order.
#
exprlist	= defParse-fsm.c defLex.c directive.c $(FUNCLIST) \
    expExtract.c expFormat.c expGperf.c expGuile.c  expMake.c \
    expOutput.c  expPrint.c  expState.c expString.c agShell.c

csrc = autogen.c $(exprlist) \
    ag-text.c    agCgi.c      agDep.c      agInit.c     agUtils.c \
    cgi-fsm.c    defDirect.c  defFind.c    defLoad.c    fmemopen.c \
    loadPseudo.c opts.c       scribble.c   tpLoad.c     tpParse.c \
    tpProcess.c

all_src     = $(csrc) $(gen_csrc) autogen.h scribble.h

EXTRA_DIST  = $(all_src) $(definitions) $(templates) $(man_MANS) \
		bootstrap.dir schemedef.scm \
		invoke-autogen.texi mk-stamps.sh

LO_LIB          = $(top_builddir)/autoopts/libopts.la
SNV_LIB         = $(top_builddir)/snprintfv/libsnprintfv.la

nodist_autogen_SOURCES = ag.c
autogen_SOURCES = $(gen_csrc)
autogen_LDADD   = $(LO_LIB) $(SNV_LIB) $(GUILE_LIBS)
autogen_LDFLAGS = $(DYNAMIC_AG) $(AG_STATIC_AUTOGEN) -no-install
autogen_CFLAGS  = $(GUILE_CFLAGS)
stamp_script    = $(srcdir)/mk-stamps.sh

AM_YFLAGS = -d

ag.c : Makefile
	exec > $@ ; \
	echo '#undef   PKGDATADIR' ; \
	echo '#define  PKGDATADIR "$(pkgdatadir)"' ; \
	echo '#undef   LIBDATADIR' ; \
	echo '#define  LIBDATADIR "$(libdatadir)"' ; \
	mk=`set -- $(MAKE) ; command -v $$1` ; \
	echo 'static char const make_prog[] = "'$$mk'";' ; \
	printf '\n#define  DEFINING 1\n' ; \
	printf '#include "%s"\n' autoopts/project.h autogen.h ; \
	printf '#include "%s"\n' $(csrc)

STAMPENV = top_srcdir="$(top_srcdir)" top_builddir="$(top_builddir)" \
	srcdir="$(srcdir)" AGexe="$(AGexe)" GDexe="$(GDexe)" CLexe="$(CLexe)" \
	DEPDIR="$(DEPDIR)" AG_TIMEOUT=$(AG_TIMEOUT)

stamp-env :
	$(STAMPENV) $(POSIX_SHELL) $(stamp_script)

../snprintfv/snprintfv.h :
	@if [ ! -f ../snprintfv/snprintfv.h ] ; then cd ../snprintfv ; \
	ln -s $(top_srcdir)/snprintfv/snprintfv/snprintfv.h . ; fi

../snprintfv/libsnprintfv.la :
	cd ../snprintfv ; $(MAKE) libsnprintfv.la

.PHONY : stamp-env
.NOTPARALLEL:

# start-generated-text

if AMDEP
DEPFL_STAMP_OPTS= $(DEPDIR)/dep-stamp-opts.mk
$(DEPFL_STAMP_OPTS) :
	$(SHELL) $(stamp_script) "$@"
include $(DEPFL_STAMP_OPTS)
DEPFL_STAMP_PROTO= $(DEPDIR)/dep-stamp-proto.mk
$(DEPFL_STAMP_PROTO) :
	$(SHELL) $(stamp_script) "$@"
include $(DEPFL_STAMP_PROTO)
DEPFL_STAMP_PARSE= $(DEPDIR)/dep-stamp-parse.mk
$(DEPFL_STAMP_PARSE) :
	$(SHELL) $(stamp_script) "$@"
include $(DEPFL_STAMP_PARSE)
DEPFL_STAMP_CGI= $(DEPDIR)/dep-stamp-cgi.mk
$(DEPFL_STAMP_CGI) :
	$(SHELL) $(stamp_script) "$@"
include $(DEPFL_STAMP_CGI)
DEPFL_STAMP_PSEUDO= $(DEPDIR)/dep-stamp-pseudo.mk
$(DEPFL_STAMP_PSEUDO) :
	$(SHELL) $(stamp_script) "$@"
include $(DEPFL_STAMP_PSEUDO)
DEPFL_STAMP_EXPRINI= $(DEPDIR)/dep-stamp-exprini.mk
$(DEPFL_STAMP_EXPRINI) :
	$(SHELL) $(stamp_script) "$@"
include $(DEPFL_STAMP_EXPRINI)
DEPFL_STAMP_DIRECTIVE= $(DEPDIR)/dep-stamp-directive.mk
$(DEPFL_STAMP_DIRECTIVE) :
	$(SHELL) $(stamp_script) "$@"
include $(DEPFL_STAMP_DIRECTIVE)
DEPFL_STAMP_TEXI= $(DEPDIR)/dep-stamp-texi.mk
$(DEPFL_STAMP_TEXI) :
	$(SHELL) $(stamp_script) "$@"
include $(DEPFL_STAMP_TEXI)
DEPFL_STAMP_AG_TEXT= $(DEPDIR)/dep-stamp-ag_text.mk
$(DEPFL_STAMP_AG_TEXT) :
	$(SHELL) $(stamp_script) "$@"
include $(DEPFL_STAMP_AG_TEXT)
DEPFL_STAMP_FMEM= $(DEPDIR)/dep-stamp-fmem.mk
$(DEPFL_STAMP_FMEM) :
	$(SHELL) $(stamp_script) "$@"
include $(DEPFL_STAMP_FMEM)
DEPFL_STAMP_MAN= $(DEPDIR)/dep-stamp-man.mk
$(DEPFL_STAMP_MAN) :
	$(SHELL) $(stamp_script) "$@"
include $(DEPFL_STAMP_MAN)
DEPFL_STAMP_FUNC= $(DEPDIR)/dep-stamp-func.mk
$(DEPFL_STAMP_FUNC) :
	$(SHELL) $(stamp_script) "$@"
include $(DEPFL_STAMP_FUNC)
DEPFL_STAMP_GVER= $(DEPDIR)/dep-stamp-gver.mk
$(DEPFL_STAMP_GVER) :
	$(SHELL) $(stamp_script) "$@"
include $(DEPFL_STAMP_GVER)
else
DEPFL_STAMP_OPTS= "$@"
DEPFL_STAMP_PROTO= "$@"
DEPFL_STAMP_PARSE= "$@"
DEPFL_STAMP_CGI= "$@"
DEPFL_STAMP_PSEUDO= "$@"
DEPFL_STAMP_EXPRINI= "$@"
DEPFL_STAMP_DIRECTIVE= "$@"
DEPFL_STAMP_TEXI= "$@"
DEPFL_STAMP_AG_TEXT= "$@"
DEPFL_STAMP_FMEM= "$@"
DEPFL_STAMP_MAN= "$@"
DEPFL_STAMP_FUNC= "$@"
DEPFL_STAMP_GVER= "$@"
endif
list_stamps = \
    stamp-opts      stamp-proto     stamp-parse     stamp-cgi \
    stamp-pseudo    stamp-exprini   stamp-directive stamp-texi \
    stamp-ag_text   stamp-fmem      stamp-man       stamp-func \
    stamp-gver

stamp-opts:
	@target="$(AUTOGEN_stamp_opts_TList)" \
	$(MAKE_STAMP)

stamp-proto:
	@target="$(AUTOGEN_stamp_proto_TList)" \
	$(MAKE_STAMP)

stamp-parse:
	@target="$(AUTOGEN_stamp_parse_TList)" \
	$(MAKE_STAMP)

stamp-cgi:
	@target="$(AUTOGEN_stamp_cgi_TList)" \
	$(MAKE_STAMP)

stamp-pseudo:
	@target="$(AUTOGEN_stamp_pseudo_TList)" \
	$(MAKE_STAMP)

stamp-exprini:
	@target="$(AUTOGEN_stamp_exprini_TList)" \
	$(MAKE_STAMP)

stamp-directive:
	@target="$(AUTOGEN_stamp_directive_TList)" \
	$(MAKE_STAMP)

stamp-texi:
	@target="$(AUTOGEN_stamp_texi_TList)" \
	$(MAKE_STAMP)

stamp-ag_text:
	@target="$(AUTOGEN_stamp_ag_text_TList)" \
	$(MAKE_STAMP)

stamp-fmem:
	@target="$(AUTOGEN_stamp_fmem_TList)" \
	$(MAKE_STAMP)

stamp-man:
	@target="$(AUTOGEN_stamp_man_TList)" \
	$(MAKE_STAMP)

stamp-func:
	@target="$(AUTOGEN_stamp_func_TList)" \
	$(MAKE_STAMP)

stamp-gver:
	@target="$(AUTOGEN_stamp_gver_TList)" \
	$(MAKE_STAMP)
.PHONY: stamps
stamps: $(list_stamps)

# end-generated-text
# end of Makefile.am
