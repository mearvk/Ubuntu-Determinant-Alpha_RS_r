#!/bin/sh

latest_release=4.2.1
yesterdate=`date --date yesterday '+%Y%m%d'`

#module=xc/fonts/scaled/Type1
module=xc/fonts/scaled
localdir=xfonts-scalable-nonfree-$latest_release.cvs$yesterdate

export CVS_RSH=ssh

#echo "Password is anoncvs"
cvs -d anoncvs@anoncvs.xfree86.org:/cvs export -d $localdir -D $yesterdate $module
tar chf - --exclude-from=`dirname $0`/getfromcvs.ignore $localdir | gzip -f9 > $localdir.tar.gz
