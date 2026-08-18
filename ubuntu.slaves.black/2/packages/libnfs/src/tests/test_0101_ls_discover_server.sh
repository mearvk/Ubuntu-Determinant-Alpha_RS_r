#!/bin/sh

. ./functions.sh

echo "discover servers test"
echo '[SKIP] due to failing in autopkgtest setup'
exit 0
start_share

echo -n "Testing nfs-ls to discover servers ... "
../utils/nfs-ls -D nfs:// > "${TESTDIR}/output" || failure
grep nfs:// "${TESTDIR}/output" > /dev/null || failure
success

stop_share

exit 0
