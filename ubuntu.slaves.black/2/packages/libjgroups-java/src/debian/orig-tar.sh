#!/bin/sh -e

# called by uscan with '--upstream-version' <version> <file>
VER=`echo $2|sed -e 's/\_/\./g'`
TAR=../libjgroups-java_$VER.orig.tar.gz
DIR=libjgroups-java-$VER.orig

# clean up the upstream tarball
if [ -r "$3" ]; then
	echo "Found existing tarball - presumably from get-orig-soruce/uscan - fixing it"
	tar xfz $3
fi
if find . -type d -a -name "belaban*"; then
	echo "Renaming belaban* to '$DIR'"
	mv belaban* $DIR
fi

# replace CC licensed files by my own simple implementation
cp -f debian/annotations/* $DIR/src/org/jgroups/annotations/

if GZIP="-9n" tar -c -z -f $TAR --exclude '*.jar' --exclude '*/out/*' --exclude '*/lib/*' $DIR; then
	echo "Created tar file in '$TAR'."
else
	echo "Error packing directory '$DIR' to '$TAR'"
	exit
fi
rm -rf $3 $DIR

# move to directory 'tarballs'
if [ -r .svn/deb-layout ]; then
  . .svn/deb-layout
  mv $TAR $origDir
  echo "moved $TAR to $origDir"
fi


echo "[OK]"
