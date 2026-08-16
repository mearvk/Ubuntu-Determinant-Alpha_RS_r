-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: fonttools
Binary: python3-fonttools, python-fonttools-doc, fonttools
Architecture: any all
Version: 4.29.1-2build1
Maintainer: Debian Fonts Task Force <debian-fonts@lists.debian.org>
Uploaders:  Luke Faraone <lfaraone@debian.org>, Yao Wei (魏銘廷) <mwei@debian.org>
Homepage: https://github.com/fonttools/fonttools
Standards-Version: 4.5.1
Vcs-Browser: https://salsa.debian.org/fonts-team/fonttools
Vcs-Git: https://salsa.debian.org/fonts-team/fonttools.git
Testsuite: autopkgtest
Testsuite-Triggers: python3-all, python3-pytest
Build-Depends: debhelper-compat (= 13), dh-python, python3-all, python3-all-dev, cython3 (>= 0.28.5), python3-brotli (>= 1.0.9) <!nocheck>, python3-pytest <!nocheck>, python3-scipy (>= 1.7.1) <!nocheck> | python3-munkres (>= 1.1.4) <!nocheck>, python3-setuptools, python3-fs (>= 2.4.11) <!nocheck>, python3-lxml (>= 4.5.0) <!nocheck>, python3-ufolib2 (>= 0.12.1) <!nocheck>, sphinx-common, unicode-data (>= 14.0.0)
Build-Depends-Indep: python3-sphinx <!nodoc>, python3-sphinx-rtd-theme <!nodoc>, python3-matplotlib <!nodoc>
Package-List:
 fonttools deb devel optional arch=all
 python-fonttools-doc deb doc optional arch=all profile=!nodoc
 python3-fonttools deb python optional arch=any
Checksums-Sha1:
 7aa024fcbc4a6dcc7efcbc47fe2dc2e7a5fce2c4 1902280 fonttools_4.29.1.orig.tar.xz
 0d285b909bdfee4fe478b811b57acef1f8901ecf 10836 fonttools_4.29.1-2build1.debian.tar.xz
Checksums-Sha256:
 c3f360d432bc96d286427cf36d9ee99039652f1f409bc42fef029a5f63094339 1902280 fonttools_4.29.1.orig.tar.xz
 588c51f28a4b09bcadca589179dc2184aed0911b351ec9045fbe1bc5cea2b495 10836 fonttools_4.29.1-2build1.debian.tar.xz
Files:
 0e02bf574c81b26a70e25cab85f3ce67 1902280 fonttools_4.29.1.orig.tar.xz
 e9f6e58e7662cc2346b384f07abe4276 10836 fonttools_4.29.1-2build1.debian.tar.xz

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEJeP/LX9Gnb59DU5Qr8/sjmac4cIFAmIyd2sACgkQr8/sjmac
4cK3KhAAtoIeNqzhrUURh/gMWAiDgPBO3zfBnFSPHHzzuwdvePnBN1SZ4pXWMDHW
aVTeIaV/04EICaxtPkHK2sJsuqypGTXOgPX9+cvX10Bv6HMp3bNi4KSG3KlrdaTk
0AoTEk2XfKvXECix9mIuSZlVx8jCNrBainunqIQJlL3gz4C4nU1iTx7LIbXXEXhR
Jddip/EJFIkS8I9wzkUQCwgLTm2uuRauhe9SqVZNG79LsgmB50BLezqLGvNaVvhI
uVxykuXCUlqSNSlW4Xae9g7CLN9hgYVfuHYmOY9o6N002/nkSDZKTgvOHE+izyDc
ma73Uj+G8LspwUjzWQwfQiR4gyL9B/hk0oxuFqi9jDCcjNOHgyPnmB0ahkowP8pq
lEkEAi3eaBiw01Ss3613Pb+qeA2YRt41IU3r7cmYOGm5o0Q4vQHZq0iJwXNJCk7k
p7jgrydcOzzkuBvHMLqQVA1B2vXASfuYm/36QqJa2lVmjOjR3t0aVBU3yWO9eocd
HDUiUJsC/LRiR16vnOfJOYqhOexIcDJPhRGlsR14SxWuC5w0cGcHaycwVEq3Cuvo
Hi/sROyrZtS7bszgzeDCJoMH7hHFR03VpjxvxohBpDOn/Q9Hm4IYg97pUYRk+W2I
7UCUOw0Ekkb5yPUwWaJBCUmEgniXquuV10a5g9iBmN8ocuyjQv8=
=3k4M
-----END PGP SIGNATURE-----
