#!/bin/sh -e

# $2 = version
VERSION=$2
ZIP=$3
TAR=../jmock_$VERSION.orig.tar.gz
DIR=jmock-$VERSION.orig

# clean up the upstream tarball
unzip $ZIP -d tmp > /dev/null
cd tmp && \
	for j in *.jar; do
		unzip $j -d $(echo $j | sed -r 's/^(jmock-.*)-.*$/\1/')
	done && \
cd $OLDPWD
mv tmp $DIR
GZIP=--best tar -c -z -f $TAR --exclude '*.jar' --exclude '*.class' $DIR
rm -rf $DIR
rm $ZIP
