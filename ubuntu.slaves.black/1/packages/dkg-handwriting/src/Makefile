#!/usr/bin/make -f

# Makefile for ttf-fifthhorseman-dkg-handwriting

# (c) 2007-2009 Daniel Kahn Gillmor <dkg@fifthhorseman.net>
# Licensed under GPL v3 or later

# This Makefile is mostly a dummy, but it should allow for building an
# "upstream" tarball, and for a quick way to build the fonts cleanly.

dkg.ttf: dkg-handwriting.sfd dkg-handwriting.pe
	./dkg-handwriting.pe

dkgTTFs.zip: dkg.ttf
	ln -s . dkg-handwriting-font
	zip dkgTTFs.zip dkg-handwriting-font/*.ttf dkg-handwriting-font/README.TXT
	rm -f dkg-handwriting-font

clean: 
	rm -f *.ttf dkgTTFs.zip

# invoke this target like `make VERSION=0.1 release' to build an
# "upstream tarball" in the build subdir (note: the curly braces are a
# bashism -- you can only "make release" from bash or an equivalent)
release:
	mkdir -p build/upstream
	ln -s ../.. build/upstream/ttf-fifthhorseman-dkg-handwriting-$(VERSION)
	(cd build/upstream && tar czf ../ttf-fifthhorseman-dkg-handwriting_$(VERSION).tar.gz --exclude=.svn --exclude=*~ ttf-fifthhorseman-dkg-handwriting-$(VERSION)/{COPYING,README.TXT,Makefile,dkg-handwriting.{pe,sfd}})
	rm -f build/upstream/ttf-fifthhorseman-dkg-handwriting-$(VERSION)
