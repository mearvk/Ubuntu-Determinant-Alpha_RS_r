#!/bin/sh -e

VERSION=$2
TAR=../fastinfoset_$VERSION.orig.tar.xz
DIR=fastinfoset-$VERSION
TAG=$(echo "$VERSION" | sed -re's/~(alpha|beta)/-\1-/;s/\./_/g')

svn export https://svn.java.net/svn/fi~svn/tags/${TAG} $DIR
XZ_OPT=--best tar -c -J -f $TAR \
    --exclude '*.jar' \
    --exclude '*.class' \
    --exclude '*.zip' \
    $DIR
rm -rf $DIR ../$TAG

# move to directory 'tarballs'
if [ -r .svn/deb-layout ]; then
  . .svn/deb-layout
  mv $TAR $origDir && echo "moved $TAR to $origDir"
fi
