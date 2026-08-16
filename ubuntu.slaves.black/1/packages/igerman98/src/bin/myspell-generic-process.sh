#!/bin/sh
cat - \
| grep -v "##" \
| sed "s/qq//g;s/#.*//" \
| grep -v "\/.*d" \
| sort -u \
| ./bin/myspellfixprefix.pl \
| sort -u 

