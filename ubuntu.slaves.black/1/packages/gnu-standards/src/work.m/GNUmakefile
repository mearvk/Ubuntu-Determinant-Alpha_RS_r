# $Id: GNUmakefile,v 1.10 2011/09/26 18:18:16 karl Exp $
# Copyright 2006, 2007, 2008, 2010, 2011 Free Software Foundation, Inc.
#
# Copying and distribution of this file, with or without modification,
# are permitted in any medium without royalty provided the copyright
# notice and this notice are preserved.
# 
# To use these targets, first do (one time only):
# - ln -s ../*.texi .
# - copy gendocs.sh and gendocs_template from texinfo/util here.
# - then try make a, then make b, then make c.
# - also update gnulib/doc.

# check that makeinfo is happy.
a:
	rm -rf maintain
	makeinfo maintain

# build everything.
b:
	gendocs.sh maintain "Information for maintainers of GNU software"

c:
# copy to a local checkout of all of www (specified by envvar $gw):
	cd manual && for f in `find -type f`; do \
	     cmp -s $$f $$gw/prep/maintain/$$f \
	  || \cp -f $$f $$gw/prep/maintain/$$f -v; done
	# if nodes were removed, remove their html_node files.
	# (and leave an anchor behind!)
