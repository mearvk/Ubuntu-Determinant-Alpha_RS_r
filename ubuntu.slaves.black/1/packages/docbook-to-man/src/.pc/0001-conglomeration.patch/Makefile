#############################################################################
#
#	Makefile for docbook-to-man pieces
#
#############################################################################
#
# Copyright (c) 1996 X Consortium
# Copyright (c) 1996 Dalrymple Consulting
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
# X CONSORTIUM OR DALRYMPLE CONSULTING BE LIABLE FOR ANY CLAIM, DAMAGES OR
# OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
# ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
# OTHER DEALINGS IN THE SOFTWARE.
# 
# Except as contained in this notice, the names of the X Consortium and
# Dalrymple Consulting shall not be used in advertising or otherwise to
# promote the sale, use or other dealings in this Software without prior
# written authorization.
#
#############################################################################
#
# Written 5/29/96 by Fred Dalrymple
#
#############################################################################

ROOT =	/usr/local

SHELL =	/bin/sh
MAKE =	make

PIECES =	cmd Instant Transpec


all:
	for dir in $(PIECES); \
	do (cd $$dir; $(MAKE) all); \
	done

install:
	for dir in $(PIECES); \
	do (cd $$dir; $(MAKE) ROOT=$(ROOT) install); \
	done


clean:
	for dir in $(PIECES); \
	do (cd $$dir; $(MAKE) clean); \
	done

clobber:    
	for dir in $(PIECES); \
	do (cd $$dir; $(MAKE) clobber); \
	done
