-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: libnfs
Binary: libnfs-dev, libnfs13, libnfs-utils
Architecture: any
Version: 4.0.0-1build2
Maintainer: Balint Reczey <rbalint@ubuntu.com>
Uploaders: Ritesh Raj Sarraf <rrs@debian.org>, Chrysostomos Nanakos <cnanakos@debian.org>
Homepage: https://github.com/sahlberg/libnfs
Standards-Version: 3.9.8
Vcs-Browser: https://salsa.debian.org/debian/libnfs
Vcs-Git: https://salsa.debian.org/debian/libnfs.git
Testsuite: autopkgtest
Testsuite-Triggers: @builddeps@, libevent-dev, libtool-bin, nfs-kernel-server, sudo, valgrind
Build-Depends: debhelper (>= 8.1.3~), dh-autoreconf, libpopt-dev
Package-List:
 libnfs-dev deb libdevel optional arch=any
 libnfs-utils deb libs optional arch=any
 libnfs13 deb libs optional arch=any
Checksums-Sha1:
 004de9e12cf726d7d5fe09b7aa47d14c3703e70f 251662 libnfs_4.0.0.orig.tar.gz
 6b35780bf85afda0d4de98d818491150b3f4a289 12016 libnfs_4.0.0-1build2.debian.tar.xz
Checksums-Sha256:
 6ee77e9fe220e2d3e3b1f53cfea04fb319828cc7dbb97dd9df09e46e901d797d 251662 libnfs_4.0.0.orig.tar.gz
 790c6af172a63dfebc5273edce56dc34d4748b1af7202a57c093c648ec10d7b6 12016 libnfs_4.0.0-1build2.debian.tar.xz
Files:
 623c6d5a4c514a9811c713effeaf68fb 251662 libnfs_4.0.0.orig.tar.gz
 e7236eb6af98cb133afe82e91d07d1b0 12016 libnfs_4.0.0-1build2.debian.tar.xz

-----BEGIN PGP SIGNATURE-----

iQJHBAEBCgAxFiEET7WIqEwt3nmnTHeHb6RY3R2wP3EFAmI8YHwTHGp1bGlhbmtA
dWJ1bnR1LmNvbQAKCRBvpFjdHbA/cU8AD/4kQq5N2wrwaqAL5NBPmCCJpARUjdx3
171oGMp9uSVEwBOdzA1cBdYD4WHvOsIm3CCXWyGOPjOciVgFOa5UU9yj6A3OBEZy
DZzTFhXkks/moGjTSP1XzEDOT8ufdRYd4rXJMSVedVk9x4/tQ0ZTnt0CPcniqaid
Rk3hyalwqPNbaYgc2EkJ9ndoK+uPklxbF8/DaFPnDAVgDdK4+NoXA2Dec8kGmgSK
wX/Wl8d9uMwLFQ2HiIvz+atqpITTfnBvpnx6BaWqmNAiLwA6+qu0/uWcvo7WZhvD
MwSmSnTfDg9pSm03+c+KzDDjbb4mrjuIj06sKJuLn6NmpD9C8forPdSf+xSoP+Nd
0bT5VcLir3mWIyCssTVfYr1afJCzGtiRWHgUdgrrRP9uQ76vqpd6Xr1+pW8PL0Yl
DrVPmm1QCWgNFQFV1nyfPfm0sOsj64RVwjoTb/R3T0sOgPYkLpk2pH49xpU8/Uag
Z/Vm165bKReKHRzXJqxQmAghZhT1VQ/5CDCJPiPUGyZp9Z0JxyVqDkQcWe3D5v+l
TJ658D7my/YBTciCfjCGsH2I9gE2WyIb8T3vJKwwMWOEBp7glD0cn4zdZzqKvKYd
kK47k9G9+kuOueEusNQH0gdsoApo/3JcnNyaHc3vmQYjHNjswiPStnCSdmnHSmWN
w1pwRDRbFQrxlg==
=TYrB
-----END PGP SIGNATURE-----
