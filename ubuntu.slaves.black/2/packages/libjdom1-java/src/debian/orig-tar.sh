#!/bin/sh -e

VERSION=$(echo $2)
TAR=../libjdom1-java_${VERSION}.orig.tar.gz
DIR=jdom-jdom-*

tar xvfz $3
rm $3
rm -r $DIR/core/lib/* $DIR/test/lib/* $DIR/contrib/lib/*
tar -c -z -f $TAR $DIR
rm -rf $DIR

# move to directory 'tarballs'
if [ -r .svn/deb-layout ]; then
  . .svn/deb-layout
  mv $TAR $origDir
  echo "moved $TAR to $origDir"
fi
