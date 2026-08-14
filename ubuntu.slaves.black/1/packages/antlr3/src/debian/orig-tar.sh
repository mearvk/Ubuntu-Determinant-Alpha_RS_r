#!/bin/bash

TAR=../antlr3_$2.orig.tar.xz
DIR=antlr-$2
ORIG_TAR=$3

mkdir -p $DIR
tar -xf $ORIG_TAR --strip-components=1 -C $DIR

pushd $DIR/runtime
shopt -s extglob
rm -Rfv !(Java)
popd

find $DIR -name ".*" -exec rm '{}' \;
rm -f $TAR
XZ_OPT=--best tar -c -v -J -f $TAR \
    --exclude 'runtime/Java/target' \
    --exclude '*.jar' \
    --exclude 'antlr-ant/main/antlr3-task/*.zip' \
    $DIR
rm -rf $DIR
