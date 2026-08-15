#                                               -*- Autoconf -*-
# Process this file with autoconf to produce a configure script.

# Copyright (C) 2021 Mark J. Wielaard <mark@klomp.org>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

AC_PREREQ([2.69])
AC_INIT([debugedit], [5.0], [debugedit@sourceware.org])
AC_CONFIG_SRCDIR([tools/debugedit.c])
AC_CONFIG_HEADERS([config.h])

# We are using foreign, not gnu, because we don't provide some
# "standard" files like ChangeLog, AUTHORS, INSTALL, etc.
AM_INIT_AUTOMAKE([foreign silent-rules subdir-objects std-options
                  no-dist-gzip dist-xz tar-pax
                  -Wall -Wno-portability])

# Silence. Override with make V=1.
AM_SILENT_RULES([yes])

# autotest directory
AC_CONFIG_TESTDIR([tests])
AC_CONFIG_FILES([tests/Makefile tests/atlocal])
AM_MISSING_PROG([AUTOM4TE], [autom4te])

# Happy to use GNU (or other) system extensions
AC_USE_SYSTEM_EXTENSIONS

# Checks for programs.
AC_PROG_AWK
AC_PROG_SED
AC_PROG_CC_C99
AC_PROG_LN_S
AC_CHECK_TOOL([LD], [ld])
AM_MISSING_PROG(HELP2MAN, help2man)

# Only really an issue on 32bit platforms. Makes sure we'll get large off_t.
AC_SYS_LARGEFILE

# Checks for libraries.
PKG_PROG_PKG_CONFIG
PKG_CHECK_MODULES([LIBELF], [libelf])
PKG_CHECK_MODULES([LIBDW], [libdw])

# Checks for header files.
AC_CHECK_HEADERS([fcntl.h inttypes.h limits.h malloc.h stddef.h stdint.h stdlib.h string.h unistd.h])

# Checks for typedefs, structures, and compiler characteristics.
AC_CHECK_HEADER_STDBOOL
AC_C_INLINE
AC_TYPE_INT8_T
AC_TYPE_OFF_T
AC_TYPE_SIZE_T
AC_TYPE_SSIZE_T
AC_TYPE_UINT16_T
AC_TYPE_UINT32_T
AC_TYPE_UINT8_T

# Checks for library functions.
AC_FUNC_ALLOCA
AC_FUNC_ERROR_AT_LINE
AC_FUNC_MALLOC
AC_FUNC_MMAP
AC_FUNC_REALLOC
AC_CHECK_FUNCS([memchr memset munmap strchr strdup strerror strrchr])

# Checks for compiler flags.
AC_CACHE_CHECK([whether gcc supports -gdwarf-5], ac_cv_gdwarf_5, [dnl
save_CFLAGS="$CFLAGS"
CFLAGS="-gdwarf-5"
AC_COMPILE_IFELSE([AC_LANG_SOURCE()], ac_cv_gdwarf_5=yes, ac_cv_gdwarf_5=no)
CFLAGS="$save_CFLAGS"
])
GDWARF_5_FLAG=$ac_cv_gdwarf_5
AC_SUBST([GDWARF_5_FLAG])

AC_CACHE_CHECK([whether gcc supports -gz=none], ac_cv_gz_none, [dnl
save_CFLAGS="$CFLAGS"
CFLAGS="-gz=none"
AC_COMPILE_IFELSE([AC_LANG_SOURCE()], ac_cv_gz_none=yes, ac_cv_gz_none=no)
CFLAGS="$save_CFLAGS"
])
if test "$ac_cv_gz_none" = "yes"; then
  GZ_NONE_FLAG="-gz=none"
else
  GZ_NONE_FLAG=""
fi
AC_SUBST([GZ_NONE_FLAG])

# And generate the output files.
AC_CONFIG_FILES([Makefile])
AC_OUTPUT
