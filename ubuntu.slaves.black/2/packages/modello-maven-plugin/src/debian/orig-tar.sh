#!/bin/sh -e

VERSION=$2
TAR=../modello-maven-plugin_$VERSION.orig.tar.xz
DIR=modello-maven-plugin-$VERSION

mkdir -p $DIR
tar -xf $3 --strip-components 1 -C $DIR
mv $DIR/modello-maven-plugin $DIR/modello-maven-plugin-$VERSION

XZ_OPT=--best tar -c -J -v -f $TAR --exclude '*.jar' --exclude '*.class' -C $DIR $DIR
rm -rf $DIR $3
