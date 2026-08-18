#!/bin/bash -e
#
# Test basic functionality using cddb_query example program.  Adapted
# from tests/check_server.sh in the package source.
#
# This requires network access to gnudb.gnudb.org on ports 80 and 8880.
#

die () {
  echo $*
  exit 1
}

set -o pipefail

gcc -o cddb_query /usr/share/doc/libcddb2-dev/examples/*.c -lcddb

#
# Query disc with single match
#
QUERY_DATA='2259 8 155 25947 47357 66630 91222 110355 124755 148317'

# Disabled - port 8880 does not work on Salsa
#
#echo "Testing CDDBP query"
#
#./cddb_query -c off -l info -P cddbp query $QUERY_DATA | tee test.log
#
#grep "Number of matches: 1" test.log || die "Wrong number of matches (cddbp)"
#grep "Live Jet Set With Orchestra" test.log || die "Wrong album title (cddbp)"

echo
echo "Testing HTTP query"

./cddb_query -c off -l info -P http query $QUERY_DATA | tee test.log

grep "Number of matches: 1" test.log || die "Wrong number of matches (http)"
grep "Live Jet Set With Orchestra" test.log || die "Wrong album title (http)"
