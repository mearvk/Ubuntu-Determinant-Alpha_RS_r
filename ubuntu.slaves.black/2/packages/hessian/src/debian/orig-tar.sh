#!/bin/sh

set -e

# called by uscan with '--upstream-version' <version> <file>
PACKAGE=`dpkg-parsechangelog | sed -n 's/^Source: //p'`
VERSION=$2
TAR=../${PACKAGE}_${VERSION}.orig.tar.xz
DIR=${PACKAGE}-${VERSION}.orig

rm -Rf $3

wget http://caucho.com/download/hessian-$VERSION-src.jar
unzip -d $DIR hessian-$VERSION-src.jar
rm hessian-$VERSION-src.jar

XZ_OPT=--best tar --numeric --group 0 --owner 0 -c -v -J -f $TAR \
    --exclude 'META-INF' --exclude **/test/** --exclude **/test  $DIR

rm -rf $DIR
