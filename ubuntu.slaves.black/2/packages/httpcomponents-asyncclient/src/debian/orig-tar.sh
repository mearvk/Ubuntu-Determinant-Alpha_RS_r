#!/bin/sh -e
#
# Removes unwanted content from the upstream sources.
# Called by uscan with '--upstream-version' <version> <file>
#

VERSION=$2
TAR=../httpcomponents-asyncclient_$VERSION.orig.tar.xz
DIR=httpcomponents-asyncclient-$VERSION
TAG=$(echo "$VERSION" | sed -re's/~(alpha|beta|rc)/-\1-/')

svn export https://svn.apache.org/repos/asf/httpcomponents/httpasyncclient/tags/${TAG}/ $DIR
XZ_OPT=--best tar -c -J -f $TAR --exclude '*.jar' --exclude '*.class' $DIR
rm -rf $DIR ../$TAG
