-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

Format: 3.0 (native)
Source: cross-toolchain-base
Binary: linux-libc-dev-amd64-cross, linux-libc-dev-arm64-cross, linux-libc-dev-armel-cross, linux-libc-dev-armhf-cross, linux-libc-dev-i386-cross, linux-libc-dev-powerpc-cross, linux-libc-dev-ppc64el-cross, linux-libc-dev-s390x-cross, libc6-amd64-cross, libc6-dbg-amd64-cross, libc6-dev-amd64-cross, libc6-arm64-cross, libc6-dbg-arm64-cross, libc6-dev-arm64-cross, libc6-armel-cross, libc6-dbg-armel-cross, libc6-dev-armel-cross, libc6-armhf-cross, libc6-dbg-armhf-cross, libc6-dev-armhf-cross, libc6-i386-cross, libc6-dbg-i386-cross, libc6-dev-i386-cross, libc6-powerpc-cross, libc6-dbg-powerpc-cross, libc6-dev-powerpc-cross, libc6-ppc64el-cross, libc6-dbg-ppc64el-cross, libc6-dev-ppc64el-cross, libc6-s390x-cross, libc6-dbg-s390x-cross, libc6-dev-s390x-cross, libc6-s390-s390x-cross, libc6-dbg-s390-s390x-cross, libc6-dev-s390-s390x-cross, libc6-ppc64-powerpc-cross, libc6-dbg-ppc64-powerpc-cross, libc6-dev-ppc64-powerpc-cross, libc6-i386-amd64-cross, libc6-dbg-i386-amd64-cross,
 libc6-dev-i386-amd64-cross, libc6-x32-amd64-cross, libc6-dbg-x32-amd64-cross, libc6-dev-x32-amd64-cross, libc6-amd64-i386-cross, libc6-dbg-amd64-i386-cross, libc6-dev-amd64-i386-cross, libc6-x32-i386-cross, libc6-dbg-x32-i386-cross,
 libc6-dev-x32-i386-cross
Architecture: all
Version: 59ubuntu3
Maintainer: Cross Toolchain Base Team <cross-toolchain-base-devs@lists.launchpad.net>
Uploaders: Matthias Klose <doko@debian.org>, Dimitri John Ledkov <xnox@debian.org>
Standards-Version: 4.5.1
Vcs-Browser: https://salsa.debian.org/toolchain-team/cross-toolchain-base
Vcs-Git: https://salsa.debian.org/toolchain-team/cross-toolchain-base.git
Testsuite: autopkgtest
Testsuite-Triggers: asciidoc, autoconf, autoconf2.69, autogen, automake, bc, binutils-source, bison, build-essential, chrpath, coreutils, cpio, debhelper, debugedit, dpkg-dev, dwz, fakeroot, file, flex, gawk, gcc-11-source, gettext, glibc-source, gperf, kernel-wedge, kmod, libconfig-auto-perl, libelf-dev, libfile-homedir-perl, libfile-temp-perl, libisl-dev, liblocale-gettext-perl, libmpc-dev, libmpfr-dev, libtool, libunwind-dev, linux-libc-dev, linux-source, lsb-release, lzma, m4, make, module-init-tools, patchutils, procps, python3, quilt, rdfind, realpath, rsync, sed, sharutils, symlinks, tar, texinfo, time, xmlto, xz-utils
Build-Depends: binutils-multiarch, dpkg (>= 1.16.0~ubuntu6), rdfind, symlinks, lsb-release, binutils-source (>= 2.38-1~), glibc-source (>= 2.35-0~), gcc-11-source (>= 11.2.0-16~), linux-source (>= 5.15), linux-libc-dev (>= 5.15), autoconf (>= 2.69), autoconf2.69, autogen, automake, bison (>= 1:2.3), chrpath, debhelper (>= 9), dpkg-dev (>= 1.15.3.1), fakeroot, file, flex, dwz, debugedit (>= 4.16), gawk, gettext, gperf (>= 3.0.1), kernel-wedge (>= 2.24), libisl-dev, libmpc-dev, libelf-dev, libmpfr-dev (>= 2.3.0), rsync, xmlto, libtool, lzma, m4, make (>= 3.81), kmod | module-init-tools, patchutils, procps, quilt, coreutils (>= 2.26) | realpath (>= 1.9.12), sed (>= 4.0.5-4), sharutils, tar (>= 1.22), xz-utils, asciidoc, texinfo, cpio, python3, bc, time, libconfig-auto-perl, libfile-temp-perl, libfile-homedir-perl, liblocale-gettext-perl, libunwind-dev [amd64 i386 x32]
Build-Conflicts: binutils-aarch64-linux-gnu [!arm64], binutils-arm-linux-gnueabi [!armel], binutils-arm-linux-gnueabihf [!armhf], binutils-i686-linux-gnu [!i386], binutils-powerpc-linux-gnu [!powerpc], binutils-powerpc64le-linux-gnu [!ppc64el], binutils-s390x-linux-gnu [!s390x], binutils-x86-64-linux-gnu [!amd64], dpkg-cross, libc6-amd64 [i386 x32], libc6-amd64-cross, libc6-arm64-cross, libc6-armel-cross, libc6-armhf-cross, libc6-i386 [amd64 x32], libc6-i386-cross, libc6-powerpc-cross, libc6-ppc64el-cross, libc6-s390x-cross, libc6-x32 [amd64 i386], libdebian-dpkgcross-perl, linux-libc-dev-amd64-cross, linux-libc-dev-arm64-cross, linux-libc-dev-armel-cross, linux-libc-dev-armhf-cross, linux-libc-dev-i386-cross, linux-libc-dev-powerpc-cross, linux-libc-dev-ppc64el-cross, linux-libc-dev-s390x-cross
Package-List:
 libc6-amd64-cross deb libs optional arch=all
 libc6-amd64-i386-cross deb libs optional arch=all
 libc6-arm64-cross deb libs optional arch=all
 libc6-armel-cross deb libs optional arch=all
 libc6-armhf-cross deb libs optional arch=all
 libc6-dbg-amd64-cross deb debug optional arch=all
 libc6-dbg-amd64-i386-cross deb debug optional arch=all
 libc6-dbg-arm64-cross deb debug optional arch=all
 libc6-dbg-armel-cross deb debug optional arch=all
 libc6-dbg-armhf-cross deb debug optional arch=all
 libc6-dbg-i386-amd64-cross deb debug optional arch=all
 libc6-dbg-i386-cross deb debug optional arch=all
 libc6-dbg-powerpc-cross deb debug optional arch=all
 libc6-dbg-ppc64-powerpc-cross deb debug optional arch=all
 libc6-dbg-ppc64el-cross deb debug optional arch=all
 libc6-dbg-s390-s390x-cross deb debug optional arch=all
 libc6-dbg-s390x-cross deb debug optional arch=all
 libc6-dbg-x32-amd64-cross deb debug optional arch=all
 libc6-dbg-x32-i386-cross deb debug optional arch=all
 libc6-dev-amd64-cross deb libdevel optional arch=all
 libc6-dev-amd64-i386-cross deb libdevel optional arch=all
 libc6-dev-arm64-cross deb libdevel optional arch=all
 libc6-dev-armel-cross deb libdevel optional arch=all
 libc6-dev-armhf-cross deb libdevel optional arch=all
 libc6-dev-i386-amd64-cross deb libdevel optional arch=all
 libc6-dev-i386-cross deb libdevel optional arch=all
 libc6-dev-powerpc-cross deb libdevel optional arch=all
 libc6-dev-ppc64-powerpc-cross deb libdevel optional arch=all
 libc6-dev-ppc64el-cross deb libdevel optional arch=all
 libc6-dev-s390-s390x-cross deb libdevel optional arch=all
 libc6-dev-s390x-cross deb libdevel optional arch=all
 libc6-dev-x32-amd64-cross deb libdevel optional arch=all
 libc6-dev-x32-i386-cross deb libdevel optional arch=all
 libc6-i386-amd64-cross deb libs optional arch=all
 libc6-i386-cross deb libs optional arch=all
 libc6-powerpc-cross deb libs optional arch=all
 libc6-ppc64-powerpc-cross deb libs optional arch=all
 libc6-ppc64el-cross deb libs optional arch=all
 libc6-s390-s390x-cross deb libs optional arch=all
 libc6-s390x-cross deb libs optional arch=all
 libc6-x32-amd64-cross deb libs optional arch=all
 libc6-x32-i386-cross deb libs optional arch=all
 linux-libc-dev-amd64-cross deb devel optional arch=all
 linux-libc-dev-arm64-cross deb devel optional arch=all
 linux-libc-dev-armel-cross deb devel optional arch=all
 linux-libc-dev-armhf-cross deb devel optional arch=all
 linux-libc-dev-i386-cross deb devel optional arch=all
 linux-libc-dev-powerpc-cross deb devel optional arch=all
 linux-libc-dev-ppc64el-cross deb devel optional arch=all
 linux-libc-dev-s390x-cross deb devel optional arch=all
Checksums-Sha1:
 fa6340dcec7c51ecb847e47d2fd230446752de54 45312 cross-toolchain-base_59ubuntu3.tar.xz
Checksums-Sha256:
 f25563ef05d9f1352163fa9dba5298a00ee5db64299313dd9eeb13e0e5364f86 45312 cross-toolchain-base_59ubuntu3.tar.xz
Files:
 59b04238920844fed2e97cc810b95cdc 45312 cross-toolchain-base_59ubuntu3.tar.xz

-----BEGIN PGP SIGNATURE-----

iQJEBAEBCAAuFiEE1WVxuIqLuvFAv2PWvX6qYHePpvUFAmIWG1kQHGRva29AdWJ1
bnR1LmNvbQAKCRC9fqpgd4+m9ev7D/9ZQ8gCDVN+IxpVZXqN+sVV1+5QiOagxF95
WXvh9oT4htXVE5uIrO2YKIqDaZdl/dfDdvtobUhb2seBQgTmTsLS1Tx2KQIjxWuD
BWkxBGq22ifvy++3locR1K8G2hIMeCyAcd25Xy6vfZypAeMene6cAB+gjbWQG3uW
Cf+0WnU6wN9mWHJusMhlyMd62akeffJWVUU5XzGXS+tUO0uQCUBkPQ4SP2cYfiYR
BUhhOPN0ccosZV4LspzkkPVYDCgFZ3SWyQ0Ff/ngewZaUCHQKV1DUbjne8AREmoU
3d9f52LwlloBayHiuTG5NEtygTGDpJ981fdZ8eAiGuAziq6+OiduPibuAZZ/BYO2
2Z/hv2thC/CGUdTM4P4EyRajpLWse+Qjad36j4xG24pvALgvp/1cELpTnvd29cEc
vaGdngNaYVb+UwreJO7J6+wkbiy/SYsbvwCAbPZQxF0Bp3w7I1XS6FX71vNHZQfj
8GW9aTxp07LK6RXPb57384Eh1xLZDAj8UT9m+nQ0HmIvDL55+GcUGsSgN3vT+NW7
ejD44XT8G3EiFcxBPe1BChDytwuWcTCa0ParDoWCBdXH7YGXtkqe89s6AAZWAYcv
tQL7aO/AnGcReawMDKVmOgLm1o/tVmAAePfnQlWIOf1kk09O2MjY/83LoleCvOKJ
W2ExWsaOIA==
=UtRv
-----END PGP SIGNATURE-----
