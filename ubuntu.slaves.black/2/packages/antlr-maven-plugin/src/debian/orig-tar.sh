#!/bin/sh -e

VERSION=$2
TAR=../antlr-maven-plugin_$VERSION.orig.tar.gz
DIR=antlr-maven-plugin-$VERSION
TAG=$(echo "antlr-maven-plugin-$VERSION" | sed -re's/~(alpha|beta)/-\1-/')

svn export https://svn.codehaus.org/mojo/tags/${TAG}/ $DIR
GZIP=--best tar -c -z -f $TAR --exclude '*.jar' --exclude '*.class' $DIR
rm -rf $DIR ../$TAG
