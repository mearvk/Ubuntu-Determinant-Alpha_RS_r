-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (native)
Source: gcc-mingw-w64
Binary: gcc-mingw-w64, gcc-mingw-w64-i686, gcc-mingw-w64-i686-posix, gcc-mingw-w64-i686-win32, gcc-mingw-w64-x86-64, gcc-mingw-w64-x86-64-posix, gcc-mingw-w64-x86-64-win32, g++-mingw-w64, g++-mingw-w64-i686, g++-mingw-w64-i686-posix, g++-mingw-w64-i686-win32, g++-mingw-w64-x86-64, g++-mingw-w64-x86-64-posix, g++-mingw-w64-x86-64-win32, gfortran-mingw-w64, gfortran-mingw-w64-i686, gfortran-mingw-w64-i686-posix, gfortran-mingw-w64-i686-win32, gfortran-mingw-w64-x86-64, gfortran-mingw-w64-x86-64-posix, gfortran-mingw-w64-x86-64-win32, gobjc-mingw-w64, gobjc-mingw-w64-i686, gobjc-mingw-w64-i686-posix, gobjc-mingw-w64-i686-win32, gobjc-mingw-w64-x86-64, gobjc-mingw-w64-x86-64-posix, gobjc-mingw-w64-x86-64-win32, gobjc++-mingw-w64, gobjc++-mingw-w64-i686, gobjc++-mingw-w64-i686-posix, gobjc++-mingw-w64-i686-win32, gobjc++-mingw-w64-x86-64, gobjc++-mingw-w64-x86-64-posix, gobjc++-mingw-w64-x86-64-win32, gnat-mingw-w64, gnat-mingw-w64-i686, gnat-mingw-w64-i686-posix,
 gnat-mingw-w64-i686-win32, gnat-mingw-w64-x86-64, gnat-mingw-w64-x86-64-posix, gnat-mingw-w64-x86-64-win32, gcc-mingw-w64-i686-posix-runtime, gcc-mingw-w64-i686-win32-runtime, gcc-mingw-w64-x86-64-posix-runtime, gcc-mingw-w64-x86-64-win32-runtime,
 gcc-mingw-w64-base
Architecture: any all
Version: 24.3
Maintainer: Stephen Kitt <skitt@debian.org>
Homepage: https://www.gnu.org/software/gcc/
Standards-Version: 4.6.0
Vcs-Browser: https://salsa.debian.org/mingw-w64-team/gcc-mingw-w64
Vcs-Git: https://salsa.debian.org/mingw-w64-team/gcc-mingw-w64.git
Build-Depends: autotools-dev, binutils-mingw-w64-i686 (>= 2.30~), binutils-mingw-w64-x86-64 (>= 2.30~), bison, debhelper, flex, g++-10 <!stage1>, gcc-10-source, gnat-10 [alpha amd64 arm64 armel armhf hppa i386 mips64el mipsel ppc64 ppc64el riscv64 s390x sh4 sparc64 x32] <!stage1>, libelf-dev, libgmp-dev, libisl-dev, libmpc-dev, libmpfr-dev, mingw-w64-i686-dev <!stage1>, mingw-w64-x86-64-dev <!stage1>, xz-utils, zlib1g-dev
Package-List:
 g++-mingw-w64 deb devel optional arch=all profile=!stage1
 g++-mingw-w64-i686 deb devel optional arch=all profile=!stage1
 g++-mingw-w64-i686-posix deb devel optional arch=any profile=!stage1
 g++-mingw-w64-i686-win32 deb devel optional arch=any profile=!stage1
 g++-mingw-w64-x86-64 deb devel optional arch=all profile=!stage1
 g++-mingw-w64-x86-64-posix deb devel optional arch=any profile=!stage1
 g++-mingw-w64-x86-64-win32 deb devel optional arch=any profile=!stage1
 gcc-mingw-w64 deb devel optional arch=all profile=!stage1
 gcc-mingw-w64-base deb devel optional arch=any
 gcc-mingw-w64-i686 deb devel optional arch=all profile=!stage1
 gcc-mingw-w64-i686-posix deb devel optional arch=any profile=!stage1
 gcc-mingw-w64-i686-posix-runtime deb devel optional arch=any
 gcc-mingw-w64-i686-win32 deb devel optional arch=any profile=!stage1
 gcc-mingw-w64-i686-win32-runtime deb devel optional arch=any
 gcc-mingw-w64-x86-64 deb devel optional arch=all profile=!stage1
 gcc-mingw-w64-x86-64-posix deb devel optional arch=any profile=!stage1
 gcc-mingw-w64-x86-64-posix-runtime deb devel optional arch=any
 gcc-mingw-w64-x86-64-win32 deb devel optional arch=any profile=!stage1
 gcc-mingw-w64-x86-64-win32-runtime deb devel optional arch=any
 gfortran-mingw-w64 deb devel optional arch=all profile=!stage1
 gfortran-mingw-w64-i686 deb devel optional arch=all profile=!stage1
 gfortran-mingw-w64-i686-posix deb devel optional arch=any profile=!stage1
 gfortran-mingw-w64-i686-win32 deb devel optional arch=any profile=!stage1
 gfortran-mingw-w64-x86-64 deb devel optional arch=all profile=!stage1
 gfortran-mingw-w64-x86-64-posix deb devel optional arch=any profile=!stage1
 gfortran-mingw-w64-x86-64-win32 deb devel optional arch=any profile=!stage1
 gnat-mingw-w64 deb devel optional arch=all profile=!stage1
 gnat-mingw-w64-i686 deb devel optional arch=all profile=!stage1
 gnat-mingw-w64-i686-posix deb devel optional arch=alpha,amd64,arm64,armel,armhf,hppa,i386,mips64el,mipsel,ppc64,ppc64el,riscv64,s390x,sh4,sparc64,x32 profile=!stage1
 gnat-mingw-w64-i686-win32 deb devel optional arch=alpha,amd64,arm64,armel,armhf,hppa,i386,mips64el,mipsel,ppc64,ppc64el,riscv64,s390x,sh4,sparc64,x32 profile=!stage1
 gnat-mingw-w64-x86-64 deb devel optional arch=all profile=!stage1
 gnat-mingw-w64-x86-64-posix deb devel optional arch=alpha,amd64,arm64,armel,armhf,hppa,i386,mips64el,mipsel,ppc64,ppc64el,riscv64,s390x,sh4,sparc64,x32 profile=!stage1
 gnat-mingw-w64-x86-64-win32 deb devel optional arch=alpha,amd64,arm64,armel,armhf,hppa,i386,mips64el,mipsel,ppc64,ppc64el,riscv64,s390x,sh4,sparc64,x32 profile=!stage1
 gobjc++-mingw-w64 deb devel optional arch=all profile=!stage1
 gobjc++-mingw-w64-i686 deb devel optional arch=all profile=!stage1
 gobjc++-mingw-w64-i686-posix deb devel optional arch=any profile=!stage1
 gobjc++-mingw-w64-i686-win32 deb devel optional arch=any profile=!stage1
 gobjc++-mingw-w64-x86-64 deb devel optional arch=all profile=!stage1
 gobjc++-mingw-w64-x86-64-posix deb devel optional arch=any profile=!stage1
 gobjc++-mingw-w64-x86-64-win32 deb devel optional arch=any profile=!stage1
 gobjc-mingw-w64 deb devel optional arch=all profile=!stage1
 gobjc-mingw-w64-i686 deb devel optional arch=all profile=!stage1
 gobjc-mingw-w64-i686-posix deb devel optional arch=any profile=!stage1
 gobjc-mingw-w64-i686-win32 deb devel optional arch=any profile=!stage1
 gobjc-mingw-w64-x86-64 deb devel optional arch=all profile=!stage1
 gobjc-mingw-w64-x86-64-posix deb devel optional arch=any profile=!stage1
 gobjc-mingw-w64-x86-64-win32 deb devel optional arch=any profile=!stage1
Checksums-Sha1:
 dbfda68ae131d7a8d8404e90ac930a730df60abe 34680 gcc-mingw-w64_24.3.tar.xz
Checksums-Sha256:
 fedd36a7a285f2a396ae5e001664c3188b91b45d704d5505914e8a11f05f2909 34680 gcc-mingw-w64_24.3.tar.xz
Files:
 2283cd01db3956e32ec62e9cf424cba1 34680 gcc-mingw-w64_24.3.tar.xz

-----BEGIN PGP SIGNATURE-----

iQIyBAEBCgAdFiEEnPVX/hPLkMoq7x0ggNMC9Yhtg5wFAmIGjhgACgkQgNMC9Yht
g5zizQ/0CNurehD5K9H/hxFITWwTp7dBC7+VNo6u25/DUNeZ8s9GlykRDQr9CmSI
KSfcvz81kMIIYlOZcvXmfFUq/hJblLtVFv4zEPGGOA5ra91WIA/v01jrnw+T9P0s
r6y9Qki9GXfgvzXdy1cpqpFssufMqveTM2KMxXpmrd6HD+aLiIDQyLaH7ucj/bLN
B12Zx8eEsK+JjGB7Sk/REQE/9ymSH26eavghHnd/jc6Qz42WCZWskfGoq0qkMg1e
b4nKTRayn92HRG5sicMMkUN6WQ4WSUqBRW1OEY5VYLytmMAYCDgBW/+hxd06zcAW
CYOUh6rGsMTBuLWmgBw8sXLBW5kun98V+8Ddje8zqcu5V8EU0de6LtU90gJthNt9
ZDdg72n/hxFebTEDo6U5ybGS7NyR548lpit1YPSgwqkI0IZoPLIroGbbWh8rcl5v
CDL3anskQ6uLcluBCJLo6vQh3bGLL6aA81f281OQcdMhbjbBAE6kN+2afiw9dd58
v4vwjaYN8Tim+KGqwz20je53093Dk6Y76YuTQnjj2F5X9gIy/PjxtB04xXIf5YqH
HWlL9mFQrkmAZ4N2aqfHbvqRbtHXp+Wpkb38WVFpa1VJJajxNPz98Z7R5dKLV0Ba
DOYUsjoHMKxM8prqSCkFzt7oC60vpU367vU+umiQFLaYb/G+Uw==
=6x8p
-----END PGP SIGNATURE-----
