#!/bin/sh
set -e

VERSION=$2
DIR=httpcomponents-client-${VERSION}
TAR=../httpcomponents-client_${VERSION}.orig.tar.xz

# Download the public suffix list
# This file was downloaded by the download-maven-plugin during the build but is disabled in Debian
mkdir -p $DIR/httpclient/src/main/resources/mozilla/
wget https://publicsuffix.org/list/effective_tld_names.dat -O $DIR/httpclient/src/main/resources/mozilla/public-suffix-list.txt

tar -xf $3
rm $3
XZ_OPT=--best tar -c -v -J -f $TAR $DIR
rm -Rf $DIR
