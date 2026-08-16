-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: freetype
Binary: libfreetype6, libfreetype-dev, libfreetype6-dev, freetype2-demos, freetype2-doc, libfreetype6-udeb
Architecture: any all
Version: 2.11.1+dfsg-1ubuntu0.2
Maintainer: Ubuntu Developers <ubuntu-devel-discuss@lists.ubuntu.com>
Uploaders: Anthony Fok <foka@debian.org>, Keith Packard <keithp@keithp.com>
Homepage: https://www.freetype.org
Standards-Version: 4.6.0
Vcs-Browser: https://salsa.debian.org/debian/freetype
Vcs-Git: https://salsa.debian.org/debian/freetype.git
Testsuite: autopkgtest
Testsuite-Triggers: build-essential, pkg-config
Build-Depends: debhelper-compat (= 13), autoconf, bzip2, gettext, libbrotli-dev, libpng-dev, libtool, libx11-dev <!stage1>, zlib1g-dev | libz-dev, pkg-config, x11proto-core-dev <!stage1>
Package-List:
 freetype2-demos deb utils optional arch=any profile=!stage1
 freetype2-doc deb doc optional arch=all
 libfreetype-dev deb libdevel optional arch=any
 libfreetype6 deb libs optional arch=any
 libfreetype6-dev deb oldlibs optional arch=any
 libfreetype6-udeb udeb debian-installer optional arch=any
Checksums-Sha1:
 2ffcb1bd3dcc141f2261d2cdf9eb1d6db608053e 257240 freetype_2.11.1+dfsg.orig-ft2demos.tar.xz
 0487bedd0dd079f044ea70212f78b02ec8a28bd1 195 freetype_2.11.1+dfsg.orig-ft2demos.tar.xz.asc
 741bc47a4f7861dae5c95915060ab137692e482a 2038348 freetype_2.11.1+dfsg.orig-ft2docs.tar.xz
 4b43c70a32442cc1689849d8cdcaf2ddb7eac69e 195 freetype_2.11.1+dfsg.orig-ft2docs.tar.xz.asc
 91c516e7489153a8aba648325aeea768dd294fea 1988020 freetype_2.11.1+dfsg.orig.tar.xz
 e86d417518c2a72b8d9e0a32b21ae2d2548a84d4 41920 freetype_2.11.1+dfsg-1ubuntu0.2.debian.tar.xz
Checksums-Sha256:
 c60620d49d0f16d95586eb868c01b129569409e6cfdcb87a78e0482a12604672 257240 freetype_2.11.1+dfsg.orig-ft2demos.tar.xz
 d911a95830c50efcf60398e51db4ec307bbf4d24168377b515aded0611e977c0 195 freetype_2.11.1+dfsg.orig-ft2demos.tar.xz.asc
 755e29908093c19138a38775784b0accf7e838ffa28a25b8722b3dfe651d80fa 2038348 freetype_2.11.1+dfsg.orig-ft2docs.tar.xz
 67cbc2f192460dc4d46129e7debe55b40a9fa6e224ffeed70b4cf397ebaccab5 195 freetype_2.11.1+dfsg.orig-ft2docs.tar.xz.asc
 ef93541237834445eb7ff355e7d4139d48844f9c977a485dea1316df54994473 1988020 freetype_2.11.1+dfsg.orig.tar.xz
 69caaa67d8b25fdc5b2d7ebc12279b47cbde6001be58bf60542d9e55d1d427e1 41920 freetype_2.11.1+dfsg-1ubuntu0.2.debian.tar.xz
Files:
 9efff227779626d46c3d7334712c15a3 257240 freetype_2.11.1+dfsg.orig-ft2demos.tar.xz
 61361df6b1e2ecb98143e9ab0f7be37f 195 freetype_2.11.1+dfsg.orig-ft2demos.tar.xz.asc
 37a74ce8cd1bf3736f77c7074a4f5052 2038348 freetype_2.11.1+dfsg.orig-ft2docs.tar.xz
 5b90f7e541f278a7279d2776a484b467 195 freetype_2.11.1+dfsg.orig-ft2docs.tar.xz.asc
 6b8bb8e8cd45ee520793dab35c92cb5b 1988020 freetype_2.11.1+dfsg.orig.tar.xz
 dae95a765a647d1547e5509c4e54a9b9 41920 freetype_2.11.1+dfsg-1ubuntu0.2.debian.tar.xz
Original-Maintainer: Hugh McMaster <hugh.mcmaster@outlook.com>

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEf+ebRFcoyOoAQoOeRbznW4QLH2kFAmRRCswACgkQRbznW4QL
H2lYuw//Y6EPsa7HCU+GNC2aYxXZxixvBHA8ejavkEDSwNcRSYN/5Co7hGpU45KR
/R9vEu+IETEesO5H+3ZgmCRPOemFrw98g+S3Ne/HwqVQCVSObXUufrCi9h2vZANb
P+MiDf93tHHLWF2Sf63Uq3kyTdEb4Zekndp1w5JjRp9ZK6ocmaOIB4JPmla1DddX
VHTDTshr4Xw16E5oMX4Me1RhNVI/FDhaearZlX4ylLT68KyoDJfufvt3c+y+P58O
GAgAkZ5vcltTNtsCoZQ4JwizhZ7Z7K9jrAwZ/CxnPvMW9qjmW5vGrQyPJiV24LXi
Q3z0iax5L0ltQ+zFuRhjgLClYwuQUF00fC2pcORDJrsPqvaZ2DEiw0MrdDgx3ABH
wCrNrwtgEu3Q30mMOzyz+ZHhZU1bK+4xUj0gKido6uZ9S6eeSfi0dvvCSSFNjdZF
1bn3Ua+iokYYptuyU44lhZvZge0QQpTSqflQXNvB5gIe5syDTdr+QVKXY+u/Klv4
nfshEHN9Y9ieBfZiidd7LlWyG6ZZYtsJ8HC8UNgO8q/mfYrNWsfGLnJ4dzoqUGl5
tkKc6SAbdwRnfD5EuqfYuSVOdbeGBeItZ8MuWcVsdVFU71ZkIMp8IGfpPCtJPaKa
r+AWVdbzko5of4Sj6vlC+nFq5e+LEcheU97AKaB200F5IGoPYUg=
=XMtn
-----END PGP SIGNATURE-----
