#!/bin/sh

set -x

# called by uscan with '--upstream-version' <version> <file>
package=`dpkg-parsechangelog | sed -n 's/^Source: //p'`
TAR=../"$package"_$2.orig.tar.gz
DIR=$package-$2.orig


tar xfz $3
mv org.osgi.service.obr-$2 $DIR
GZIP=--best tar -c -z -f $TAR $DIR
rm -rf $DIR $3
