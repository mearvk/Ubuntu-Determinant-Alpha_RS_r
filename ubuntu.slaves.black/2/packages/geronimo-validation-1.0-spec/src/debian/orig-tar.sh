#!/bin/sh 

set -e

# called by uscan with '--upstream-version' <version> <file>
echo "version $2"
package=`dpkg-parsechangelog | sed -n 's/^Source: //p'`
version=$2
tarball=$3
TAR=${package}_${version}.orig.tar.xz
DIR=${package}-${version}.orig
upstream_package="$(echo $package | sed 's/-1\.0-spec/_1.0_spec/')"
REPO="http://svn.apache.org/repos/asf/geronimo/specs/tags/${upstream_package}-${version}/"

svn export $REPO $DIR
XZ_OPT=--best tar --numeric --group 0 --owner 0 -c -v -J -f $TAR $DIR

rm -rf $tarball $DIR
