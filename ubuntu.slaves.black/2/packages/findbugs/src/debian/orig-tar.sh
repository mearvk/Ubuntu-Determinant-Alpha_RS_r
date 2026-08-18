#!/bin/sh -e

PACKAGE=$(dpkg-parsechangelog -S Source)
VERSION=$2
DIR=${PACKAGE}-${VERSION}
TAR=../${PACKAGE}_${VERSION}.orig.tar.xz

mkdir $DIR.tmp $DIR
tar -xf $3 --strip-components=1 -C $DIR.tmp
mv $DIR.tmp/findbugs/* $DIR
rm $3
XZ_OPT=--best tar -c -v -J -f $TAR \
    --exclude '*.jar' \
    --exclude '*.pdf' \
    --exclude '.settings' \
    --exclude '.classpath' \
    --exclude '.project' \
    --exclude '.idea' \
    $DIR
rm -Rf $DIR.tmp $DIR
