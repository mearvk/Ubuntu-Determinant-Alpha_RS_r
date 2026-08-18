-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: aom
Binary: aom-tools, libaom3, libaom-dev, libaom-doc
Architecture: any all
Version: 3.3.0-1
Maintainer: Debian Multimedia Maintainers <debian-multimedia@lists.debian.org>
Uploaders: James Cowgill <jcowgill@debian.org>
Homepage: https://aomedia.org/
Standards-Version: 4.6.0
Vcs-Browser: https://salsa.debian.org/multimedia-team/aom
Vcs-Git: https://salsa.debian.org/multimedia-team/aom.git
Testsuite: autopkgtest
Testsuite-Triggers: bc, build-essential, ffmpeg, pkg-config
Build-Depends: cmake (>= 3.6), debhelper-compat (= 13), libyuv-dev, yasm [any-amd64 any-i386]
Build-Depends-Indep: doxygen
Package-List:
 aom-tools deb video optional arch=any
 libaom-dev deb libdevel optional arch=any
 libaom-doc deb doc optional arch=all
 libaom3 deb libs optional arch=any
Checksums-Sha1:
 c14259fb6310a01294162fc81f2850398ccf71c3 4768166 aom_3.3.0.orig.tar.gz
 262be0fcdc996aecc73b3e0cb70c541d1e2f0c9f 12196 aom_3.3.0-1.debian.tar.xz
Checksums-Sha256:
 298ced1f5aeed8f7c4e21138eeb646b19486e9c6e2d711640f4ae5822ad330c1 4768166 aom_3.3.0.orig.tar.gz
 c4a3f13a9296c8fb8946fa31dc67cac1d7aef614e6f27d6864d3a4dca67ffde2 12196 aom_3.3.0-1.debian.tar.xz
Files:
 fdc9e487a7636601ff1c8725e095ff93 4768166 aom_3.3.0.orig.tar.gz
 936e233be4f1c45bc6ff83a5aad68cde 12196 aom_3.3.0-1.debian.tar.xz

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEfncpR22H1vEdkazLwpPntGGCWs4FAmISeA0ACgkQwpPntGGC
Ws6AZQ//a3aCZjkfyaf0+Tl0okJKgpGI/1IvSMS7qzh8JbdnvtMO2Hy2Lq04UjNe
a4Su6IkH6g3givOhSy60ozJTcL6oHM8f8K1LnLkQyoAWIOjOT9w4zWLp7Rn/4alo
QWEVItZYSUKhw7yA5Rbpnz42ti67GMDPpdMF8c/GujucCAcEu0LYO0sOngD56Qj0
dvYhPNrVABBPVVplTgPttqZ6RcROc1533hwP97NmoqVtHZrguzTj4vV77ZG6i/8B
ob6h8VHA2Vodg0B9XIJfjEa7IGYSK3f5tpE4uygRsWGwaAT87LpOKmciStldUxYm
DR31JHYRAv8SC22NcQibyD6BqZjG+72Z5548h1fO0oirtdYbceYCpCBoRTzotNar
aMTRekQ7k7/E+XhOfrUp5A+QSHt+IjJtbIpo8032zkPh3dUlYT5KNGk6zz7AFvwq
LNsTHNjFOeOqQ1ddmlm0PgH2mRmcfgmLMTcpbr4q0UjhwBTDnYlYWrkrrzj48f1X
e5phvLtHoRm0+wYTZwVZzDJ9mQIS/k5RNHYuIJcV8JFJyXszQ4ogLIL69DywmcbT
a7qLY1+SI0jOB3i0fw9azchU2Ze/ycCjtCrpveDKMi2NZUjEGZvJXviy54P4Us4a
HutqmjakXlnLpfS0Xxm1t1Gp28ErEFbKjBp9exSP2nPctw5QN7A=
=kW4T
-----END PGP SIGNATURE-----
