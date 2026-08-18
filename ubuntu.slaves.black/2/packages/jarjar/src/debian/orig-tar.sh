#!/bin/sh -e

VERSION=$2
TAR=../jarjar_$VERSION.orig.tar.gz
DIR=jarjar-$VERSION
REV=$(echo $VERSION | sed 's/^.*+svn\([0-9]\+\)$/\1/')

svn export http://jarjar.googlecode.com/svn/trunk/jarjar -r ${REV} $DIR
tar -c -z -f $TAR --exclude '*.jar' $DIR
rm -rf $DIR

# move to directory 'tarballs'
if [ -r .svn/deb-layout ]; then
  . .svn/deb-layout
  mv $TAR $origDir && echo "moved $TAR to $origDir"
fi
