#!/bin/sh
set -efu

CMD=$1

# test good file
$CMD setup.py

# create a known-bad file
cat << EOF > $AUTOPKGTEST_TMP/test.py
import sys  # unused import

print('Hello world, this is an overly long line for PEP-8. We expect flake8 to complain')
# undeclared variable
count += 1
EOF

# test know-bad file
set +e
$CMD $AUTOPKGTEST_TMP/test.py > $AUTOPKGTEST_TMP/out
RC=$?
set -e
echo 'flake8 output on known-bad file:'
cat $AUTOPKGTEST_TMP/out

if [ $RC -eq 0 ]; then
   echo "flake8 expected to fail, but it succeeded:" >&2
   exit 1
fi

grep -q 'F401.*sys' $AUTOPKGTEST_TMP/out
grep -q 'E501.*line too long' $AUTOPKGTEST_TMP/out
grep -q 'F821.*count' $AUTOPKGTEST_TMP/out
