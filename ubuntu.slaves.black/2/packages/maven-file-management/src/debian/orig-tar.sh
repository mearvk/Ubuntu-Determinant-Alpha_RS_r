#!/bin/sh -e

VERSION=$2
TAR=../maven-file-management_$VERSION.orig.tar.xz
DIR=maven-file-management-$VERSION
TAG=$(echo "file-management-$VERSION" | sed -re's/~(alpha|beta)/-\1-/')

svn export http://svn.apache.org/repos/asf/maven/shared/tags/${TAG}/ $DIR
XZ_OPT=--best tar -c -J -f $TAR --exclude '*.jar' --exclude '*.class' $DIR
rm -rf $DIR ../$TAG
