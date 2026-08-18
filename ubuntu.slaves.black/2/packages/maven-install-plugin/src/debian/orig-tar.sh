#!/bin/sh -e

VERSION=$2
TAR=../maven-install-plugin_$VERSION.orig.tar.xz
DIR=maven-install-plugin-$VERSION
TAG=$(echo "maven-install-plugin-$VERSION" | sed -re's/~(alpha|beta)/-\1-/')

svn export http://svn.apache.org/repos/asf/maven/plugins/tags/${TAG}/ $DIR
XZ_OPT=--best tar -c -J -f $TAR --exclude '*.class' $DIR
rm -rf $DIR ../$TAG

# move to directory 'tarballs'
if [ -r .svn/deb-layout ]; then
  . .svn/deb-layout
  mv $TAR $origDir && echo "moved $TAR to $origDir"
fi
