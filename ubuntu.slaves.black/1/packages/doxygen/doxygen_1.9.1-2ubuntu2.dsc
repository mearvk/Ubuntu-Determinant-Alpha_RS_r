-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

Format: 3.0 (quilt)
Source: doxygen
Binary: doxygen, doxygen-latex, doxygen-doc, doxygen-gui, doxygen-doxyparse
Architecture: any all
Version: 1.9.1-2ubuntu2
Maintainer: Paolo Greppi <paolo.greppi@libpf.com>
Homepage: http://www.doxygen.nl/
Standards-Version: 4.5.1
Vcs-Browser: https://salsa.debian.org/debian/doxygen
Vcs-Git: https://salsa.debian.org/debian/doxygen.git
Testsuite: autopkgtest
Build-Depends: debhelper-compat (= 12), dpkg-dev (>= 1.17.14), qtbase5-dev (>= 5.12.5+dfsg-3) <!stage1>, flex, bison (>= 1.875a), python3, zlib1g-dev, libxapian-dev (>= 1.2.21-1.2), cmake, llvm-14-dev [amd64 armel armhf arm64 i386 mips mipsel mips64el ppc64 ppc64el riscv64 s390x sparc64], libclang-14-dev [amd64 armel armhf arm64 i386 mips mipsel mips64el ppc64 ppc64el riscv64 s390x sparc64], clang-14 [amd64 armel armhf arm64 i386 mips mipsel mips64el ppc64 ppc64el riscv64 s390x sparc64], sassc, faketime, mat2
Build-Depends-Indep: texlive-fonts-recommended, texlive-plain-generic, texlive-latex-extra, texlive-latex-recommended, texlive-extra-utils, texlive-font-utils, ghostscript, graphviz, rdfind
Package-List:
 doxygen deb devel optional arch=any
 doxygen-doc deb doc optional arch=all
 doxygen-doxyparse deb devel optional arch=any
 doxygen-gui deb devel optional arch=any profile=!stage1
 doxygen-latex deb devel optional arch=all
Checksums-Sha1:
 aa2dc24cdcc715e1a025a79620082e9961780203 5050499 doxygen_1.9.1.orig.tar.gz
 9af7fd42826bf8e03236a124248de73b6621cb4a 28712 doxygen_1.9.1-2ubuntu2.debian.tar.xz
Checksums-Sha256:
 96db0b69cd62be1a06b0efe16b6408310e5bd4cd5cb5495b77f29c84c7ccf7d7 5050499 doxygen_1.9.1.orig.tar.gz
 c9c43eaa560a8af973cbc696176077f96e7db55ae648a692e982b8195be93f48 28712 doxygen_1.9.1-2ubuntu2.debian.tar.xz
Files:
 04f2f374392cf0ee36503ea8a07f07cd 5050499 doxygen_1.9.1.orig.tar.gz
 0e5fdeabe2f61ce43efcb6949b45b64f 28712 doxygen_1.9.1-2ubuntu2.debian.tar.xz

-----BEGIN PGP SIGNATURE-----

iQJEBAEBCAAuFiEE1WVxuIqLuvFAv2PWvX6qYHePpvUFAmIPEQ0QHGRva29AdWJ1
bnR1LmNvbQAKCRC9fqpgd4+m9Re7EADBGx4B8nNdvHRxtfiIqCi+V3CqhUs0Y5ab
DPAL2mmxOrslhz0GACwDv0Y7/5/u5lXtdG1HdE9sOxiI2VTvtDUvIi7k0JwMUO9w
bD89sJDpFwblOAMKVsTbWdZWduKPq003BKq8XQbW9tAYxkZWVHjpHE1XiAB4hFVF
q7D2GT4ZCyjV3HAF7IMhb8DfdMxVjR5H0oMhL22C5qHak39A9Gv0s9infxucZvx0
wSea1z2hKB/GfkXFkUYajiMwP2tlR+M0wjGPq5OGLL57dNHM5Tr9wrtCOM+o40E4
mWut25Bp0rgIuixRYo+mE2gndYvaF89vSEVIcLv3b02epMtxaGwkCRpOcTedU4Tl
WWXpWzjgIJOwJK7pg4FGw5HhdJAwd4AdedWkIvbe+xG8HTbdhK7+4DhfVtvUo7Up
ZDRYzVcmaWRPSjdx6bWQmMGi5RVHxfmKhOZrjcYE2EWF92vnsP2OW25c7SweGJkq
uGL+R41QUliWpeD2Ttkfa2fa1xN6GA7GBx7DePRbx5pH0s0QWM5XJfv60oYr3k92
O9rlmwU9myHUMNo7HZx06VjqN9NAWEoMAyljcr7J1l60ItSmbp+WyP6O05cEV7tO
JJAUF+13cPIKzNdUEnRjDnZjgIb44pL0EPKoyfudIBWonrJ7IxRUvS2bKFPzowO7
L7ndMNftKw==
=zB18
-----END PGP SIGNATURE-----
