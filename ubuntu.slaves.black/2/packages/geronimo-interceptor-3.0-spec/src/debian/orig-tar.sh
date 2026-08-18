#!/bin/sh -e

if [ -r .svn/deb-layout ]; then
  . .svn/deb-layout
fi

if [ -z "$origDir" ]; then
	origDir=..
fi

echo "Storing orig tarball in '$origDir'."

# $1 = version
TAR=$origDir/geronimo-interceptor-3.0-spec_$2.orig.tar.gz
DIR=geronimo-interceptor-3.0-spec-java-$2

if [ -d "$DIR" ]; then
	echo "Could not temporarily unpack source tree in '$DIR', the directory is already existing."
	exit 1
fi

# clean up the upstream tarball
svn export http://svn.apache.org/repos/asf/geronimo/specs/tags/geronimo-interceptor_3.0_spec-$2/ $DIR
GZIP=--best tar -c -z -f $TAR $DIR
rm -rf $DIR
rm ../geronimo-interceptor_3.0_spec-$2
