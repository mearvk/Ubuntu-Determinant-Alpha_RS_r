# Copyright (C) 1999-2009  Free Software Foundation, Inc.
#  
# This file is part of GNU gengetopt 
#
# GNU gengetopt is free software; you can redistribute it and/or modify 
# it under the terms of the GNU General Public License as published by 
# the Free Software Foundation; either version 3, or (at your option) 
# any later version. 
#
# GNU gengetopt is distributed in the hope that it will be useful, but 
# WITHOUT ANY WARRANTY; without even the implied warranty of 
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General
# Public License for more details. 
#
# You should have received a copy of the GNU General Public License along 
# with gengetopt; see the file COPYING. If not, write to the Free Software 
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA. 

SUBDIRS = skels tests

bin_PROGRAMS = gengetopt

noinst_LTLIBRARIES = libgengetopt.la

libgengetopt_la_SOURCES = \
	acceptedvalues.cpp \
	argsdef.c \
	cmdline.c \
	fileutils.cpp \
	ggos.cpp \
	globals.cpp \
	gm.cc \
	gm_utils.cpp \
	parser.cc \
	scanner.cc \
	yyerror.cc

gengetopt_SOURCES = gengetopt.cc

scanner.cc: scanner.ll
	$(LEX) $(LFLAGS) -o $@ $<

parser.cc: parser.yy
	$(YACC) -o $@ $< --defines=$(@:.cc=.h)
parser.h: parser.cc
	@if test -f $@; then :; else \
		rm -f -- $<; \
		$(MAKE) $(AM_MAKEFLAGS) $<; \
	fi

# these are for gnulib
AM_CPPFLAGS = -I$(top_srcdir)/gl -I$(top_builddir)/gl

libgengetopt_la_LIBADD = \
	$(top_builddir)/gl/libgnu.la \
	@LTLIBOBJS@ \
	skels/libgen.la

LDADD = libgengetopt.la

EXTRA_DIST = \
	$(pkgdata_DATA) \
	argsdef.h \
	cmdline.ggo \
	cmdline.h \
	gengetopt.h \
	ggo_options.h \
	ggos.h \
	global_opts.h \
	globals.h \
	gm.h \
	gnugetopt.h \
	groups.h \
	parser.h \
	parser.yy \
	scanner.ll

# to have flex generate a case insensitive scanner
AM_LFLAGS = -i

cmdline.c: cmdline.ggo
	$(GENGETOPT) --input $<
cmdline.h: cmdline.c
	@if test -f $@; then :; else \
		rm -f -- $<; \
		$(MAKE) $(AM_MAKEFLAGS) $<; \
	fi

BUILT_SOURCES = \
	cmdline.c \
	cmdline.h \
	parser.cc \
	parser.h \
	scanner.cc

# we distribute these files because who uses gengetopt might need them
# these are installed in $(prefix)/share/gengetopt
pkgdata_DATA = gnugetopt.h getopt.c getopt1.c

noinst_HEADERS = \
	acceptedvalues.h \
	errorcodes.h \
	fileutils.h \
	gm_utils.h \
	yyerror.h
