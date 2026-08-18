#!/bin/sh -e

VERSION=$2
TAR=../maven-war-plugin_$VERSION.orig.tar.xz
DIR=maven-war-plugin-$VERSION
TAG=$(echo "maven-war-plugin-$VERSION" | sed -re's/~(alpha|beta)/-\1-/')

svn export http://svn.apache.org/repos/asf/maven/plugins/tags/${TAG}/ $DIR
XZ_OPT=--best tar -c -J -f $TAR $DIR
rm -rf $DIR ../$TAG
