-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: samba
Binary: samba, samba-libs, samba-common, samba-common-bin, smbclient, samba-testsuite, registry-tools, samba-dev, python3-samba, samba-dsdb-modules, samba-vfs-modules, libsmbclient, libsmbclient-dev, winbind, libpam-winbind, libnss-winbind, libwbclient0, libwbclient-dev, ctdb
Architecture: any all
Version: 2:4.15.13+dfsg-0ubuntu1.2
Maintainer: Ubuntu Developers <ubuntu-devel-discuss@lists.ubuntu.com>
Uploaders: Steve Langasek <vorlon@debian.org>, Jelmer Vernooĳ <jelmer@debian.org>, Mathieu Parent <sathieu@debian.org>, Andrew Bartlett <abartlet+debian@catalyst.net.nz>
Homepage: http://www.samba.org
Standards-Version: 4.5.0
Vcs-Browser: https://salsa.debian.org/samba-team/samba
Vcs-Git: https://salsa.debian.org/samba-team/samba.git
Testsuite: autopkgtest
Testsuite-Triggers: cifs-utils, coreutils, passwd, systemd
Build-Depends: bison, debhelper-compat (= 13), dh-exec, dh-python, docbook-xml, docbook-xsl, flex, libacl1-dev, libarchive-dev, libavahi-client-dev, libavahi-common-dev, libblkid-dev, libbsd-dev, libcap-dev [linux-any], libcephfs-dev [amd64 arm64 armel armhf mips64el mipsel ppc64el ppc64 s390x x32], libcmocka-dev (>= 1.1.3), libcups2-dev, libdbus-1-dev, libgnutls28-dev (>= 3.6.5), libglusterfs-dev [!i386], libgpgme11-dev, libicu-dev, libjansson-dev, libldap2-dev, libldb-dev (>= 2:2.4.4-0ubuntu0.22.04.2~), libncurses5-dev, libpam0g-dev, libparse-yapp-perl, libpcap-dev [hurd-i386 kfreebsd-any], libpopt-dev, librados-dev [amd64 arm64 armel armhf mips64el mipsel ppc64el ppc64 s390x x32], libreadline-dev, libsystemd-dev [linux-any], libtalloc-dev (>= 2.3.3~), libtasn1-6-dev (>= 3.8), libtasn1-bin, libtdb-dev (>= 1.4.4~), libtevent-dev (>= 0.11.0~), liburing-dev [!i386], perl, pkg-config, po-debconf, python3-dev, python3-dnspython, python3-etcd, python3-ldb (>= 2:2.4.4-0ubuntu0.22.04.2~), python3-ldb-dev (>= 2:2.4.4-0ubuntu0.22.04.2~), python3-markdown, python3-talloc-dev (>= 2.3.1~), python3-tdb (>= 1.4.3~), python3-testtools, python3, xfslibs-dev [linux-any], xsltproc, zlib1g-dev (>= 1:1.2.3)
Build-Conflicts: libtracker-miner-2.0-dev, libtracker-sparql-2.0-dev
Package-List:
 ctdb deb net optional arch=any
 libnss-winbind deb admin optional arch=any
 libpam-winbind deb admin optional arch=any
 libsmbclient deb libs optional arch=any
 libsmbclient-dev deb libdevel optional arch=any
 libwbclient-dev deb libdevel optional arch=any
 libwbclient0 deb libs optional arch=any
 python3-samba deb python optional arch=any
 registry-tools deb net optional arch=any
 samba deb net optional arch=any
 samba-common deb net optional arch=all
 samba-common-bin deb net optional arch=any
 samba-dev deb devel optional arch=any
 samba-dsdb-modules deb libs optional arch=any
 samba-libs deb libs optional arch=any
 samba-testsuite deb net optional arch=any
 samba-vfs-modules deb net optional arch=any
 smbclient deb net optional arch=any
 winbind deb net optional arch=any
Checksums-Sha1:
 82acba7a53ff569920284c04a8945f27978471b0 12237364 samba_4.15.13+dfsg.orig.tar.xz
 1addb67b23f5a5a8bc31acc8ae59fc615a44bc42 309612 samba_4.15.13+dfsg-0ubuntu1.2.debian.tar.xz
Checksums-Sha256:
 5ba26d9351ce1291251acb7efe30781a42c2d75017b349b4e3c7e15726cbc3ab 12237364 samba_4.15.13+dfsg.orig.tar.xz
 fae9a89be6c33d3f232c803750c42c2543b3d6ef90e04467a39b80ca18de1d8a 309612 samba_4.15.13+dfsg-0ubuntu1.2.debian.tar.xz
Files:
 810330932ab20c78289c2b2063357483 12237364 samba_4.15.13+dfsg.orig.tar.xz
 16ac508657890f22297aa9007e49a945 309612 samba_4.15.13+dfsg-0ubuntu1.2.debian.tar.xz
Original-Maintainer: Debian Samba Maintainers <pkg-samba-maint@lists.alioth.debian.org>

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEUMSg3c8x5FLOsZtRZWnYVadEvpMFAmStk2UACgkQZWnYVadE
vpOexg/+JtPtK2ThQj9OgKrHxooZ8MNITeXsrP1BGsa/lThQA1xtMEd6FU6nJkx5
i6WayzKeo2Ila9G/aJTv0nyJ9e4jFwpgkKdkAuVnbKfwKfXh7To9RF1Ut4gb4bnq
5wpCYF5jc5MB0tHP5o8Sy/tqE+ij8sM9BJEmzDE1TA66B/npygW0o10M8TmCJ71h
jmKQPN2CnKHlwW5iuoHO27ssy/eeV2U8/52PNqzdRahUgPy2DFV1IJ2i1oZx/pgQ
XJMf1bW9w+StA/NjZUyIUa7VcYy8lT2sNdiP36ZyIMCxfuJQ8GgjuK+RIW9oY5cs
gwl9PB2IY7MCSdUPfRqyo74J5a1TJ3sg09UVSft+SjYrmjOw765lg4exBQh2S6E9
NLsybJ0tORjsJkc9/ZaEJ5lz/+Ky62Z0Nfro59FzvY0L7jBk2cy/3Zc93Ft0o6tu
PtNhvyeLLy6AqanhkY/KGDABDbmeIgTSUBqNgHQiRNNG6+Tf0/zh8lnRy1Xpyn7T
liJA4W4qX/sC4ypw5CkDBltDFJrMhOEsYd3o/JDnP++H3n+a7AwW/4ARZgQLQ+xl
ltY+GXH9Sr3ubi0a42a2m4YJvIbfqO98V88j5Cm5MoGFR3stEZmDT6lbdpOyGDu2
CWVS3tc1QaqF2rAKd8CQkm8L22VJCRRngvKynr5vSgJrz4v/zkw=
=IqwD
-----END PGP SIGNATURE-----
