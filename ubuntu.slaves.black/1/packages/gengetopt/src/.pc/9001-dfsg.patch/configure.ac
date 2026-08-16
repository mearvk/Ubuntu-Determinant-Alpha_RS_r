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
# with gengetopt; see the file COPYING.

dnl Process this file with autoconf to produce a configure script.
AC_INIT(GNU gengetopt,2.23)

AC_CONFIG_AUX_DIR([build-aux])
AC_CONFIG_MACRO_DIR([m4])

AM_CONFIG_HEADER(config.h)

AM_INIT_AUTOMAKE([dist-xz check-news subdir-objects info-in-builddir tar-ustar])

dnl directory for docs (html)
AC_SUBST(gengetoptdocdir)
gengetoptdocdir=$docdir

dnl directory for examples
AC_SUBST(gengetoptexamplesdir)
gengetoptexamplesdir=$gengetoptdocdir/examples

AC_PROG_CC
dnl Use of GnuLib
gl_EARLY

AC_PROG_CXX
AC_PROG_INSTALL
AC_PROG_YACC

AM_PROG_LIBTOOL
AM_PROG_LEX

dnl add options for non GNU compilers
AC_NONGNU_FLAGS

dnl Checks for typedefs, structures, and compiler characteristics.
dnl AC_C_CONST obsolescent
AC_TYPE_SIZE_T
AC_C_LONG_LONG

AC_CANONICAL_HOST

dnl test for --enable-warnings command line option
AC_ARG_ENABLE(
	warnings,
	[  --enable-warnings            enable compiler warnings],
	AC_COMPILE_WARNINGS
)

AC_ARG_WITH(
	[gengen],
	[  --with-gengen=mygengen       gengen to use],
	[GENGEN_TO_USE=$withval],
	[GENGEN_TO_USE=[gengen]]
)
AC_SUBST(GENGEN, $GENGEN_TO_USE)

AC_ARG_WITH(
	[gengetopt],
	[  --with-gengetopt=mygengetopt gengetopt to use],
	[GENGETOPT_TO_USE=$withval],
	[GENGETOPT_TO_USE=[gengetopt]]
)
AC_SUBST(GENGETOPT, $GENGETOPT_TO_USE)

AC_CXX_HAVE_STL
AC_CXX_HAVE_SSTREAM

dnl for executable extensions
AC_EXEEXT

dnl set some flags for yacc to generate header file
AC_SUBST(YFLAGS)
YFLAGS="$YFLAGS -d -v"

dnl Checks for header files.
AC_HEADER_STDC
AC_CHECK_HEADERS(malloc.h strings.h unistd.h libintl.h stddef.h)

dnl Checks for typedefs, structures, and compiler characteristics.
AC_C_CONST
AC_C_INLINE
AC_HEADER_STDBOOL

# For gnulib.
gl_INIT

AC_PATH_PROGS(TAR, tar gtar)

dnl this is for testing purpose and development
AC_PATH_PROGS(VALGRIND, [valgrind], [:])

dnl this is only for developers who use change command line options
AC_PATH_PROGS(HELP2MAN, [help2man], [:])

dnl we want to avoid tests in case we're crosscompiling
dnl since we would not be able to run the gengetopt executable in that case
AM_CONDITIONAL(NO_CROSSCOMPILING, test "$cross_compiling" = no )

AH_TEMPLATE(HAVE_LONG_LONG)

AC_CONFIG_FILES([
	Makefile
	doc/Makefile
	gl/Makefile
	src/Makefile
	src/skels/Makefile
	src/tests/Makefile
	tests/Makefile
	tests/test_conf.conf
	tests/test_conf_inc.conf
	tests/test_conf_parser_ov2.c
	tests/test_conf_parser_ov3.c
	tests/test_conf_parser_ov4.c
])

AC_DEFUN([AC_CONFIG_TEST_SH], [AC_CONFIG_FILES([$1], [chmod -- +x $1])])

AC_CONFIG_TEST_SH([tests/more_than_once.sh])
AC_CONFIG_TEST_SH([tests/no_optgiven.sh])
AC_CONFIG_TEST_SH([tests/test_all_opts.sh])
AC_CONFIG_TEST_SH([tests/test_all_opts_file_save.sh])
AC_CONFIG_TEST_SH([tests/test_conf_parser.sh])
AC_CONFIG_TEST_SH([tests/test_conf_parser_err.sh])
AC_CONFIG_TEST_SH([tests/test_conf_parser_err_string.sh])
AC_CONFIG_TEST_SH([tests/test_conf_parser_grp.sh])
AC_CONFIG_TEST_SH([tests/test_conf_parser_ov.sh])
AC_CONFIG_TEST_SH([tests/test_conf_parser_ov2.sh])
AC_CONFIG_TEST_SH([tests/test_conf_parser_ov3.sh])
AC_CONFIG_TEST_SH([tests/test_conf_parser_ov4.sh])
AC_CONFIG_TEST_SH([tests/test_conf_parser_save.sh])
AC_CONFIG_TEST_SH([tests/test_default_values.sh])
AC_CONFIG_TEST_SH([tests/test_dep.sh])
AC_CONFIG_TEST_SH([tests/test_groups.sh])
AC_CONFIG_TEST_SH([tests/test_manual_help.sh])
AC_CONFIG_TEST_SH([tests/test_manual_help_args.sh])
AC_CONFIG_TEST_SH([tests/test_modes.sh])
AC_CONFIG_TEST_SH([tests/test_multiple.sh])
AC_CONFIG_TEST_SH([tests/test_multiple_err.sh])
AC_CONFIG_TEST_SH([tests/test_multiple_parsers.sh])
AC_CONFIG_TEST_SH([tests/test_output_dir.sh])
AC_CONFIG_TEST_SH([tests/test_output_dirs.sh])
AC_CONFIG_TEST_SH([tests/test_sections.sh])
AC_CONFIG_TEST_SH([tests/test_show_help.sh])
AC_CONFIG_TEST_SH([tests/test_simple_multiple.sh])
AC_CONFIG_TEST_SH([tests/test_simple_multiple_default.sh])
AC_CONFIG_TEST_SH([tests/test_unamed.sh])
AC_CONFIG_TEST_SH([tests/test_unnamed.sh])
AC_CONFIG_TEST_SH([tests/test_values.sh])
AC_CONFIG_TEST_SH([tests/test_values_err.sh])
AC_CONFIG_TEST_SH([tests/test_wrong_ggo.sh])
AC_CONFIG_TEST_SH([tests/valgrind_tests.sh])

AC_OUTPUT
