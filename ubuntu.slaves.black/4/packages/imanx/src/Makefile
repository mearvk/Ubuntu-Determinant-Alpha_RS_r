# Makefile for ispell-gv
# ispell-gv -- Ispell dictionary list for Scots Gaelic (gaelg)
#
# Copyright (C) Alastair McKinstry, 1997,1998
# Released under the GNU Public License
#
# $Id: Makefile,v 1.1.1.1 1999/01/30 19:14:49 alastair Exp $

ISPELL=`rpm -q ispell`
VERSION=`cat version`

ifndef PREFIX
PREFIX=${DESTDIR}/usr
endif

# Edit WORDLISTS to change list of words that are included.

RPM_ROOT_DIR=/usr/src/redhat
WORDLISTS= words unchecked-words
ALLFILES= $(WORDLISTS) Makefile ispell-gv.spec.sed ChangeLog README COPYING \
	manx.4 gaelg.aff

TARFILE=ispell-gv-$(VERSION).tar


manx.hash: manx.words
	buildhash manx.words manx.aff manx.hash

manx.words: $(WORDLISTS)
	cat $(WORDLISTS) > manx.words

gv_GB.dic: manx.words
	wc -l manx.words > gv_GB.dic
	cat manx.words >> gv_GB.dic

clean:
	rm -f *.cnt *.stat  manx.words *~ *.bak *.log  *-stamp gv_GB.dic

reallyclean:
	make clean
	rm -rf *.hash

check: manx.words manx.hash
	${MAKE} -C tests check

munch:
	for d in $(WORDLISTS) incorrect-words ; do munchlist -l  manx.aff $$d > tmp ; mv tmp $$d ; done


tarfile: 
	make munch clean
	rm -f gaelg.hash ../ispell-gv-*
	ln -s ispell-gv ../ispell-gv-$(VERSION)
	tar  cvf ../$(TARFILE) -C .. -h  ispell-gv-$(VERSION)
	gzip ../$(TARFILE)
	rm ../ispell-gv-$(VERSION)
	ln -s ../$(TARFILE).gz ../ispell-gv-latest.tgz

../ispell-gv-latest.tgz:
	make tarfile

rpm: 	../ispell-gv-latest.tgz
	mv ../$(TARFILE).gz $(RPM_ROOT_DIR)/SOURCES
	sed s/DATESTAMP/$(DATE)/ < ispell-gv.spec.sed > $(RPM_ROOT_DIR)/SPECS/ispell-gv-$(VERSION).spec	
	(cd $(RPM_ROOT_DIR)/SPECS;	rpm -ba -vv --sign ispell-gv-$(VERSION).spec)


install: manx.hash manx.aff
	mkdir -p ${PREFIX}/lib/ispell
	cp manx.aff manx.hash ${PREFIX}/lib/ispell

install-words: manx.words
	mkdir -p ${PREFIX}/share/dict
	cp manx.words ${PREFIX}/share/dict/manx

install-myspell: gv_GB.dic
	mkdir -p ${PREFIX}/share/myspell/dicts
	mkdir -p ${PREFIX}/share/myspell/infos/ooo
	cp gv_GB.aff gv_GB.dic ${PREFIX}/share/myspell/dicts
	cp debian/myspell.info ${PREFIX}/share/myspell/infos/ooo/myspell-gv
