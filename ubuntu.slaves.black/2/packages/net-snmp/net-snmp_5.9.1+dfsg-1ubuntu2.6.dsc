-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: net-snmp
Binary: snmpd, snmptrapd, snmp, libsnmp-base, libsnmp40, libnetsnmptrapd40, libsnmp-dev, libsnmp-perl, tkmib
Architecture: any all
Version: 5.9.1+dfsg-1ubuntu2.6
Maintainer: Ubuntu Developers <ubuntu-devel-discuss@lists.ubuntu.com>
Uploaders: Craig Small <csmall@debian.org>, Thomas Anders <tanders@users.sourceforge.net>, Noah Meyerhans <noahm@debian.org>
Homepage: http://net-snmp.sourceforge.net/
Standards-Version: 4.6.0
Vcs-Browser: https://salsa.debian.org/debian/net-snmp
Vcs-Git: https://salsa.debian.org/debian/net-snmp.git
Testsuite: autopkgtest
Build-Depends: debhelper-compat (= 12), libtool, libwrap0-dev, libssl-dev, perl:any (>= 5.8), perl-xs-dev, autoconf, automake, debianutils (>= 1.13.1), bash (>= 2.05), findutils (>= 4.1.20), procps, pkg-config, libbsd-dev [kfreebsd-i386 kfreebsd-amd64], libkvm-dev [kfreebsd-i386 kfreebsd-amd64], libsensors4-dev [!hurd-i386 !kfreebsd-i386 !kfreebsd-amd64], default-libmysqlclient-dev, libpci-dev, dh-apport
Build-Conflicts: libsnmp-dev
Package-List:
 libnetsnmptrapd40 deb libs optional arch=any
 libsnmp-base deb libs optional arch=all
 libsnmp-dev deb libdevel optional arch=any
 libsnmp-perl deb perl optional arch=any
 libsnmp40 deb libs optional arch=any
 snmp deb net optional arch=any
 snmpd deb net optional arch=any
 snmptrapd deb net optional arch=any
 tkmib deb net optional arch=all
Checksums-Sha1:
 85fb26a4a86a7abcf2ff2a43be641553b37d9735 3557580 net-snmp_5.9.1+dfsg.orig.tar.xz
 cce4e12c5648a27164b7a59f93b2ee0a549ffadb 83436 net-snmp_5.9.1+dfsg-1ubuntu2.6.debian.tar.xz
Checksums-Sha256:
 30342c169f7494e653a766c677b0995a151ac9f887645a760e25c767a87a2c1b 3557580 net-snmp_5.9.1+dfsg.orig.tar.xz
 cf43c68522ec9844afa8bf477d97a41c1a8b0ce7858be5aa600dac1f1e181aa0 83436 net-snmp_5.9.1+dfsg-1ubuntu2.6.debian.tar.xz
Files:
 03a8c9eb42be9764bc848f0ce76b38b6 3557580 net-snmp_5.9.1+dfsg.orig.tar.xz
 1a41f0316722e9aa3c33faed03acb264 83436 net-snmp_5.9.1+dfsg-1ubuntu2.6.debian.tar.xz
Original-Maintainer: Debian SNMP Team <team+snmp@tracker.debian.org>

-----BEGIN PGP SIGNATURE-----

iQJJBAEBCgAzFiEEO+EUUxKLErUg53wTEr7aOaHncEIFAmQAm1sVHGRnYWRvbXNr
aUB1YnVudHUuY29tAAoJEBK+2jmh53BCDRoP/1iiLpz+w7/OEwP2nA1pR2+YqPmH
ZRYPB0tWkQvk3qnK00fK/fVGRW+GeIkY/7SJb4HuU2Kr4IM9frCzWUigTowFbmUH
5uGO4tf/ZujDOQu0Ul1T9AFXpCYclnFtaSDc/SHClebamL/y8fweeZZVXNt3Q1ea
3Nm3Vv4cVeIH7RmOHXUQ9I/de31gjqH1fWA80dbGY0O9og95SeiGCYB+s7fr7sj7
7H4WrUzophp8QkxLbDb9NGBxYBcNEZLYTC6BROaKlsX2Xe6XUd699oFOiLOGHWCb
a59lz6trekkpuRFnChMNUNrP6guQ98EijlKlF7awDfQZoVZ6Bg0014nT87Lrfh3C
/AFrpBI6DLAS9INnTipCvWLJ7bObq2O2OW95YAKdllRD0WVVkx/jSe6K6/CikT+B
3k4XYA4NR/3cDqfMfQA5lggLZ3pmOp1PMFuWrxOw0oKhqAkwoBC5JkHR+k7WT7U+
5KaOW12XHcaZc7B8qzPAUNRCeAl4HuxCQBCD4LsVHRWqnGX7JbCHy0C7LjT/Lw9G
/nbO/Mn0tIMdUv2Z8Lx/pvMmAgMWVZzVGa3ANui7Qqc9cIqs9ZXoKoDfftHhNQqQ
mAN3Fgq0QCTYBKrP9tgTeIOsEIEABb+T8Yp4KGQB7/1HCcpxdeKNxxYU8Myvx6SS
9/xplu/UNEApbJxy
=6A6b
-----END PGP SIGNATURE-----
