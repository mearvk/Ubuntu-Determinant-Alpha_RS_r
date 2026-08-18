-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: abseil
Binary: libabsl-dev, libabsl20210324
Architecture: any
Version: 0~20210324.2-2
Maintainer: Benjamin Barenblat <bbaren@debian.org>
Homepage: https://abseil.io/
Description: extensions to the C++ standard library
 Abseil is an open-source collection of C++ library code designed to augment the
 C++ standard library. The Abseil library code is collected from Google's C++
 codebase and has been extensively tested and used in production. In some cases,
 Abseil provides pieces missing from the C++ standard; in others, Abseil
 provides alternatives to the standard for special needs.
Standards-Version: 4.6.0
Vcs-Browser: https://salsa.debian.org/debian/abseil
Vcs-Git: https://salsa.debian.org/debian/abseil.git
Testsuite: autopkgtest
Testsuite-Triggers: cmake, g++, libgtest-dev, make
Build-Depends: cmake (>= 3.5), debhelper-compat (= 12), googletest (>= 1.10.0.20200926) [!hppa !mipsel !ppc64]
Package-List:
 libabsl-dev deb libdevel optional arch=any
 libabsl20210324 deb libs optional arch=any
Checksums-Sha1:
 a183656261e4700c60fbd058da92595d83bbf3b3 1774104 abseil_0~20210324.2.orig.tar.gz
 4c7612ec7147751d099a7275dd2f747dc811e3ef 37788 abseil_0~20210324.2-2.debian.tar.xz
Checksums-Sha256:
 1680eeea723a4164259dc8660bc06aafb4e73374b9f15a6891afab9c029d4825 1774104 abseil_0~20210324.2.orig.tar.gz
 e63a2eb431655777f4e68fe8cca41d7d67ff96f6564279a8d53e07b7aec1e1bf 37788 abseil_0~20210324.2-2.debian.tar.xz
Files:
 5e6fa2eca52ec76c873945950659133a 1774104 abseil_0~20210324.2.orig.tar.gz
 d08051d0c12d007f9a251ef19c69128a 37788 abseil_0~20210324.2-2.debian.tar.xz

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEQbf+q7LkywHKVTMA5ZUVm53A7cMFAmIBUXEACgkQ5ZUVm53A
7cOWbA//cTgq+YMz0dTz+ICcImnolXy3EnD0wS+0Uy9tpI6xVcXCj6rfHLiuIoRs
JXR8eI/J+uq4tUcw69+p49vaVNTzeofcBVcsWj7Xyol1eM2Kw4roAJvtGisIudZB
ZaCFxHtmJihz/Ua2lRtFm3LMRY2Er7QsBcq+B0w9aB5VTur8mJXXQeZhUJDs/B0i
5zoTfrDdsPqp4j3yYRDfoAWzMT1Ze5hvtP5wHtGxDazSywJ4UA31/6fK0VjpcW9K
cRjpQbHZGbL/pv6iQfTHYgwAFotHLddxTOZVuPwWbtWJ+17GxGzWoz1oxg8fVO5D
DjDe6tn13+wyzPAVccbDtmzC5xANHo7+cJU3vqzEtPsQVttayV47VQfXD5TSaAkZ
cohjpTo3BPVfGxXcqVW5bHWLywgEgbxmNGnZ4U+aokzQxzFAddbYUEHrlmcbrKBg
Pf4lhbVcSvgTjQZNp390qvPh1Xce1BVqB1MMizy0o4qtfviMHJ+ZOtKIYM50aqGE
v/BdONy03bu9OY+IEfM+D5av0Cb0vqrVJhPLFULLJSUC2wg6I4KukTQI4mf7QkCi
1pahNngARvQziUZHnN6Yj1Q8rMUGiKdzoFmYAlyEkuUPt+8ErN3XGkK7TfOaklNS
gezLzv9cZIs/xn50zTKPHGG/hPicsch/fD32A/LVo9rtvua+icg=
=dfFm
-----END PGP SIGNATURE-----
