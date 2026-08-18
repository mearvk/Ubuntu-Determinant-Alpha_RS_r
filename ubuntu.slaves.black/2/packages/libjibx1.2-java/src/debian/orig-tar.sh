#!/bin/sh -e

# called by uscan with '--upstream-version' <version> <file>
PACKAGE=$(dpkg-parsechangelog -S Source)
VERSION=$2
DIR=${PACKAGE}-${VERSION}
TAR=../${PACKAGE}_${VERSION}.orig.tar.xz

# clean up the upstream tarball
unzip $3
rm $3
mv jibx $DIR
XZ_OPT=--best tar -c -v -J -f $TAR \
    --exclude 'docs/api' \
    --exclude 'build/classes' \
    --exclude 'lib/*.jar' \
    $DIR
rm -rf $DIR
