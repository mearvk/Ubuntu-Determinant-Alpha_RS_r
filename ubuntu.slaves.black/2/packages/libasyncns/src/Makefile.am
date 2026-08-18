# This file is part of libasyncns.
#
# Copyright 2005-2008 Lennart Poettering
#
# libasyncns is free software; you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as
# published by the Free Software Foundation, either version 2.1 of the
# License, or (at your option) any later version.
#
# libasyncns is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with libasyncns. If not, see
# <http://www.gnu.org/licenses/>.

ACLOCAL_AMFLAGS = -I m4

EXTRA_DIST = bootstrap.sh README LICENSE
SUBDIRS=libasyncns doc doxygen

MAINTAINERCLEANFILES=README
noinst_DATA = README

pkgconfigdir = $(libdir)/pkgconfig
pkgconfig_DATA = libasyncns.pc

README:
	rm -f README
	$(MAKE) -C doc README
	ln -s doc/README README

homepage: all dist doxygen
	test -d $$HOME/homepage/private
	mkdir -p $$HOME/homepage/private/projects/libasyncns $$HOME/homepage/private/projects/libasyncns/doxygen
	cp libasyncns-@PACKAGE_VERSION@.tar.gz $$HOME/homepage/private/projects/libasyncns
	cp doc/README.html doc/style.css $$HOME/homepage/private/projects/libasyncns
	cp -a doxygen/html/* $$HOME/homepage/private/projects/libasyncns/doxygen
	ln -sf README.html $$HOME/homepage/private/projects/libasyncns/index.html

doxygen:
	$(MAKE) -C doxygen doxygen

.PHONY: homepage doxygen
