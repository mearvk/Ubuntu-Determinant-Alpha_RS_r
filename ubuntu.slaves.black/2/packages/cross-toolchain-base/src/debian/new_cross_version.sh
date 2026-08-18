#! /bin/sh

arch="$1"
if [ -z "$1" ]; then
    echo >&2 "usage: $0 <architecture>"
    exit 1
fi

#vendor=$(if dpkg-vendor --derives-from Ubuntu; then echo ubuntu; else echo debian; fi)

cross=c
cross=cross

v_deb_linux=$(apt-cache policy linux-libc-dev | awk '/^ \*\*\*/ {print $2}')
v_deb_glibc=$(dpkg-parsechangelog -l/usr/src/glibc/debian/changelog | egrep '^Version:' | cut -f 2 -d ' ')

v_deb_linux_cross=$(apt-cache show --no-all-versions linux-libc-dev-$arch-cross 2>/dev/null | awk '/^Version:/ {print $2}')
v_deb_glibc_cross=$(apt-cache show --no-all-versions libc6-$arch-cross 2>/dev/null | awk '/^Version/ {print $2}')

echo >&2 "linux: $v_deb_linux / $v_deb_linux_cross"
echo >&2 "glibc: $v_deb_glibc / $v_deb_glibc_cross"

if [ -n "$v_deb_linux_cross" ]; then
    v_deb_linux_cross_v=$(echo $v_deb_linux_cross | sed 's/\(.*\)c[ros]*.*/\1/')
    v_deb_linux_cross_c=$(echo $v_deb_linux_cross | sed 's/.*c[ros]*\(.*\)/\1/')
    case "$v_deb_linux_cross_c=" in
	*.*) v_deb_linux_cross_c=$(echo $v_deb_linux_cross_c | awk -F. '{print $1}')
    esac				
else
    v_deb_linux_cross_v=$v_deb_linux
    v_deb_linux_cross_c=0
fi

if [ -n "$v_deb_glibc_cross" ]; then
    v_deb_glibc_cross_v=$(echo $v_deb_glibc_cross | sed 's/\(.*\)c[ros].*/\1/')
    v_deb_glibc_cross_c=$(echo $v_deb_glibc_cross | sed 's/.*c[ros]*\(.*\)/\1/')
    case "$v_deb_glibc_cross_c=" in
	*.*) v_deb_glibc_cross_c=$(echo $v_deb_glibc_cross_c | awk -F. '{print $1}')
    esac				
else
    v_deb_glibc_cross_v=$v_deb_glibc
    v_deb_glibc_cross_c=0
fi

echo >&2 ""
echo >&2 "old linux version: $v_deb_linux_cross_v / $v_deb_linux_cross_c"
echo >&2 "old glibc version: $v_deb_glibc_cross_v / $v_deb_glibc_cross_c"

if dpkg --compare-versions $v_deb_linux gt $v_deb_linux_cross_v; then
    v_linux_new_c=1
else
    v_linux_new_c=$(expr $v_deb_linux_cross_c + 1)
fi

if dpkg --compare-versions $v_deb_glibc gt $v_deb_glibc_cross_v; then
    v_glibc_new_c=1
else
    v_glibc_new_c=$(expr $v_deb_glibc_cross_c + 1)
fi

if dpkg --compare-versions $v_linux_new_c gt $v_glibc_new_c; then
    v_new_c=$v_linux_new_c
else
    v_new_c=$v_glibc_new_c
fi

echo >&2 ""
echo >&2 "new linux version: ${v_deb_linux}${cross}${v_new_c}"
echo >&2 "new glibc version: ${v_deb_glibc}${cross}${v_new_c}"

echo $v_new_c
