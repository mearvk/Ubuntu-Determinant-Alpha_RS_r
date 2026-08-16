dnl Process this file with autoconf to produce configure.
# vim: noet sw=8
# $Id: configure.ac,v 1.21 2007/03/03 13:44:14 stevecheng Exp $

AC_INIT([docbook2X], 0.8.8, [stevecheng@users.sourceforge.net], docbook2X)
AC_CONFIG_SRCDIR(perl/docbook2X.pl)

AM_INIT_AUTOMAKE(docbook2X, 0.8.8)

XSLT_PROCESSOR="libxslt"

AC_ARG_WITH(html-xsl, 
	AC_HELP_STRING([--with-html-xsl],
[build HTML documentation using Norman Walsh's DocBook XSL stylesheets (default is no)]),
	HTML_XSL="$withval",
	HTML_XSL=no)
AC_ARG_WITH(xslt-processor,
	AC_HELP_STRING([--with-xslt-processor=ARG],
[which XSLT processor to use (possible choices are: libxslt, saxon, xalan-j)]),
	XSLT_PROCESSOR="$withval",
	XSLT_PROCESSOR="libxslt")
AC_ARG_WITH(resolver-jars,
	AC_HELP_STRING([--with-resolver-jars=ARG],
[specify Java class path for Apache XML Commons catalogs resolver]),
	RESOLVER_JARS="$withval",
	RESOLVER_JARS="")
AC_ARG_WITH(saxon-jars,
	AC_HELP_STRING([--with-saxon-jars=ARG],
[specify Java class path for SAXON XSLT processor]),
	SAXON_JARS="$withval",
	SAXON_JARS="")
AC_ARG_WITH(xalan-jars,
	AC_HELP_STRING([--with-xalan-jars=ARG],
[specify Java class path for Xalan XSLT processor]),
	XALAN_JARS="$withval",
	XALAN_JARS="")



AM_CONDITIONAL(HAVE_HTML_XSL, test "x$HTML_XSL" != "xno")
AC_SUBST(XSLT_PROCESSOR)
	
dnl Check for compiler, Perl...
AC_PROG_CC
AC_PROG_INSTALL

AC_PATH_PROG(PERL, perl)
if test -z "$PERL" ; then
	AC_MSG_ERROR(You need Perl 5)
fi

dnl For db2x_manxml and db2x_texixml
AC_PATH_PROG(ICONV, iconv piconv)
if test -z "$ICONV" ; then
	AC_MSG_ERROR(You need iconv)
fi
dnl (piconv is an iconv implementation from Perl 5.8.0.
dnl  I haven't heard of anyone using it regularly, but
dnl  I added it here for the convenience of non-GNU
dnl  platforms that may not already have a working
dnl  iconv.)

dnl For sgml2xml-isoent
AC_PATH_PROG(SX, sgml2xml sx)
AC_PATH_PROG(OSX, osx)

dnl For db2x_texixml
AC_PATH_PROG(MAKEINFO, makeinfo)

dnl For testing man pages.  
dnl We check for groff only; Unix nroff is useless for testing.
AC_PATH_PROG(GROFF, groff)
AM_CONDITIONAL(HAVE_GROFF, test -n "$GROFF")

dnl For validating the docbook2X documentation XML sources
AC_PATH_PROG(XMLLINT, xmllint)
AM_CONDITIONAL(HAVE_XMLLINT, test -n "$XMLLINT")

dnl Tidy is for tidying up the output from the HTML stylesheets.
AC_PATH_PROG(TIDY, tidy)
AM_CONDITIONAL(HAVE_TIDY, test -n "$TIDY")


dnl The XSLT processors
AC_PATH_PROG(XSLTPROC, xsltproc)
AC_PATH_PROG(JAVA, java)

if test -z "$RESOLVER_JARS" ; then
AC_CHECK_FILE(/usr/local/share/java/resolver.jar, 
	[ RESOLVER_JARS=/usr/local/share/java/resolver.jar ])
fi
if test -z "$RESOLVER_JARS" ; then
AC_CHECK_FILE(/usr/share/java/resolver.jar,
	[ RESOLVER_JARS=/usr/share/java/resolver.jar ])
fi
if test -z "$RESOLVER_JARS" ; then
AC_CHECK_FILE(/usr/share/java/xml-commons-resolver-1.1.jar,
	[ RESOLVER_JARS=/usr/share/java/xml-commons-resolver-1.1.jar ])
fi
AC_SUBST(RESOLVER_JARS)

if test -z "$SAXON_JARS" ; then
AC_CHECK_FILE(/usr/local/share/java/saxon.jar, 
	[ SAXON_JARS=/usr/local/share/java/saxon.jar ])
fi
if test -z "$SAXON_JARS" ; then
AC_CHECK_FILE(/usr/share/java/saxon.jar,
	[ SAXON_JARS=/usr/share/java/saxon.jar ])
fi
AC_SUBST(SAXON_JARS)

if test -z "$XALAN_JARS" ; then
AC_CHECK_FILE(/usr/local/share/java/xalan.jar, 
	[ XALAN_JARS=/usr/local/share/java/xalan.jar ])
fi
if test -z "$XALAN_JARS" ; then
AC_CHECK_FILE(/usr/share/java/xalan.jar,
	[ XALAN_JARS=/usr/share/java/xalan.jar ])
fi
if test -z "$XALAN_JARS" ; then
AC_CHECK_FILE(/usr/share/java/xalan2.jar,
	[ XALAN_JARS=/usr/share/java/xalan2.jar ])
fi
AC_SUBST(XALAN_JARS)



dnl For utf8trans
AM_CONFIG_HEADER(utf8trans/config.h)
AC_CHECK_HEADERS(getopt.h)
AC_CHECK_FUNCS(getline, ,)
AC_CHECK_FUNCS(getopt_long,,)

dnl ----------------------------------------------------------------------
dnl
dnl Default paths enbedded in db2x_xsltproc binary:
dnl

dnl This bit copied from libggi's configure:

test "x$prefix" = xNONE && prefix=$ac_default_prefix
test "x$exec_prefix" = xNONE && exec_prefix='${prefix}'

dnl Use static_* to substitute into files where values shouldn't
dnl dynamicly change.  Makefiles need to be able to dynamicly change
dnl paths between build and install and shouldn't use these static_*.
dnl Files that will be installed must always show the final location where
dnl they will reside and should use these static_* values.
dnl Ensure that all static_* are fully expanded.

eval static_datadir="$datadir"

eval static_bindir="$bindir"
old_val=""
until test "$static_bindir" = "$old_val"; do
	old_val="$static_bindir"
	eval static_bindir="$static_bindir"
done

dnl For perl/config.pl
INSTALLED_UTF8TRANS="$static_bindir/`echo utf8trans | sed -e "$program_transform_name"`"
INSTALLED_CHARMAP_ROFF="$static_datadir/docbook2X/charmaps/roff.charmap"
INSTALLED_CHARMAP_TEXI="$static_datadir/docbook2X/charmaps/texi.charmap"

INSTALLED_DB2X_MANXML="$static_bindir/`echo db2x_manxml | sed -e "$program_transform_name"`"
INSTALLED_DB2X_TEXIXML="$static_bindir/`echo db2x_texixml | sed -e "$program_transform_name"`"

INSTALLED_STYLESHEETS_CATALOG="$static_datadir/docbook2X/xslt/catalog.xml"
INSTALLED_DB2X_XSLTPROC="$static_bindir/`echo db2x_xsltproc | sed -e "$program_transform_name"`"
INSTALLED_SGML2XML_ISOENT="$static_bindir/`echo sgml2xml-isoent | sed -e "$program_transform_name"`"

AC_SUBST(INSTALLED_UTF8TRANS)
AC_SUBST(INSTALLED_CHARMAP_ROFF)
AC_SUBST(INSTALLED_CHARMAP_TEXI)
AC_SUBST(INSTALLED_DB2X_MANXML)
AC_SUBST(INSTALLED_DB2X_TEXIXML)
AC_SUBST(INSTALLED_STYLESHEETS_CATALOG)
AC_SUBST(INSTALLED_DB2X_XSLTPROC)
AC_SUBST(INSTALLED_SGML2XML_ISOENT)

dnl Turn on compiler warnings (for utf8trans)
CFLAGS="${CFLAGS} -Wall"
AC_SUBST(CFLAGS)


dnl ----------------------------------------------------------------------
dnl
dnl Makefile output
dnl

AC_OUTPUT(
Makefile
charmaps/Makefile dtd/Makefile
xslt/Makefile 
xslt/common/Makefile xslt/common/text/Makefile
xslt/man/Makefile xslt/texi/Makefile
xslt/documentation/Makefile xslt/backend/Makefile
perl/Makefile 
perl/config.pl perl/sgml2xml-isoent
utf8trans/Makefile
doc/Makefile
test/Makefile test/refentry/Makefile test/complete-manuals/Makefile
test/utf8trans/Makefile test/sgml/Makefile
)

