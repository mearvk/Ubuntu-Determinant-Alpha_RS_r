#!/bin/sh

set -e

VERSION=$2
TAR=../libcommons-net-java_$VERSION.orig.tar.xz
DIR=commons-net-$VERSION
TAG=$(echo "NET_$VERSION" | sed -re's,\.,_,')

svn export http://svn.apache.org/repos/asf/commons/proper/net/tags/${TAG} $DIR
XZ_OPT=--best tar -c -J -f $TAR $DIR
rm -rf $DIR ../$TAG
