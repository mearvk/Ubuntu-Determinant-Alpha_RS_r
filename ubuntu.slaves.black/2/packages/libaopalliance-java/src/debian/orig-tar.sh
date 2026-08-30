#!/bin/sh -e

DATE=$1
DIR=libaopalliance-java-$DATE
TAR=../libaopalliance-java_$DATE.orig.tar.gz
CVSROOT=:pserver:anonymous@aopalliance.cvs.sourceforge.net:/cvsroot/aopalliance

cvs -z9 -d$CVSROOT export -D $DATE -d $DIR aopalliance
tar -c -z -f $TAR $DIR
rm -rf $DIR
