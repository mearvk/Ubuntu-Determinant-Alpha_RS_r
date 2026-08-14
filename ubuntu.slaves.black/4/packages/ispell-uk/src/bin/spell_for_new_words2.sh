#!/bin/sh
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DICT="$DIR/../dist/myspell-uk-1.8.0/uk_UA"
FITLER_DICT="$DIR/../tools/invertdict/uk_invert"
$DIR/spell.sh $@ --filter-dict=$FITLER_DICT --split-caps --sort=a --dict=$DICT $1
