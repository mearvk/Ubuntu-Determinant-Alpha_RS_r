#!/bin/sh
#
# Transforms DocBook .xml documents so that docbook-to-man can grok them.
#
if test "a$#" = "a0"; then
    echo "$0: missing argument" >&2
    echo "usage: $0 <document>" >&2
    echo "prepares an AspectJ document for dobook-to-man" >&2
    exit 2
fi

NAME=`basename $1`
NAME=${NAME%.*}
TMPFILE=`mktemp` || exit 1
trap "rm -f $TMPFILE" 0

# add the doctype header
echo '<!DOCTYPE refentry PUBLIC "-//OASIS//DTD DocBook V4.3//EN">' >> $TMPFILE
sed -e "s,<refnamediv>,<refmeta><refentrytitle>$NAME</refentrytitle><manvolnum>1</manvolnum></refmeta><refnamediv>," < $1 >> $TMPFILE
docbook-to-man $TMPFILE | sed -e 's# (link to URL \(.*\)) # \1#'
