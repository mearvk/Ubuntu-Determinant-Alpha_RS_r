AC_PREREQ(2.61)

# package version number (not shared library version)
# odd micro numbers indicate in-progress development
# even micro numbers indicate released versions
m4_define([clutter_imcontext_version_major], [0])
m4_define([clutter_imcontext_version_minor], [1])
m4_define([clutter_imcontext_version_micro], [4])

m4_define([clutter_imcontext_version],
          [clutter_imcontext_version_major.clutter_imcontext_version_minor.clutter_imcontext_version_micro])
m4_define([clutter_imcontext_api_version],
          [clutter_imcontext_version_major.clutter_imcontext_version_minor])

AC_INIT(clutter_imcontext, clutter_imcontext_version)
AM_INIT_AUTOMAKE(clutter_imcontext, clutter_imcontext_version)
AC_CONFIG_HEADERS(config.h)

CLUTTER_IMCONTEXT_API_VERSION=clutter_imcontext_api_version
AC_SUBST(CLUTTER_IMCONTEXT_API_VERSION)

# Check for programs
AC_PROG_LIBTOOL
AC_PROG_CC
AC_PROG_INSTALL

# enable pkg-config
PKG_PROG_PKG_CONFIG

# Check for function availability
# AC_CHECK_FUNCS([memset])

AC_PATH_PROG([GLIB_GENMARSHAL], [glib-genmarshal])

PKG_CHECK_MODULES(CLUTTER, glib-2.0
			clutter-1.0 >= 1.0.0)

AC_SUBST(CLUTTER_CFLAGS)
AC_SUBST(CLUTTER_LIBS)

GTK_DOC_CHECK([1.9])

# Add --enable-debug arg
AC_ARG_ENABLE(debug,
              [  --enable-debug            Turn on debugging], ,
              enable_debug=no)
if test "$enable_debug" = "yes"; then
  AC_DEFINE(ENABLE_DEBUG,1,[Define this to enable the debug facility])
fi

# Output files
AC_OUTPUT([Makefile
clutter-imcontext/Makefile
clutter-imcontext/clutter-imcontext.pc
tools/Makefile
tests/Makefile
doc/Makefile
doc/reference/Makefile
doc/reference/version.xml
])

echo ""
echo "   clutter-imcontext $VERSION"
echo "   ====================="
echo "   Documentation: ${enable_gtk_doc}"
echo ""
echo "   To build the project, run \"make\""
echo ""

