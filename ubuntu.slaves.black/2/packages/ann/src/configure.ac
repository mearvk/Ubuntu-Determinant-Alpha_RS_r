# Process this file with autoconf to produce a configure script.
AC_INIT([ann], [1.0], [bornik@icg.tu-graz.aca.t])

AC_CONFIG_AUX_DIR(cfg)

AM_INIT_AUTOMAKE
AC_CONFIG_HEADERS(config.h)
AM_MAINTAINER_MODE

ANN_VERSION="1.0"
AC_SUBST([ANN_VERSION])

# Checks for programs.
AC_PROG_CC
AC_PROG_CPP
AC_PROG_CXX
AC_PROG_CXXCPP
AC_PROG_LN_S
AC_PROG_MAKE_SET
AC_LANG(C++)

# AM_DISABLE_SHARED
# AM_DISABLE_STATIC
AC_DISABLE_FAST_INSTALL
AC_PROG_LIBTOOL

# Checks for header files.
AC_HEADER_STDC

# Checks for typedefs, structures, and compiler characteristics.
AC_C_CONST
AC_C_INLINE
AC_HEADER_TIME
AC_STRUCT_TM
AC_CXX_HAVE_STD
AC_CXX_HAVE_STL
AC_CXX_TYPENAME

# Checks for library functions.
AC_PROG_GCC_TRADITIONAL

AC_SUBST([LIBS])
AC_SUBST([CXXFLAGS])
AC_SUBST([CPPFLAGS])
AC_SUBST([LDFLAGS])

AC_CONFIG_FILES([Makefile
                 src/Makefile
                 include/Makefile
                 ann2fig/Makefile
                 sample/Makefile
                 test/Makefile])

AC_OUTPUT
