#!/bin/sh

echo "This script helps you to find files which are not documented"
echo "in debian/copyright. When a set of files has been documented,"
echo "please write a short regexp into $0's source."

# write the regexps of already documented files there:

alreadyOKpatterns='uglifyjs2|uglify|source-map|esprima|opto.build|blank|xpconnect|/node|/browser|/rhino'


for f in $(find build/jslib -name "*.js"| grep -Ev "$alreadyOKpatterns"); do
    if !(cat $f | head -n 10 | grep -q "The Dojo Foundation All Rights Reserved"); then
	echo "============= $f ================"
	l="$(cat $f | head -n 10 | grep -i license)"
	c="$(cat $f | head -n 10 | grep -Ei 'copyright|\(c\)')"
	echo "License: $l"
	echo "©: $c"
    fi
done
