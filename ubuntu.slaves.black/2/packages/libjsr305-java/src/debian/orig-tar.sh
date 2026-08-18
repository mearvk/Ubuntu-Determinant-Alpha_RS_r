#!/bin/sh 

set -e

package="`dpkg-parsechangelog | sed -n 's/^Source: //p'`"
version="`dpkg-parsechangelog | sed -n 's/^Version: //p' | sed 's/-.*$//'`"
REPO="http://jsr-305.googlecode.com/svn/trunk"
rev="`echo $version | sed 's/^.*+svn\(.*\)/\1/'`"
TAR="${package}_${version}.orig.tar.gz"
DIR="${package}-${version}.orig"

svn export -r $rev ${REPO} ${DIR}
GZIP=--best tar --numeric --group 0 --owner 0 -cvzf ${TAR} \
    --exclude=javadoc ${DIR}

rm -rf ${DIR}
