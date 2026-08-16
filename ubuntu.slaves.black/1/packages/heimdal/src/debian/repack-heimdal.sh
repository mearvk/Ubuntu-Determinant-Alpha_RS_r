#!/bin/sh
set -e

srcdir=$(dirname "$0")
version=$2
tgz="$(realpath "../heimdal_$version.orig.tar.xz")"
tmp=$(mktemp -d)

cd "$tmp"
tar xf "$tgz"
awk '/End Table/{flag=0;print}flag;/Start Table/{flag=1;print}' \
    heimdal-*/lib/wind/rfc3454.txt >rfc3454.txt
mv rfc3454.txt heimdal-*/lib/wind/
tar --xz -cf "$tgz" heimdal-*
