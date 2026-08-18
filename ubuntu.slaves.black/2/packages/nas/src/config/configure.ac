dnl Process this file with autoconf to produce a configure script.
dnl $Id: configure.ac 136 2004-09-11 19:23:33Z jon $
dnl

AC_INIT([nas],[1.6],[jon@radscan.com])
AC_CONFIG_HEADER(config.h)
dnl AM_INIT_AUTOMAKE
AC_PROG_LIBTOOL
AC_PROG_YACC
AC_PROG_LEX
dnl AC_PATH_X
dnl AC_PATH_XTRA

AC_PREFIX_DEFAULT(/opt)

dnl checks the system
dnl AC_CANONICAL_TARGET([])
dnl Checks for programs.
dnl get the system type and set accordingly.  first init some defaults.


AC_PROG_CC

dnl Checks for libraries.
dnl Replace `main' with a function in -lm:

AC_CHECK_LIB(m, main)

dnl check for libcrypt
olibs="$LIBS"
AC_CHECK_LIB(crypt, crypt, LIBS="$olibs -lcrypt")

dnl check for libgen
olibs="$LIBS"
AC_CHECK_LIB(gen, crypt, LIBS="$olibs -lgen")

dnl check for libz
olibs="$LIBS"
AC_CHECK_LIB(z, gzread)

dnl Checks for header files.
AC_HEADER_STDC
AC_CHECK_HEADERS(fcntl.h limits.h sys/ioctl.h sys/times.h termio.h unistd.h)
AC_CHECK_HEADERS(sys/time.h sys/select.h stropts.h poll.h values.h)
AC_CHECK_HEADERS(time.h string.h strings.h termios.h zlib.h)
AC_CHECK_HEADERS(stdint.h stdlib.h limits.h malloc.h)
AC_CHECK_HEADERS(sys/soundcard.h machine/soundcard.h)

dnl Checks for typedefs, structures, and compiler characteristics.
AC_C_CONST
AC_TYPE_SIZE_T
AC_HEADER_TIME
AC_STRUCT_TM

dnl Checks for library functions.
AC_TYPE_SIGNAL
AC_FUNC_VPRINTF
AC_CHECK_FUNCS(select strstr fileno setpgrp daemon)
AC_CHECK_FUNCS(getmsg poll setitimer strerror)

AC_FUNC_SETPGRP
AC_FUNC_SNPRINTF

dnl check for sys_errlist decl

AC_MSG_CHECKING(for sys_errlist declaration)
AC_RUN_IFELSE([AC_LANG_SOURCE([[
#include <sys/types.h>
#include <stdio.h>

#include <errno.h>
main()
{
  char *s = sys_errlist[0];
  exit(0);
}
]])],[AC_MSG_RESULT(yes)
  AC_DEFINE(SYS_ERRLIST_DECLARED, 1, [sys_errlist declared])],[AC_MSG_RESULT(no)],[:])

AC_OUTPUT



