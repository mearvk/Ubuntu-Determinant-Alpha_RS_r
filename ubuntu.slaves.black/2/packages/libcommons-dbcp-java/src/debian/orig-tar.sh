#!/bin/sh -e

# $2 version
# $3 upstream tarball

TAR=../libcommons-dbcp-java_$2.orig.tar.xz
DIR=libcommons-dbcp-java-$2.orig

# From SVN
#VERSION=`echo $2 | sed -e 's/\+.*//g' | sed -e 's/\./_/g'`
#REVISION=HEAD
#REVISION=`echo $2 | sed -e 's/.*svn//'`
#svn export -r $REVISION http://svn.apache.org/repos/asf/commons/proper/dbcp/trunk $DIR

# From Tarball
tar xvzf $3
mv commons-dbcp-* $DIR

# Repack
XZ_OPT=--best tar -c -J -f $TAR $DIR
rm -rf $DIR

# move to directory 'tarballs'
if [ -r .svn/deb-layout ]; then
  . .svn/deb-layout
  mv $TAR $origDir
  echo "moved $TAR to $origDir"
fi

exit 0
