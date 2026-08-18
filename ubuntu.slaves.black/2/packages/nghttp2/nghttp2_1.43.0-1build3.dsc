-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: nghttp2
Binary: libnghttp2-dev, libnghttp2-doc, libnghttp2-14, nghttp2-client, nghttp2-proxy, nghttp2-server, nghttp2
Architecture: any all
Version: 1.43.0-1build3
Maintainer: Ubuntu Developers <ubuntu-devel-discuss@lists.ubuntu.com>
Uploaders: Ondřej Surý <ondrej@debian.org>
Homepage: https://nghttp2.org/
Standards-Version: 4.5.1
Vcs-Browser: https://salsa.debian.org/debian/nghttp2
Vcs-Git: https://salsa.debian.org/debian/nghttp2.git
Testsuite: autopkgtest
Testsuite-Triggers: nginx
Build-Depends: debhelper (>= 13), debhelper-compat (= 13), dpkg-dev (>= 1.17.14), libc-ares-dev, libcunit1-dev <!nocheck>, libev-dev, libevent-dev, libjansson-dev, libjemalloc-dev [!hurd-i386], libssl-dev, libsystemd-dev, libxml2-dev, pkg-config, zlib1g-dev
Build-Depends-Indep: python3-sphinx
Package-List:
 libnghttp2-14 deb libs optional arch=any
 libnghttp2-dev deb libdevel optional arch=any
 libnghttp2-doc deb doc optional arch=all
 nghttp2 deb httpd optional arch=all
 nghttp2-client deb httpd optional arch=any
 nghttp2-proxy deb httpd optional arch=any
 nghttp2-server deb httpd optional arch=any
Checksums-Sha1:
 cf95821d4f5afe5b69911eb98fb1f4681c8c86d0 4521786 nghttp2_1.43.0.orig.tar.bz2
 48e329dc21b2949dbb21bbd46ef12ebad5636c95 16528 nghttp2_1.43.0-1build3.debian.tar.xz
Checksums-Sha256:
 556f24653397c71ebb8270b3c5e5507f0893e6eac2c6eeda6be2ecf6e1f50f62 4521786 nghttp2_1.43.0.orig.tar.bz2
 51994c95e10680151b883a0c31ab716c6b1b66677bc79a46904e7956822d988c 16528 nghttp2_1.43.0-1build3.debian.tar.xz
Files:
 d7d7d01fd9c5d30c2960ae4349e6b6b7 4521786 nghttp2_1.43.0.orig.tar.bz2
 921cf218a6bcf79764d50cac77869fbe 16528 nghttp2_1.43.0-1build3.debian.tar.xz
Original-Maintainer: Tomasz Buchert <tomasz@debian.org>

-----BEGIN PGP SIGNATURE-----

iQJHBAEBCgAxFiEET7WIqEwt3nmnTHeHb6RY3R2wP3EFAmI8mn4THGp1bGlhbmtA
dWJ1bnR1LmNvbQAKCRBvpFjdHbA/cWuzD/sGZZeHsTAsg8/eBcQc8LiYfQ3mnfEV
lbOHxRsnN642PW0+uHpT71v/lfIYvYEVxHa76jJo3iTvSPOhp2pvXkgJloRHeHO0
6PWfq1Zu4tBo29Gg31+gUYDnBApJbNJ1tkXWsa4YKumQ+kBlHIPIrybIYO3vswDM
cZ7SqqhBJEiD5Az41tXK/Y88qMK8SIFpzTe0FGdOqnC0xOY2Osh4V8iHs02hJLgJ
78rgsPoagyFn4Yv98xf7HSOz3Q65bAbXNbeGtJRp5X+y3kd39JPaIh+YhMg2eHGC
Bv2BWxJI9atU1Zi2m/1eNmDxvdahf4bk47i6Ecvd6Cj8n0YBLvB9D623qc0T8tGC
4HSEW9isOxSFORXGbR2B6q4jDR73HTOAZWLKCwSd/d3LipVQfSHT8d9Qc4Av0UcB
TXvakmIyZ4k3mEsgSs8pRDgp7Ibt6F9tlMF98DVLuUSrzxb9ILvfq4sKpvMOpK8I
SM95dnfFB3CDGv3ew3zT67sXpqq4rk580iYRCMpL8CgCc3JyAYiq2Y5dRFeY0ssQ
P8+23zTZVXO9bXC/owa+/UzHIAJM2t5XRadS46vo3vsgSpHB8MYJUx9Teulx9Q3Z
qJCVi3O7utyheSDtFyEfRGoCoKlZUaGRLljNjih0QkqRVKDsrJhGkHUbrExBeIPI
uBc5bUVbQAPL4w==
=09x3
-----END PGP SIGNATURE-----
