-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: nfs-utils
Binary: nfs-kernel-server, nfs-common, libnfsidmap-dev, libnfsidmap1
Architecture: any
Version: 1:2.6.1-1ubuntu1.2
Maintainer: Ubuntu Developers <ubuntu-devel-discuss@lists.ubuntu.com>
Uploaders: Anibal Monsalve Salazar <anibal@debian.org>, Ben Hutchings <benh@debian.org>, Steve Langasek <vorlon@debian.org>, Salvatore Bonaccorso <carnil@debian.org>
Homepage: https://linux-nfs.org/
Standards-Version: 4.6.0
Vcs-Browser: https://salsa.debian.org/kernel-team/nfs-utils
Vcs-Git: https://salsa.debian.org/kernel-team/nfs-utils.git
Testsuite: autopkgtest
Testsuite-Triggers: keyutils, krb5-admin-server, krb5-kdc, krb5-user
Build-Depends: debhelper-compat (= 13), libwrap0-dev, libevent-dev, libkrb5-dev, libblkid-dev, libkeyutils-dev, pkg-config, libldap2-dev, libcap-dev, libtirpc-dev, libdevmapper-dev, libmount-dev, libsqlite3-dev, dh-apport
Package-List:
 libnfsidmap-dev deb libdevel optional arch=any
 libnfsidmap1 deb libs optional arch=any
 nfs-common deb net optional arch=any
 nfs-kernel-server deb net optional arch=any
Checksums-Sha1:
 dfeae5f73683e10c301a4aea45fcb096ef94c26c 701232 nfs-utils_2.6.1.orig.tar.xz
 95c10bcadcc302749c265afe180bc6dbe05f08a4 62564 nfs-utils_2.6.1-1ubuntu1.2.debian.tar.xz
Checksums-Sha256:
 60dfcd94a9f3d72a12bc7058d811787ec87a6d593d70da2123faf9aad3d7a1df 701232 nfs-utils_2.6.1.orig.tar.xz
 1df12ea77b87fb32a42e351cedf71c7bad20acfb94d25d554575674effbb82c4 62564 nfs-utils_2.6.1-1ubuntu1.2.debian.tar.xz
Files:
 43445a3563185963b736a7081979fd08 701232 nfs-utils_2.6.1.orig.tar.xz
 d8752ab137af90c8b5499405cfd88c53 62564 nfs-utils_2.6.1-1ubuntu1.2.debian.tar.xz
Original-Maintainer: Debian kernel team <debian-kernel@lists.debian.org>

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEiGZB1jWM2kalbBxyrJg+tb9ry6kFAmNbwIcACgkQrJg+tb9r
y6nEHxAAv8X5gvNT/P6btaYQt7bDwi1W5F4ds52202Gw5xxKVUdqzqNgQhhCSPeu
Q73EGFugm2bVcwDiygdkKwgA9wiHWEj54k3SS0/nKhxphmRZT2oMpDMyjgsr/BH6
v4W5cX3n9EdbrxDDaKjG7wnojEepY3liBAySut0feA5yZ6Gv3hLWUXTv56Sfx4Pj
DNsGuyoDU3TKhnAgLVd16CCiL+j26HOgRbQqLvU60QuE82Va+qNd1etP5TeTjf2P
iz8iByGUR7exfqvrBjfahwlNS79D5LU4UlHNFkb3oTdycHx2nxG0+/zO//xf+zdd
5iNBLdB5XGDL/AaF0IMycrlpfcZO1vWUWRjg4nYQZO3tt6Pv60M2Q1CKmFucBt/j
rtdb8KOX+amJzo/PgkzCRRL97A+H41Bl/lIXHpAbfLCcuqckXIJNxsDsQzhnWB+n
xDySDe6b/C6EYHEaocEaV3wfg4DdJu4YxeqIkiUT7aV7EreZbkqtBfWt5W9bZpir
NY1l78cv0d45zSLxrnZq+Jc4cNdl5Aq/ClfL9vFPod3vtFI0PyjVJpvj14AsNKCJ
pyLKq9seqQIMmIt9X8Zj33ljpLez8idmsBJ1ZIxIzw3II9QxDs6AfLQ+1zVuXR/l
hgqKsTLdshcrLwIPtXOqCy16OKIWAqedfDFMI2NHY5dTHfDnvKs=
=NIZ3
-----END PGP SIGNATURE-----
