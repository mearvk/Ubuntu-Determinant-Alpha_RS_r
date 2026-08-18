#!/bin/sh -e

VERSION=$2
TAR=../maven-invoker-plugin_$VERSION.orig.tar.xz
DIR=maven-invoker-plugin-$VERSION
TAG=$(echo "maven-invoker-plugin-$VERSION" | sed -re's/~(alpha|beta)/-\1-/')

svn export http://svn.apache.org/repos/asf/maven/plugins/tags/${TAG} $DIR
XZ_OPT=--best tar -c -J -v -f $TAR $DIR
rm -rf $DIR ../$TAG
