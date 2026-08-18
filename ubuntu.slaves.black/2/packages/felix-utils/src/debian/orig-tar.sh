#!/bin/sh -e

VERSION=$2
TAR=../felix-utils_$VERSION.orig.tar.xz
DIR=felix-utils-$VERSION
TAG=$(echo "org.apache.felix.utils-$VERSION" | sed -re's/~(alpha|beta)/-\1-/')

svn export https://svn.apache.org/repos/asf/felix/releases/${TAG}/ $DIR
XZ_OPT=--best tar -c -J -f $TAR --exclude '*.jar' --exclude '*.class' $DIR
rm -rf $DIR ../$TAG

# move to directory 'tarballs'
if [ -r .svn/deb-layout ]; then
  . .svn/deb-layout
  mv $TAR $origDir && echo "moved $TAR to $origDir"
fi
