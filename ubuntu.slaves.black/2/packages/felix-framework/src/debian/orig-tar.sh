#!/bin/sh

set -x

# called by uscan with '--upstream-version' <version> <file>
package=`dpkg-parsechangelog | sed -n 's/^Source: //p'`
TAR=../"$package"_$2.orig.tar.xz
DIR=$package-$2.orig


tar xfz $3
mv org.apache.felix.framework-$2 $DIR
XZ_OPT=--best tar -c -J -f $TAR $DIR
rm -rf $DIR $3
