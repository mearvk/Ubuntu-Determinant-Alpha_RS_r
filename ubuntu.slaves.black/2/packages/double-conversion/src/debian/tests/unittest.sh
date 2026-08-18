#!/bin/sh
set -e

CXXFLAGS=$(dpkg-buildflags --get CXXFLAGS)
elfname="run_tests"

if [ -n "${DEB_HOST_GNU_TYPE:-}" ]; then
    CROSS_COMPILE="$DEB_HOST_GNU_TYPE-"
else
    CROSS_COMPILE=
fi

# compile src into object files
srcs=$(find test/cctest -type f -name '*.cc' -print)
for src in $srcs; do
	if ! test -r ${src%.cc}.o; then
		${CROSS_COMPILE}g++ ${CXXFLAGS} -c $src -o ${src%.cc}.o
		echo CXX $src
	fi
done

# link
objs=$(find test/cctest -type f -name '*.o' -print)
${CROSS_COMPILE}g++ -o $elfname $objs -ldouble-conversion
echo LD $elfname

# execute

./$elfname --list | sed -e 's/<$//' | xargs ./$elfname

# cleanup

rm test/cctest/*.o
rm run_tests
