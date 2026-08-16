#!/bin/sh -e

# called by uscan with '--upstream-version' <version> <file>
VERSION=$2
DIR=gradle-propdeps-plugin-$VERSION
TAR=../gradle-propdeps-plugin_$VERSION.orig.tar.xz

mkdir $DIR
tar -xf $3 --strip-components=1 -C $DIR
rm $3
XZ_OPT=--best tar cJvf $TAR \
    --exclude '*.jar' \
    --exclude '*.class' \
    --exclude '.settings' \
    --exclude '.project' \
    --exclude '.classpath' \
    --exclude 'gradlew*' \
    --exclude 'gradle/wrapper' \
    --exclude 'bundlor-plugin' \
    --exclude 'docbook-reference-plugin' \
    --exclude '.wrapper' \
    --exclude 'wrapper.gradle' \
    --exclude 'spring-io-plugin' \
    $DIR
rm -rf $DIR
