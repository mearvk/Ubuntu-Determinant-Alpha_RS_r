#!/bin/sh -e

VERSION=$2
TAR=../apache-pom_$VERSION.orig.tar.gz
DIR=apache-pom-$VERSION
TAG=$(echo "apache-$VERSION" | sed -re's/~(alpha|beta)/-\1-/')

svn export http://svn.apache.org/repos/asf/maven/pom/tags/${TAG}/ $DIR
GZIP=--best tar -c -z -f $TAR --exclude '*.jar' --exclude '*.class' $DIR
rm -rf $DIR ../$TAG
