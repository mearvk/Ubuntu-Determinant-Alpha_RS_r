#!/bin/bash

TAR=../antlr4_$2.orig.tar.xz
DIR=antlr-$2
ORIG_TAR=$3

mkdir -p $DIR
tar -xf $ORIG_TAR --strip-components=1 -C $DIR
rm $ORIG_TAR

pushd $DIR/runtime
shopt -s extglob
rm -Rfv !(Java)
popd

find $DIR -name ".*" -exec rm '{}' \;
rm -f $TAR
XZ_OPT=--best tar -c -v -J -f $TAR \
    --exclude 'runtime/Java/target' \
    --exclude 'runtime-testsuite/resources' \
    --exclude 'runtime-testsuite/src' \
    --exclude 'runtime-testsuite/test' \
    --exclude 'nb-configuration.xml' \
    --exclude '*.nuspec' \
    --exclude '*.ps1' \
    --exclude '*.jar' \
    --exclude '.github*' \
    --exclude '.travis*' \
    $DIR
rm -rf $DIR
