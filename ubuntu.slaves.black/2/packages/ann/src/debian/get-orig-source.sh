#!/bin/sh -e

# called by uscan with '--upstream-version' <version> <file>

pkg=ann
version=$2
src_tarball=$3

topdir=$pkg-$version+doc
rm -rf $topdir
mkdir $topdir
tar xfz $src_tarball --directory=$topdir --strip=1

doc_tarball=ANN_$version-doc.tar.gz
wget http://www.cs.umd.edu/%7Emount/ANN/Files/$version/$doc_tarball
tar xfz $doc_tarball --directory=$topdir/doc --strip=1
rm -f $doc_tarball

tarball=ann_$version+doc.orig.tar.gz
tar cfz $tarball $topdir
mv $tarball ..
rm -rf $topdir

echo Created upstream tarball ../$tarball
