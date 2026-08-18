-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

Format: 3.0 (native)
Source: cross-toolchain-base-ports
Binary: linux-libc-dev-alpha-cross, linux-libc-dev-hppa-cross, linux-libc-dev-m68k-cross, linux-libc-dev-ppc64-cross, linux-libc-dev-riscv64-cross, linux-libc-dev-sh4-cross, linux-libc-dev-sparc64-cross, linux-libc-dev-x32-cross, libc6.1-alpha-cross, libc6.1-dbg-alpha-cross, libc6.1-dev-alpha-cross, libc6-hppa-cross, libc6-dbg-hppa-cross, libc6-dev-hppa-cross, libc6-m68k-cross, libc6-dbg-m68k-cross, libc6-dev-m68k-cross, libc6-ppc64-cross, libc6-dbg-ppc64-cross, libc6-dev-ppc64-cross, libc6-riscv64-cross, libc6-dbg-riscv64-cross, libc6-dev-riscv64-cross, libc6-sh4-cross, libc6-dbg-sh4-cross, libc6-dev-sh4-cross, libc6-sparc64-cross, libc6-dbg-sparc64-cross, libc6-dev-sparc64-cross, libc6-x32-cross, libc6-dbg-x32-cross, libc6-dev-x32-cross, libc6-powerpc-ppc64-cross, libc6-dbg-powerpc-ppc64-cross, libc6-dev-powerpc-ppc64-cross, libc6-sparc-sparc64-cross, libc6-dbg-sparc-sparc64-cross, libc6-dev-sparc-sparc64-cross, libc6-amd64-x32-cross, libc6-dbg-amd64-x32-cross,
 libc6-dev-amd64-x32-cross, libc6-i386-x32-cross, libc6-dbg-i386-x32-cross,
 libc6-dev-i386-x32-cross
Architecture: all
Version: 51ubuntu4
Maintainer: Cross Toolchain Base Team <cross-toolchain-base-devs@lists.launchpad.net>
Uploaders: Matthias Klose <doko@debian.org>, Dimitri John Ledkov <xnox@debian.org>
Standards-Version: 4.5.1
Vcs-Browser: https://salsa.debian.org/toolchain-team/cross-toolchain-base/tree/ports
Vcs-Git: https://salsa.debian.org/toolchain-team/cross-toolchain-base.git -b ports
Build-Depends: binutils-multiarch, dpkg (>= 1.16.0~ubuntu6), rdfind, symlinks, lsb-release, binutils-source (>= 2.38-1~), glibc-source (>= 2.35-0~), gcc-11-source (>= 11.2.0-16~), linux-source (>= 5.15), linux-libc-dev (>= 5.15), autoconf (>= 2.69), autoconf2.69, autogen, automake, bison (>= 1:2.3), chrpath, debhelper (>= 9), dpkg-dev (>= 1.15.3.1), fakeroot, file, flex, dwz, debugedit (>= 4.16), gawk, gettext, gperf (>= 3.0.1), kernel-wedge (>= 2.24), libisl-dev, libmpc-dev, libelf-dev, libmpfr-dev (>= 2.3.0), rsync, xmlto, libtool, lzma, m4, make (>= 3.81), kmod | module-init-tools, patchutils, procps, quilt, coreutils (>= 2.26) | realpath (>= 1.9.12), sed (>= 4.0.5-4), sharutils, tar (>= 1.22), xz-utils, asciidoc, texinfo, cpio, python3, bc, time, libconfig-auto-perl, libfile-temp-perl, libfile-homedir-perl, liblocale-gettext-perl, libunwind-dev [amd64 i386 x32]
Build-Conflicts: binutils-alpha-linux-gnu [!alpha], binutils-hppa-linux-gnu [!hppa], binutils-m68k-linux-gnu [!m68k], binutils-powerpc64-linux-gnu [!ppc64], binutils-riscv64-linux-gnu [!riscv64], binutils-sh4-linux-gnu [!sh4], binutils-sparc64-linux-gnu [!sparc64], binutils-x86-64-linux-gnux32 [!x32], dpkg-cross, libc6-alpha-cross, libc6-amd64 [i386 x32], libc6-hppa-cross, libc6-i386 [amd64 x32], libc6-m68k-cross, libc6-ppc64-cross, libc6-riscv64-cross, libc6-sh4-cross, libc6-sparc64-cross, libc6-x32 [amd64 i386], libc6-x32-cross, libdebian-dpkgcross-perl, linux-libc-dev-alpha-cross, linux-libc-dev-hppa-cross, linux-libc-dev-m68k-cross, linux-libc-dev-ppc64-cross, linux-libc-dev-riscv64-cross, linux-libc-dev-sh4-cross, linux-libc-dev-sparc64-cross, linux-libc-dev-x32-cross
Package-List:
 libc6-amd64-x32-cross deb libs optional arch=all
 libc6-dbg-amd64-x32-cross deb debug optional arch=all
 libc6-dbg-hppa-cross deb debug optional arch=all
 libc6-dbg-i386-x32-cross deb debug optional arch=all
 libc6-dbg-m68k-cross deb debug optional arch=all
 libc6-dbg-powerpc-ppc64-cross deb debug optional arch=all
 libc6-dbg-ppc64-cross deb debug optional arch=all
 libc6-dbg-riscv64-cross deb debug optional arch=all
 libc6-dbg-sh4-cross deb debug optional arch=all
 libc6-dbg-sparc-sparc64-cross deb debug optional arch=all
 libc6-dbg-sparc64-cross deb debug optional arch=all
 libc6-dbg-x32-cross deb debug optional arch=all
 libc6-dev-amd64-x32-cross deb libdevel optional arch=all
 libc6-dev-hppa-cross deb libdevel optional arch=all
 libc6-dev-i386-x32-cross deb libdevel optional arch=all
 libc6-dev-m68k-cross deb libdevel optional arch=all
 libc6-dev-powerpc-ppc64-cross deb libdevel optional arch=all
 libc6-dev-ppc64-cross deb libdevel optional arch=all
 libc6-dev-riscv64-cross deb libdevel optional arch=all
 libc6-dev-sh4-cross deb libdevel optional arch=all
 libc6-dev-sparc-sparc64-cross deb libdevel optional arch=all
 libc6-dev-sparc64-cross deb libdevel optional arch=all
 libc6-dev-x32-cross deb libdevel optional arch=all
 libc6-hppa-cross deb libs optional arch=all
 libc6-i386-x32-cross deb libs optional arch=all
 libc6-m68k-cross deb libs optional arch=all
 libc6-powerpc-ppc64-cross deb libs optional arch=all
 libc6-ppc64-cross deb libs optional arch=all
 libc6-riscv64-cross deb libs optional arch=all
 libc6-sh4-cross deb libs optional arch=all
 libc6-sparc-sparc64-cross deb libs optional arch=all
 libc6-sparc64-cross deb libs optional arch=all
 libc6-x32-cross deb libs optional arch=all
 libc6.1-alpha-cross deb libs optional arch=all
 libc6.1-dbg-alpha-cross deb debug optional arch=all
 libc6.1-dev-alpha-cross deb libdevel optional arch=all
 linux-libc-dev-alpha-cross deb devel optional arch=all
 linux-libc-dev-hppa-cross deb devel optional arch=all
 linux-libc-dev-m68k-cross deb devel optional arch=all
 linux-libc-dev-ppc64-cross deb devel optional arch=all
 linux-libc-dev-riscv64-cross deb devel optional arch=all
 linux-libc-dev-sh4-cross deb devel optional arch=all
 linux-libc-dev-sparc64-cross deb devel optional arch=all
 linux-libc-dev-x32-cross deb devel optional arch=all
Checksums-Sha1:
 225f3e4491c8c35618e184514b3e16398b54d016 1491568 cross-toolchain-base-ports_51ubuntu4.tar.xz
Checksums-Sha256:
 00abd576b493666a83f0c077ef426e9b69875d5381d7189197eb57b8a6ee73c4 1491568 cross-toolchain-base-ports_51ubuntu4.tar.xz
Files:
 d860c5bf8da5a9e2c672c36eb9bb192d 1491568 cross-toolchain-base-ports_51ubuntu4.tar.xz

-----BEGIN PGP SIGNATURE-----

iQJEBAEBCAAuFiEE1WVxuIqLuvFAv2PWvX6qYHePpvUFAmIjHpMQHGRva29AdWJ1
bnR1LmNvbQAKCRC9fqpgd4+m9QR+EACKkgubAMKcC2zYUemgLJ0LKXG2zpt4xMb+
C8s2s8gVRr00yGDNbySQX7C+6t84T3oLAbM3QqUQ4Bg2ci8pyC6m60RDa8vD3MgJ
7MZi6B4hLeJkeILqtHBR87p2kLLjdMlxjKIHGoZA1lIySpK7QdQrOCob2l8ZSCBI
AqxAmcZ3HPpT8hXYh22XpdSAzfX9W3IlvbiEqWzJdoa+vtZF+mz4ICdcpB3/Bu3f
UaZcypmpqZbU4aX5BgVcBQ5dOwas9VKbswiJ2zbwMbO8bHSAqMJNdjk47CZRcJwY
9Je4aIfGV+UkEZnQSNTY0CM72KKIDmgSskCH9qzDP2ltGAeqzxdVXYhDREKA/lJK
KsGzvctwFqdqeRL1tbkFSJL7TVE5Uj0hHQUudya5IbMrdMyruzK7Sdk2RHKYktry
e8bTHUvttfcqvhOWfWuVcugb2NxDS2qsSWW4aaRpD1atNt3RDKIAU1i1He/AZYbr
xe2oLa7cy9/nQazYk81e8rBTSYE0F/7LxsKwxWxMIm9sjrxKreXJLtjMG0X2j8Rl
QVCb9qGfTuPXEIxPFv14Ci3QH7OqdGKcx6BBacTc9ruQcOR0eFddv1g7yj7nD0sN
zauOHegBtcJbYao24i9QW3efaD/QD9dcb1BAjDHF6HqmU4UmUv6pSiUmh/kc+wIl
Tj9ENPT1zw==
=oQu6
-----END PGP SIGNATURE-----
