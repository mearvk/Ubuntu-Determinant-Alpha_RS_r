BISON_TEXI = doc/bison.texi
DESTDIR = $(CURDIR)/debian/tmp

TEXI2PDF = /usr/bin/texi2pdf
INSTALL = /usr/bin/install
CP = /bin/cp
SED = /bin/sed

EXAMPLES = examples/c++/calc++/calc++.cc \
           examples/c++/calc++/driver.cc \
           examples/c++/calc++/driver.hh \
           examples/c++/calc++/parser.yy \
           examples/c++/calc++/scanner.ll \
           examples/c++/simple.yy \
           examples/c/mfcalc/calc.h \
           examples/c/mfcalc/mfcalc.y \
           examples/c/rpcalc/rpcalc.y

all: doc/bison.texi
	$(MAKEINFO) --no-split $^
	$(SED) -i -e 's/image src="figs/image src="\/usr\/share\/doc\/bison-doc\/html\/figs/' bison.info
	$(MAKEINFO) -o html --html $^
	$(TEXI2PDF) -I build-aux $^
	examples/extexi $^ -- $(EXAMPLES)

install:
	$(INSTALL) -d $(DESTDIR)/usr/share/info
	$(CP) bison.info $(DESTDIR)/usr/share/info
	$(INSTALL) -d $(DESTDIR)/usr/share/doc/bison-doc
	$(CP) --parents $(EXAMPLES) $(DESTDIR)/usr/share/doc/bison-doc
	$(CP) -r bison.pdf html $(DESTDIR)/usr/share/doc/bison-doc
	$(INSTALL) -d $(DESTDIR)/usr/share/doc/bison-doc/html/figs
	$(CP) -r doc/figs/*.svg $(DESTDIR)/usr/share/doc/bison-doc/html/figs

