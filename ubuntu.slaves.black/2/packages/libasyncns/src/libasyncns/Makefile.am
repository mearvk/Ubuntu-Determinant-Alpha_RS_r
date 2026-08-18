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

AM_CFLAGS=-D__EXTENSIONS__ $(PTHREAD_CFLAGS)

lib_LTLIBRARIES=libasyncns.la
libasyncns_la_CC=$(PTHREAD_CC)
libasyncns_la_SOURCES=asyncns.c asyncns.h
libasyncns_la_LDFLAGS=-version-info $(LIBASYNCNS_VERSION_INFO) $(LDFLAGS_NOUNDEFINED)
libasyncns_la_LIBADD=$(PTHREAD_LIBS)

check_PROGRAMS=asyncns-test
asyncns_test_CC=$(PTHREAD_CC)
asyncns_test_SOURCES=asyncns-test.c
asyncns_test_LDADD=libasyncns.la $(PTHREAD_LIBS)

include_HEADERS=asyncns.h
