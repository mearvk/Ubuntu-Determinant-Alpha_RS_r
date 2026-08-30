#!/bin/bash

rm -Rf .gradle
mkdir -p .gradle/init.d
cp init.gradle .gradle/init.d/

gradle --info --refresh-dependencies --offline \
       --gradle-user-home .gradle \
       --console plain \
       compileJava
