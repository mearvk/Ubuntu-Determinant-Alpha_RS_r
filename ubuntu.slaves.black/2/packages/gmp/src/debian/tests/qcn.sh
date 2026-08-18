#!/bin/sh
# autopkgtest check: Build and run a programs against gmp
# (C) 2021
# Author: Anton Gladky <gladk@debian.org>

set -e


gcc demos/qcn.c -lgmp -lm -o qcn 
./qcn
