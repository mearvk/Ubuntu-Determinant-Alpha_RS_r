#!/bin/sh -e

VERSION=$2
TAR=../nekohtml_$VERSION.orig.tar.xz
DIR=nekohtml-$VERSION
TAG=nekohtml-$2

svn export https://nekohtml.svn.sourceforge.net/svnroot/nekohtml/branches/$TAG $DIR
rm -r $DIR/lib
tar -c -J -f $TAR $DIR
rm -rf $DIR ../$TAG
