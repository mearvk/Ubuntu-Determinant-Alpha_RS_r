-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

Format: 3.0 (quilt)
Source: alsa-driver
Binary: linux-sound-base, alsa-base, alsa-base-udeb, alsa-source
Architecture: all
Version: 1.0.25+dfsg-0ubuntu7
Maintainer: Ubuntu Core Developers <ubuntu-devel@lists.ubuntu.com>
Uploaders: Jordi Mallach <jordi@debian.org>, Elimar Riesebieter <riesebie@lxtec.de>
Homepage: http://www.alsa-project.org/
Standards-Version: 3.9.2
Vcs-Bzr: http://bazaar.launchpad.net/~ubuntu-audio-dev/alsa-driver/ubuntu
Build-Depends: debhelper (>= 7), po-debconf
Build-Depends-Indep: autoconf, bzip2, cpio
Package-List:
 alsa-base deb sound optional arch=all
 alsa-base-udeb udeb debian-installer optional arch=all profile=!noudeb
 alsa-source deb kernel optional arch=all
 linux-sound-base deb sound optional arch=all
Checksums-Sha1:
 4f40148f91cb3fcc88ea198916ae5970bfe54eda 3825058 alsa-driver_1.0.25+dfsg.orig.tar.bz2
 21b81a9092f6cb36f0d22b392ced3c7b79a1f569 261976 alsa-driver_1.0.25+dfsg-0ubuntu7.debian.tar.bz2
Checksums-Sha256:
 5367f37c2228269c31ab656cbbefbaafa7e56b2bba4569b25c13f7d62649188c 3825058 alsa-driver_1.0.25+dfsg.orig.tar.bz2
 5e427a5b140aa163c8285ab3d26958db6a5d9e79a563528a2444c72e1dbe22c6 261976 alsa-driver_1.0.25+dfsg-0ubuntu7.debian.tar.bz2
Files:
 5b4349327b0d1200b0a97c58926e15a3 3825058 alsa-driver_1.0.25+dfsg.orig.tar.bz2
 0f3169e8cb9c4dd95520fb748a600f16 261976 alsa-driver_1.0.25+dfsg-0ubuntu7.debian.tar.bz2
Debian-Vcs-Browser: http://svn.debian.org/wsvn/pkg-alsa/trunk/alsa-driver/
Debian-Vcs-Svn: svn://svn.debian.org/pkg-alsa/trunk/alsa-driver
Original-Maintainer: Debian ALSA Maintainers <pkg-alsa-devel@lists.alioth.debian.org>

-----BEGIN PGP SIGNATURE-----

iQJEBAEBCAAuFiEE1WVxuIqLuvFAv2PWvX6qYHePpvUFAmAzl7sQHGRva29AdWJ1
bnR1LmNvbQAKCRC9fqpgd4+m9S+qD/4lAeUJ9TWUiTvfnepeHZZO/33LRk3uxeb/
K05FCeWii8VnelRpq2UbGxwgDmMJcUeeoOi1wirn3107BThLwBZcxUcaXI0Ec/s3
stgyeNdKTFHz9yatE2PRdv+3z1f82qvDXW/rAag2ukbdz6KFXFCMEhFcglTqF+98
cOIZALFm58ugmVPGgslogMMykcSgTKfc2VCOsOSS9vPT7CnEpQqbggnjMerhGLbh
JCc0bBeWz5IyaVVws6QfmDSdIaxXG0QSPrFrhzL3Qq2QmpBbcZWAGQtXw88JGQxl
Ibw8alT0YPL4QypTpwIcfvqy+KG8WAmiZUsXcdzYiYL0ZBLdVE5787XuoUoi9qAF
eGbYQHq5eBWT8EbdvAdKad0/fniJeXEkADSurn4lLw+kU8f7osIgYQG+BwldwcC/
6jYZHL645ElBy9EsX04JMKUK4B8PGb+cnxC84wyVTNY2HjuG0O1+6eJuk+gSAhOR
y99v/EzmyESTv9uc3Nz0JkhIpLyKT/Xq+QUDPzfde5I975MAVvPCZCVeIxepE4E5
rmthq7bF14ijlkZ8KRpK2ZZD6iY5ONljeYNZOVBmVNGFc3pk8tZSig9dVSrc1vOx
XmWrylLyYb2DO64DMJl0nHNWDEJ3SFwn11aVWQde8I+j1WfpQRRf9aS5dSkryxX8
4uhy4j506Q==
=3X+a
-----END PGP SIGNATURE-----
