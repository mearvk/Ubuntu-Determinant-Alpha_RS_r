#!/bin/sh
SORTFILE=debian/fonts.sort
groups=`cut -f2 $SORTFILE | sort -u`
basedir=`pwd`

#
# Create Directories for fonts
#
for group in $groups; do
	if [ ! -d $group ]; then
		mkdir $group
	fi
done

#
# Extract font .zip files
#
for nam in *.zip; do
	group=`grep "^$nam[[:space:]]" $SORTFILE | cut -f2`
	if [ -z $group ]; then
		echo Font $nam is unsorted.
	else
		unzip -j -L -u -q $nam -d $group -x read_me.txt
	fi
done

#
# Rename some problematic files
#
mv deco/let*seat.ttf deco/let_seat.ttf
mv uncommon/chr*32*.ttf uncommon/chr32.ttf
