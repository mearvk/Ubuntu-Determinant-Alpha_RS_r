# vim: noet sw=8
 
# ----------------------------------------------------------------------
# $Id: Makefile.am,v 1.3 2006/04/22 15:21:32 stevecheng Exp $
#

include $(top_srcdir)/docbuild.mk

SGML_FILES = docbook2man-sgmlspl.sgml
MXML_FILES = docbook2man-sgmlspl.mxml
MAN_FILES = docbook2man-sgmlspl.1

.PHONY: installcheck man

# We require installcheck, because the sgml2xml-isoent
# installed location is hard-coded into the db2x_xsltproc library.
# It isn't worth it to make it a configurable option.
#
# Note that we don't write commands in this Makefile 
# to convert to XML, since the whole point is to test
# that db2x_xsltproc is calling sgml2xml-isoent properly.
installcheck: man

man: $(MAN_FILES)

%.mxml: %.sgml
	$(db2x_xsltproc) --sgml -s man -o $@ $<

%.1: %.mxml
	$(db2x_manxml) $<
if HAVE_GROFF
	$(GROFF) -man -Tutf8 -z -w all $@ 2>&1 | grep "warning: " ; test $$? -eq 1
endif
	$(db2x_perl) $(srcdir)/../htest-man.pl $@

CLEANFILES = $(MXML_FILES) $(MAN_FILES)
EXTRA_DIST = $(SGML_FILES)

.DELETE_ON_ERROR:
