#!/bin/sh
# autopkgtest check: Build and run a programs against gmp
# (C) 2021
# Author: Anton Gladky <gladk@debian.org>

set -e


gcc demos/isprime.c -lgmp -o isprime 
./isprime 4
./isprime 5
./isprime 123
