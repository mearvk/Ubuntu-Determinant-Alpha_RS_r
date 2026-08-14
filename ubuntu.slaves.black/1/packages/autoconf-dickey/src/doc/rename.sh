#!/bin/sh
# The ac252 package renames the entries in an info directory section to avoid
# install-time conflict with the regular autoconf package.  Newer versions of
# install-info have a "--name" option which appears simpler, but does not solve
# this particular problem -T.E.Dickey
SRC=`echo "$1" | sed -e 's,^./,,'`
DST=`echo "$2" | sed -e 's,^./,,'`
SRC_NAME=`basename $SRC .info`
DST_NAME=`basename $DST .info`
if test "$SRC_NAME" != "$DST_NAME"
then
	PREFIX=`echo "$DST_NAME" | sed -e "s/$SRC_NAME.*$//"`
	SUFFIX=`echo "$DST_NAME" | sed -e "s/^.*$SRC_NAME//"`

	sed -e "s/^\*[ 	]*\([^ 	][^ 	]*\):[ 	]*($SRC_NAME)\(.\)/* $PREFIX\1$SUFFIX: ($DST_NAME)\2/" <$SRC | \
	sed -e "s/^This is $SRC_NAME\.info,/This is $DST_NAME.info,/" |
	sed -e "s/^File:[ 	]*$SRC_NAME\.info/File: $DST_NAME.info/" >$DST
elif test "$SRC" != "$DST"
then
	cat $SRC >$DST
fi
