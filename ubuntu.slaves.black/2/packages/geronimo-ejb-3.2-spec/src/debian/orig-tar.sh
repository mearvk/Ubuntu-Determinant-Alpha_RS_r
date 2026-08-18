#!/bin/sh -e
#
# Removes unwanted content from the upstream sources.
# Called by uscan with '--upstream-version' <version> <file>
#

VERSION=$2
TAR=../geronimo-ejb-3.2-spec_$VERSION.orig.tar.xz
DIR=geronimo-ejb-3.2-spec-$VERSION
TAG=$(echo "geronimo-ejb_3.2_spec-$VERSION" | sed -re's/~(alpha|beta|rc)/-\1/')

svn export https://svn.apache.org/repos/asf/geronimo/specs/tags/${TAG}/ $DIR
XZ_OPT=--best tar -c -J -f $TAR --exclude '*.jar' --exclude '*.class' $DIR
rm -rf $DIR ../$TAG

# move to directory 'tarballs'
if [ -r .svn/deb-layout ]; then
  . .svn/deb-layout
  mv $TAR $origDir && echo "moved $TAR to $origDir"
fi
