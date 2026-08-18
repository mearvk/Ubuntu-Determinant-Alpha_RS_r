#!/bin/sh -e

# called by uscan with '--upstream-version' <version> <file>

TAR=../libjamon-java_$2.orig.tar.gz
DIR=jamonapi

unzip $3
tar -c -z -f $TAR --exclude '*.jar' --exclude '*.war' $DIR
rm -rf $3 $DIR

# move to directory 'tarballs'
if [ -r .svn/deb-layout ]; then
  . .svn/deb-layout
  mv $TAR $origDir
  echo "moved $TAR to $origDir"
fi

