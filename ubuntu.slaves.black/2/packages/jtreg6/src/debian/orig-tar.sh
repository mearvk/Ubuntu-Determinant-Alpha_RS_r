#!/bin/sh -e

# called by uscan with '--upstream-version' <version> <file>
VERSION=$2
DIR=jtreg-${VERSION}
TAR=../jtreg_${VERSION}.orig.tar.gz

rm -f $3
wget http://hg.openjdk.java.net/code-tools/jtreg/archive/jtreg$VERSION.tar.gz
mv jtreg$VERSION.tar.gz $TAR


# move to directory 'tarballs'
if [ -r .svn/deb-layout ]; then
    . .svn/deb-layout
    mv $TAR $origDir
    echo "moved $TAR to $origDir"
fi

exit 0
