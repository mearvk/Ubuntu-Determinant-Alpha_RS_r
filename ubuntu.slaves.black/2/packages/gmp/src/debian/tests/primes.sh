#!/bin/sh
# autopkgtest check: Build and run a programs against gmp
# (C) 2021
# Author: Anton Gladky <gladk@debian.org>

set -e


gcc demos/primes.c -lgmp -lm -o primes 
./primes 1 5
./primes 100 150
