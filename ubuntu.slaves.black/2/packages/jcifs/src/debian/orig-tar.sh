#!/bin/sh -e

# called by uscan with '--upstream-version' <version> <file>
VERSION=$2
TAR=../jcifs_$VERSION.orig.tar.xz
DIR=jcifs-$VERSION

# clean up the upstream tarball
mkdir $DIR
tar --strip-components=1 --directory=$DIR -xf $3
rm -f $3 $TAR
XZ_OPT=--best tar cJvf $TAR \
    --exclude 'docs/api' \
    --exclude '*.jar' \
    --exclude '*.class' \
    --exclude 'examples/Format.java' \
    $DIR
rm -rf $DIR

# move to directory 'tarballs'
if [ -r .svn/deb-layout ]; then
    . .svn/deb-layout
    mv $3 $origDir
    echo "moved $3 to $origDir"
fi

exit 0
