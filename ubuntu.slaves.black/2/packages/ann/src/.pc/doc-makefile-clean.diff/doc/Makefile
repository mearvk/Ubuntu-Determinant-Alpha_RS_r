#-----------------------------------------------------------------------------
# Makefile for ANN User's Manual
#
# ANN: Approximate Nearest Neighbors
# Version: 1.1.1 08/04/06
#-----------------------------------------------------------------------------
# Copyright (c) 1997-2005 University of Maryland and Sunil Arya and
# David Mount.  All Rights Reserved.
# 
# This software and related documentation is part of the Approximate
# Nearest Neighbor Library (ANN).  This software is provided under
# the provisions of the Lesser GNU Public License (LGPL).  See the
# file ../ReadMe.txt for further information.
# 
# The University of Maryland (U.M.) and the authors make no
# representations about the suitability or fitness of this software for
# any purpose.  It is provided "as is" without express or implied
# warranty.
#-----------------------------------------------------------------------------
# Revision 0.1  03/04/98
#	Initial release
# Revision 1.1.1  08/04/06
#	Added copyright/license
#-----------------------------------------------------------------------------

#-----------------------------------------------------------------------------
# Basic definitions
#		BASEDIR		where include, src, lib, ... are
#-----------------------------------------------------------------------------

BASEDIR	= ..

#-----------------------------------------------------------------------------
# Some more definitions
#		ANNMAN		name of user's manual
#		FIGURES		list of included figures
#-----------------------------------------------------------------------------

ANNMAN = ANNmanual
FIGURES = Figs/ann.eps Figs/kd-tree.eps

#-----------------------------------------------------------------------------
# Make the program
#-----------------------------------------------------------------------------

default: ps

ps: $(ANNMAN).ps

pdf: $(ANNMAN).pdf

$(ANNMAN).pdf: $(ANNMAN).dvi
	dvipdf $(ANNMAN).dvi

%.eps: %.fig
	fig2dev -L eps $< $@

$(ANNMAN).ps: $(ANNMAN).dvi
	dvips $(ANNMAN).dvi

$(ANNMAN).dvi: $(ANNMAN).tex $(ANNMAN).bbl $(FIGURES)
	latex $(ANNMAN).tex
	latex $(ANNMAN).tex

$(ANNMAN).bbl: $(ANNMAN).tex $(FIGURES)
	latex $(ANNMAN).tex
	bibtex $(ANNMAN)

#-----------------------------------------------------------------------------
# configuration definitions
#-----------------------------------------------------------------------------

include ../Make-config

#-----------------------------------------------------------------------------
# Cleaning
#-----------------------------------------------------------------------------

clean:
	-rm -f core *.aux *.dvi *.log *.blg *.bbl *.toc $(FIGURES);

realclean: clean
	-rm -f $(ANNMAN).ps
	# (The following is intentionally omitted, beacuse it is part of
	# the distribution.)
	# -rm -f $(ANNMAN).pdf 
