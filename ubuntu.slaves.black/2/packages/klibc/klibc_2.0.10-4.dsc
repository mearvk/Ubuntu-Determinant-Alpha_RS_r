-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: klibc
Binary: libklibc-dev, libklibc, klibc-utils
Architecture: linux-any
Version: 2.0.10-4
Maintainer: Debian Kernel Team <debian-kernel@lists.debian.org>
Uploaders: Ben Hutchings <benh@debian.org>, maximilian attems <maks@debian.org>
Homepage: https://git.kernel.org/cgit/libs/klibc/klibc.git
Standards-Version: 4.1.2
Vcs-Browser: https://salsa.debian.org/kernel-team/klibc
Vcs-Git: https://salsa.debian.org/kernel-team/klibc.git
Testsuite: autopkgtest
Testsuite-Triggers: build-essential
Build-Depends: debhelper-compat (= 12), linux-libc-dev, m4 [sparc]
Package-List:
 klibc-utils deb libs optional arch=linux-any
 libklibc deb libs optional arch=linux-any
 libklibc-dev deb libdevel optional arch=linux-any
Checksums-Sha1:
 4ae82c63fc83c49c8742c02dc372fb41bec7efe9 474068 klibc_2.0.10.orig.tar.xz
 1f3b90bb4d20057382a89f691544ffc7f126fa69 20664 klibc_2.0.10-4.debian.tar.xz
Checksums-Sha256:
 662753da8889e744dfc0db6eb4021c3377ee7ef8ed66d7d57765f8c9e25939cd 474068 klibc_2.0.10.orig.tar.xz
 2067c712a109704a15b5ac1528ab26a8b68fee1e4d65d2af469b62ef8d5c38ba 20664 klibc_2.0.10-4.debian.tar.xz
Files:
 59289d3af07cecaf18888d1692d164eb 474068 klibc_2.0.10.orig.tar.xz
 166cb0dd14fbae9288c1b207c568f23c 20664 klibc_2.0.10-4.debian.tar.xz

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmH3IWYACgkQ57/I7JWG
EQmCOxAApmRmwJojckwe9zIZq1vqr8epLTNSCigfJiXkQ3thDkr+belUd9PE1UDi
ECToLSRdSYRrc5zGj62p8DH+u4Db+MF1VVa/ViQTC88wyXBN0tr4wFKu0j2ndOh7
oupKgVtJ6UBs6LWVCXABLGrSEC8sW0MrhykK3/u7XFwx31r36B2qBPke8tMsWcja
Fv/TAnwPgpT4wYh6epioXAhIdfs5lCQrGv7XeSt2YWT2DrH5r/oLY41aNqjL5/Kh
oUc2WojQfjrdsMS1af1pSZO22DYqzZXgH+R1hLRmLDwoewpoPDblnIlcpDqqX7fa
SiLWmMdAmBH3rSQFtomFpRhR30oXdtRVRcL3oBhSHz0iqqCYVcbg55lu6eC12MY0
2gmECA+pbQ29N2r5shQTVahRWIAJJyzjZS3PO7VWcpBEHTFgdOdH9SwK+ZLQCCoF
G4IKgOdgpEd6LRysRtIQNiYicKL57MryvL//87KPNG5qG9cNzB54X3pT4lfRCI+S
5Iyf8r3oaQOjtaU9f9HyvQVgTxqpim1mpS9LG4PY1ZeXKXYVZF587dt4Rzu/dl5v
CYSPa2tuW0YNM3MxwWqWV9vXqIHuayI8UmUMMNr7x09B0hmntnxnauFVRlCFFgVq
o4UFWaRXm2oEI6aCM2UGAmKPA9oDJ2z/rfN1SX45HtODWP0uI2c=
=qs3s
-----END PGP SIGNATURE-----
