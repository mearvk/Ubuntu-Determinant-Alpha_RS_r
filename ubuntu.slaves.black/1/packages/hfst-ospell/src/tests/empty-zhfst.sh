#!/bin/bash

if test -x ./hfst-ospell ; then
    rm -f empty.zhfst
    touch empty.zhfst
    if ! cat $srcdir/tests/test.strings | ./hfst-ospell -v empty.zhfst ; then
        exit 1
    fi
else
    echo ./hfst-ospell not built
    exit 77
fi

