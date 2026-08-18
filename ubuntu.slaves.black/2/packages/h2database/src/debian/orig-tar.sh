#!/bin/sh -e

VERSION=$2
TAR=../h2database_$VERSION.orig.tar.xz
DIR=h2database-$VERSION
TAG=version-$VERSION

mkdir $DIR
tar -xf $3 --strip-components=2 -C $DIR
rm -Rf $DIR/service

XZ_OPT=--best tar -c -v -J -f $TAR \
    --exclude '*.jar' \
    --exclude '*.class' \
    --exclude 'service/*' \
    $DIR
rm -rf $DIR $3
