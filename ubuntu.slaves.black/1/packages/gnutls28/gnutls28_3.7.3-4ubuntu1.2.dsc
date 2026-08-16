-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: gnutls28
Binary: libgnutls28-dev, libgnutls30, gnutls-bin, gnutls-doc, libgnutlsxx28, libgnutls-openssl27, libgnutls-dane0, guile-gnutls
Architecture: any all
Version: 3.7.3-4ubuntu1.2
Maintainer: Ubuntu Developers <ubuntu-devel-discuss@lists.ubuntu.com>
Uploaders:  Andreas Metzler <ametzler@debian.org>, Eric Dorland <eric@debian.org>, James Westby <jw+debian@jameswestby.net>, Simon Josefsson <simon@josefsson.org>,
Homepage: https://www.gnutls.org/
Standards-Version: 4.6.0
Vcs-Browser: https://salsa.debian.org/gnutls-team/gnutls
Vcs-Git: https://salsa.debian.org/gnutls-team/gnutls.git
Testsuite: autopkgtest
Testsuite-Triggers: build-essential, ca-certificates, datefudge, freebsd-net-tools, net-tools, openssl, softhsm2
Build-Depends: bison, ca-certificates <!nocheck>, chrpath, datefudge <!nocheck>, debhelper-compat (= 13), freebsd-net-tools [kfreebsd-i386 kfreebsd-amd64] <!nocheck>, gperf, guile-3.0-dev <!noguile>, libcmocka-dev <!nocheck>, libidn2-dev, libopts25-dev, libp11-kit-dev (>= 0.23.10), libssl-dev <!nocheck>, libtasn1-6-dev (>= 4.9), libunbound-dev (>= 1.5.10-1), libunistring-dev (>= 0.9.7), net-tools [!kfreebsd-i386 !kfreebsd-amd64] <!nocheck>, nettle-dev (>= 3.6), openssl <!nocheck>, pkg-config, python3:any, softhsm2 <!nocheck>
Build-Depends-Indep: gtk-doc-tools, texinfo (>= 4.8), texlive-latex-base, texlive-plain-generic
Build-Conflicts: libgnutls-dev
Package-List:
 gnutls-bin deb net optional arch=any
 gnutls-doc deb doc optional arch=all
 guile-gnutls deb lisp optional arch=any profile=!noguile
 libgnutls-dane0 deb libs optional arch=any
 libgnutls-openssl27 deb libs optional arch=any
 libgnutls28-dev deb libdevel optional arch=any
 libgnutls30 deb libs optional arch=any
 libgnutlsxx28 deb libs optional arch=any
Checksums-Sha1:
 552c337be97d2379ae7233ebf55e949010ef7837 6119292 gnutls28_3.7.3.orig.tar.xz
 8acbc8d130f1f19b757cfcc4c17d34118c46a4b9 833 gnutls28_3.7.3.orig.tar.xz.asc
 bcfa3484da92bb551f8b413f9025696abcec5dd5 75936 gnutls28_3.7.3-4ubuntu1.2.debian.tar.xz
Checksums-Sha256:
 fc59c43bc31ab20a6977ff083029277a31935b8355ce387b634fa433f8f6c49a 6119292 gnutls28_3.7.3.orig.tar.xz
 a2f95ac5d7dd951bddef01ec9930616dd1a5226173b3dc7896b3bed411c91d9a 833 gnutls28_3.7.3.orig.tar.xz.asc
 dc1359a25ba6c5927f16df64e394bd9df0546115b50dd237361d5aeb97ad1d0a 75936 gnutls28_3.7.3-4ubuntu1.2.debian.tar.xz
Files:
 3723d8fee66c5d45d780ca64c089ed23 6119292 gnutls28_3.7.3.orig.tar.xz
 a37f45031cf2d47b24e7d28faf9c6478 833 gnutls28_3.7.3.orig.tar.xz.asc
 6f63f9a46e826661663b319177e7e072 75936 gnutls28_3.7.3-4ubuntu1.2.debian.tar.xz
Original-Maintainer: Debian GnuTLS Maintainers <pkg-gnutls-maint@lists.alioth.debian.org>

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEUMSg3c8x5FLOsZtRZWnYVadEvpMFAmPs2O0ACgkQZWnYVadE
vpPpkQ//azg5K5ZXbAsZxWhWuRxIDGOYrncUNur/OIbM7BAfgW8H9g2se0G3dGeX
ubP0IT7Nu9rqD0LDOqL54BfjN2LrZCkBFyfaesjpu3sJPCHnwuXEWS6ypiSZ0/DX
1S1mjitO87UU0DFKCCg6m8yLPV2dDSDgHeeld9BjWV9i8PyBQ7ptHqdVxudnmnE0
ZpVuxVpqqiGG7aLX3DQUnUbrJBOrZy2xHVz/+T7uwxhxMhkbyJwptut8RFdN3P41
HAgD0AmnIVhG+eONv0Jb20luL0+e4ELKoLDN7Dabg+KBnmIuFkJ15GMEhhWf79SG
ezoisHVMvtTi/KZyj2ZWVVw9kJEQn2mGbAvWsAeZhSjXs8QDpM5GWpePyYBuLlX3
1WZpRtpybwQz0q1f6GIwEDsjduoyMa2pEuY3MteyydqB5TcMHxVXpkEe7irj0wDE
B78YThuZc7wuydE2O+WUOd4I/JP7HGzCEOHsFtLjdwWqMbLJnrUwrwwB0PHDnf9T
bUUr602nHL3t1u8hSVOooIdaUMVORMJW2Bjg7VLFwcjIBLlRTaiSuSFryaZhTt8U
jkLC7GyydschS2UDvKwC74PhO5Ay9pi3VxnIi+aDur0rsqtISm7M5aTIhC18rpky
3BdUOEuJmdbXOmxuEefLhbNRArtvvoK6KFjWk/jiam3fUf/84Xw=
=5O0y
-----END PGP SIGNATURE-----
