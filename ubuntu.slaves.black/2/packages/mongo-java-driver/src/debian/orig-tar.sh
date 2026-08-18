#!/bin/sh
set -e

VERSION=$2
DIR=mongo-java-driver-r${VERSION}
TAR=../mongo-java-driver_${VERSION}.orig.tar.xz

tar -xf $3
rm $3
XZ_OPT=--best tar -c -v -J -f $TAR --exclude '*.jar' --exclude 'gradlew*' --exclude 'gradle/wrapper' $DIR
rm -Rf $DIR
