# Do all the work for Automake.  This macro actually does too much --
# some checks are only needed if your package does certain things.
# But this isn't really a big deal.

# serial 1

dnl Usage:
dnl AM_INIT_AUTOMAKE(package,version, [no-define])

AC_DEFUN(AM_INIT_AUTOMAKE,
[AC_REQUIRE([AC_PROG_INSTALL])
PACKAGE=[$1]
AC_SUBST(PACKAGE)
VERSION=[$2]
AC_SUBST(VERSION)
dnl test to see if srcdir already configured
if test "`cd $srcdir && pwd`" != "`pwd`" && test -f $srcdir/config.status; then
  AC_MSG_ERROR([source directory already configured; run "make distclean" there first])
fi
ifelse([$3],,
[AC_DEFINE_UNQUOTED(PACKAGE, "$PACKAGE", [Name of package])
AC_DEFINE_UNQUOTED(VERSION, "$VERSION", [Version number of package])])
AC_REQUIRE([AM_SANITY_CHECK])
AC_REQUIRE([AC_ARG_PROGRAM])
dnl FIXME This is truly gross.
missing_dir=`cd $ac_aux_dir && pwd`
#
ac_prog_editor=`echo $program_transform_name| sed -e 's/\\$\\$/$/g'`
ac_prog_actual=`echo aclocal|sed -e $ac_prog_editor`
AM_MISSING_PROG(ACLOCAL, $ac_prog_actual, $missing_dir)
#
ac_prog_actual=`echo autoconf|sed -e $ac_prog_editor`
AM_MISSING_PROG(AUTOCONF, $ac_prog_actual, $missing_dir)
#
AUTOMAKE=${AUTOMAKE-"automake"}
AC_SUBST(AUTOMAKE)
#
ac_prog_actual=`echo autoheader|sed -e $ac_prog_editor`
AM_MISSING_PROG(AUTOHEADER, $ac_prog_actual, $missing_dir)
#
AM_MISSING_PROG(MAKEINFO, makeinfo, $missing_dir)
AC_REQUIRE([AC_PROG_MAKE_SET])])
