#!/bin/sh -e
#
# Removes unwanted content from the upstream sources.
# Called by uscan with '--upstream-version' <version> <file>
#

VERSION=$2
TAR=../maven-script-interpreter_$VERSION.orig.tar.xz
DIR=maven-script-interpreter-$VERSION
TAG=$(echo "maven-script-interpreter-$VERSION" | sed -re's/~(alpha|beta|rc)/-\1-/')

svn export http://svn.apache.org/repos/asf/maven/shared/tags/${TAG}/ $DIR
XZ_OPT=--best tar -c -J -f $TAR --exclude '*.jar' --exclude '*.class' $DIR
rm -rf $DIR ../$TAG

# move to directory 'tarballs'
if [ -r .svn/deb-layout ]; then
  . .svn/deb-layout
  mv $TAR $origDir && echo "moved $TAR to $origDir"
fi
