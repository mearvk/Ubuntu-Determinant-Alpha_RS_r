#!/bin/sh -e

PACKAGE=$(dpkg-parsechangelog -S Source)
VERSION=$2
DIR=${PACKAGE}-${VERSION}
TAR=../${PACKAGE}_${VERSION}.orig.tar.xz
TAG=maven-mapping-$VERSION

svn export https://svn.apache.org/repos/asf/maven/shared/tags/$TAG/ $DIR
tar -c -J -f $TAR $DIR
rm -rf $DIR ../$TAG $3
