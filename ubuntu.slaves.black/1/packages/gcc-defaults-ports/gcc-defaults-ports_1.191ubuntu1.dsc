-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

Format: 3.0 (native)
Source: gcc-defaults-ports
Binary: cpp-alpha-linux-gnu, gcc-alpha-linux-gnu, g++-alpha-linux-gnu, gobjc-alpha-linux-gnu, gobjc++-alpha-linux-gnu, gfortran-alpha-linux-gnu, gccgo-alpha-linux-gnu, gdc-alpha-linux-gnu, gm2-alpha-linux-gnu, cpp-hppa-linux-gnu, gcc-hppa-linux-gnu, g++-hppa-linux-gnu, gobjc-hppa-linux-gnu, gobjc++-hppa-linux-gnu, gfortran-hppa-linux-gnu, gdc-hppa-linux-gnu, gm2-hppa-linux-gnu, cpp-m68k-linux-gnu, gcc-m68k-linux-gnu, g++-m68k-linux-gnu, gobjc-m68k-linux-gnu, gobjc++-m68k-linux-gnu, gfortran-m68k-linux-gnu, gdc-m68k-linux-gnu, gm2-m68k-linux-gnu, cpp-powerpc64-linux-gnu, gcc-powerpc64-linux-gnu, g++-powerpc64-linux-gnu, gobjc-powerpc64-linux-gnu, gobjc++-powerpc64-linux-gnu, gfortran-powerpc64-linux-gnu, gccgo-powerpc64-linux-gnu, gdc-powerpc64-linux-gnu, gm2-powerpc64-linux-gnu, gcc-multilib-powerpc64-linux-gnu, g++-multilib-powerpc64-linux-gnu, gobjc-multilib-powerpc64-linux-gnu, gobjc++-multilib-powerpc64-linux-gnu, gfortran-multilib-powerpc64-linux-gnu,
 gccgo-multilib-powerpc64-linux-gnu, gdc-multilib-powerpc64-linux-gnu, cpp-riscv64-linux-gnu, gcc-riscv64-linux-gnu, g++-riscv64-linux-gnu, gobjc-riscv64-linux-gnu, gobjc++-riscv64-linux-gnu, gfortran-riscv64-linux-gnu, gccgo-riscv64-linux-gnu, gdc-riscv64-linux-gnu, gm2-riscv64-linux-gnu, cpp-sh4-linux-gnu, gcc-sh4-linux-gnu, g++-sh4-linux-gnu, gobjc-sh4-linux-gnu, gobjc++-sh4-linux-gnu, gfortran-sh4-linux-gnu, gdc-sh4-linux-gnu, gm2-sh4-linux-gnu, cpp-sparc64-linux-gnu, gcc-sparc64-linux-gnu, g++-sparc64-linux-gnu, gobjc-sparc64-linux-gnu, gobjc++-sparc64-linux-gnu, gfortran-sparc64-linux-gnu, gccgo-sparc64-linux-gnu, gdc-sparc64-linux-gnu, gm2-sparc64-linux-gnu, gcc-multilib-sparc64-linux-gnu, g++-multilib-sparc64-linux-gnu, gobjc-multilib-sparc64-linux-gnu, gobjc++-multilib-sparc64-linux-gnu, gfortran-multilib-sparc64-linux-gnu, gccgo-multilib-sparc64-linux-gnu, gdc-multilib-sparc64-linux-gnu, cpp-powerpc-linux-gnu, gcc-powerpc-linux-gnu, g++-powerpc-linux-gnu,
 gobjc-powerpc-linux-gnu, gobjc++-powerpc-linux-gnu, gfortran-powerpc-linux-gnu, gccgo-powerpc-linux-gnu, gdc-powerpc-linux-gnu, gm2-powerpc-linux-gnu, gcc-multilib-powerpc-linux-gnu, g++-multilib-powerpc-linux-gnu, gobjc-multilib-powerpc-linux-gnu, gobjc++-multilib-powerpc-linux-gnu, gfortran-multilib-powerpc-linux-gnu, gccgo-multilib-powerpc-linux-gnu, gdc-multilib-powerpc-linux-gnu, cpp-x86-64-linux-gnux32, gcc-x86-64-linux-gnux32, g++-x86-64-linux-gnux32, gobjc-x86-64-linux-gnux32, gobjc++-x86-64-linux-gnux32, gfortran-x86-64-linux-gnux32, gccgo-x86-64-linux-gnux32, gdc-x86-64-linux-gnux32, gm2-x86-64-linux-gnux32, gcc-multilib-x86-64-linux-gnux32, g++-multilib-x86-64-linux-gnux32, gobjc-multilib-x86-64-linux-gnux32, gobjc++-multilib-x86-64-linux-gnux32, gfortran-multilib-x86-64-linux-gnux32, gccgo-multilib-x86-64-linux-gnux32,
 gdc-multilib-x86-64-linux-gnux32
Architecture: amd64 i386 x32 ppc64el arm64
Version: 1.191ubuntu1
Maintainer: Debian GCC Maintainers <debian-gcc@lists.debian.org>
Uploaders: Matthias Klose <doko@debian.org>
Standards-Version: 4.6.0
Vcs-Browser: https://salsa.debian.org/toolchain-team/gcc-defaults/tree/ports
Vcs-Git: https://salsa.debian.org/toolchain-team/gcc-defaults.git -b ports
Build-Depends: m4, debhelper (>= 11), dpkg-dev (>= 1.17.11), gcc-11-base (>= 11.2.0-7~), lsb-release
Package-List:
 cpp-alpha-linux-gnu deb interpreters optional arch=amd64,i386,x32
 cpp-hppa-linux-gnu deb interpreters optional arch=amd64,i386,x32
 cpp-m68k-linux-gnu deb interpreters optional arch=amd64,i386,x32
 cpp-powerpc-linux-gnu deb interpreters optional arch=amd64,i386,x32,ppc64el
 cpp-powerpc64-linux-gnu deb interpreters optional arch=amd64,i386,x32,ppc64el
 cpp-riscv64-linux-gnu deb interpreters optional arch=amd64,i386,x32,arm64,ppc64el
 cpp-sh4-linux-gnu deb interpreters optional arch=amd64,i386,x32
 cpp-sparc64-linux-gnu deb interpreters optional arch=amd64,i386,x32
 cpp-x86-64-linux-gnux32 deb interpreters optional arch=amd64,arm64,i386,ppc64el
 g++-alpha-linux-gnu deb devel optional arch=amd64,i386,x32
 g++-hppa-linux-gnu deb devel optional arch=amd64,i386,x32
 g++-m68k-linux-gnu deb devel optional arch=amd64,i386,x32
 g++-multilib-powerpc-linux-gnu deb devel optional arch=amd64,i386,x32,ppc64el
 g++-multilib-powerpc64-linux-gnu deb devel optional arch=amd64,i386,x32,ppc64el
 g++-multilib-sparc64-linux-gnu deb devel optional arch=amd64,i386,x32
 g++-multilib-x86-64-linux-gnux32 deb devel optional arch=amd64,arm64,i386,ppc64el
 g++-powerpc-linux-gnu deb devel optional arch=amd64,i386,x32,ppc64el
 g++-powerpc64-linux-gnu deb devel optional arch=amd64,i386,x32,ppc64el
 g++-riscv64-linux-gnu deb devel optional arch=amd64,i386,x32,arm64,ppc64el
 g++-sh4-linux-gnu deb devel optional arch=amd64,i386,x32
 g++-sparc64-linux-gnu deb devel optional arch=amd64,i386,x32
 g++-x86-64-linux-gnux32 deb devel optional arch=amd64,arm64,i386,ppc64el
 gcc-alpha-linux-gnu deb devel optional arch=amd64,i386,x32
 gcc-hppa-linux-gnu deb devel optional arch=amd64,i386,x32
 gcc-m68k-linux-gnu deb devel optional arch=amd64,i386,x32
 gcc-multilib-powerpc-linux-gnu deb devel optional arch=amd64,i386,x32,ppc64el
 gcc-multilib-powerpc64-linux-gnu deb devel optional arch=amd64,i386,x32,ppc64el
 gcc-multilib-sparc64-linux-gnu deb devel optional arch=amd64,i386,x32
 gcc-multilib-x86-64-linux-gnux32 deb devel optional arch=amd64,arm64,i386,ppc64el
 gcc-powerpc-linux-gnu deb devel optional arch=amd64,i386,x32,ppc64el
 gcc-powerpc64-linux-gnu deb devel optional arch=amd64,i386,x32,ppc64el
 gcc-riscv64-linux-gnu deb devel optional arch=amd64,i386,x32,arm64,ppc64el
 gcc-sh4-linux-gnu deb devel optional arch=amd64,i386,x32
 gcc-sparc64-linux-gnu deb devel optional arch=amd64,i386,x32
 gcc-x86-64-linux-gnux32 deb devel optional arch=amd64,arm64,i386,ppc64el
 gccgo-alpha-linux-gnu deb devel optional arch=amd64,i386,x32
 gccgo-multilib-powerpc-linux-gnu deb devel optional arch=amd64,i386,x32,ppc64el
 gccgo-multilib-powerpc64-linux-gnu deb devel optional arch=amd64,i386,x32,ppc64el
 gccgo-multilib-sparc64-linux-gnu deb devel optional arch=amd64,i386,x32
 gccgo-multilib-x86-64-linux-gnux32 deb devel optional arch=amd64,arm64,i386,ppc64el
 gccgo-powerpc-linux-gnu deb devel optional arch=amd64,i386,x32,ppc64el
 gccgo-powerpc64-linux-gnu deb devel optional arch=amd64,i386,x32,ppc64el
 gccgo-riscv64-linux-gnu deb devel optional arch=amd64,i386,x32,arm64,ppc64el
 gccgo-sparc64-linux-gnu deb devel optional arch=amd64,i386,x32
 gccgo-x86-64-linux-gnux32 deb devel optional arch=amd64,arm64,i386,ppc64el
 gdc-alpha-linux-gnu deb devel optional arch=amd64,i386,x32
 gdc-hppa-linux-gnu deb devel optional arch=amd64,i386,x32
 gdc-m68k-linux-gnu deb devel optional arch=amd64,i386,x32
 gdc-multilib-powerpc-linux-gnu deb devel optional arch=amd64,i386,x32,ppc64el
 gdc-multilib-powerpc64-linux-gnu deb devel optional arch=amd64,i386,x32,ppc64el
 gdc-multilib-sparc64-linux-gnu deb devel optional arch=amd64,i386,x32
 gdc-multilib-x86-64-linux-gnux32 deb devel optional arch=amd64,arm64,i386,ppc64el
 gdc-powerpc-linux-gnu deb devel optional arch=amd64,i386,x32,ppc64el
 gdc-powerpc64-linux-gnu deb devel optional arch=amd64,i386,x32,ppc64el
 gdc-riscv64-linux-gnu deb devel optional arch=amd64,i386,x32,arm64,ppc64el
 gdc-sh4-linux-gnu deb devel optional arch=amd64,i386,x32
 gdc-sparc64-linux-gnu deb devel optional arch=amd64,i386,x32
 gdc-x86-64-linux-gnux32 deb devel optional arch=amd64,arm64,i386,ppc64el
 gfortran-alpha-linux-gnu deb devel optional arch=amd64,i386,x32
 gfortran-hppa-linux-gnu deb devel optional arch=amd64,i386,x32
 gfortran-m68k-linux-gnu deb devel optional arch=amd64,i386,x32
 gfortran-multilib-powerpc-linux-gnu deb devel optional arch=amd64,i386,x32,ppc64el
 gfortran-multilib-powerpc64-linux-gnu deb devel optional arch=amd64,i386,x32,ppc64el
 gfortran-multilib-sparc64-linux-gnu deb devel optional arch=amd64,i386,x32
 gfortran-multilib-x86-64-linux-gnux32 deb devel optional arch=amd64,arm64,i386,ppc64el
 gfortran-powerpc-linux-gnu deb devel optional arch=amd64,i386,x32,ppc64el
 gfortran-powerpc64-linux-gnu deb devel optional arch=amd64,i386,x32,ppc64el
 gfortran-riscv64-linux-gnu deb devel optional arch=amd64,i386,x32,arm64,ppc64el
 gfortran-sh4-linux-gnu deb devel optional arch=amd64,i386,x32
 gfortran-sparc64-linux-gnu deb devel optional arch=amd64,i386,x32
 gfortran-x86-64-linux-gnux32 deb devel optional arch=amd64,arm64,i386,ppc64el
 gm2-alpha-linux-gnu deb devel optional arch=amd64,i386,x32
 gm2-hppa-linux-gnu deb devel optional arch=amd64,i386,x32
 gm2-m68k-linux-gnu deb devel optional arch=amd64,i386,x32
 gm2-powerpc-linux-gnu deb devel optional arch=amd64,i386,x32,ppc64el
 gm2-powerpc64-linux-gnu deb devel optional arch=amd64,i386,x32,ppc64el
 gm2-riscv64-linux-gnu deb devel optional arch=amd64,i386,x32,arm64,ppc64el
 gm2-sh4-linux-gnu deb devel optional arch=amd64,i386,x32
 gm2-sparc64-linux-gnu deb devel optional arch=amd64,i386,x32
 gm2-x86-64-linux-gnux32 deb devel optional arch=amd64,arm64,i386,ppc64el
 gobjc++-alpha-linux-gnu deb devel optional arch=amd64,i386,x32
 gobjc++-hppa-linux-gnu deb devel optional arch=amd64,i386,x32
 gobjc++-m68k-linux-gnu deb devel optional arch=amd64,i386,x32
 gobjc++-multilib-powerpc-linux-gnu deb devel optional arch=amd64,i386,x32,ppc64el
 gobjc++-multilib-powerpc64-linux-gnu deb devel optional arch=amd64,i386,x32,ppc64el
 gobjc++-multilib-sparc64-linux-gnu deb devel optional arch=amd64,i386,x32
 gobjc++-multilib-x86-64-linux-gnux32 deb devel optional arch=amd64,arm64,i386,ppc64el
 gobjc++-powerpc-linux-gnu deb devel optional arch=amd64,i386,x32,ppc64el
 gobjc++-powerpc64-linux-gnu deb devel optional arch=amd64,i386,x32,ppc64el
 gobjc++-riscv64-linux-gnu deb devel optional arch=amd64,i386,x32,arm64,ppc64el
 gobjc++-sh4-linux-gnu deb devel optional arch=amd64,i386,x32
 gobjc++-sparc64-linux-gnu deb devel optional arch=amd64,i386,x32
 gobjc++-x86-64-linux-gnux32 deb devel optional arch=amd64,arm64,i386,ppc64el
 gobjc-alpha-linux-gnu deb devel optional arch=amd64,i386,x32
 gobjc-hppa-linux-gnu deb devel optional arch=amd64,i386,x32
 gobjc-m68k-linux-gnu deb devel optional arch=amd64,i386,x32
 gobjc-multilib-powerpc-linux-gnu deb devel optional arch=amd64,i386,x32,ppc64el
 gobjc-multilib-powerpc64-linux-gnu deb devel optional arch=amd64,i386,x32,ppc64el
 gobjc-multilib-sparc64-linux-gnu deb devel optional arch=amd64,i386,x32
 gobjc-multilib-x86-64-linux-gnux32 deb devel optional arch=amd64,arm64,i386,ppc64el
 gobjc-powerpc-linux-gnu deb devel optional arch=amd64,i386,x32,ppc64el
 gobjc-powerpc64-linux-gnu deb devel optional arch=amd64,i386,x32,ppc64el
 gobjc-riscv64-linux-gnu deb devel optional arch=amd64,i386,x32,arm64,ppc64el
 gobjc-sh4-linux-gnu deb devel optional arch=amd64,i386,x32
 gobjc-sparc64-linux-gnu deb devel optional arch=amd64,i386,x32
 gobjc-x86-64-linux-gnux32 deb devel optional arch=amd64,arm64,i386,ppc64el
Checksums-Sha1:
 70bcbe41eda2ac55031617af03343945ae280a28 48076 gcc-defaults-ports_1.191ubuntu1.tar.xz
Checksums-Sha256:
 47a9416d12da124a1ddc736e00bbc059c36afbaaf0ac59f53a6fa00a79e31f25 48076 gcc-defaults-ports_1.191ubuntu1.tar.xz
Files:
 f27ec25540fd5c3f3b637ae682e4aeb0 48076 gcc-defaults-ports_1.191ubuntu1.tar.xz

-----BEGIN PGP SIGNATURE-----

iQJEBAEBCAAuFiEE1WVxuIqLuvFAv2PWvX6qYHePpvUFAmIcsQ0QHGRva29AdWJ1
bnR1LmNvbQAKCRC9fqpgd4+m9SSPD/41D0MMduppdVZ3DwxYhTTzP2HeaCWJ5L6L
oHaY/y3hESc5JYmskVppwWJyCeYlmIAjNg35tS3AfDwNmUVKDTNVSE0DiNWHnjr3
E6kiDalq/GMoleXGO6i+KS3d8z2cBE+d4Ms1WznQIyzHptVXU9zXJnjyDrfkKmP3
XxDGDzPQ+edTL4ueldFgfmRL0dxldr7s77D1gl8wGH/O1ztf0qvkt9Vx9U0VW/69
94vbpXfr7DUKDCrPJ63q30k3O2S3HVdPQsB0XaPmQ0H5lMCGBLbPWTih6vUQMGun
VaWfxunjiCXavwUjKVsU8T8yviPQE5x1Cg2NszlnxawdA0P35Lt/FO6ey73hFvUy
lP/gSKq0BPrfYdIdYdHNSlKdO0dNF9Reew5M5CewKZNgGgIAdNFjje5E8ewt54KI
DXUBbdIT0rkkC55J6j5oRfatT/8NhBnuVVf3cCJpMyuCFvwLHntTl3B0Yk+rSrbw
4v2qcb4yJz6iX3ZO/2j2PIlgpyiC4k8EnQSQmAyhZEhAVxQqLs10MHq3WXZhW4U/
hfmHtXlPsRxONKLxi9+6jzzsU5gg7SXWYBHA04hYb3wnfMFKcNSNEeHlc3nb4bmM
7E2lO+fs26K137RmgWT33W3fztmLgomGrSP9tenV80M47wCyaQHODRdVio/EWNqs
BCbufoY5yQ==
=3rcH
-----END PGP SIGNATURE-----
