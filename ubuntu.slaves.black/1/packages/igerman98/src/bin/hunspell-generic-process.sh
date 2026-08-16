#!/bin/sh
cat - \
| grep -v "##" \
| sed "s/qq//g;s/#.*//" \
| sort -u \
| ./bin/myspellfixprefix.pl \
| sort -u 

