#!/bin/sh
# autopkgtest check: Build and run a programs against gmp
# (C) 2021
# Author: Anton Gladky <gladk@debian.org>

set -e


gcc demos/factorize.c -lgmp -o factorize 
echo 5  | ./factorize 
echo 12 | ./factorize
echo 44 | ./factorize
