#!/bin/sh
# test for broken GNU grep, see http://debbugs.gnu.org/cgi/bugreport.cgi?bug=23234
LC_ALL=C
export LC_ALL
test `echo -e -n "test\nt\304st\ntest" | grep st| sed -n '$='` -eq 3 || { \
	echo
	echo "ERROR: your grep version is broken. Please install a more POSIX compliant" ; \
	echo "       grep version or simply symlink busybox to bin/grep here" ; \
	exit 1 ; \
}

