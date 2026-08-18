#!/bin/sh -e

# called by uscan with '--upstream-version' <version> <file>

# clean up the upstream tarball
tar -x -z -f $3 --exclude '*.jar' --exclude '*/jlex/*' --exclude '*/docs/*'
tar -c -z -f $3 jexcelapi
rm -rf jexcelapi

# move to directory 'tarballs'
if [ -r .svn/deb-layout ]; then
  . .svn/deb-layout
  mv $3 $origDir
  echo "moved $3 to $origDir"
fi

