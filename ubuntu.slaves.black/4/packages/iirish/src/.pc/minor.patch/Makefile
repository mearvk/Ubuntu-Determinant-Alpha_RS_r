# Makefile for ispell-ga
# ispell-ga -- Ispell dictionary list for Irish Gaelic (irish)
#
# Copyright (C) Alastair McKinstry, 1997,1998, 2002
# Released under the GNU Public License
#
# $Id: Makefile,v 1.1.1.1 2000/03/06 19:36:18 alastairmck Exp $

ifndef PREFIX
PREFIX=${DESTDIR}/usr
endif

RELEASE=2.0

# Edit WORDLISTS to change list of words that are included.

# WORDLISTS= wordlists/words 	\
	   wordlists/computer 	\
	   wordlists/languages	\
	   wordlists/places	\
	   wordlists/names	\
	   wordlists/unchecked-words\
	   wordlists/scannell-words

WORDLISTS = scannell/gaeilge.raw


irish.words irish.hash: $(WORDLISTS)
#	cat $(WORDLISTS) | ./tools/irish-prefixes.pl > irish.words
	cat $(WORDLISTS) > irish.words
	buildhash irish.words irish.aff irish.hash

tests: build
	$(MAKE) -C tests

clean:
	rm -f *.cnt *.stat  irish.words *~ *.bak *.hash
	$(MAKE) -C tests clean
	${MAKE} -C rpm clean

reallyclean: clean
	rm -rf *.hash

test:
	rm -f irish.hash
	cat $(WORDLISTS) incorrect-words |  ./irish-prefixes.pl > irish.words
	buildhash irish.words irish.aff irish.hash


munch:
	for d in $(WORDLISTS) incorrect-words ; do munchlist -l  irish.aff $$d > tmp ; mv tmp $$d ; done



rpm: 
	${MAKE} -C rpm rpm

install: install-ispell 

install-ispell: irish.hash
	mkdir -p $(PREFIX)/lib/ispell
	mkdir -p $(PREFIX)/share/man/man5
	cp irish.hash $(PREFIX)/lib/ispell
	cp irish.aff  $(PREFIX)/lib/ispell
	cp gaeilge.5 $(PREFIX)/share/man/man5

install-words: irish.words
	mkdir -p $(PREFIX)/share/dict
	cp irish.words $(PREFIX)/share/dict/irish
