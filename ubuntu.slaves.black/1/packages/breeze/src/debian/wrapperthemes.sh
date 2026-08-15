#!/bin/sh
set -e

ICONDIR=/usr/share/icons
WRAPPERDIR=/etc/X11/cursors
: ${CURDIR:=`pwd`}

tmp="$(mktemp)"

while [ $# -gt 0 ]; do
    theme=$1
    shift

    mkdir -p ${CURDIR}/debian/tmp${WRAPPERDIR}
    cd ${CURDIR}/debian/tmp${ICONDIR}
    grep -a -v Inherits ${CURDIR}/debian/tmp${ICONDIR}/${theme}/index.theme > "$tmp"
    echo "Inherits=${theme}" >> "$tmp"
    install -m 644 "$tmp" ${CURDIR}/debian/tmp${WRAPPERDIR}/${theme}.theme
    rm "$tmp"
done
