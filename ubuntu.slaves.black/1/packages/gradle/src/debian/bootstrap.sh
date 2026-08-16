#!/bin/sh

set -e

URL="https://services.gradle.org/distributions/gradle-1.5-bin.zip"
ZIP="$(basename $URL)"
DIR="$(echo $ZIP | sed 's/-bin\.zip$//')"
VERSION="1.5+bootstrap"

wget $URL -O $ZIP
unzip $ZIP
mkdir -m 0755 -p $DIR/debian/usr/share/gradle $DIR/debian/usr/bin $DIR/debian/DEBIAN
chmod 0755 $DIR/debian $DIR/debian/usr $DIR/debian/usr/share
rsync -avP $DIR/bin $DIR/lib $DIR/debian/usr/share/gradle
rm $DIR/debian/usr/share/gradle/bin/gradle.bat
./debian/gradle.sed -i $DIR/debian/usr/share/gradle/bin/gradle
cd $DIR/debian/usr/bin && ln -s ../share/gradle/bin/gradle && cd $OLDPWD

cat > $DIR/debian/DEBIAN/control <<EOF
Package: gradle
Version: $VERSION
Architecture: all
Maintainer: Debian Java Maintainers <pkg-java-maintainers@lists.alioth.debian.org>
Depends: default-jre-headless
Provides: libgradle-plugins-java
Section: java
Priority: optional
Homepage: https://gradle.org/
Description: Groovy based build system
 Gradle is a build system written in Groovy. It uses Groovy
 also as the language for its build scripts. It has a powerful
 multi-project build support. It has a layer on top of Ivy
 that provides a build-by-convention integration for Ivy. It
 gives you always the choice between the flexibility of Ant
 and the convenience of a build-by-convention behavior.
EOF

fakeroot dpkg-deb --build $DIR/debian
mv $DIR/debian.deb ./gradle_${VERSION}_all.deb
echo -e "\n\n./gradle_${VERSION}_all.deb was built."

rm -rf $DIR $ZIP
