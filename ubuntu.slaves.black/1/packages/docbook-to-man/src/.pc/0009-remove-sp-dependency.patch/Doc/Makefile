# $Id: Makefile,v 1.1 1999/07/03 15:27:44 debacle Exp $

docbook-to-man.1: docbook-to-man.sgml
	nsgmls -i roff docbook-to-man.sgml | \
	    instant -t docbook-to-man.ts -c roff.cmap -s roff.sdata > \
	    docbook-to-man.1
