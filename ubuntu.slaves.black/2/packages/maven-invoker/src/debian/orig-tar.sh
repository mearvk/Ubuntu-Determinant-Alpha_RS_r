#!/bin/sh -e


PACKAGE=$(dpkg-parsechangelog -S Source)
VERSION=$2
DIR=${PACKAGE}-${VERSION}
TAR=../${PACKAGE}_${VERSION}.orig.tar.xz

TAG=$(echo maven-invoker-${VERSION} | sed -e's,~,-,')

svn export http://svn.apache.org/repos/asf/maven/shared/tags/$TAG $DIR

XZ_OPT=--best tar -c -J -v -f $TAR $DIR
rm -rf $3 $DIR
