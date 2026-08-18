#!/bin/sh -e
#
# Removes unwanted content from the upstream sources.
# Called by uscan with '--upstream-version' <version> <file>
#

VERSION=$2
TAR=../geronimo-jcache-1.0-spec_$VERSION.orig.tar.xz
DIR=geronimo-jcache-1.0-spec-$VERSION
TAG=$(echo "geronimo-jcache_1.0_spec-$VERSION" | sed -re's/~(alpha|beta|rc)/-\1/')

svn export http://svn.apache.org/repos/asf/geronimo/specs/tags/${TAG}/ $DIR
XZ_OPT=--best tar -c -J -f $TAR --exclude '*.jar' --exclude '*.class' $DIR
rm -rf $DIR ../$TAG
