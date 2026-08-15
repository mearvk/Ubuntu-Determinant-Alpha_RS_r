-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: cython
Binary: cython3, cython3-dbg, cython-doc
Architecture: any all
Version: 0.29.28-1ubuntu3
Maintainer: Ubuntu Developers <ubuntu-devel-discuss@lists.ubuntu.com>
Uploaders: Ondrej Certik <ondrej@certik.cz>, Yaroslav Halchenko <debian@onerussian.com>
Homepage: http://cython.org/
Standards-Version: 4.5.0
Vcs-Browser: https://salsa.debian.org/python-team/packages/cython
Vcs-Git: https://salsa.debian.org/python-team/packages/cython.git
Testsuite: autopkgtest
Testsuite-Triggers: python3-all, python3-all-dbg
Build-Depends: debhelper (>= 7.0.50~), dh-python, help2man, python3-all-dev, python3-all-dbg, python3-numpy [!i386] <!nocheck>, gdb <!nocheck>
Build-Depends-Indep: python3-sphinx
Package-List:
 cython-doc deb doc optional arch=all
 cython3 deb python optional arch=any
 cython3-dbg deb debug optional arch=any
Checksums-Sha1:
 0e85468d2af207c19530648cda271d27d03c6894 2081368 cython_0.29.28.orig.tar.gz
 4cb28d7663dd402c825f95be11148a671b988c3e 25988 cython_0.29.28-1ubuntu3.debian.tar.xz
Checksums-Sha256:
 d6fac2342802c30e51426828fe084ff4deb1b3387367cf98976bb2e64b6f8e45 2081368 cython_0.29.28.orig.tar.gz
 d129c9c7cd46a47b217592664d570e53c487857eac703ac309afde973498eeab 25988 cython_0.29.28-1ubuntu3.debian.tar.xz
Files:
 0e98543dca816300a27e7d76146a6280 2081368 cython_0.29.28.orig.tar.gz
 a1fa14d800a02f8c11f5da40d7999f06 25988 cython_0.29.28-1ubuntu3.debian.tar.xz
Original-Maintainer: Debian Python Team <team+python@tracker.debian.org>

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEJeP/LX9Gnb59DU5Qr8/sjmac4cIFAmIzh0YACgkQr8/sjmac
4cJx8w//bvJiq0tzyLf7iWRyvwFspwRqOCVjUkMF3PLmw3zzz7nywRRkekBCqt22
G6ot7N1Xiy1QYEUv0khBTsI/8rmmYs1lCpLdvZA08DpW/iOmOtZovOUFuy26HvZ+
1z/0DlembNnf0JvkmgQUq76Lh1xSiVnh//zqBvK9UWKdA9HIBvJ6Ui+hu7TokMKf
aPcUJCArk0wwhJXCATB18ejotYYxHT1jIwjZ9wBuyjTZJR8bwJJVNu8GBfR/u8y0
wYsMNjAY/0ixQqAaqptk/agvPOag4WtpyVCY4ZTtJ16UWD42cq8igZi8JN6aIWUm
fhbp/+wSFfPL8+3Ac1Plf4axHbuY0U4mk43QbL7oeDE5PoaQkaZxojFYK/CDzn1F
mrehHKpYwfgXkzZ4OUFu1/ngjgQh6fMCTXFwDwEcf+Lp3YnkSH5CySaLAwXhjUYR
xExj+64ZW16eQ7DDMxcUoIMpq1JCT+LgWEXEeeJZZ7v/fq2RiL6CR7/UQQy4nhEO
LTxLOhiBo4n96zV4gt3CmIW2jr224gFAfSn7of3o9y1Pm6mE44mzr+Wyn6MFmWDp
YBYBKvMsb26DsCcvUj3E7FatPHugOAXtH4vgOjSqLiibkpO/IeBGg+JVG3EMfFLz
US6+0f1t/1tPIxlEJdnoNey4N5xIfISNSUexOVw6hZP01rUhPiY=
=F7Pf
-----END PGP SIGNATURE-----
