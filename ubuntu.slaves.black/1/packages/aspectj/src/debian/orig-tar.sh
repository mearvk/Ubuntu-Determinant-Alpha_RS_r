#!/bin/sh
#
# This script is called by uscan and filters out non-free elements
#

set -e

VERSION=$2
TAG="`echo $VERSION | tr . _`"
DIR="org.aspectj-$TAG"
TAR=../aspectj_$VERSION.orig.tar.xz

# Extract the upstream tarball fetched by uscan
rm -Rf $DIR
tar -xf $3
rm $3

find $DIR -name .cvsignore -delete
find $DIR -name .gitignore -delete

# Remove unlicenced files
find $DIR -type d -name "testdata" | xargs rm -rf
find $DIR -type d -name "testsrc"  | xargs rm -rf
rm -rf $DIR/tests/
rm -rf $DIR/testing/
rm -rf $DIR/org.aspectj.ajdt.core/scripts/*.py

# Remove non-free docs
rm -rf $DIR/docs/dist/doc/examples
rm -rf $DIR/docs/sandbox/
rm -rf $DIR/docs/teaching/
rm -rf $DIR/docs/test/
find $DIR -type f -name "*.doc" -delete
find $DIR -type f -name "*.pdf" -delete
find $DIR -type f -name "*.ppt" -delete
find $DIR -type f -name "*.vsd" -delete

# We'll use Debian version of these
rm -Rf $DIR/lib/ant
rm -Rf $DIR/lib/junit
rm -Rf $DIR/lib/commons
rm -Rf $DIR/lib/asm

# Remove the bcel jar and the archived source, rebuild them at package build time
rm -f $DIR/lib/bcel/bcel*.jar
rm -f $DIR/lib/bcel/bcel*.zip

# Expand the jdt sources and remove the archive
rm -f $DIR/org.eclipse.jdt.core/jdtcore-for-aspectj*.jar
mkdir -p $DIR/org.eclipse.jdt.core/src
unzip -o -d $DIR/org.eclipse.jdt.core/src $DIR/org.eclipse.jdt.core/jdtcore-for-aspectj*.zip
rm -f $DIR/org.eclipse.jdt.core/jdtcore-for-aspectj*.zip

# NOTE:this jar is rebuild after initial bootstrap
#rm -f $DIR/lib/build/build.jar

# Bootstrap using symlink to existing aspectj
rm -f $DIR/lib/aspectj/lib/aspectj*.jar

# The LICENSE.TXT here refers to managementapi-jrockit81.jar which is removed as well
# See http://dev.eclipse.org/viewcvs/index.cgi/org.aspectj/modules/lib/ext/jrockit/LICENSE.TXT?root=Tools_Project&view=co
(cd $DIR/lib/ext/jrockit && rm -f jrockit.jar LICENSE.TXT managementapi-jrockit81.jar jrockit-src.zip)
rm -f $DIR/loadtime/src/org/aspectj/weaver/loadtime/JRockitAgent.java

# These ones are not needed
rm -Rf $DIR/lib/docbook
rm -Rf $DIR/lib/jdiff
rm -Rf $DIR/lib/jython
rm -Rf $DIR/lib/regexp
rm -Rf $DIR/lib/saxon
rm -Rf $DIR/lib/test


echo "Generating $TAR"
XZ_OPT=--best tar -cJf $TAR $DIR

rm -Rf $DIR
