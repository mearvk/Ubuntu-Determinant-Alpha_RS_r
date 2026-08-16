-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

Format: 3.0 (native)
Source: gcc-defaults
Binary: cpp, gcc, gcc-multilib, g++, g++-multilib, gobjc, gobjc-multilib, gobjc++, gobjc++-multilib, gfortran, gfortran-multilib, gccgo, gccgo-multilib, gdc, gdc-multilib, libgphobos-dev, gm2, gccbrig, gcc-offload-nvptx, gcc-offload-amdgcn, gcc-hppa64-linux-gnu, cpp-x86-64-linux-gnu, gcc-x86-64-linux-gnu, g++-x86-64-linux-gnu, gobjc-x86-64-linux-gnu, gobjc++-x86-64-linux-gnu, gfortran-x86-64-linux-gnu, gccgo-x86-64-linux-gnu, gdc-x86-64-linux-gnu, gm2-x86-64-linux-gnu, gcc-multilib-x86-64-linux-gnu, g++-multilib-x86-64-linux-gnu, gobjc-multilib-x86-64-linux-gnu, gobjc++-multilib-x86-64-linux-gnu, gfortran-multilib-x86-64-linux-gnu, gccgo-multilib-x86-64-linux-gnu, gdc-multilib-x86-64-linux-gnu, cpp-s390x-linux-gnu, gcc-s390x-linux-gnu, g++-s390x-linux-gnu, gobjc-s390x-linux-gnu, gobjc++-s390x-linux-gnu, gfortran-s390x-linux-gnu, gccgo-s390x-linux-gnu, gdc-s390x-linux-gnu, gm2-s390x-linux-gnu, gcc-multilib-s390x-linux-gnu, g++-multilib-s390x-linux-gnu,
 gobjc-multilib-s390x-linux-gnu, gobjc++-multilib-s390x-linux-gnu, gfortran-multilib-s390x-linux-gnu, gccgo-multilib-s390x-linux-gnu, gdc-multilib-s390x-linux-gnu, cpp-powerpc64le-linux-gnu, gcc-powerpc64le-linux-gnu, g++-powerpc64le-linux-gnu, gobjc-powerpc64le-linux-gnu, gobjc++-powerpc64le-linux-gnu, gfortran-powerpc64le-linux-gnu, gccgo-powerpc64le-linux-gnu, gdc-powerpc64le-linux-gnu, gm2-powerpc64le-linux-gnu, cpp-aarch64-linux-gnu, gcc-aarch64-linux-gnu, g++-aarch64-linux-gnu, gobjc-aarch64-linux-gnu, gobjc++-aarch64-linux-gnu, gfortran-aarch64-linux-gnu, gccgo-aarch64-linux-gnu, gdc-aarch64-linux-gnu, gm2-aarch64-linux-gnu, cpp-arm-linux-gnueabihf, gcc-arm-linux-gnueabihf, g++-arm-linux-gnueabihf, gobjc-arm-linux-gnueabihf, gobjc++-arm-linux-gnueabihf, gfortran-arm-linux-gnueabihf, gccgo-arm-linux-gnueabihf, gdc-arm-linux-gnueabihf, gm2-arm-linux-gnueabihf, cpp-arm-linux-gnueabi, gcc-arm-linux-gnueabi, g++-arm-linux-gnueabi, gobjc-arm-linux-gnueabi,
 gobjc++-arm-linux-gnueabi, gfortran-arm-linux-gnueabi, gccgo-arm-linux-gnueabi, gdc-arm-linux-gnueabi, gm2-arm-linux-gnueabi, cpp-powerpc-linux-gnu, gcc-powerpc-linux-gnu, g++-powerpc-linux-gnu, gobjc-powerpc-linux-gnu, gobjc++-powerpc-linux-gnu, gfortran-powerpc-linux-gnu, gccgo-powerpc-linux-gnu, gdc-powerpc-linux-gnu, gcc-multilib-powerpc-linux-gnu, g++-multilib-powerpc-linux-gnu, gobjc-multilib-powerpc-linux-gnu, gobjc++-multilib-powerpc-linux-gnu, gfortran-multilib-powerpc-linux-gnu, gccgo-multilib-powerpc-linux-gnu, gdc-multilib-powerpc-linux-gnu, cpp-i686-linux-gnu, gcc-i686-linux-gnu, g++-i686-linux-gnu, gobjc-i686-linux-gnu, gobjc++-i686-linux-gnu, gfortran-i686-linux-gnu, gccgo-i686-linux-gnu, gdc-i686-linux-gnu, gm2-i686-linux-gnu, gcc-multilib-i686-linux-gnu, g++-multilib-i686-linux-gnu, gobjc-multilib-i686-linux-gnu, gobjc++-multilib-i686-linux-gnu, gfortran-multilib-i686-linux-gnu, gccgo-multilib-i686-linux-gnu, gdc-multilib-i686-linux-gnu, cpp-doc,
 gfortran-doc, gcc-doc,
 gccgo-doc
Architecture: any
Version: 1.193ubuntu1
Maintainer: Debian GCC Maintainers <debian-gcc@lists.debian.org>
Uploaders: Matthias Klose <doko@debian.org>
Standards-Version: 4.5.1
Vcs-Browser: https://salsa.debian.org/toolchain-team/gcc-defaults
Vcs-Git: https://salsa.debian.org/toolchain-team/gcc-defaults.git
Build-Depends: m4, debhelper (>= 11), dpkg-dev (>= 1.17.11), gcc-10-base (>= 10.2.1-3~), lsb-release
Package-List:
 cpp deb interpreters optional arch=any
 cpp-aarch64-linux-gnu deb interpreters optional arch=amd64,i386,x32,ppc64el
 cpp-arm-linux-gnueabi deb interpreters optional arch=amd64,i386,x32,arm64,ppc64el
 cpp-arm-linux-gnueabihf deb interpreters optional arch=amd64,i386,x32,arm64,ppc64el
 cpp-doc deb doc optional arch=any
 cpp-i686-linux-gnu deb interpreters optional arch=amd64,arm64,ppc64el,x32
 cpp-powerpc-linux-gnu deb interpreters optional arch=amd64,i386,x32,ppc64el
 cpp-powerpc64le-linux-gnu deb interpreters optional arch=amd64,i386,x32,ppc64,arm64
 cpp-s390x-linux-gnu deb interpreters optional arch=amd64,i386,x32,arm64,ppc64el
 cpp-x86-64-linux-gnu deb interpreters optional arch=arm64,i386,ppc64el,x32
 g++ deb devel optional arch=any
 g++-aarch64-linux-gnu deb devel optional arch=amd64,i386,x32,ppc64el
 g++-arm-linux-gnueabi deb devel optional arch=amd64,i386,x32,arm64,ppc64el
 g++-arm-linux-gnueabihf deb devel optional arch=amd64,i386,x32,arm64,ppc64el
 g++-i686-linux-gnu deb devel optional arch=amd64,arm64,ppc64el,x32
 g++-multilib deb devel optional arch=amd64,i386,kfreebsd-amd64,mips,mips64,mips64el,mips64r6,mips64r6el,mipsel,mipsn32,mipsn32el,mipsn32r6,mipsn32r6el,mipsr6,mipsr6el,powerpc,ppc64,s390,s390x,sparc,sparc64,x32
 g++-multilib-i686-linux-gnu deb devel optional arch=amd64,arm64,ppc64el,x32
 g++-multilib-powerpc-linux-gnu deb devel optional arch=amd64,i386,x32,ppc64el
 g++-multilib-s390x-linux-gnu deb devel optional arch=amd64,i386,x32,arm64,ppc64el
 g++-multilib-x86-64-linux-gnu deb devel optional arch=arm64,i386,ppc64el,x32
 g++-powerpc-linux-gnu deb devel optional arch=amd64,i386,x32,ppc64el
 g++-powerpc64le-linux-gnu deb devel optional arch=amd64,i386,x32,ppc64,arm64
 g++-s390x-linux-gnu deb devel optional arch=amd64,i386,x32,arm64,ppc64el
 g++-x86-64-linux-gnu deb devel optional arch=arm64,i386,ppc64el,x32
 gcc deb devel optional arch=any
 gcc-aarch64-linux-gnu deb devel optional arch=amd64,i386,x32,ppc64el
 gcc-arm-linux-gnueabi deb devel optional arch=amd64,i386,x32,arm64,ppc64el
 gcc-arm-linux-gnueabihf deb devel optional arch=amd64,i386,x32,arm64,ppc64el
 gcc-doc deb doc optional arch=any
 gcc-hppa64-linux-gnu deb devel optional arch=amd64,hppa,i386,x32
 gcc-i686-linux-gnu deb devel optional arch=amd64,arm64,ppc64el,x32
 gcc-multilib deb devel optional arch=amd64,i386,kfreebsd-amd64,mips,mips64,mips64el,mips64r6,mips64r6el,mipsel,mipsn32,mipsn32el,mipsn32r6,mipsn32r6el,mipsr6,mipsr6el,powerpc,ppc64,s390,s390x,sparc,sparc64,x32
 gcc-multilib-i686-linux-gnu deb devel optional arch=amd64,arm64,ppc64el,x32
 gcc-multilib-powerpc-linux-gnu deb devel optional arch=amd64,i386,x32,ppc64el
 gcc-multilib-s390x-linux-gnu deb devel optional arch=amd64,i386,x32,arm64,ppc64el
 gcc-multilib-x86-64-linux-gnu deb devel optional arch=arm64,i386,ppc64el,x32
 gcc-offload-amdgcn deb devel optional arch=amd64
 gcc-offload-nvptx deb devel optional arch=amd64,ppc64el
 gcc-powerpc-linux-gnu deb devel optional arch=amd64,i386,x32,ppc64el
 gcc-powerpc64le-linux-gnu deb devel optional arch=amd64,i386,x32,ppc64,arm64
 gcc-s390x-linux-gnu deb devel optional arch=amd64,i386,x32,arm64,ppc64el
 gcc-x86-64-linux-gnu deb devel optional arch=arm64,i386,ppc64el,x32
 gccbrig deb devel optional arch=amd64,i386,x32
 gccgo deb devel optional arch=any
 gccgo-aarch64-linux-gnu deb devel optional arch=amd64,i386,x32,ppc64el
 gccgo-arm-linux-gnueabi deb devel optional arch=amd64,i386,x32,arm64,ppc64el
 gccgo-arm-linux-gnueabihf deb devel optional arch=amd64,i386,x32,arm64,ppc64el
 gccgo-doc deb doc optional arch=any
 gccgo-i686-linux-gnu deb devel optional arch=amd64,arm64,ppc64el,x32
 gccgo-multilib deb devel optional arch=amd64,i386,mips,mips64,mips64el,mips64r6,mips64r6el,mipsel,mipsn32,mipsn32el,mipsn32r6,mipsn32r6el,mipsr6,mipsr6el,powerpc,ppc64,s390,s390x,sparc,sparc64,x32
 gccgo-multilib-i686-linux-gnu deb devel optional arch=amd64,arm64,ppc64el,x32
 gccgo-multilib-powerpc-linux-gnu deb devel optional arch=amd64,i386,x32,ppc64el
 gccgo-multilib-s390x-linux-gnu deb devel optional arch=amd64,i386,x32,arm64,ppc64el
 gccgo-multilib-x86-64-linux-gnu deb devel optional arch=arm64,i386,ppc64el,x32
 gccgo-powerpc-linux-gnu deb devel optional arch=amd64,i386,x32,ppc64el
 gccgo-powerpc64le-linux-gnu deb devel optional arch=amd64,i386,x32,ppc64,arm64
 gccgo-s390x-linux-gnu deb devel optional arch=amd64,i386,x32,arm64,ppc64el
 gccgo-x86-64-linux-gnu deb devel optional arch=arm64,i386,ppc64el,x32
 gdc deb devel optional arch=any
 gdc-aarch64-linux-gnu deb devel optional arch=amd64,i386,x32,ppc64el
 gdc-arm-linux-gnueabi deb devel optional arch=amd64,i386,x32,arm64,ppc64el
 gdc-arm-linux-gnueabihf deb devel optional arch=amd64,i386,x32,arm64,ppc64el
 gdc-i686-linux-gnu deb devel optional arch=amd64,arm64,ppc64el,x32
 gdc-multilib deb devel optional arch=amd64,i386,kfreebsd-amd64,mips,mips64,mips64el,mips64r6,mips64r6el,mipsel,mipsn32,mipsn32el,mipsn32r6,mipsn32r6el,mipsr6,mipsr6el,powerpc,ppc64,s390,s390x,sparc,sparc64,x32
 gdc-multilib-i686-linux-gnu deb devel optional arch=amd64,arm64,ppc64el,x32
 gdc-multilib-powerpc-linux-gnu deb devel optional arch=amd64,i386,x32,ppc64el
 gdc-multilib-s390x-linux-gnu deb devel optional arch=amd64,i386,x32,arm64,ppc64el
 gdc-multilib-x86-64-linux-gnu deb devel optional arch=arm64,i386,ppc64el,x32
 gdc-powerpc-linux-gnu deb devel optional arch=amd64,i386,x32,ppc64el
 gdc-powerpc64le-linux-gnu deb devel optional arch=amd64,i386,x32,ppc64,arm64
 gdc-s390x-linux-gnu deb devel optional arch=amd64,i386,x32,arm64,ppc64el
 gdc-x86-64-linux-gnu deb devel optional arch=arm64,i386,ppc64el,x32
 gfortran deb devel optional arch=any
 gfortran-aarch64-linux-gnu deb devel optional arch=amd64,i386,x32,ppc64el
 gfortran-arm-linux-gnueabi deb devel optional arch=amd64,i386,x32,arm64,ppc64el
 gfortran-arm-linux-gnueabihf deb devel optional arch=amd64,i386,x32,arm64,ppc64el
 gfortran-doc deb doc optional arch=any
 gfortran-i686-linux-gnu deb devel optional arch=amd64,arm64,ppc64el,x32
 gfortran-multilib deb devel optional arch=amd64,i386,kfreebsd-amd64,mips,mips64,mips64el,mips64r6,mips64r6el,mipsel,mipsn32,mipsn32el,mipsn32r6,mipsn32r6el,mipsr6,mipsr6el,powerpc,ppc64,s390,s390x,sparc,sparc64,x32
 gfortran-multilib-i686-linux-gnu deb devel optional arch=amd64,arm64,ppc64el,x32
 gfortran-multilib-powerpc-linux-gnu deb devel optional arch=amd64,i386,x32,ppc64el
 gfortran-multilib-s390x-linux-gnu deb devel optional arch=amd64,i386,x32,arm64,ppc64el
 gfortran-multilib-x86-64-linux-gnu deb devel optional arch=arm64,i386,ppc64el,x32
 gfortran-powerpc-linux-gnu deb devel optional arch=amd64,i386,x32,ppc64el
 gfortran-powerpc64le-linux-gnu deb devel optional arch=amd64,i386,x32,ppc64,arm64
 gfortran-s390x-linux-gnu deb devel optional arch=amd64,i386,x32,arm64,ppc64el
 gfortran-x86-64-linux-gnu deb devel optional arch=arm64,i386,ppc64el,x32
 gm2 deb devel optional arch=any
 gm2-aarch64-linux-gnu deb devel optional arch=amd64,i386,x32,ppc64el
 gm2-arm-linux-gnueabi deb devel optional arch=amd64,i386,x32,arm64,ppc64el
 gm2-arm-linux-gnueabihf deb devel optional arch=amd64,i386,x32,arm64,ppc64el
 gm2-i686-linux-gnu deb devel optional arch=amd64,arm64,ppc64el,x32
 gm2-powerpc64le-linux-gnu deb devel optional arch=amd64,i386,x32,ppc64,arm64
 gm2-s390x-linux-gnu deb devel optional arch=amd64,i386,x32,arm64,ppc64el
 gm2-x86-64-linux-gnu deb devel optional arch=arm64,i386,ppc64el,x32
 gobjc deb devel optional arch=any
 gobjc++ deb devel optional arch=any
 gobjc++-aarch64-linux-gnu deb devel optional arch=amd64,i386,x32,ppc64el
 gobjc++-arm-linux-gnueabi deb devel optional arch=amd64,i386,x32,arm64,ppc64el
 gobjc++-arm-linux-gnueabihf deb devel optional arch=amd64,i386,x32,arm64,ppc64el
 gobjc++-i686-linux-gnu deb devel optional arch=amd64,arm64,ppc64el,x32
 gobjc++-multilib deb devel optional arch=amd64,i386,kfreebsd-amd64,mips,mips64,mips64el,mips64r6,mips64r6el,mipsel,mipsn32,mipsn32el,mipsn32r6,mipsn32r6el,mipsr6,mipsr6el,powerpc,ppc64,s390,s390x,sparc,sparc64,x32
 gobjc++-multilib-i686-linux-gnu deb devel optional arch=amd64,arm64,ppc64el,x32
 gobjc++-multilib-powerpc-linux-gnu deb devel optional arch=amd64,i386,x32,ppc64el
 gobjc++-multilib-s390x-linux-gnu deb devel optional arch=amd64,i386,x32,arm64,ppc64el
 gobjc++-multilib-x86-64-linux-gnu deb devel optional arch=arm64,i386,ppc64el,x32
 gobjc++-powerpc-linux-gnu deb devel optional arch=amd64,i386,x32,ppc64el
 gobjc++-powerpc64le-linux-gnu deb devel optional arch=amd64,i386,x32,ppc64,arm64
 gobjc++-s390x-linux-gnu deb devel optional arch=amd64,i386,x32,arm64,ppc64el
 gobjc++-x86-64-linux-gnu deb devel optional arch=arm64,i386,ppc64el,x32
 gobjc-aarch64-linux-gnu deb devel optional arch=amd64,i386,x32,ppc64el
 gobjc-arm-linux-gnueabi deb devel optional arch=amd64,i386,x32,arm64,ppc64el
 gobjc-arm-linux-gnueabihf deb devel optional arch=amd64,i386,x32,arm64,ppc64el
 gobjc-i686-linux-gnu deb devel optional arch=amd64,arm64,ppc64el,x32
 gobjc-multilib deb devel optional arch=amd64,i386,kfreebsd-amd64,mips,mips64,mips64el,mips64r6,mips64r6el,mipsel,mipsn32,mipsn32el,mipsn32r6,mipsn32r6el,mipsr6,mipsr6el,powerpc,ppc64,s390,s390x,sparc,sparc64,x32
 gobjc-multilib-i686-linux-gnu deb devel optional arch=amd64,arm64,ppc64el,x32
 gobjc-multilib-powerpc-linux-gnu deb devel optional arch=amd64,i386,x32,ppc64el
 gobjc-multilib-s390x-linux-gnu deb devel optional arch=amd64,i386,x32,arm64,ppc64el
 gobjc-multilib-x86-64-linux-gnu deb devel optional arch=arm64,i386,ppc64el,x32
 gobjc-powerpc-linux-gnu deb devel optional arch=amd64,i386,x32,ppc64el
 gobjc-powerpc64le-linux-gnu deb devel optional arch=amd64,i386,x32,ppc64,arm64
 gobjc-s390x-linux-gnu deb devel optional arch=amd64,i386,x32,arm64,ppc64el
 gobjc-x86-64-linux-gnu deb devel optional arch=arm64,i386,ppc64el,x32
 libgphobos-dev deb libdevel optional arch=any
Checksums-Sha1:
 457fd5401cbe91f1c4704f42b7a2c88b18772477 48128 gcc-defaults_1.193ubuntu1.tar.xz
Checksums-Sha256:
 f2859f04a7db7b5777be7e17d546b8779c7ea563d50d6575604706d25e57f852 48128 gcc-defaults_1.193ubuntu1.tar.xz
Files:
 e5008eee790be6cc02d113f8367bddc0 48128 gcc-defaults_1.193ubuntu1.tar.xz

-----BEGIN PGP SIGNATURE-----

iQJEBAEBCAAuFiEE1WVxuIqLuvFAv2PWvX6qYHePpvUFAmELl4oQHGRva29AdWJ1
bnR1LmNvbQAKCRC9fqpgd4+m9fpGEADQiZjbPz27H3yhQUZkW4kyuiTWtyzxbsCv
cEJKbrg0TFkJuFuyqGmKTuLoGW4rDzRXwDuEKbzrkzx7fMqEMCHs8rpjorBUAj5O
zFu0mIbOxC8yadyb878VgF/AP0u+uAuv9R4QguZgmFfPgYIMRDM2ghQzt5088mwO
g8p1UIuEmU0Qd+61givu1duE/IuOgQB3hocDtA87yyjUC0VH1PyP+d7vwpgsJ5gf
3XBzynQF31F7x2kVVuMFkCtmsCgvoshExXs43jhSk5UKhc6Yg2IrmScFfI9MhHdT
dv6hYs6BIc9ptmGkmaSqHXrVjwTAeAPi9bEYRNDp4Y/qTgTqLhjz+ckje8JX8foS
9Zrw9PdivACGzKoAO8YWJA3+fzY9E4Nryiobk5tDedHp9xATcYmG8/NqRq2/H/yg
SgVxu+rxU+1aSTjFHkDCR7pS5eW3XSRPKBmAEEjgc0RdAHp2QqZ1/d61ZjobTMOP
kLFWhO7v6yDyOHcva8l/fivSBug2TXr0Lq0/a/Jse/3MQ2qHRgdUUTfgTTfNyF3Y
uAbqEzcglD08Y8Icw1bDKJDLkoWjkEFvmhtoCvuBJuXhGoKDlksAX0XXNOA6C8kC
8qro2ZdPE02lTCRBGKVFXcbE7Oill3Ed7GdNhUxL009XA7i+ofL7ZLhw4bbKHaee
TIuBf1qwog==
=Qxc1
-----END PGP SIGNATURE-----
