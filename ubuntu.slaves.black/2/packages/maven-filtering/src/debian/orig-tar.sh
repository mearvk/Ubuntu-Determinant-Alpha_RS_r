#!/bin/sh -e

TAR=../maven-filtering_$2.orig.tar.xz
DIR=maven-filtering-$2
TAG=$(echo maven-filtering-$2 | sed -e's,~,-,')

svn export http://svn.apache.org/repos/asf/maven/shared/tags/$TAG $DIR
XZ_OPT=--best tar -c -J -f $TAR $DIR
rm -rf $DIR ../$TAG

# move to directory 'tarballs'
if [ -r .svn/deb-layout ]; then
  . .svn/deb-layout
  mv $TAR $origDir
  echo "moved $TAR to $origDir"
fi
