# $Id: Makefile.am,v 1.12 2004/08/07 00:31:54 stevecheng Exp $
#
# This Makefile installs the Texinfo XSLT stylesheets.
#

XSL_FILES = admon.xsl autotoc.xsl beginpage.xsl biblio.xsl block.xsl \
	callout.xsl caption.xsl component.xsl division.xsl \
	docbook.xsl footnote.xsl \
	force-inline.xsl formal.xsl glossary.xsl graphics.xsl \
	index.xsl info.xsl inline.xsl keywords.xsl lists.xsl math.xsl \
	menudescrip.xsl param.xsl pi.xsl qandaset.xsl refentry.xsl \
	sectioning.xsl sections.xsl synop.xsl table.xsl \
	texifile.xsl texinode-base.xsl texinode.xsl chunk.xsl \
	toc.xsl verbatim.xsl xref.xsl \
	jrefentry.xsl

xsltdir = $(pkgdatadir)/xslt
xslttexidir = $(xsltdir)/texi
xslttexi_DATA = $(XSL_FILES)

EXTRA_DIST = $(XSL_FILES)
