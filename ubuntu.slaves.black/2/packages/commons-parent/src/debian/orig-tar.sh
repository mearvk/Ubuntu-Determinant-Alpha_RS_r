#!/bin/sh -e

VERSION=$2
TAR=../commons-parent_$VERSION.orig.tar.gz
DIR=commons-parent-$VERSION
TAG=$(echo "commons-parent-$VERSION" | sed -re's/~(alpha|beta|RC)/-\1/')

svn export http://svn.apache.org/repos/asf/commons/proper/commons-parent/tags/${TAG}/ $DIR
GZIP=--best tar -c -z -f $TAR --exclude '*.jar' --exclude '*.class' $DIR
rm -rf $DIR ../$TAG

# move to directory 'tarballs'
if [ -r .svn/deb-layout ]; then
  . .svn/deb-layout
  mv $TAR $origDir && echo "moved $TAR to $origDir"
fi
