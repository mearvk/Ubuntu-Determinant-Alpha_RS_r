# $Id: Makefile.am,v 1.21 2006/03/20 02:51:00 stevecheng Exp $
#
# This Makefile installs the Perl scripts and modules.
#

include $(top_srcdir)/docbuild.mk

PL_FILES = db2x_manxml.pl db2x_texixml.pl docbook2X.pl db2x_xsltproc.pl
SCRIPT_FILES = db2x_xsltproc sgml2xml-isoent \
	db2x_manxml db2x_texixml \
	docbook2man docbook2texi

MAKEMAKER_FILES = XML/Handler/Makefile.PL XML/Handler/SGMLSpl.pm
	
bin_SCRIPTS = $(SCRIPT_FILES)

db2x_xsltproc: config.pl db2x_xsltproc.pl
	rm -f $@
	cat $^ >$@
	chmod 555 $@
	$(PERL) -c -w $@

db2x_manxml: config.pl XML/Handler/SGMLSpl.pm db2x_manxml.pl
	rm -f $@
	cat $^ >$@
	chmod 555 $@
	$(db2x_perl) -c -w $@

db2x_texixml: config.pl XML/Handler/SGMLSpl.pm db2x_texixml.pl
	rm -f $@
	cat $^ >$@
	chmod 555 $@
	$(db2x_perl) -c -w $@

docbook2man: config.pl docbook2X.pl
	rm -f $@
	(cat config.pl ; echo 'my $$CONVERSION_TYPE = q<man>;'; cat $(srcdir)/docbook2X.pl) >$@
	chmod 555 $@
	$(PERL) -c -w $@

docbook2texi: config.pl docbook2X.pl
	rm -f $@
	(cat config.pl ; echo 'my $$CONVERSION_TYPE = q<texi>;'; cat $(srcdir)/docbook2X.pl) >$@
	chmod 555 $@
	$(PERL) -c -w $@

# Not needed anymore, we include the SGMLSpl module source
# directly into the db2x_manxml and db2x_texixml scripts	
#install-data-local:
#	if test ! -e XML ; then cp -dpR $(srcdir)/XML . ; fi
#	cd XML/Handler && perl Makefile.PL PREFIX=$(prefix) && $(MAKE) install

EXTRA_DIST = $(PL_FILES) $(MAKEMAKER_FILES)

DISTCLEANFILES = config.pl
CLEANFILES = $(SCRIPT_FILES)

