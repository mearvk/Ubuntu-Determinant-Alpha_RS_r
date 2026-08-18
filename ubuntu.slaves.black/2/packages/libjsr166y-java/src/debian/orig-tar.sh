#!/bin/sh

set -e

version=`dpkg-parsechangelog | grep '^Version:' | cut -f 2 -d ' ' | sed 's/-[^-]*$//'`
echo "version ${version}"
package=`dpkg-parsechangelog | sed -n 's/^Source: //p'`
tarball="${package}_${version}.orig.tar.gz"
DIR=jsr166
REMOTE=':pserver:anonymous@gee.cs.oswego.edu/home/jsr166/jsr166'
TAG='release-1_7_0'

#LC_ALL=C TZ=UTC cvs -d $REMOTE login
LC_ALL=C TZ=UTC cvs -d $REMOTE export -r $TAG jsr166

GZIP=--best tar --numeric --group 0 --owner 0 -X debian/orig-tar.excludes \
    -c -v -z -f "${tarball}" $DIR

rm -rf $DIR
