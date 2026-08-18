#!/bin/sh

set -e

# called by uscan with '--upstream-version' <version> <file>
TAR=../libhibernate3-java_$2.orig.tar.gz
DIR=libhibernate3-java-$2

# clean up the upstream tarball
tar zxf $3
rm $3
mv hibernate-distribution* $DIR
GZIP=--best tar -c -z -f $TAR -X debian/orig-tar.exclude $DIR
rm -rf $DIR

# move to directory 'tarballs'
if [ -r .svn/deb-layout ]; then
  . .svn/deb-layout
  mv $TAR $origDir
  echo "moved $TAR to $origDir"
fi
