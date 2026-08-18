#!/bin/sh -e

VERSION=$2
TAR=../maven-deploy-plugin_$VERSION.orig.tar.xz
DIR=maven-deploy-plugin-$VERSION
TAG=$(echo "maven-deploy-plugin-$VERSION" | sed -re's/~(alpha|beta)/-\1-/')

svn export https://svn.apache.org/repos/asf/maven/plugins/tags/${TAG}/ $DIR
XZ_OPT=--best tar -c -J -f $TAR $DIR
rm -rf $DIR ../$TAG
