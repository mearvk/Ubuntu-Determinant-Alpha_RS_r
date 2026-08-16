#!/bin/bash

if test -x ./hfst-ospell ; then
    if ! cat $srcdir/tests/test.strings | ./hfst-ospell -v $srcdir/tests/empty_titles.zhfst ; then
        exit 1
    fi
else
    echo ./hfst-ospell not built
    exit 77
fi

