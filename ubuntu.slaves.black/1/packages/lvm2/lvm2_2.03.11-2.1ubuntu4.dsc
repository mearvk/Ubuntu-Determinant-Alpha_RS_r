-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: lvm2
Binary: lvm2, lvm2-udeb, lvm2-dbusd, lvm2-lockd, libdevmapper-dev, libdevmapper1.02.1, libdevmapper1.02.1-udeb, dmsetup, dmsetup-udeb, libdevmapper-event1.02.1, dmeventd, liblvm2cmd2.03, liblvm2-dev
Architecture: linux-any all
Version: 2.03.11-2.1ubuntu4
Maintainer: Ubuntu Developers <ubuntu-devel-discuss@lists.ubuntu.com>
Uploaders: Bastian Blank <waldi@debian.org>
Homepage: https://sourceware.org/lvm2/
Standards-Version: 4.1.1
Vcs-Browser: https://salsa.debian.org/lvm-team/lvm2
Vcs-Git: https://salsa.debian.org/lvm-team/lvm2.git
Build-Depends: debhelper-compat (= 13), autoconf-archive, automake, libaio-dev, libblkid-dev, pkg-config, systemd, thin-provisioning-tools
Build-Depends-Arch: libcmap-dev, libcorosync-common-dev, libcpg-dev, libdlm-dev (>> 2), libdlmcontrol-dev, libedit-dev, libquorum-dev, libsanlock-dev, libselinux1-dev, libsystemd-dev, libudev-dev
Build-Depends-Indep: dh-sequence-python3, python3-dev, python3-dbus, python3-pyudev
Package-List:
 dmeventd deb admin optional arch=linux-any
 dmsetup deb admin optional arch=linux-any
 dmsetup-udeb udeb debian-installer optional arch=linux-any profile=!noudeb
 libdevmapper-dev deb libdevel optional arch=linux-any
 libdevmapper-event1.02.1 deb libs optional arch=linux-any
 libdevmapper1.02.1 deb libs optional arch=linux-any
 libdevmapper1.02.1-udeb udeb debian-installer optional arch=linux-any profile=!noudeb
 liblvm2-dev deb libdevel optional arch=linux-any
 liblvm2cmd2.03 deb libs optional arch=linux-any
 lvm2 deb admin optional arch=linux-any
 lvm2-dbusd deb admin optional arch=all
 lvm2-lockd deb admin optional arch=linux-any
 lvm2-udeb udeb debian-installer optional arch=linux-any profile=!noudeb
Checksums-Sha1:
 131a5943a49f141d67fbd75ff4d6577c884fe132 1699012 lvm2_2.03.11.orig.tar.xz
 9d736c06f2cd3434962eea3fed51f477a8cf7aee 44492 lvm2_2.03.11-2.1ubuntu4.debian.tar.xz
Checksums-Sha256:
 7ef41edc65c4b807c5667ac7e9c371016d0db2a641812b334571acc0e025d86c 1699012 lvm2_2.03.11.orig.tar.xz
 c9d33a7735602261de5361981336eb031056fb89cc1fa559349e8eb80a57d98d 44492 lvm2_2.03.11-2.1ubuntu4.debian.tar.xz
Files:
 7abb38e01b740dd7cbbe3d2aac93f1bc 1699012 lvm2_2.03.11.orig.tar.xz
 5cec62c825cbefc412200f5830145e64 44492 lvm2_2.03.11-2.1ubuntu4.debian.tar.xz
Original-Maintainer: Debian LVM Team <team+lvm@tracker.debian.org>

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEJeP/LX9Gnb59DU5Qr8/sjmac4cIFAmINLxAACgkQr8/sjmac
4cKlHRAAh30cZucv60h3AYBA/hpDTGnFakND3cYQsO8YhYqmCkwdpS14Z/5qSTyr
Np5iylc+bcn4laGUnaKTJz4bIVatsr5w+oOLPnOuUqeG8RlZOPctFMLuoaoTUwPv
f3YAeKgNI7qBqr44v8uEIuU5Oa9Cfx9hXG6aGVkT2h2KhHbSsIHmNxzBPrOB/ORg
8JMYGsBqk/svEtQvabYW4czbAgMCRCsTCzdZ2X2kXIG/JJpL0QDxupIUtJIoxwfu
ZXqJjBpSOE3wB6sYkprgVIe9WHq7Hs8B8rkHohkRSZrlNWWbhnmQnDZ0mWAM9/GQ
enWTLVrXBFwCsun21Q52eI8+22pKKTzOHXDiPDKBT9y8nk2d4SqmWGTM4dmucWOC
1V88jdXEHFfOCNxpSRg/q3O91Y65QjqGqzXuTsCUWJRWBcBIbjzfrSyigrdQ9c6x
KyeKoDt7XsrhjdqiA85NfbaYHLdllNW8B9WCkkYeNwUitIqiU0qBjSxkhPI0uuz+
88Xu5yermEbQxY6oyarlHYsPJNdRp9O0S0lQi5VEJGolkyDYhvAzScgXtquy+asm
DOmhYPS+1lKjHYPRR2oPS/O86BOu16yvA0uqOmQ3Slzl53/Z/AWE3Pyv7l6ubFzF
L641EMpsW73ghg+Fkr/hV+xZYLr+XY8TGjGPPMryXXMA9JIOXZ8=
=qzZD
-----END PGP SIGNATURE-----
