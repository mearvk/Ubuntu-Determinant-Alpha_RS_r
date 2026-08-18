#!/bin/sh -e

VERSION=$2
TAR=../felix-bundlerepository_$VERSION.orig.tar.xz
DIR=felix-bundlerepository-$VERSION
TAG=$(echo "org.apache.felix.bundlerepository-$VERSION" | sed -re's/~(alpha|beta)/-\1-/')

svn export https://svn.apache.org/repos/asf/felix/releases/${TAG}/ $DIR
XZ_OPT=--best tar -c -J -f $TAR --exclude '*.jar' --exclude '*.class' $DIR
rm -rf $DIR ../$TAG
