#!/bin/sh

set -e

PACKAGE=$(dpkg-parsechangelog -S Source)
VERSION=$2
TAR=../${PACKAGE}_${VERSION}.orig.tar.xz
DIR=${PACKAGE}_${VERSION}
TAG=$(echo "VALIDATOR_$VERSION" | sed -re's,\.,_,g')

svn export http://svn.apache.org/repos/asf/commons/proper/validator/tags/${TAG} $DIR
XZ_OPT=--best tar -c -J -f $TAR $DIR
rm -rf $DIR ../$TAG
