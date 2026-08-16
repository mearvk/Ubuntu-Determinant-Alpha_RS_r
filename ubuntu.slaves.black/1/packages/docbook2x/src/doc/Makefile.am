# ----------------------------------------------------------------------
# $Id: Makefile.am,v 1.52 2007/02/25 22:28:05 stevecheng Exp $
#
# This Makefile builds the documentation for docbook2X in various
# formats.
#
# Unfortunately, you must not use VPATH builds if you want 
# the converted documentation to end up in the right place
# for the docbook2X distribution.  (It's an automake limitation
# that takes too much effort to work around.)
#

include $(top_srcdir)/docbuild.mk

# ----------------------------------------------------------------------
#
# Document info
#

# Stylesheets
XSLT_MAN = $(srcdir)/ss-man.xsl
XSLT_TEXI = $(srcdir)/ss-texinfo.xsl
XSLT_HTML = $(srcdir)/ss-html.xsl

XML_FILES = docbook2X.xml \
	changes.xml charsets.xml design-notes.xml faq.xml manpages.xml \
	quickstart.xml texinfo.xml textents.xml todo.xml xsltproc.xml \
	perf.xml testing.xml install.xml \
	i18n-system-property/i18n-system-property.xml

HTML_FILES = changes.html charsets.html cindex.html design-notes.html \
	db2x_manxml.html db2x_texixml.html db2x_xsltproc.html \
	sgml2xml-isoent.html docbook2X.html faq.html manpages.html \
	texinfo.html todo.html utf8trans.html xsltproc.html \
	performance.html testing.html install.html dependencies.html \
        docbook2man.html docbook2texi.html

MAN_FILES = db2x_manxml.1 db2x_texixml.1 db2x_xsltproc.1 utf8trans.1 \
	docbook2man.1 docbook2texi.1 sgml2xml-isoent.1

INFO_FILES = docbook2X.info
TEXI_FILES = docbook2X.texi

XSL_FILES = ss-man.xsl ss-texinfo.xsl ss-html.xsl

DOC = docbook2X
DOC_XML = $(DOC).xml



# ----------------------------------------------------------------------
#
# Validation
#

if HAVE_XMLLINT
DOC_VAL = .$(DOC).valid
$(DOC_VAL): $(XML_FILES)
	$(XMLLINT) --noout --valid $<
	touch $(DOC_VAL)
DOC_DEP = $(DOC_VAL)

validate: $(DOC_VAL)

else
DOC_DEP = $(XML_FILES)
endif



# ----------------------------------------------------------------------
#
# User targets
#

.PHONY: all html man texi

all: html man info

html: $(DOC).html
man: $(MAN_FILES)
texi: $(DOC).texi
info: $(DOC).info


# ----------------------------------------------------------------------
#
# HTML conversion
#

if HAVE_HTML_XSL
$(HTML_FILES): $(DOC_XML) $(DOC_DEP) $(XSLT_HTML)
	$(db2x_xsltproc) -s $(XSLT_HTML) $<
if HAVE_TIDY
	-$(TIDY) -q -m -f /dev/null \
		--doctype strict --output-xhtml true --add-xml-decl false \
		$(HTML_FILES)
endif
endif


# ----------------------------------------------------------------------
#
# Texinfo conversion
#

$(DOC).txml: $(DOC_XML) $(DOC_DEP) $(XSLT_TEXI)
	$(db2x_xsltproc) -s $(XSLT_TEXI) \
		--string-param install-datadir="$(datadir)/docbook2X/" \
		-o $@ $<

$(DOC).texi: $(DOC).txml
	$(db2x_texixml) $<

# Stupid makeinfo uses the POSIX locale for localizing documents
$(DOC).info: $(DOC).texi
	LANG=C makeinfo $<


# ----------------------------------------------------------------------
#
# Man page conversion
#

$(DOC).mxml: $(DOC_XML) $(DOC_DEP) $(XSLT_MAN)
	$(db2x_xsltproc) -s $(XSLT_MAN) \
		--string-param header-4="docbook2X $(VERSION)" \
		--string-param install-datadir="$(datadir)/docbook2X/" \
		-o $@ $<

$(MAN_FILES): $(DOC).mxml
	$(db2x_manxml) --solinks $<

# The use of $(srcdir) below is strange, and arguably not correct
# for VPATH builds; however, check gets called by automake's distcheck,
# which breaks if we do not use $(srcdir) here.
check: $(DOC).mxml
if HAVE_GROFF
	$(GROFF) -man -Tutf8 -z -w all $(srcdir)/*.1 2>&1 | grep "warning: " ; test $$? -eq 1
endif
	$(db2x_perl) $(top_srcdir)/test/htest-man.pl $(srcdir)/*.1

# Use for screenshot on Web site
demo-man.ps: $(MAN_FILES)
	groff -Tps -man $(srcdir)/docbook2man.1 $(srcdir)/docbook2texi.1 \
			$(srcdir)/db2x_manxml.1 $(srcdir)/db2x_texixml.1 \
			$(srcdir)/db2x_xsltproc.1 $(srcdir)/sgml2xml-isoent.1 \
			$(srcdir)/utf8trans.1 > demo-man.ps

# ----------------------------------------------------------------------
#
# The INSTALL, NEWS files
#
# The call to 'tr' is there because I absolutely hate the ugly
# fake directional ASCII quotes.
#
# Important: This rule doesn't work when configured for a VPATH build;
#            and it is not worthwhile to try to fix it because
#            it is a dangerous command anyway (it changes 
#            the INSTALL file in the distribution).
install.txt: install2.xml install.xml textents.xml
	$(db2x_xsltproc) -s $(XSLT_TEXI) install2.xml | $(db2x_texixml) --plaintext --to-stdout | tr \` \' > install.txt
	cp install.txt ../INSTALL

# ----------------------------------------------------------------------
#
# Distribution (automake)
#

EXTRA_DIST = $(XML_FILES) install2.xml $(MAN_FILES) $(HTML_FILES) \
	$(XSL_FILES) docbook2X.css \
	$(DOC).mxml $(DOC).txml .$(DOC).valid
# We include the last three files in the distribution, even though
# they are auto-generated, so that we don't trigger unnecessary
# rebuilding of the documentation on the user's end.

# Don't include big ass texinfo.tex
AUTOMAKE_OPTIONS = no-texinfo.tex

# ----------------------------------------------------------------------
#
# Install (automake)
#

htmldir = $(datadir)/doc/docbook2X

man_MANS = $(MAN_FILES)
html_DATA = $(HTML_FILES)
info_TEXINFOS = docbook2X.texi


# ----------------------------------------------------------------------
#
# Clean (automake)
#

MAINTAINERCLEANFILES = $(MAN_FILES) $(HTML_FILES) \
	$(INFO_FILES) $(TEXI_FILES) \
	$(DOC).mxml $(DOC).txml $(DOC_VAL)

.DELETE_ON_ERROR:

