#!/bin/sh -e

VERSION=$2
TAR=../janino_$VERSION.orig.tar.xz
DIR=janino-$VERSION

svn export https://svn.codehaus.org/janino/tags/janino_$VERSION/ $DIR
tar -c -J -f $TAR --exclude .classpath --exclude .settings --exclude .project --exclude *.jar --exclude .hgignore $DIR
rm -rf $DIR ../$TAG $3

# move to directory 'tarballs'
if [ -r .svn/deb-layout ]; then
  . .svn/deb-layout
  mv $TAR $origDir
  echo "moved $TAR to $origDir"
fi
