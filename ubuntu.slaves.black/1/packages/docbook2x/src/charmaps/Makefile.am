CHARMAP_XML_FILES = texi.charmap texi.charmap.xml texi-small.charmap.xml
CHARMAP_FILES = roff.charmap roff.charmap.xml roff-small.charmap.xml 

# Disable for now, because the xmlcharmap2utf8trans script
# is not completely functional yet
#%.charmap: %.charmap.xml
#	$(PERL) $(srcdir)/xmlcharmap2utf8trans $< > $@

charmapsdir = $(pkgdatadir)/charmaps
charmaps_DATA = $(CHARMAP_XML_FILES) $(CHARMAP_FILES)

EXTRA_DIST = $(CHARMAP_XML_FILES) $(CHARMAP_FILES) xmlcharmap2utf8trans
