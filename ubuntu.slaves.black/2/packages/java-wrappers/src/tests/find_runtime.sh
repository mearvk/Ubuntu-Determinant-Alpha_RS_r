#!/bin/sh

# find_runtime.sh: A small test script for find_java_runtime
# copyright 2008 by Vincent Fourmond.
# Distributed under the same terms as java-wrappers itself.

DEBUG_WRAPPER=1
. ../java-wrappers.sh

find_java_runtime 

echo $JAVA_HOME