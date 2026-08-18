#!/bin/sh
set -e

if [ -n "${DEB_HOST_GNU_TYPE:-}" ]; then
        export CC=$(dpkg-architecture -qDEB_HOST_GNU_TYPE)-gcc
fi

cd tests
make test
make clean
cd ..
