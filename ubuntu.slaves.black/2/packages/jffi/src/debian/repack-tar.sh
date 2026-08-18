#/bin/sh -e

VERSION=$2
UPSTREAM_TAR=../$VERSION.tar.gz
TAR=../jffi_$VERSION.orig.tar.xz
DIR=jffi-$VERSION
mkdir -p $DIR

# Unpack ready fo re-packing
tar -xzf $UPSTREAM_TAR -C $DIR --strip-components=1

# Repack excluding stuff we don't need
tar -cJf $TAR --exclude-from debian/orig-tar.exclude $DIR
rm -rf $DIR

