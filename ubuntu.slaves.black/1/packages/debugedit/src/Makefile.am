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

# Tests have their own directory and Makefile.am everything else is
# defined here.
SUBDIRS = tests

AM_CFLAGS = -Wall

# All our programs
bin_PROGRAMS = debugedit sepdebugcrcfix

# Install find-debuginfo in $(bindir)
bin_SCRIPTS = find-debuginfo

# All our scripts are generated, so need to be explicitly cleaned
CLEANFILES = $(bin_SCRIPTS)

# Some standard substitutions for scripts
do_subst = ($(SED) -e 's,[@]PACKAGE[@],$(PACKAGE),g' \
		   -e 's,[@]VERSION[@],$(VERSION),g')

find-debuginfo: $(top_srcdir)/scripts/find-debuginfo.in Makefile
	$(do_subst) < "$(top_srcdir)/scripts/$@.in" > "$@"
	chmod +x "$@"

debugedit_SOURCES = tools/debugedit.c \
		    tools/hashtab.c \
		    tools/md5.c \
		    tools/sha1.c
debugedit_CFLAGS = @LIBELF_CFLAGS@ @LIBDW_CFLAGS@ $(AM_CFLAGS)
debugedit_LDADD = @LIBELF_LIBS@ @LIBDW_LIBS@

sepdebugcrcfix_SOURCES = tools/sepdebugcrcfix.c
sepdebugcrcfix_CFLAGS = @LIBELF_CFLAGS@ $(AM_CFLAGS)
sepdebugcrcfix_LDADD = @LIBELF_LIBS@

# Manual pages are generated for dist
dist_man_MANS = debugedit.1 sepdebugcrcfix.1 find-debuginfo.1

# The 'case' ensures the man pages are only generated if the corresponding
# source script (the first prerequisite) or configure.ac (for the version)
# has been changed.  The executable prerequisite is solely meant to force
# these docs to be made only after the executable has been compiled.
# This makes sure help2man is not normally necessary (since the generated
# man pages are distributed).
debugedit.1: tools/debugedit.c configure.ac debugedit$(EXEEXT)
	@case '$?' in \
	  *$<* | *configure.ac* ) $(HELP2MAN) -N --output=$@ \
		--name='debug source path manipulation tool' \
		./debugedit$(EXEEXT) ;; \
	  * ) : ;; \
	esac

sepdebugcrcfix.1: tools/sepdebugcrcfix.c configure.ac sepdebugcrcfix$(EXEEXT)
	@case '$?' in \
	  *$<* | *configure.ac* ) $(HELP2MAN) -N --output=$@ \
		--name='fixes CRC for separate .debug files' \
		./sepdebugcrcfix$(EXEEXT) ;;\
	  * ) : ;; \
	esac

find-debuginfo.1: $(top_srcdir)/scripts/find-debuginfo.in configure.ac find-debuginfo
	@case '$?' in \
	  *$<* | *configure.ac* ) $(HELP2MAN) -N --output=$@ \
		--name='finds debuginfo and processes it' \
		./find-debuginfo ;;\
	  * ) : ;; \
	esac

noinst_HEADERS= tools/ansidecl.h \
		tools/hashtab.h \
		tools/md5.h \
		tools/sha1.h

EXTRA_DIST = README COPYING COPYING3 COPYING.LIB scripts/find-debuginfo.in
