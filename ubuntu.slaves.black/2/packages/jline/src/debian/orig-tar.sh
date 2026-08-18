#!/bin/sh -e

# called by uscan with '--upstream-version' <version> <file>
ZIP=../jline-$2.zip
DIR=jline-$2.orig
TAR=../jline_$2.orig.tar.gz

# clean up the upstream tarball
unzip $ZIP
mv jline-$2 $DIR
GZIP=--best tar czf $TAR -X debian/orig-tar.exclude $DIR
rm -rf $DIR $3 $ZIP

# move to directory 'tarballs'
if [ -r .svn/deb-layout ]; then
    . .svn/deb-layout
    mv $TAR $origDir
    echo "moved $TAR to $origDir"
fi

exit 0
