#!/bin/sh

set -e

TAR=../maven-doxia-tools_$2.orig.tar.xz
DIR=maven-doxia-tools-$2
TAG=maven-doxia-tools-$2

svn export http://svn.apache.org/repos/asf/maven/shared/tags/$TAG $DIR
XZ_OPT=--best tar -c -J -f $TAR $DIR
rm -rf $DIR ../$TAG
