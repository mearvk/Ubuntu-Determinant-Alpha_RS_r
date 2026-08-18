#!/bin/sh -e

# called by uscan with '--upstream-version' <version> <file>

PACKAGE=$(dpkg-parsechangelog -S Source)
VERSION=$2
DIR=${PACKAGE}-${VERSION}
TAR=../${PACKAGE}_${VERSION}.orig.tar.xz

mkdir $DIR
tar -xf $3 --strip-components=1 -C $DIR
rm $3
XZ_OPT=--best tar -c -v -J -f $TAR \
    --exclude '*.jar' \
    $DIR
rm -Rf $DIR
