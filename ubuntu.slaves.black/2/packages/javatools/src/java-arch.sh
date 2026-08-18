#!/bin/sh --

if [ "-h" = "$1" ] || [ "--help" = "$1" ]; then
    echo "Usage: java-arch.sh [debian arch name]"
    echo "Returns the equivelent name used by the JDK for that arch"
    echo "or the debian build arch if not specified"
    exit 0
fi

if [ -z "$1" ]; then
    DPKG_ARCH=`dpkg --print-architecture`
else
    DPKG_ARCH="$1"
fi

case $DPKG_ARCH in
	arm64)
		echo aarch64
		;;
	armel|armeb|armhf)
		echo arm
		;;
	powerpc|powerpcspe)
		echo ppc
		;;
	ppc64el)
		echo ppc64le
		;;
	hppa)
		echo parisc
		;;
	sparc64)
		echo sparc
		;;
	sh4)
		echo sh
		;;
	*)
		echo  $DPKG_ARCH
		;;
esac
