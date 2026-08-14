# vim:set ts=2:noet:
include ../common.mk
bdir=generated

.PHONY: all install clean

all: $(bdir)/manpages.stamp

install: $(bdir)/manpages.stamp
	for man in $(bdir)/apt-listchanges*.1; do \
		test -s "$$f"; \
		lang=`echo $$man | sed -e 's/^.*apt-listchanges\.*// ; s/\.*1//'`; \
		install -d $(DESTDIR)/usr/share/man/$$lang/man1;                \
		install -m 644 $$man $(DESTDIR)/usr/share/man/$$lang/man1/apt-listchanges.1; \
	done
clean:
	rm -rf generated

PO4A := PERL_HASH_SEED=0 PERL_PERTURB_KEYS=0 po4a $(XGETTEXT_COMMON_OPTIONS) --previous

# params: input output
define xml2man
	set -- xmllint --valid --noout --noent --nonet "$(1)"; \
	echo "$$@"; \
	"$$@"; \
	lang="`echo "$(1)" | sed -e 's/^.*apt-listchanges//; s/\.xml$$// ;s/^\.//'`"; \
	[ "$$lang" ] && langparam="--stringparam l10n.gentext.default.language $$lang" || langparam=""; \
	set -- xsltproc --nonet --xinclude \
						$$langparam \
						--stringparam man.authors.section.enabled 0 \
						--stringparam man.output.lang.in.name.enabled 1 \
						--stringparam man.charmap.enabled 0 \
						--stringparam man.hyphenate 0 \
						--stringparam man.justify 0 \
						--output "$(bdir)/" \
					/usr/share/xml/docbook/stylesheet/docbook-xsl/manpages/docbook.xsl \
					"$(1)"; \
	echo "$$@"; \
	"$$@"; \
	echo
endef


update-po:
	$(PO4A) --force -v po4a.cfg

$(bdir)/po4a.stamp:  apt-listchanges.xml po/*.po po/*.add po4a.cfg
	$(PO4A)  -v po4a.cfg
	touch "$@"

$(bdir)/manpages.stamp: $(bdir)/po4a.stamp
	@ set -e; \
	for f in apt-listchanges.xml $(bdir)/apt-listchanges.*.xml; do \
		test -f "$$f" || continue; \
		g="$(bdir)/`basename $$f .xml`.1"; \
		$(call xml2man,$$f,$$g) ;  \
	done
	touch "$@"
