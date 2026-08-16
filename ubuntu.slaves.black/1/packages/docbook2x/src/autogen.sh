#!/bin/sh
set -e

if test ! -e perl/docbook2X.pl; then
echo "autogen.sh: Please run this script from the docbook2X/ directory.";
exit 1;
fi

# automake tries to detect the docbook2X.texi file
# but it does not exist until we build the package,
# so put a dummy value in there for now.
echo '@setfilename docbook2X.info' > doc/docbook2X.texi
echo '@setfilename docbook2man-xslt.info' > xslt/documentation/docbook2man-xslt.texi
echo '@setfilename docbook2texi-xslt.info' > xslt/documentation/docbook2texi-xslt.texi
# but if we had a good docbook2X.texi to begin with
# the above command would clobber it, so this tells the
# make system to build it again.
touch -t 197001010000 doc/docbook2X.texi
touch -t 197001010000 xslt/documentation/docbook2man-xslt.texi
touch -t 197001010000 xslt/documentation/docbook2texi-xslt.texi
rm -f doc/docbook2X.txml
rm -f xslt/documentation/docbook2man-xslt.txml
rm -f xslt/documentation/docbook2texi-xslt.txml

aclocal
autoheader
automake --add-missing
autoconf

