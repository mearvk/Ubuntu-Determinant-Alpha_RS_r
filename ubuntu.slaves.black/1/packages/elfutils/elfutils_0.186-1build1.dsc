-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: elfutils
Binary: elfutils, libelf1, libelf-dev, libdw-dev, libdw1, libasm1, libasm-dev, libdebuginfod1, libdebuginfod-dev, debuginfod, libdebuginfod-common
Architecture: any all
Version: 0.186-1build1
Maintainer: Debian Elfutils Maintainers <debian-gcc@lists.debian.org>
Uploaders: Kurt Roeckx <kurt@roeckx.be>, Matthias Klose <doko@debian.org>, Sergio Durigan Junior <sergiodj@debian.org>,
Homepage: https://sourceware.org/elfutils/
Standards-Version: 4.5.1
Vcs-Browser: https://salsa.debian.org/toolchain-team/elfutils
Vcs-Git: https://salsa.debian.org/toolchain-team/elfutils.git
Build-Depends: debhelper (>= 11), autoconf, automake, lsb-release, bzip2, zlib1g-dev, zlib1g-dev:native, libbz2-dev, liblzma-dev, m4, gettext, po-debconf, gawk, dpkg-dev (>= 1.16.1~), gcc-multilib [any-amd64 sparc64] <!nocheck>, libc6-dbg [powerpc powerpcspe ppc64 ppc64el armel armhf arm64 sparc64 riscv64], flex, bison, pkg-config, libarchive-dev <!pkg.elfutils.nodebuginfod>, libmicrohttpd-dev <!pkg.elfutils.nodebuginfod>, libcurl4-gnutls-dev <!pkg.elfutils.nodebuginfod>, libsqlite3-dev <!pkg.elfutils.nodebuginfod>
Build-Conflicts: autoconf2.13
Package-List:
 debuginfod deb devel optional arch=any profile=!pkg.elfutils.nodebuginfod
 elfutils deb utils optional arch=any
 libasm-dev deb libdevel optional arch=any
 libasm1 deb libs optional arch=any
 libdebuginfod-common deb devel optional arch=all profile=!pkg.elfutils.nodebuginfod
 libdebuginfod-dev deb libdevel optional arch=any profile=!pkg.elfutils.nodebuginfod
 libdebuginfod1 deb libs optional arch=any profile=!pkg.elfutils.nodebuginfod
 libdw-dev deb libdevel optional arch=any
 libdw1 deb libs optional arch=any
 libelf-dev deb libdevel optional arch=any
 libelf1 deb libs optional arch=any
Checksums-Sha1:
 650d52024be684dabf18a5261a69836a16f84f72 9230491 elfutils_0.186.orig.tar.bz2
 df8e7873c045703ebbc5e8188233359b8eb8c24e 37944 elfutils_0.186-1build1.debian.tar.xz
Checksums-Sha256:
 7f6fb9149b1673d38d9178a0d3e0fb8a1ec4f53a9f4c2ff89469609879641177 9230491 elfutils_0.186.orig.tar.bz2
 07ae39683a59ce2d3a46f4b36277bf36076e4c7ce4634195fec63f81f95f7e3c 37944 elfutils_0.186-1build1.debian.tar.xz
Files:
 2c095e31e35d6be7b3718477b6d52702 9230491 elfutils_0.186.orig.tar.bz2
 1a025e227af8f9e0e412501bad8ab18f 37944 elfutils_0.186-1build1.debian.tar.xz

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEqx+XcX7ftBm4bj5/AhnKGdA0MwwFAmI7JeoACgkQAhnKGdA0
Mwx5YQgAmXdBzVIgnIVlZxPetPJWO+XCJ1zG+s5E3g9SEMOdeKV1Ke/3wYD9luI6
W9t3/kq09XyKPXBLUlaprmSIobLqVjdQA8TdnjbwDTFDKSCv6TgKLnY5l/KqCqh1
pt1Y1GGEeSAOF5Z1DPMigyJ5XlflkohFHYomN4CLNMXVtG5UWKU+eBnoN1gPqPgB
2ra+TPSfubRzyzd/gh/nH40qtgP17THObVXgifAkrIwQTQ010ace7MaEHbGt84Vb
jnkL71OMmyic4DO+QxXSIedBJGtzzosDmrP7Xbd2Ir3cnDVzhdkZEqTP6+3MPA/O
o2hHOGWx8YduM1DOxwIA/Etg5EM6nQ==
=Y7Df
-----END PGP SIGNATURE-----
