#!/bin/sh -e

VERSION=$2
TAR=../maven-repository-builder_$VERSION.orig.tar.xz
DIR=maven-repository-builder-$VERSION
TAG=$(echo "maven-repository-builder-$VERSION" | sed -re's/~(alpha|beta)/-\1-/')

svn export http://svn.apache.org/repos/asf/maven/shared/tags/${TAG} $DIR
XZ_OPT=--best tar -c -J -f $TAR --exclude '*.jar' --exclude '*.class' $DIR
rm -rf $DIR ../$TAG
