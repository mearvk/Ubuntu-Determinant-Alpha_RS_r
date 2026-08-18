-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: ndctl
Binary: ndctl, libndctl6, libndctl-dev, daxctl, libdaxctl1, libdaxctl-dev, libcxl1, libcxl-dev
Architecture: linux-any
Version: 72.1-1
Maintainer: Adam Borowski <kilobyte@angband.pl>
Homepage: https://github.com/pmem/ndctl
Standards-Version: 4.6.0
Vcs-Browser: https://github.com/kilobyte/ndctl/tree/debian
Vcs-Git: https://github.com/kilobyte/ndctl -b debian
Testsuite: autopkgtest
Build-Depends: debhelper-compat (= 13), pkg-config, libkmod-dev, libudev-dev, uuid-dev, libjson-c-dev, bash-completion, libkeyutils-dev, asciidoctor, libiniparser-dev
Package-List:
 daxctl deb misc optional arch=linux-any
 libcxl-dev deb libdevel optional arch=linux-any
 libcxl1 deb libs optional arch=linux-any
 libdaxctl-dev deb libdevel optional arch=linux-any
 libdaxctl1 deb libs optional arch=linux-any
 libndctl-dev deb libdevel optional arch=linux-any
 libndctl6 deb libs optional arch=linux-any
 ndctl deb misc optional arch=linux-any
Checksums-Sha1:
 a5004a53ab1c461dbb17a6fde9c60adaff7daaef 365324 ndctl_72.1.orig.tar.gz
 583c65a1aa4a15f5d089b3b94bf3ea2eb31213a8 9744 ndctl_72.1-1.debian.tar.xz
Checksums-Sha256:
 9059ee4b129730604cee6aba7a8bc207b6e9aa6466b6da9b3b29d1996bf3712a 365324 ndctl_72.1.orig.tar.gz
 024d7b17e942fed6b3e4f6faa29a729662bd139f743024cdce8b8412044607bd 9744 ndctl_72.1-1.debian.tar.xz
Files:
 faa0fa043dbd922d13ecb6f31b00e3b2 365324 ndctl_72.1.orig.tar.gz
 f1beeb37b610d50040e40135d0b36dea 9744 ndctl_72.1-1.debian.tar.xz

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEkjZVexcMh/iCHArDweDZLphvfH4FAmHuvZ0ACgkQweDZLphv
fH6vjRAA1XKY0o3KCHoDryHTZN0shB+5hjRZ6PLjQRoEgA/lUwUb1Cu+JQb0mX8Z
BU6TQTvvdIFAIk2R3vdjppEWutm6ajyqt3kint5IphZ+sFH538RXCK7z/Ok+pvTi
b9s5nBOVs7f7HUt1Onm+eBj2SudZMXrOyHQ1s/ILVWY9n3+eagP7iVgWKrllbWjz
gNlHyQtneHtIWFVBVgkatryWsTyVhpAAB76QVNmTKMTctPh2lMMSpRfYdFFNdavu
4dZAE8djnwCQxqXmOVTygRKFSsk0We42tw+P+4ST8+eKvEY16Rm/t3e1KtcVlVdC
CMuBuEnnWRjYUOoKQ2uUSVJcWcSCj1OwwR1IK+/OsAeuacTfZwSzyYSQYSUFMZMJ
ucuG/eGh2lWFA8/pdGRML/KediYMz1js6p6efezC0Y1gMWq6vgXsZwwOs0SFbuRw
+2waNXYUL6gjXgc/KBo4UyJS8Cx6Dhe0S49yS8DBnDr6CuljyCP9zErKDKtNHshj
Ld5Cun2pvE5MD1LdcgZQouFDufE54DMVAmmN4l06TjzUeWevkG6EYIwubQXveCAq
pYr/HvlfU1jVpmoUDW0iXzS45cy06IIu3IygKt7ey4FlhJ0FiFiiswE0es/VHg9P
lwzNqWBcnxPyOsQtBxuB37/ALcPrrYiqpH9NEiiAnAh0FecAuYY=
=/PkC
-----END PGP SIGNATURE-----
