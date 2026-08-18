-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: ncurses
Binary: ncurses-base, ncurses-term, libtinfo6, libtinfo6-udeb, libncurses6, libncurses-dev, libtinfo-dev, libncurses5-dev, libncursesw6, libncursesw6-udeb, libncursesw5-dev, lib64tinfo6, lib64ncurses6, lib64ncursesw6, lib64ncurses-dev, lib32tinfo6, lib32ncurses6, lib32ncursesw6, lib32ncurses-dev, ncurses-bin, ncurses-examples, ncurses-doc, libtinfo5, libncurses5, libncursesw5
Architecture: any all
Version: 6.3-2ubuntu0.1
Maintainer: Ubuntu Developers <ubuntu-devel-discuss@lists.ubuntu.com>
Uploaders: Sven Joachim <svenjoac@gmx.de>
Homepage: https://invisible-island.net/ncurses/
Standards-Version: 4.5.1
Vcs-Browser: https://salsa.debian.org/debian/ncurses
Vcs-Git: https://salsa.debian.org/debian/ncurses.git
Build-Depends: debhelper-compat (= 13), libgpm-dev [linux-any], pkg-config, libmd-dev [kfreebsd-any], autoconf-dickey (>= 2.52+20210509)
Build-Depends-Arch: g++-multilib [amd64 i386 powerpc ppc64 s390 sparc] <!nobiarch>
Package-List:
 lib32ncurses-dev deb libdevel optional arch=amd64,ppc64 profile=!nobiarch
 lib32ncurses6 deb libs optional arch=amd64,ppc64 profile=!nobiarch
 lib32ncursesw6 deb libs optional arch=amd64,ppc64 profile=!nobiarch
 lib32tinfo6 deb libs optional arch=amd64,ppc64 profile=!nobiarch
 lib64ncurses-dev deb libdevel optional arch=i386,powerpc,sparc,s390 profile=!nobiarch
 lib64ncurses6 deb libs optional arch=i386,powerpc,sparc,s390 profile=!nobiarch
 lib64ncursesw6 deb libs optional arch=i386,powerpc,sparc,s390 profile=!nobiarch
 lib64tinfo6 deb libs optional arch=i386,powerpc,sparc,s390 profile=!nobiarch
 libncurses-dev deb libdevel optional arch=any
 libncurses5 deb oldlibs optional arch=any profile=!pkg.ncurses.nolegacy
 libncurses5-dev deb oldlibs optional arch=any
 libncurses6 deb libs optional arch=any
 libncursesw5 deb oldlibs optional arch=any profile=!pkg.ncurses.nolegacy
 libncursesw5-dev deb oldlibs optional arch=any
 libncursesw6 deb libs optional arch=any
 libncursesw6-udeb udeb debian-installer optional arch=any profile=!noudeb
 libtinfo-dev deb oldlibs optional arch=any
 libtinfo5 deb oldlibs optional arch=any profile=!pkg.ncurses.nolegacy
 libtinfo6 deb libs optional arch=any
 libtinfo6-udeb udeb debian-installer optional arch=any profile=!noudeb
 ncurses-base deb misc required arch=all essential=yes
 ncurses-bin deb utils required arch=any essential=yes
 ncurses-doc deb doc optional arch=all
 ncurses-examples deb misc optional arch=any profile=!pkg.ncurses.noexamples
 ncurses-term deb misc standard arch=all
Checksums-Sha1:
 38fb1462d13b04bb900adf07918725c4b7ed0682 3583550 ncurses_6.3.orig.tar.gz
 6c5fccc716dbf84b6d60e7fb0df45aef9d90f67e 729 ncurses_6.3.orig.tar.gz.asc
 4cf2336ccc545dc743b204a0197bf403d616ce55 56080 ncurses_6.3-2ubuntu0.1.debian.tar.xz
Checksums-Sha256:
 97fc51ac2b085d4cde31ef4d2c3122c21abc217e9090a43a30fc5ec21684e059 3583550 ncurses_6.3.orig.tar.gz
 37b9e80c11fa02fbd8caf42ab9573427f54f2c7212eb4aeec9f455b5d79dee14 729 ncurses_6.3.orig.tar.gz.asc
 ca221fdf0d4a987b9719985a8c7a6e603a7ef8f855cdfaefe73b56c08130064a 56080 ncurses_6.3-2ubuntu0.1.debian.tar.xz
Files:
 a2736befde5fee7d2b7eb45eb281cdbe 3583550 ncurses_6.3.orig.tar.gz
 7410b0bb10e5a381a3e18afe82ff0168 729 ncurses_6.3.orig.tar.gz.asc
 12cfa9fc95dbd01535ec1d821942f89e 56080 ncurses_6.3-2ubuntu0.1.debian.tar.xz
Original-Maintainer: Craig Small <csmall@debian.org>

-----BEGIN PGP SIGNATURE-----

iQFYBAEBCgBCFiEEGq96SdAIJY1vInRLbzAtCH6LqTYFAmRmdrYkHGNhbWlsYS5j
YW1hcmdvZGVtYXRvc0BjYW5vbmljYWwuY29tAAoJEG8wLQh+i6k2a3kH/0Vcr0uA
p1XSslmbaR7m1kznGs6iyd6bU6xVRChzWpSuHNluflZhe4v7YNugB/ojwW4O04Hb
ovU4Pl8D2l7bKeXbytA36gwZLwEPenEOLQ2/vNp7xDfsVGsnB6FcIh/VBVv3elpA
QLthSxPNdgg5Pw/bP9N877S7nLpHu2eFAGxhId+nn6MX1bMpCjWKBtCK0VCc6Y5d
RpY9z+ZrAa/BEaqrdYZVEjQGvNVXgK1eKVX0jzZMKYMjLD3N+i+KrvddqhyPqtZ5
2cGcbcMN2WHEqQACwIy/xB2OJiB+6JcSu7nw0YVOlfiREzzl5BQIfDgU/4H30H50
fL2HL9n1hKv65e0=
=sK4W
-----END PGP SIGNATURE-----
