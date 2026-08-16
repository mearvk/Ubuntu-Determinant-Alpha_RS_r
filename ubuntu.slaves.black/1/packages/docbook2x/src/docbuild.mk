# ----------------------------------------------------------------------
#
# Common defines for building documentation
#

db2x_perl = $(PERL)

# Location of docbook2X programs
stylesheets_catalog = $(top_srcdir)/xslt/catalog.xml

utf8trans = $(top_builddir)/utf8trans/utf8trans
db2x_texixml = $(db2x_perl) $(top_builddir)/perl/db2x_texixml --utf8trans-program=$(utf8trans) --utf8trans-map=$(top_srcdir)/charmaps/texi.charmap
db2x_manxml = $(db2x_perl) $(top_builddir)/perl/db2x_manxml --utf8trans-program=$(utf8trans) --utf8trans-map=$(top_srcdir)/charmaps/roff.charmap

db2x_xsltproc = $(top_builddir)/perl/db2x_xsltproc -C $(stylesheets_catalog)
