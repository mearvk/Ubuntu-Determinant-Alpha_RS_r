#! /bin/bash
## run-ag.sh -- shell script for running autogen within autogen build
##
## Author:	    Bruce Korb <bkorb@gnu.org>
##
## This file is part of AutoGen.
## AutoGen Copyright (C) 2018 by Bruce Korb - all rights reserved
##
## AutoGen is free software: you can redistribute it and/or modify it
## under the terms of the GNU General Public License as published by the
## Free Software Foundation, either version 3 of the License, or
## (at your option) any later version.
##
## AutoGen is distributed in the hope that it will be useful, but
## WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
## See the GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License along
## with this program.  If not, see <http://www.gnu.org/licenses/>.
## ---------------------------------------------------------------------
#
# If the first argument ends with *-dep.mk, then it is expected that this
# script has been called in the Makefile building phase and the target and
# any containing directory must be created. The target is created with a
# very old time stamp.
#
AGexe=/u/bkorb/tools/ag/autogen-bld/agen5/.libs/autogen
find_exe() {
  eval local exe=\${$1}
  test -x "$exe" && return 0
  case "$2" in
    autogen ) exe=`cd ../agen5   > /dev/null ; pwd`/$2 ;;
    columns ) exe=`cd ../columns > /dev/null ; pwd`/$2 ;;

    * ) echo "wrong executable: '$2'" >&2
        exit 1 ;;
  esac
  test -x "$exe" || exe=`command -v $2`
  test -x "$exe" || {
    echo "cannot locate $2"
    return 1
  } 1>&2
  eval $1=$exe
  return 0
}

STAMP_TEMP_DIR=$(mktemp --suffix=.tdir -d /tmp/run-ag-XXXXXXXX)
exec 9>&2 2>> ${STAMP_TEMP_DIR}/mk-stamps.log
VERBOSE=1

test "X$VERBOSE" = X1 && {
  PS4='+run-ag-$LINENO> '
  set -x
  : in $PWD
}

stamp_file=''
case "$1" in
  -MF*-dep.mk ) : ;;

  *-dep.mk )
    dir=`dirname "$1"`
    test -d "$dir" || mkdir -p "$dir" || exit 1
    touch -t 197001020000 "$1"
    exit $?
    ;;

  '' ) exit 1 ;;
esac

test -x "$AGexe" || find_exe AGexe autogen
test -x "CLexe"  || find_exe CLexe columns
PATH=`dirname "$CLexe"`:"$PATH"
L_opt="-L'${top_srcdir}/autoopts/tpl'"
test "X${top_srcdir}" = "X${top_builddir}" || \
  L_opt="$L_opt -L'${top_builddir}/autoopts/tpl'"

eval "${AGexe}" $L_opt '"$@"'
exit $?

## Local Variables:
## mode: shell-script
## indent-tabs-mode: nil
## sh-indentation: 2
## sh-basic-offset: 2
## End:

# END OF add-on/build-aux/mk-ag-dep.sh
