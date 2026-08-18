#!/bin/sh

set -e

VERSION=$(dpkg-parsechangelog | sed -ne 's,^Version: \(.*\)-.*,\1,p')
SOURCE=$(dpkg-parsechangelog | sed -ne 's,Source: \(.*\),\1,p')

SVNROOT=http://svn.code.sf.net/p/itext/code/tags/iText_$(echo $VERSION | sed -e s/\\./_/g)/src

echo $SVNROOT

DIR=$SOURCE
TAR=../${SOURCE}_${VERSION}.orig.tar.gz

svn export $SVNROOT $DIR
find $DIR -name \*.java -o -name \*.ps -o -name \*.txt -o -name \*.gif -o -name \*.png -o -name \*.afm -o -name \*.html -o -name \*.xml -o -name \.ant*.properties | xargs tar -zcf $TAR
rm -rf $DIR

# move to directory 'tarballs'
if [ -r .svn/deb-layout ]; then
  . .svn/deb-layout
  mv $TAR $origDir
  echo "moved $TAR to $origDir"
fi
