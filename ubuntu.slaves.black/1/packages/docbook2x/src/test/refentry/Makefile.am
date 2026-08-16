# ----------------------------------------------------------------------
# $Id: Makefile.am,v 1.11 2007/02/25 21:20:26 stevecheng Exp $
#

include $(top_srcdir)/docbuild.mk

XML_FILES = sgml2xml.xml sgmlnorm.xml docbook2manxml.xml VCR.xml \
            statgrab.xml vermeulen.xml sg_init.xml leidert-example.xml
MXML_FILES = sgml2xml.mxml sgmlnorm.mxml docbook2manxml.mxml VCR.mxml \
             statgrab.mxml vermeulen.mxml sg_init.mxml leidert-example.mxml
MAN_FILES = sgml2xml.1 sgmlnorm.1 docbook2manxml.1 VCR.7 \
            statgrab.3 vermeulen.3 sg_init.2 leidert-example.1



# ----------------------------------------------------------------------
#
# User targets
#

.PHONY: check man

check: man

man: $(MAN_FILES)



# ----------------------------------------------------------------------
#
# Man page conversion
#

%.mxml: %.xml
	$(db2x_xsltproc) -s man -o $@ $<

%.1: %.mxml
	$(db2x_manxml) $<
if HAVE_GROFF
	$(GROFF) -man -Tutf8 -z -w all $@ 2>&1 | grep "warning: " ; test $$? -eq 1 
endif
	$(db2x_perl) $(srcdir)/../htest-man.pl $@

%.2: %.mxml
	$(db2x_manxml) $<
if HAVE_GROFF
	$(GROFF) -man -Tutf8 -z -w all $@ 2>&1 | grep "warning: " ; test $$? -eq 1 
endif
	$(db2x_perl) $(srcdir)/../htest-man.pl $@

%.3: %.mxml
	$(db2x_manxml) $<
if HAVE_GROFF
	$(GROFF) -man -Tutf8 -z -w all $@ 2>&1 | grep "warning: " ; test $$? -eq 1 
endif
	$(db2x_perl) $(srcdir)/../htest-man.pl $@

%.7: %.mxml
	$(db2x_manxml) $<
if HAVE_GROFF
	$(GROFF) -man -Tutf8 -z -w all $@ 2>&1 | grep "warning: " ; test $$? -eq 1 
endif
	$(db2x_perl) $(srcdir)/../htest-man.pl $@

EXTRA_DIST = $(XML_FILES) 

CLEANFILES = $(MXML_FILES) $(MAN_FILES)

.DELETE_ON_ERROR:

