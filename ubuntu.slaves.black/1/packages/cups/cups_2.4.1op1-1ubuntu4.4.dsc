-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: cups
Binary: libcups2, cups, cups-bsd, cups-client, cups-common, cups-core-drivers, cups-daemon, cups-ipp-utils, cups-ppdc, cups-server-common, libcups2-dev, libcupsimage2, libcupsimage2-dev
Architecture: any all
Version: 2.4.1op1-1ubuntu4.4
Maintainer: Ubuntu Developers <ubuntu-devel-discuss@lists.ubuntu.com>
Uploaders:  Till Kamppeter <till.kamppeter@gmail.com>, Thorsten Alteholz <debian@alteholz.de>,
Homepage: https://github.com/OpenPrinting/cups/
Standards-Version: 4.6.0
Vcs-Browser: https://salsa.debian.org/printing-team/cups
Vcs-Git: https://salsa.debian.org/printing-team/cups.git
Testsuite: autopkgtest
Build-Depends: autoconf, automake, debhelper-compat (= 13), dh-strip-nondeterminism, libavahi-client-dev, libavahi-common-dev, libdbus-1-dev, libgnutls28-dev, libkrb5-dev, libpam0g-dev, libpaper-dev, libsystemd-dev [linux-any], libtool, libusb-1.0-0-dev [!hurd-any], patch, pkg-config, po-debconf, po4a, zlib1g-dev, libapparmor-dev, libsnapd-glib-dev
Build-Depends-Arch: dh-apparmor
Build-Conflicts: libgmp-dev (<< 2:6)
Package-List:
 cups deb net optional arch=any
 cups-bsd deb net optional arch=any
 cups-client deb net optional arch=any
 cups-common deb net optional arch=all
 cups-core-drivers deb net optional arch=any
 cups-daemon deb net optional arch=any
 cups-ipp-utils deb net optional arch=any
 cups-ppdc deb utils optional arch=any
 cups-server-common deb net optional arch=all
 libcups2 deb libs optional arch=any
 libcups2-dev deb libdevel optional arch=any
 libcupsimage2 deb libs optional arch=any
 libcupsimage2-dev deb libdevel optional arch=any
Checksums-Sha1:
 9c9d37e314a25be1f1f16f32f4876195d3f08705 8113914 cups_2.4.1op1.orig.tar.gz
 5e3e0eb9a9d5248233fc06933078aee49f06fbc2 356540 cups_2.4.1op1-1ubuntu4.4.debian.tar.xz
Checksums-Sha256:
 c7339f75f8d4f2dec50c673341a45fc06b6885bb6d4366d6bf59a4e6c10ae178 8113914 cups_2.4.1op1.orig.tar.gz
 e276cb7f23ef997cdca6f9151438de14de4de7d31f2a276cf77412fae323d1d9 356540 cups_2.4.1op1-1ubuntu4.4.debian.tar.xz
Files:
 c2e5143d06f21e19ea2b73913185656f 8113914 cups_2.4.1op1.orig.tar.gz
 a8a18cb417593133d494d634ce6e8ce2 356540 cups_2.4.1op1-1ubuntu4.4.debian.tar.xz
Original-Maintainer: Debian Printing Team <debian-printing@lists.debian.org>

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEUMSg3c8x5FLOsZtRZWnYVadEvpMFAmSUNJAACgkQZWnYVadE
vpOEjRAAiX9bOTw7JRs+ZQ0EjVel/O91AZNhsJTEPRS3bQiMaKsJ/63bywAeYWwS
6MeW+fZY+GVAInIcmrhBEAMWxkJvY+fOFvdzjQrumB9Nf4siOZO8chFEdWamSr+s
rVzazLpwPJyGj66Zr9M3jufKZz7KelfBwo3I2XvMAA9I4mzaciRSgM0OWXo4M7Um
biZF8bduSWiXJgA4bc3wnb7eWPvzOo+qW24NBLHQ6JYpzDQgaeA4M6t63rkzHNmy
iGtHQ1uQtWTq2A3/QXWZUExx1QElL/b1Hx244reiZjH/Dkv9kiu3H1nTGOEPV7Bj
dWqtm34zXmphWinzZ/nxOAEplvHUR4sHV7+Zcy0QzCITFkruAZ4s1cR/fSbbUJmC
c8RDtw+xTYPZatTq7whTFD7ffChvCPsnuXgvf4P95iRCBRp40UMBAXCLxRErtxy8
OKucbnZpbBTNFTNpoNfo2PvsUa6uQUVcp29nC2/laSaAqC/1NaO9uQu6qfK8+H1V
7t3Poy4ZYBdtK6ofl6KmVY0NoAxMgFnEZn205WK8UknWzBwdr4ilphOu81qAs4Fr
gwDTcdnugh3tevw8vdrh5t5PYtWogYroqirw9LOSO0z8E7H4Jt8TRKYRiXOzgBGV
gOcgSTCSq0Ce4tuqt5okRfYH1/K+WYkskN+VuaY81GvTjx+dEEg=
=skdW
-----END PGP SIGNATURE-----
