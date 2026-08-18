-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: iptables
Binary: iptables, libxtables12, libxtables-dev, libiptc0, libiptc-dev, libip4tc2, libip4tc-dev, libip6tc2, libip6tc-dev
Architecture: linux-any
Version: 1.8.7-1ubuntu5.1
Maintainer: Ubuntu Developers <ubuntu-devel-discuss@lists.ubuntu.com>
Uploaders: Arturo Borrero Gonzalez <arturo@debian.org>, Alberto Molina Coballes <alb.molina@gmail.com>, Laurence J. Lane <ljlane@debian.org>
Homepage: https://www.netfilter.org/
Standards-Version: 4.5.0
Vcs-Browser: https://salsa.debian.org/pkg-netfilter-team/pkg-iptables
Vcs-Git: https://salsa.debian.org/pkg-netfilter-team/pkg-iptables.git
Testsuite: autopkgtest
Build-Depends: autoconf, automake, bison, debhelper-compat (= 13), flex, libmnl-dev, libnetfilter-conntrack-dev, libnetfilter-conntrack3, libnfnetlink-dev, linuxdoc-tools, libnftnl-dev (>= 1.1.6), libtool (>= 2.2.6)
Package-List:
 iptables deb net optional arch=linux-any
 libip4tc-dev deb libdevel optional arch=linux-any
 libip4tc2 deb libs optional arch=linux-any
 libip6tc-dev deb libdevel optional arch=linux-any
 libip6tc2 deb libs optional arch=linux-any
 libiptc-dev deb libdevel optional arch=linux-any
 libiptc0 deb oldlibs optional arch=linux-any
 libxtables-dev deb libdevel optional arch=linux-any
 libxtables12 deb libs optional arch=linux-any
Checksums-Sha1:
 05ef75415cb7cb7641f51d51e74f3ea29cc31ab1 717862 iptables_1.8.7.orig.tar.bz2
 ca51e23957c3fec772b7144be0033dd76d714698 87396 iptables_1.8.7-1ubuntu5.1.debian.tar.xz
Checksums-Sha256:
 c109c96bb04998cd44156622d36f8e04b140701ec60531a10668cfdff5e8d8f0 717862 iptables_1.8.7.orig.tar.bz2
 a46b2df9e4eb0d8a1dce34f4416dc8c4a753d04e169397b30a8406330ba2945c 87396 iptables_1.8.7-1ubuntu5.1.debian.tar.xz
Files:
 602ba7e937c72fbb7b1c2b71c3b0004b 717862 iptables_1.8.7.orig.tar.bz2
 205de7517232fea0bd6ea1bfe009d208 87396 iptables_1.8.7-1ubuntu5.1.debian.tar.xz
Original-Maintainer: Debian Netfilter Packaging Team <pkg-netfilter-team@lists.alioth.debian.org>

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEiv0I09G4F7LfiYL1AaxLQINZCpgFAmRbqWcACgkQAaxLQINZ
CphzeBAAiLfvsMGcmDuJkij06NZJu6CI5NMyYjfm+keib2LI8vD+nEkybMGuUFJT
t74xIWnnweL5qaFkmSMQzl8HmqbRbbZeUSbULGdmb96N1A2pvmCdA/3g7sFfnqva
Q36Qy3gvMrqfiQ2SZrzlvk+2BUh9UHV9C0ic7AEkbh4TWXK6yndzh8YdKAEVxHDp
IFtd1jHZkDcnvok+vibg5cfLo0fynRJDT5gQ3xACSrKpPiubrAbNzrpNFcnPM8Xj
CGfzk8qgEVZg70PG+vOdi1QJajh9IWrReJXhtnp+Vu3o04U9TXieTzPhzmu5Q+87
h1OWTvb22odeGfH7YsSNVKBT1rqy57+JqAyrQ+x9heYmCk+riFobDjW2+j4gJjeX
s9g1p3/c82Vh+Hfd97amp7HWZYuIgbVsuEir55W8sjQ8w58L7qRACwIUv1nywfd/
qunQ41bviIVuZgwGlL9sYyvxxxeu67PSLsthg6T0D5QZYz88s2X1GHIZevVOjOkz
adqcZHgTDFIFJLFFVWKmp0lA9gx0X7qdKrr0+LOhMxxsrY+MwxqnHq10Nlq3XOQW
W9C9RMyrbpG03XRD5RH7B3CrSYJ8hj7qhu+6RNC1q8GT3qJ/MDymcxeD48CDj45O
cu2p3MHc1t6jIStz/EGrMPumBuyZHm5EUPmCWd3sjlP0bEwvurU=
=kCPQ
-----END PGP SIGNATURE-----
