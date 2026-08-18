#!/bin/sh -e

# called by uscan with '--upstream-version' <version> <file>
SOURCE=$(dpkg-parsechangelog | sed -ne 's,Source: \(.*\),\1,p')
TAR=../${SOURCE}_$2.orig.tar.xz
DIR=$SOURCE-$2
TAG=$2
SVN=http://jtype.googlecode.com/svn/tags/

svn export $SVN/$TAG $DIR
XZ_OPT=--best tar -c -J -f $TAR $DIR
rm -rf $3 $DIR

# move to directory 'tarballs'
if [ -r .svn/deb-layout ]; then
  . .svn/deb-layout
  mv $TAR $origDir
  echo "moved $TAR to $origDir"
fi

