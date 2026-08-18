-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: hwloc
Binary: hwloc, hwloc-nox, libhwloc-dev, libhwloc15, libhwloc-plugins, libhwloc-common, libhwloc-doc
Architecture: any all
Version: 2.7.0-2ubuntu1
Maintainer: Samuel Thibault <sthibault@debian.org>
Homepage: https://www.open-mpi.org/projects/hwloc/
Standards-Version: 4.6.0
Vcs-Browser: https://salsa.debian.org/debian/hwloc
Vcs-Git: https://salsa.debian.org/debian/hwloc.git
Testsuite: autopkgtest
Testsuite-Triggers: debhelper, dh-autoreconf, libltdl-dev, libxml2-dev, libxml2-utils
Build-Depends: debhelper-compat (= 12), dh-exec, libltdl-dev [!gnu-any-any], valgrind [amd64 arm64 armhf i386 mips64el mipsel ppc64el s390x powerpc ppc64], libcairo2-dev, libx11-dev, libxml2-dev, libxml2-utils <!nocheck>, libncurses5-dev, libnuma-dev [linux-any] <!nocheck>, libxnvctrl-dev, libpciaccess-dev, libudev-dev [linux-any], pkg-config, ocl-icd-opencl-dev [!hurd-i386] | opencl-dev, opencl-headers, autoconf (>= 2.63), dpkg-dev (>= 1.16)
Build-Depends-Indep: doxygen-latex, transfig
Build-Conflicts: autoconf2.13
Package-List:
 hwloc deb admin optional arch=any
 hwloc-nox deb admin optional arch=any
 libhwloc-common deb libs optional arch=all
 libhwloc-dev deb libdevel optional arch=any
 libhwloc-doc deb doc optional arch=all
 libhwloc-plugins deb libs optional arch=any
 libhwloc15 deb libs optional arch=any
Checksums-Sha1:
 6e971b7d182ef8dde3c95b1c6afc2c4c7b5a0ce7 6805375 hwloc_2.7.0.orig.tar.bz2
 ff5bee97cae553b5cecaf5313b6e4eb6a36e2e88 14856 hwloc_2.7.0-2ubuntu1.debian.tar.xz
Checksums-Sha256:
 028cee53ebcfe048283a2b3e87f2fa742c83645fc3ae329134bf5bb8b90384e0 6805375 hwloc_2.7.0.orig.tar.bz2
 2d08de149a4c70bf589b00df8397926eaec3bbe50b400558c1e9ceda9268ebb8 14856 hwloc_2.7.0-2ubuntu1.debian.tar.xz
Files:
 ce504380d78cac6ad641e2fe44a237be 6805375 hwloc_2.7.0.orig.tar.bz2
 d5b51bb515cef048aba54f2a548fa70e 14856 hwloc_2.7.0-2ubuntu1.debian.tar.xz

-----BEGIN PGP SIGNATURE-----

iQGzBAEBCgAdFiEEhN+v6p1yFKyOpddzy9+ryK2RbF0FAmKrO+UACgkQy9+ryK2R
bF1l5gv/RyiBJItjs5xAz+lcMRVDfkvk07gkGcval9IZC+J8HEjsrT0IgpJDJA+5
ZypcvyVtHOuX56hIr5InteOPDvLMyC/BcuYUvmxr0RpnRCzABQfCX3i57qsDJ3E7
wFpYu6Tfyxfd+mt0Nv/UD2Aie182sPC36n3Kb3jYL2fVOa65z7lc5iYD4RcwFoMv
KnFhTpO32apONQzUmzq7ED8Bc1OHpHfSJDanCKV1y5un39u/NvTjb6UVxLMGl4S5
9Gr4I/ht2SBEYHu4WtPCEmf/q5DhbyQJq4FO5u69pFTtjTXSBabY08gR8u9jdynj
k76Zz8JpzyN06MDoHUNtuB84tZV74dPdoZndUfcI48JRc2xKfXA4roXGZu78WEQ5
FR5kNphl7pyBHaWbB08E0ZnXyEDA22gbW/Gfh6gUn9hOIDzqqIER+ccJAX7dT6MK
DO+BjC3Ht/ippju5Rk4JnlRoQY8pvp63zpoNjdZB1SN1ysP4vj/n0nUeeYDDDS6E
vsllr87+
=3QZy
-----END PGP SIGNATURE-----
