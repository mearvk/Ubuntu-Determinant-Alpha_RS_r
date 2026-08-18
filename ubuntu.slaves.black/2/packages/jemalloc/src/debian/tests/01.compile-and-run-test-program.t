#!/bin/sh

test_description="compile with jemalloc"

. /usr/share/sharness/sharness.sh

if [ -n "${DEB_HOST_GNU_TYPE:-}" ]; then
  CROSS_COMPILE="$DEB_HOST_GNU_TYPE-"
else
  CROSS_COMPILE=
fi

test_expect_success "compile test program against libjemalloc" "
  ${CROSS_COMPILE}gcc ../ex_stats_print.c -o ex_stats_print -ljemalloc
"
test_expect_success "run test program" "
 ./ex_stats_print
"

test_done
