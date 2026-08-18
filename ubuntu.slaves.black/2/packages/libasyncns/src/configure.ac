dnl -*- Autoconf -*-
dnl Process this file with autoconf to produce a configure script.
dnl
dnl This file is part of libasyncns.
dnl
dnl Copyright 2005-2008 Lennart Poettering
dnl
dnl libasyncns is free software; you can redistribute it and/or modify
dnl it under the terms of the GNU Lesser General Public License as
dnl published by the Free Software Foundation, either version 2.1 of the
dnl License, or (at your option) any later version.
dnl
dnl libasyncns is distributed in the hope that it will be useful, but
dnl WITHOUT ANY WARRANTY; without even the implied warranty of
dnl MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
dnl Lesser General Public License for more details.
dnl
dnl You should have received a copy of the GNU Lesser General Public
dnl License along with libasyncns. If not, see
dnl <http://www.gnu.org/licenses/>.

AC_PREREQ(2.63)
AC_INIT([libasyncns],[0.8],[mznflapaf (at) 0pointer (dot) de])
AC_CONFIG_SRCDIR([libasyncns/asyncns.c])
AC_CONFIG_HEADERS([config.h])
AC_CONFIG_MACRO_DIR([m4])
AM_INIT_AUTOMAKE([foreign 1.10 -Wall])

AC_SUBST(PACKAGE_URL, [http://0pointer.de/lennart/projects/libasyncns/])

AC_SUBST(LIBASYNCNS_VERSION_INFO, [3:1:3])

if type -p stow > /dev/null && test -d /usr/local/stow ; then
   AC_MSG_NOTICE([*** Found /usr/local/stow: default install prefix set to /usr/local/stow/${PACKAGE_NAME}-${PACKAGE_VERSION} ***])
   ac_default_prefix="/usr/local/stow/${PACKAGE_NAME}-${PACKAGE_VERSION}"
fi

m4_ifdef([AM_SILENT_RULES], [AM_SILENT_RULES([yes])])

dnl Checks for programs.
AC_PROG_CC
AC_PROG_CC_C99
AM_PROG_CC_C_O
AC_PROG_CPP

AC_USE_SYSTEM_EXTENSIONS

AC_PROG_INSTALL
AC_PROG_LN_S
AC_PROG_MAKE_SET
AC_PROG_LIBTOOL

CC_CHECK_CFLAGS_APPEND([-pipe -Wall -W -Wextra -pedantic -Wformat -Wold-style-definition -Wdeclaration-after-statement -Wfloat-equal -Wmissing-declarations -Wmissing-prototypes -Wstrict-prototypes -Wredundant-decls -Wmissing-noreturn -Wshadow -Wendif-labels -Wpointer-arith -Wbad-function-cast -Wcast-qual -Wcast-align -Wwrite-strings -Winline -Wno-unused-parameter -Wstrict-aliasing])

dnl Checks for header files.
AC_HEADER_ASSERT
AC_HEADER_STDC
AC_HEADER_SYS_WAIT
AC_CHECK_HEADERS([arpa/inet.h fcntl.h netdb.h stdlib.h string.h sys/socket.h unistd.h sys/prctl.h netinet/in.h arpa/nameser_compat.h])

dnl Checks for typedefs, structures, and compiler characteristics.
AC_C_CONST
AC_TYPE_PID_T
AC_TYPE_SIZE_T
AC_TYPE_SSIZE_T
AC_TYPE_UINT16_T
AC_TYPE_UINT8_T
AC_HEADER_TIME

dnl Checks for library functions.
AC_FUNC_FORK
AC_FUNC_MALLOC
AC_FUNC_SELECT_ARGTYPES
AC_TYPE_SIGNAL
AC_CHECK_FUNCS([memset select strndup setresuid setreuid strerror])

AC_SYS_LARGEFILE

AC_CHECK_LIB(nsl, gethostbyname)
AC_CHECK_LIB(socket, connect)

ACF_SEARCH_FUNCTION([res_query], [-lresolv, -lbind],
  [], [AC_MSG_ERROR([res_query not found])],
  [AC_LANG_PROGRAM([[
      #include <resolv.h>
     ]], [[res_query(0, 0, 0, 0, 0);]])
  ])

ACX_PTHREAD

CC_NOUNDEFINED

ZP_LYNX_DOC

AC_CONFIG_FILES([Makefile libasyncns/Makefile doc/Makefile doc/README.html doxygen/Makefile doxygen/doxygen.conf libasyncns.pc])
AC_OUTPUT
