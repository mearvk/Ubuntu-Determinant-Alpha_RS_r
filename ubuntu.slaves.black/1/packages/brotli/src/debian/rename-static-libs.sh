#!/bin/bash

set -eu
shopt -s globstar

if [[ $(ls debian/tmp/**/*-static.a | wc -l) != 3 ]]; then
  echo "Can't find the libraries!"
  exit 1
fi

for lib in $(ls debian/tmp/**/*-static.a); do
  echo "Renaming ${lib}"
  mv "${lib}" "${lib//-static/}"
done
