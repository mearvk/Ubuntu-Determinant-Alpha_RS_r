#!/bin/sh -e

# called by uscan with '--upstream-version' <version> <file>
VERSION=$2
TAR=../libhamcrest-java_$VERSION.orig.tar.gz
SOURCE=$(dpkg-parsechangelog | sed -ne 's,Source: \(.*\),\1,p')
DIR=${SOURCE}-$2

# clean up the upstream tarball
tar -z -x -f $3
rm $3
mv hamcrest-$2 $DIR
GZIP=--best tar -c -z -f $TAR --exclude '*.jar' --exclude '*/lib/*' $DIR
rm -rf $DIR

# move to directory 'tarballs'
if [ -r .svn/deb-layout ]; then
  . .svn/deb-layout
  mv $3 $origDir
  echo "moved $3 to $origDir"
fi
