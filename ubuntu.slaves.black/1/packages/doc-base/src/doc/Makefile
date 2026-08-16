# vim:ts=2
# makefile for doc-base
# $Id: Makefile 206 2011-01-16 21:08:22Z robert $
#

ALL_TARGET := build-local
SUBDIRS		 := 
include ../common.mk

XMLLINT  := xmllint --nonet --noout --postvalid --xinclude
XSLTPROC := xsltproc --nonet --xinclude


generated := $(bdir)/version.ent							\
						 $(bdir)/doc-base.xml  						\
						 $(bdir)/doc-base.txt 						\
						 $(bdir)/doc-base.html/index.html \
						 $(bdir)/check-stamp							\
						 $(bdir)/section.list

$(ALL_TARGET): $(generated) | $(bdir)


$(bdir)/doc-base.xml: doc-base.xml | $(bdir)
	$(call msg,$@)
	cp -f $< $@
	touch -r $< $@

$(bdir)/check-stamp: $(bdir)/doc-base.xml $(bdir)/version.ent
	$(call msg,$@)
	$(XMLLINT) $(bdir)/doc-base.xml # check xml syntax
	touch $@

$(bdir)/doc-base.txt: $(bdir)/doc-base.xml $(bdir)/version.ent $(bdir)/check-stamp xsl/*.xsl
	$(call msg,$@)
	cd $(bdir) && $(XSLTPROC) $(CURDIR)/xsl/text.xsl $(<F) > doc-base.tmp.html
	lynx -dump -nolist $(bdir)/doc-base.tmp.html > $@

$(bdir)/doc-base.html/%: $(bdir)/doc-base.xml $(bdir)/version.ent $(bdir)/check-stamp xsl/*.xsl
	$(call msg,$@)
	cd $(bdir) &&  $(XSLTPROC) --stringparam base.dir doc-base.html $(CURDIR)/xsl/html-chunk.xsl $(<F)

$(bdir)/version.ent: $(bdir)/doc-base.xml $(CHANGELOGFILE) $(MAKEFILESLIST) | $(bdir)
	$(call msg,$@)
	echo "<!ENTITY version \"$(VERSION)\">"    > $@.new
	echo "<!ENTITY date    \"$(DATE_EN)\">"    >> $@.new
	mv -f $@.new $@

$(bdir)/section.list: doc-base.xml | $(bdir)
	$(call msg,$@)
	perl -e  \
	   'exec ("'perl'", "-ne", join("",@ARGV)) if $$#ARGV >-1;                                     '\
	   '      last           if /^\s*<!--\s*section\s+list\s+end\s*-->\s*$$/;                      '\
	   '      $$insect = 1   if /^\s*<!--\s*section\s+list\s+begin\s*-->\s*$$/;                    '\
	   '      next           unless $$insect;                                                      '\
	   '      next           if /\s*<!--\s*section\s+list\s+skip\s*-->/;                           '\
	   '      print "$$2\n"  if /^\s*<(term|para)>\s*<literal>\s*(.*)\s*<\/literal>\s*<\/\1>\s$$/; '\
	 < $< > $@.tmp
	touch -r $< $@.tmp
	mv $@.tmp $@
	sha1sum $@

install-local: $(generated) 
	$(call msg,$@)
	$(call install,$(docdir),$(bdir)/version.ent)
	$(call install,$(docdir)/doc-base.html,$(bdir)/doc-base.html/*)
	$(call install,$(docdir),$(bdir)/doc-base.xml $(bdir)/doc-base.txt,compress)
	$(call install,$(sharedir)/data,$(bdir)/section.list)
