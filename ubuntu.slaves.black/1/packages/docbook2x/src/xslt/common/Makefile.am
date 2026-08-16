# $Id: Makefile.am,v 1.12 2006/03/19 20:39:37 stevecheng Exp $
#

SUBDIRS = text

XSL_FILES = check-idref.xsl cmdsynopsis.xsl gentext.xsl l10n.xsl \
	lists.xsl labels.xsl messages.xsl person.xsl titles.xsl \
	ucase.xsl whitespace.xsl string.xsl version.xsl
	
xsltdir = $(pkgdatadir)/xslt
xsltcommondir = $(xsltdir)/common
xsltcommon_DATA = $(XSL_FILES)

EXTRA_DIST = $(XSL_FILES)
