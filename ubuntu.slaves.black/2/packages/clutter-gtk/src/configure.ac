# clutter package version number, (as distinct from shared library version)
# An odd micro number indicates in-progress development, (eg. from git)
# An even micro number indicates a released version.
m4_define([clutter_gtk_major], [1])
m4_define([clutter_gtk_minor], [8])
m4_define([clutter_gtk_micro], [4])
m4_define([clutter_gtk_version], [clutter_gtk_major.clutter_gtk_minor.clutter_gtk_micro])

# increase the interface age for each release; if the API changes, set to 0
m4_define([clutter_gtk_interface_age], [4])
m4_define([clutter_gtk_binary_age], [m4_eval(100 * clutter_gtk_minor + clutter_gtk_micro)])

m4_define([clutter_gtk_release_status],
          [m4_if(m4_eval(clutter_gtk_micro % 2), [1],
                 [git],
                 [m4_if(m4_eval(clutter_gtk_minor % 2), [1],
                        [snapshot],
                        [release])])])

AC_PREREQ([2.63])

AC_INIT([clutter-gtk],
        [clutter_gtk_version],
        [http://bugzilla.gnome.org/enter_bug.cgi?product=clutter-gtk],
        [clutter-gtk],
        [http://www.clutter-project.org/libraries/clutter-gtk])

AC_CONFIG_HEADERS([config.h])
AC_CONFIG_SRCDIR([clutter-gtk/clutter-gtk.h])
AC_CONFIG_AUX_DIR([build])
AC_CONFIG_MACRO_DIR([build/autotools])

AM_INIT_AUTOMAKE([1.14 subdir-objects foreign -Wno-portability no-define no-dist-gzip dist-xz tar-ustar])

AM_SILENT_RULES([yes])

AC_SUBST([CLUTTER_GTK_MAJOR_VERSION],  [clutter_gtk_major])
AC_SUBST([CLUTTER_GTK_MINOR_VERSION],  [clutter_gtk_minor])
AC_SUBST([CLUTTER_GTK_MICRO_VERSION],  [clutter_gtk_micro])
AC_SUBST([CLUTTER_GTK_API_VERSION],    [1.0])
AC_SUBST([CLUTTER_GTK_API_VERSION_AM], [1_0])
AC_SUBST([CLUTTER_GTK_VERSION],        [clutter_gtk_version])
AC_SUBST([CLUTTER_GTK_RELEASE_STATUS], [clutter_gtk_release_status])

m4_define([lt_current], [m4_eval(100 * clutter_gtk_minor + clutter_gtk_micro - clutter_gtk_interface_age)])
m4_define([lt_revision], [clutter_gtk_interface_age])
m4_define([lt_age], [m4_eval(clutter_gtk_binary_age - clutter_gtk_interface_age)])
CLUTTER_GTK_LT_CURRENT=lt_current
CLUTTER_GTK_LT_REV=lt_revision
CLUTTER_GTK_LT_AGE=lt_age
CLUTTER_GTK_LT_VERSION="$CLUTTER_GTK_LT_CURRENT:$CLUTTER_GTK_LT_REV:$CLUTTER_GTK_LT_AGE"
CLUTTER_GTK_LT_LDFLAGS="-version-info $CLUTTER_GTK_LT_VERSION"

AC_CANONICAL_HOST
AC_MSG_CHECKING([if building for some Win32 platform])
AS_CASE([$host],
        [*-*-mingw*|*-*-cygwin*],
        [
          CLUTTER_GTK_LT_LDFLAGS="$CLUTTER_GTK_LT_LDFLAGS -no-undefined"
          platform_win32=yes
        ],

        [platform_win32=no]
)
AC_MSG_RESULT([$platform_win32])

AC_SUBST(CLUTTER_GTK_LT_VERSION)
AC_SUBST(CLUTTER_GTK_LT_LDFLAGS)

dnl ========================================================================

# Checks for programs.
AM_PROG_CC_C_O

# require libtool >= 2.2
LT_PREREQ([2.2.6])
LT_INIT([disable-static])

# Checks for header files.
AC_HEADER_STDC

AC_CHECK_LIBM
AC_SUBST(LIBM)

m4_define([clutter_req_version], [1.23.7])
m4_define([gtk_req_version], [3.21.0])

PKG_CHECK_MODULES([CLUTTER_GTK_DEPS], [clutter-1.0 >= clutter_req_version gtk+-3.0 >= gtk_req_version])
AC_SUBST([CLUTTER_GTK_DEPS_CFLAGS])
AC_SUBST([CLUTTER_GTK_DEPS_LIBS])

CLUTTER_GTK_HIDDEN_VISIBILITY_CFLAGS=""
case "$host" in
  *-*-mingw*)
    dnl on mingw32 we do -fvisibility=hidden and __declspec(dllexport)
    AC_DEFINE([CLUTTER_GTK_EXTERN], [__attribute__((visibility("default"))) __declspec(dllexport) extern],
              [defines how to decorate public symbols while building])
    CFLAGS="${CFLAGS} -fvisibility=hidden"
    ;;
  *)
    dnl on other compilers, check if we can do -fvisibility=hidden
    SAVED_CFLAGS="${CFLAGS}"
    CFLAGS="-fvisibility=hidden"
    AC_MSG_CHECKING([for -fvisibility=hidden compiler flag])
    AC_TRY_COMPILE([], [return 0],
                   AC_MSG_RESULT(yes)
                   enable_fvisibility_hidden=yes,
                   AC_MSG_RESULT(no)
                   enable_fvisibility_hidden=no)
    CFLAGS="${SAVED_CFLAGS}"

    AS_IF([test "${enable_fvisibility_hidden}" = "yes"], [
      AC_DEFINE([CLUTTER_GTK_EXTERN], [__attribute__((visibility("default"))) extern],
                [defines how to decorate public symbols while building])
      CLUTTER_GTK_HIDDEN_VISIBILITY_CFLAGS="-fvisibility=hidden"
    ])
    ;;
esac
AC_SUBST(CLUTTER_GTK_HIDDEN_VISIBILITY_CFLAGS)


m4_define([deprecated_default],
          [m4_if(m4_eval(clutter_gtk_minor % 2), [1],
                 [no],
                 [yes])])

AC_ARG_ENABLE([deprecated],
              [AS_HELP_STRING([--enable-deprecated=@<:@no/yes@:>@],
                              [Whether deprecated symbols should be disabled when compiling Clutter-GTK @<:@default=]deprecated_default[@:>
@])],
              [],
              [enable_deprecated=deprecated_default])

AS_CASE([$enable_deprecated],

        [no],
        [
          CLUTTER_GTK_DEPRECATED_CFLAGS="-DG_DISABLE_SINGLE_INCLUDES -DCOGL_DISABLE_DEPRECATED -DGDK_PIXBUF_DISABLE_DEPRECATED"
        ],

        [yes],
        [
          CLUTTER_GTK_DEPRECATED_CFLAGS="-DGLIB_DISABLE_DEPRECATION_WARNINGS -DCLUTTER_DISABLE_DEPRECATION_WARNINGS -DGDK_DISABLE_DEPRECATION_WARNINGS"
        ],

        [AC_MSG_ERROR([Unknown argument for --enable-deprecated])]
)

AC_SUBST([CLUTTER_GTK_DEPRECATED_CFLAGS])

dnl = Enable debug level ===================================================

m4_define([debug_default], [m4_if(m4_eval(clutter_gtk_minor % 2), [1], [yes], [minimum])])
AC_ARG_ENABLE([debug],
              [AS_HELP_STRING([--enable-debug=@<:@no/minimum/yes@:>@],
                              [Turns on debugging. @<:@default=]debug_default[@:>@])],
              [],
              [enable_debug=debug_default])

AS_CASE([$enable_debug],

        [yes],
        [
          test "$cflags_set" = set || CFLAGS="$CFLAGS -g"
          CLUTTER_GTK_DEBUG_CFLAGS="-DCLUTTER_GTK_ENABLE_DEBUG"
        ],

        [minimum],
        [
          CLUTTER_GTK_DEBUG_CFLAGS="-DCLUTTER_GTK_ENABLE_DEBUG -DG_DISABLE_CAST_CHECKS"
        ],

        [no],
        [
          CLUTTER_GTK_DEBUG_CFLAGS="-DG_DISABLE_ASSERT -DG_DISABLE_CHECKS -DG_DISABLE_CAST_CHECKS"
        ],

        [AC_MSG_ERROR([Invalid argument for --enable-debug])]
)

AC_SUBST([CLUTTER_GTK_DEBUG_CFLAGS])

# use strict compiler flags only on development releases
m4_define([maintainer_flags_default], [m4_if(m4_eval(clutter_gtk_minor % 2), [1], [yes], [no])])
AC_ARG_ENABLE([maintainer-flags],
              [AS_HELP_STRING([--enable-maintainer-flags=@<:@no/yes@:>@],
                              [Use strict compiler flags @<:@default=]maintainer_flags_default[@:>@])],
              [],
              [enable_maintainer_flags=maintainer_flags_default])

MAINTAINER_CFLAGS=""
AS_IF([test "x$enable_maintainer_flags" = "xyes" && test "x$GCC" = "xyes"],
      [
        AS_COMPILER_FLAGS([MAINTAINER_CFLAGS],
                          ["-Wall -Wshadow -Wcast-align -Wuninitialized
                            -Wno-strict-aliasing -Wempty-body -Wformat
                            -Wformat-security -Winit-self
                            -Wdeclaration-after-statement -Wvla"])
      ]
)

# strip leading spaces
MAINTAINER_CFLAGS=${MAINTAINER_CFLAGS#*  }
AC_SUBST(MAINTAINER_CFLAGS)

dnl = I18N =================================================================

AM_GNU_GETTEXT_VERSION([0.18])
AM_GNU_GETTEXT([external])

GETTEXT_PACKAGE="cluttergtk-1.0"
AC_SUBST(GETTEXT_PACKAGE)
AC_DEFINE_UNQUOTED(GETTEXT_PACKAGE,
                   "$GETTEXT_PACKAGE",
                   [The prefix for our gettext translation domains.])

dnl = GTK Doc check ========================================================

G_PREFIX=`$PKG_CONFIG --variable=prefix glib-2.0`
GDK_PREFIX=`$PKG_CONFIG --variable=prefix gdk-3.0`
GTK_PREFIX=`$PKG_CONFIG --variable=prefix gtk+-3.0`
GDK_PIXBUF_PREFIX=`$PKG_CONFIG --variable=prefix gdk-pixbuf-2.0`
CLUTTER_PREFIX=`$PKG_CONFIG --variable=prefix clutter-1.0`
AC_SUBST(G_PREFIX)
AC_SUBST(GDK_PREFIX)
AC_SUBST(GTK_PREFIX)
AC_SUBST(GDK_PIXBUF_PREFIX)
AC_SUBST(CLUTTER_PREFIX)

GTK_DOC_CHECK([1.24], [--flavour=no-tmpl])

GOBJECT_INTROSPECTION_CHECK([1.32])

AC_CONFIG_FILES([
        Makefile
        build/Makefile
        build/autotools/Makefile
        
        clutter-gtk/Makefile
        clutter-gtk/gtk-clutter-version.h
        
        doc/Makefile

        examples/Makefile

        po/Makefile.in

        clutter-gtk.pc
])

AC_OUTPUT

dnl ========================================================================

echo ""
echo " Clutter-GTK $CLUTTER_GTK_VERSION ($CLUTTER_GTK_RELEASE_STATUS)"
echo ""
echo "   Prefix: ${prefix}"
echo "   Libdir: ${libdir}"
echo ""
echo "   Debug level: ${enable_debug}"
echo "   Documentation: ${enable_gtk_doc}"
echo "   Compiler flags: $CFLAGS $MAINTAINER_CFLAGS"
echo "   Introspection data: ${enable_introspection}"
echo "   Enable deprecated symbols: ${enable_deprecated}"
echo ""
