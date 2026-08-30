#! /bin/sh

arch="$1"
if [ -z "$1" ]; then
    echo >&2 "usage: $0 <architecture>"
    exit 1
fi

[ -z "$TARGET_ARCH" ] && verbose=y

#vendor=$(if dpkg-vendor --derives-from Ubuntu; then echo ubuntu; else echo debian; fi)

cross=c
cross=cross
case "$arch" in
    arm64)
	pkg_all=libgcc-11-dev-arm64-cross;;
    ppc64)
	pkg_all=libgcc-11-dev-ppc64-cross;;
    mipsr6el)
	pkg_all=libgcc-11-dev-mipsr6el-cross;;
    *)
	echo >&2 "usage: $0 <architecture>"
	exit 1
esac
case "$(dpkg-architecture -qDEB_HOST_ARCH)" in
    arm64)
	pkg_any=gcc-11-arm-linux-gnueabihf-base;;
    ppc64)
	pkg_any=gcc-11-powerpc64le-linux-gnu-base;;
    ppc64el)
	pkg_any=gcc-11-powerpc-linux-gnu-base;;
    amd64|i386|x32)
	case "$arch" in
	    arm64)
		pkg_any=gcc-11-aarch64-linux-gnu-base;;
	    ppc64)
		pkg_any=gcc-11-powerpc64-linux-gnu-base;;
	    mipsr6el)
		pkg_any=gcc-11-mipsisa32r6el-linux-gnu-base;;
	esac;;
esac

v_deb_gcc=$(apt-cache policy gcc-11-source | awk '/^ \*\*\*/ {print $2}')

v_deb_gcc_cross=$(apt-cache show --no-all-versions $pkg_all 2>/dev/null | awk '/^Version/ {print $2}')

if [ -n "$verbose" ]; then
    echo >&2 "gcc: $v_deb_gcc / $v_deb_gcc_cross"
fi

if [ -n "$v_deb_gcc_cross" ]; then
    v_deb_gcc_cross_v=$(echo $v_deb_gcc_cross | sed 's/\(.*\)c[ros]*.*/\1/')
    v_deb_gcc_cross_c=$(echo $v_deb_gcc_cross | sed 's/.*c[ros]*\(.*\)/\1/')
    case "$v_deb_gcc_cross_c" in
	*.*) v_deb_gcc_cross_c=$(echo $v_deb_gcc_cross_c | awk -F. '{print $1}')
    esac				
else
    v_deb_gcc_cross_v=$v_deb_gcc
    v_deb_gcc_cross_c=0
fi

if [ -n "$verbose" ]; then
    echo >&2 ""
    echo >&2 "old gcc version: $v_deb_gcc_cross_v / $v_deb_gcc_cross_c"
fi

if dpkg --compare-versions $v_deb_gcc gt $v_deb_gcc_cross_v; then
    v_gcc_new_c=1
else
    v_deb_src=$(apt-cache show --no-all-versions $pkg_all 2>/dev/null | sed -n '/^Source:/s/.*(\(.*\))/\1/p')
    [ -n "$v_deb_src" ] || v_deb_src=1
    v_src=$(dpkg-parsechangelog| sed -n 's/-*//; s/^Version: \(.*\)/\1/p')
    if dpkg --compare-versions $v_deb_src lt $v_src; then
	v_gcc_new_c=$(expr $v_deb_gcc_cross_c + 1)
    else
	v_gcc_new_c=$v_deb_gcc_cross_c
    fi
fi

if [ -n "$verbose" ]; then
    echo >&2 ""
    echo >&2 "new gcc version: ${v_deb_gcc}${cross}${v_gcc_new_c}"

    echo $v_gcc_new_c
fi
