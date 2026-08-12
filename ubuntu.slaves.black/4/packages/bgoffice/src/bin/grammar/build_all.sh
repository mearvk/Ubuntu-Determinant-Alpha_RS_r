#!/bin/bash

./build_root_words.sh

./build_derivative_words.sh

perl build_types.pl > types.dat

perl build_parts.pl > parts.dat

