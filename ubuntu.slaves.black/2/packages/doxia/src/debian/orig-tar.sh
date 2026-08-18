#!/bin/sh -e

VERSION=$2
TAR=../doxia_$VERSION.orig.tar.xz
DIR=doxia-$VERSION
TAG=$(echo "doxia-$VERSION" | sed -re's/~(alpha|beta)/-\1-/')

svn export http://svn.apache.org/repos/asf/maven/doxia/doxia/tags/${TAG}/ $DIR
XZ_OPT=--best tar -c -J -f $TAR --exclude '*.jar' --exclude '*.class' $DIR
rm -rf $DIR ../$TAG
