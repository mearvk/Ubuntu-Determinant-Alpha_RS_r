#!/bin/sh -e

VERSION=$2
TAR=../maven-reporting-api_$VERSION.orig.tar.xz
DIR=maven-reporting-api-$VERSION
TAG=$(echo "maven-reporting-api-$VERSION" | sed -re's/~(alpha|beta)/-\1-/')

svn export http://svn.apache.org/repos/asf/maven/shared/tags/${TAG}/ $DIR
XZ_OPT=--best tar -c -J -f $TAR $DIR
rm -rf $DIR ../$TAG
