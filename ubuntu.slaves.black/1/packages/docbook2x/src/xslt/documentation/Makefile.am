# $Id: Makefile.am,v 1.11 2007/02/25 22:18:01 stevecheng Exp $
#
# This Makefile builds the stylesheet reference documentation.
#

include $(top_srcdir)/docbuild.mk

XSL_FILES = extract-jrefentry.xsl quote-xml.xsl extract-jrefentry2.xsl \
	ss-texi.xsl ss-html.xsl
XSL_FILES2 = extract-params.xsl

XML_FILES  = docbook2man-xslt.xml   docbook2texi-xslt.xml \
	     docbook2man-param.xml docbook2texi-param.xml
TXML_FILES = docbook2man-xslt.txml docbook2texi-xslt.txml
TEXI_FILES = docbook2man-xslt.texi docbook2texi-xslt.texi
INFO_FILES = docbook2man-xslt.info docbook2texi-xslt.info

all: texi info docbook2man-param.xml docbook2texi-param.xml
texi: docbook2man-xslt.texi docbook2texi-xslt.texi
info: docbook2man-xslt.info docbook2texi-xslt.info
html: .docbook2man-xslt.html .docbook2texi-xslt.html

docbook2man-xslt.xml: $(XSL_FILES)
	$(db2x_xsltproc) -s $(srcdir)/extract-jrefentry2.xsl -o $@ \
		$(srcdir)/../man/docbook.xsl \
		-g title="docbook2X Man-pages Stylesheets Reference" \
		-g input-filename="docbook.xsl"

docbook2texi-xslt.xml: $(XSL_FILES)
	$(db2x_xsltproc) -s $(srcdir)/extract-jrefentry2.xsl -o $@ \
		$(srcdir)/../texi/docbook.xsl \
		-g title="docbook2X Texinfo Stylesheets Reference" \
		-g input-filename="docbook.xsl"

docbook2man-param.xml: $(XSL_FILES2)
	$(db2x_xsltproc) -s $(srcdir)/extract-params.xsl -o $@ \
		$(srcdir)/../man/param.xsl

docbook2texi-param.xml: $(XSL_FILES2)
	$(db2x_xsltproc) -s $(srcdir)/extract-params.xsl -o $@ \
		$(srcdir)/../texi/param.xsl

%.txml: %.xml
	$(db2x_xsltproc) -s $(srcdir)/ss-texi.xsl -o $@ $< \
		-g output-file="$*"

%.texi: %.txml
	$(db2x_texixml) $<

%.info: %.texi
	LANG=C makeinfo $<


if HAVE_HTML_XSL
.%.html: %.xml
	$(db2x_xsltproc) -s ss-html.xsl \
			 -g base.dir="$*.html/" \
			 -g root.filename="$*" $<
if HAVE_TIDY
	-$(TIDY) -q -m -f /dev/null \
		--doctype strict --output-xhtml true --add-xml-decl false \
		$*.html/*.html
endif
	touch $@
endif

# Don't try to build any DVI stuff.
# It breaks distcheck.  I don't know why, and don't really care.
dvi:
dvi-am:
dvi-recursive:



# ----------------------------------------------------------------------
# 
# Distribution (automake)
# 
#

info_TEXINFOS = $(TEXI_FILES)
AUTOMAKE_OPTIONS = no-texinfo.tex

# This is a hack, we really do not want to distribute
# the .xml or .txml files, because they are huge,
# but if we omit them in the straightforward way,
# the Texinfo files get rebuilt at the user's end,
# which is wrong.
#
# Really, you ought to be able to tell make
# not to consider non-existent files as out-of-date.
# <sigh>
dist-hook:
	touch $(distdir)/docbook2man-xslt.xml
	touch $(distdir)/docbook2man-xslt.txml
	touch $(distdir)/docbook2man-xslt.texi
	touch $(distdir)/docbook2man-xslt.info
	touch $(distdir)/docbook2texi-xslt.xml
	touch $(distdir)/docbook2texi-xslt.txml
	touch $(distdir)/docbook2texi-xslt.texi
	touch $(distdir)/docbook2texi-xslt.info

EXTRA_DIST = $(XSL_FILES) $(XSL_FILES2)


# ----------------------------------------------------------------------
# 
# Clean (automake)
# 
#

MAINTAINERCLEANFILES = $(TEXI_FILES) $(INFO_FILES)
CLEANFILES = $(XML_FILES) $(TXML_FILES)

.DELETE_ON_ERROR:

