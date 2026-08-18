#!/bin/sh
set -e

VERSION=$2
DIR=args4j-args4j-site-${VERSION}
TAR=../args4j_${VERSION}.orig.tar.xz

tar -xf $3
rm $3
XZ_OPT=--best tar -c -v -J -f $TAR \
    --exclude '*.jar' \
    --exclude '*.zip' \
    --exclude '*.settings' \
    --exclude '*.classpath' \
    --exclude '*.project' \
    $DIR
rm -Rf $DIR
