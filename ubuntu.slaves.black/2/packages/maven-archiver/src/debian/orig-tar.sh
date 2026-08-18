#!/bin/sh -e

VERSION=$2
TAR=../maven-archiver_$VERSION.orig.tar.xz
DIR=maven-archiver-$VERSION
TAG=$(echo "maven-archiver-$VERSION" | sed -re's/~(alpha|beta)/-\1-/')

svn export http://svn.apache.org/repos/asf/maven/shared/tags/${TAG}/ $DIR
XZ_OPT=--best tar -c -J -f $TAR $DIR
rm -rf $DIR ../$TAG

# move to directory 'tarballs'
if [ -r .svn/deb-layout ]; then
  . .svn/deb-layout
  mv $TAR $origDir && echo "moved $TAR to $origDir"
fi
