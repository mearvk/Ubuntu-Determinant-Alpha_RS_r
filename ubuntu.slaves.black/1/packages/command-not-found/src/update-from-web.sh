#!/bin/sh

set -e

distro=$(dpkg-parsechangelog -S Distribution)

cd CommandNotFound/db

# the commands-not-found data is currently extracted here
mkdir -p dists
scp -r nusakan.canonical.com:~mvo/cnf-extractor/command-not-found-extractor/dists/${distro}* dists/
find dists/ -name "*.xz" -o -name "*.gz" | xargs rm -f

