-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: brotli
Binary: python3-brotli, brotli, libbrotli-dev, libbrotli1
Architecture: any
Version: 1.0.9-2build6
Maintainer: Tomasz Buchert <tomasz@debian.org>
Uploaders: Ondřej Surý <ondrej@debian.org>
Homepage: https://github.com/google/brotli
Standards-Version: 4.5.0
Vcs-Browser: https://salsa.debian.org/debian/brotli
Vcs-Git: https://salsa.debian.org/debian/brotli.git
Testsuite: autopkgtest
Testsuite-Triggers: python3-all
Build-Depends: cmake, debhelper (>= 13), debhelper-compat (= 13), dh-python <!nopython>, libpython3-all-dev <!nopython>, python3-all-dev:any <!nopython>, python3-setuptools <!nopython>, python3:any <!nopython>
Package-List:
 brotli deb utils optional arch=any
 libbrotli-dev deb libdevel optional arch=any
 libbrotli1 deb libs optional arch=any
 python3-brotli deb python optional arch=any profile=!nopython
Checksums-Sha1:
 ddfefdf2593b3f03eec221a7f4ceaa710e5a2e6b 486984 brotli_1.0.9.orig.tar.gz
 3438a301517102f454b7d54c8066e88dd51f5b81 5812 brotli_1.0.9-2build6.debian.tar.xz
Checksums-Sha256:
 f9e8d81d0405ba66d181529af42a3354f838c939095ff99930da6aa9cdf6fe46 486984 brotli_1.0.9.orig.tar.gz
 18bade39edd19e24c6a115b0053f84ebb909a9386c9a657ee6768b49a2af9974 5812 brotli_1.0.9-2build6.debian.tar.xz
Files:
 c2274f0c7af8470ad514637c35bcee7d 486984 brotli_1.0.9.orig.tar.gz
 6cc805bde1fe52071d6274dd722dcc51 5812 brotli_1.0.9-2build6.debian.tar.xz

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEqx+XcX7ftBm4bj5/AhnKGdA0MwwFAmI67BQACgkQAhnKGdA0
MwyvjwgAkttozFrd04plqpiu47gdstXRDS43T3HvLSXJ8BkRlQ0QsIAsVA8cXeIZ
aWWjykGeLswpNUJc1Cnpa4otW1x6JD66vNtbOAjVNJNq2lHpgHYt9kA+TXPnbvNT
n5FBPjBVuTw9sQTz7sS8LSabZCMXNxhHWFfkS4tC8Y+mqueX47yc8Xa5rS3pSE0h
0MXZsg5c744CHxkYYkoM8IDNBEjqV1wc9e9ToThA/Gs2AB+tUb3NjI66hV5YpkHH
0zjyThu86ahj9SL8x1fJ2STmqtJrCLmR4wUjzes0wZZoqr5SF3Qre4A61VVAfoTP
JmFP24VfXVU+mVqd98zP0TRAbpy+1A==
=t1EQ
-----END PGP SIGNATURE-----
