#!/bin/sh -e

# called by uscan with '--upstream-version' <version> <file>
DIR=btm-dist-$2
TAR=../libbtm-java_$2.orig.tar.gz

unzip $3

GZIP=--best tar czf $TAR --exclude='*.jar' --exclude='*.tlog' $DIR
rm -rf $DIR ../$2 $3

# move to directory 'tarballs'
if [ -r .svn/deb-layout ]; then
    . .svn/deb-layout
    mv $TAR $origDir
    echo "moved $TAR to $origDir"
fi

