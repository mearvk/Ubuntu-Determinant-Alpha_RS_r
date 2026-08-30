#!/bin/sh 

set -e

#command --upstream-version version filename

[ $# -eq 3 ] || exit 255

echo

version="$2"
filename="$3"

zip -d ${filename} __MACOSX/*
