#
#  Copyright (C) 1997-2000  Roman Hodek <roman@hodek.net>
#  Copyright (C) 2004  Raphael Bossek <bossekr@debian.org>
#  Copyright (c) 2007-2008  Neil Williams <codehelp@debian.org>
#
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program; if not, write to the Free Software
#  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
#

all: man1 man3
	$(MAKE) -C po

test: 

man1:
	pod2man dpkg-cross > dpkg-cross.1

man3:
	pod2man Debian/DpkgCross.pm > Debian::DpkgCross.3

install:
	$(MAKE) -C po install

clean:
	rm -f dpkg-cross.1 Debian::DpkgCross.3

distclean: clean
