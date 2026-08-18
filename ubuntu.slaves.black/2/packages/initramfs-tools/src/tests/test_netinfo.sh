#!/bin/sh

data_dir="${0%.sh}.d"
my_dir=$(dirname "$0")
SCRIPTS_D=$(cd "$my_dir/../scripts" && pwd)
RET_SKIP=99
RET_FAIL=2
RET_PASS=0

PASSES=0
FAILS=0
SKIPS=0

logfail() { echo "FAIL:" "$@" 1>&2; return $RET_FAIL; }
logpass() { echo "PASS:" "$@" 1>&2; return $RET_PASS; }

pass_on_nodiff() {
   # log_on_diff(tname, expected, found)
   local tname="$1" expected="$2" found="$3" out="" opts="-u"
   [ -d "$expected" ] && opts="-Naur"
   out=$(diff $opts "$expected" "$found")
   r=$?
   if [ $r -eq 0 ]; then
      logpass "$tname"
   else
      logfail "$tname: expected output differed"
      echo "$out" 1>&2
      return $RET_FAIL
   fi
}

_run_in_functions() {
   local name="$1" r=""
   shift
   sh -ec '. "$1"; shift; "$@";' \
      "test-$name" "$SCRIPTS_D/functions" "$@" || {
      r=$?
      logfail "$name execution returned $r. ($*)"
      return $r
   }
}

run_resolvconf() {
   local bname="$1" testdir="$2" results_d="$3"
   local tname="$bname-netinfo-to-resolv.conf"
   shift 3
   local expected="$testdir/expected-resolv.conf"
   local found="$results_d/resolv.conf"
   [ -f "$expected" ] || return $RET_SKIP
   _run_in_functions "$tname" netinfo_to_resolv_conf "$found" "$@" || return

   pass_on_nodiff "$tname" "$expected" "$found"
}

run_netinfo_to_netplan() {
   local bname="$1" testdir="$2" results_d="$3"
   local tname="$bname-netinfo-to-netplan"
   shift 3
   local found_d="$results_d/netplan"
   local expected_d="$testdir/netplan"
   [ -d "$expected_d" ] || return $RET_SKIP

   _run_in_functions "$tname" netinfo_to_netplan "$found_d" "$@" || return
   pass_on_nodiff "$tname" "$expected_d" "$found_d"
}

run_netplan_generate() {
   local bname="$1" testdir="$2" results_d="$3"
   local tname="$bname-netplan-generate"
   shift 3
   local expected_d="$testdir/netplan"
   [ -d "$expected_d" ] || return $RET_SKIP
   type netplan >/dev/null 2>/dev/null || return $RET_SKIP

   mkdir -p $results_d/lib/
   cp -r $expected_d $results_d/lib
   netplan generate --root-dir $results_d
   r=$?
   if [ $r -eq 0 ]; then
      logpass "$tname"
   else
      logfail "$tname: netplan generate failed"
      return $RET_FAIL
   fi
}

record() {
   local ret="$1"
   case "$ret" in
      0) PASSES=$(($PASSES+1));;
      $RET_SKIP) SKIPS=$(($SKIPS+1));;
      *) FAILS=$(($FAILS+1));;
   esac
}

for testdir in "${data_dir}"/*; do
   [ -d "$testdir" ] || continue
   dname="${testdir##*/}"
   results_d=$(mktemp -d "${TMPDIR:-/tmp}/${0##*/}.XXXX")
   confs=$(
      for f in "${testdir}"/net-*.conf "${testdir}/net6-"*.conf; do
         [ -f "$f" ] && echo "$f"
      done
   )
   run_resolvconf "$dname" "$testdir" "$results_d" $confs
   record $?

   run_netinfo_to_netplan "$dname" "$testdir" "$results_d" $confs
   record $?

   run_netplan_generate "$dname" "$testdir" "$results_d" $confs
   record $?

   rm -Rf "${results_d}"
done

echo "INFO: ran $(($PASSES+$FAILS)) tests: $PASSES pass. $FAILS fail."
[ $FAILS -eq 0 ]
exit
