#!/bin/bash

set -e

version=$1
branch=$(git branch --show-current)
TMPDIR=$(mktemp -d)

echo "Installing to $TMPDIR for heat-dashboard $version"

mkdir -p $TMPDIR/lib

grep -i xstatic requirements.txt > $TMPDIR/requirements.txt

pip3 install -t $TMPDIR/lib -r $TMPDIR/requirements.txt -c "https://opendev.org/openstack/requirements/raw/branch/$branch/upper-constraints.txt"

(
    cd $TMPDIR/lib
    ls -lRt
    rm -Rf *.egg-info *.dist-info
    rm -Rf *.pth
    find . -name "*.pyc" -delete
    touch xstatic/__init__.py xstatic/pkg/__init__.py
    tar -czf heat-dashboard_${version}.orig-xstatic.tar.gz *
)

mv  $TMPDIR/lib/heat-dashboard_${version}.orig-xstatic.tar.gz ../build-area/
rm -rf $TMPDIR

rm -Rf xstatic
mkdir xstatic
tar -zxf ../build-area/heat-dashboard_${version}.orig-xstatic.tar.gz
git add --all xstatic
debchange --append "Refresh xstatic assets."
debcommit --all
