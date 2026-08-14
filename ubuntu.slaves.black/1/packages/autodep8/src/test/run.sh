#!/bin/sh

failed=0
for f in $@; do
  echo "$f"
  echo "$f" | sed -e 's/./-/g'
  echo
  sh $f || failed=$(($failed + 1))
  echo
done

if [ "$failed" -gt 0 ]; then
  exit 1
fi
