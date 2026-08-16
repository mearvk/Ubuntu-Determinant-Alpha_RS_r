# ----------------------------------------------------------------------
# $Id: Makefile.am,v 1.5 2006/04/15 18:27:17 stevecheng Exp $
#

include $(top_srcdir)/docbuild.mk

XML_FILES = at1.xml dbtotexi.xml xml-catalogs-spec.xml
TXML_FILES = at1.txml dbtotexi.txml xml-catalogs-spec.txml
TEXI_FILES = at1.texi dbtotexi.texi xml-catalogs-spec.texi
INFO_FILES = at1.info dbtotexi.info xml-catalogs-spec.info



# ----------------------------------------------------------------------
#
# User targets
#

.PHONY: check texi info

check: texi info

texi: $(TEXI_FILES)
info: $(INFO_FILES)



# ----------------------------------------------------------------------
#
# Texinfo conversion
#

%.txml: %.xml
	$(db2x_xsltproc) -s texi -g output-file="$*" -o $@ $<

%.texi: %.txml
	$(db2x_texixml) $<

%.info: %.texi
	makeinfo --no-split $<



EXTRA_DIST = $(XML_FILES) 

CLEANFILES = $(TXML_FILES) $(TEXI_FILES) $(INFO_FILES)

.DELETE_ON_ERROR:

