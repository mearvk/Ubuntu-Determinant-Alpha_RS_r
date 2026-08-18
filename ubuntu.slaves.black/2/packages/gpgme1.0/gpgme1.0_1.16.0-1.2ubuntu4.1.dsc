-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: gpgme1.0
Binary: libgpgme-dev, libgpgme11, python3-gpg, libqgpgme7, libgpgmepp6, libgpgmepp-dev, libgpgmepp-doc, gpgme-json
Architecture: any all
Version: 1.16.0-1.2ubuntu4.1
Maintainer: Ubuntu Developers <ubuntu-devel-discuss@lists.ubuntu.com>
Uploaders:  Daniel Kahn Gillmor <dkg@fifthhorseman.net>,
Homepage: https://www.gnupg.org/related_software/gpgme/
Standards-Version: 4.6.0
Vcs-Browser: https://salsa.debian.org/debian/gpgme
Vcs-Git: https://salsa.debian.org/debian/gpgme.git -b debian/sid
Testsuite: autopkgtest
Testsuite-Triggers: gcc, libc6-dev, python3-all
Build-Depends: automake (>= 1.14), debhelper-compat (= 13), dh-exec, dh-python, gnupg-agent, gnupg2 | gnupg (>= 2), gpgsm, libassuan-dev (>= 2.4.2), libgpg-error-dev (>= 1.36), libpython3-all-dev, pkg-config, python3-all-dev:any, qtbase5-dev, scdaemon, swig, texinfo
Build-Depends-Indep: doxygen, graphviz
Package-List:
 gpgme-json deb web optional arch=any
 libgpgme-dev deb libdevel optional arch=any
 libgpgme11 deb libs optional arch=any
 libgpgmepp-dev deb libdevel optional arch=any
 libgpgmepp-doc deb doc optional arch=all
 libgpgmepp6 deb libs optional arch=any
 libqgpgme7 deb libs optional arch=any
 python3-gpg deb python optional arch=any
Checksums-Sha1:
 536763b24a661538a83182ff0917469d85c6173b 1718913 gpgme1.0_1.16.0.orig.tar.bz2
 87dfefbcbdaf91a29292b7449cd22d32e91eb017 228 gpgme1.0_1.16.0.orig.tar.bz2.asc
 9f8d3b8b8c887838daad4093e68f9802295b1b8f 24796 gpgme1.0_1.16.0-1.2ubuntu4.1.debian.tar.xz
Checksums-Sha256:
 6c8cc4aedb10d5d4c905894ba1d850544619ee765606ac43df7405865de29ed0 1718913 gpgme1.0_1.16.0.orig.tar.bz2
 d362c79f9a352eb5119b94820306b27de89afbb0a6a223910e873bf86215616a 228 gpgme1.0_1.16.0.orig.tar.bz2.asc
 1dd294805e170ff5e9e1abbf92e6e5f8a571693eced1dab6705dd97302c475b3 24796 gpgme1.0_1.16.0-1.2ubuntu4.1.debian.tar.xz
Files:
 e31b9e0efc5a2e1ec1bbed22e7a082a4 1718913 gpgme1.0_1.16.0.orig.tar.bz2
 f8336eb26e01a6170087187612a25ba2 228 gpgme1.0_1.16.0.orig.tar.bz2.asc
 0c3ea56c3edcaea8452b096faa9e4e7e 24796 gpgme1.0_1.16.0-1.2ubuntu4.1.debian.tar.xz
Original-Maintainer: Debian GnuPG Maintainers <pkg-gnupg-maint@lists.alioth.debian.org>

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEpi0s+9ULm1vzYNVLFZ61xO/Id0wFAmSdtk0ACgkQFZ61xO/I
d0yrxBAAlVdPvscmmXvACrECZ6QDpOQ3lK3ETOl9YgRNIDJmTIcWNH9Jz2CgIfth
zwif734SWsEVwPbRvFPRGTTqxQbWd9DpB6WXQre5HU9t2tftPhCeep71cRVFM9F4
gOQOPMTiMGFqaA4djoBW9VhGTk2lHotEGZipTCl+eU/shRwgjtuDI/XN0eg/mnBE
+ssl3zYPkAJOeYw9VxLXfpWaHrUQruYKeMWTNC8y69WX4sYXb/GoCt0kds//6V4v
SqdIjR145f/OAmysSvQG3NHnuAQJ2lp/QpSruLlz0BTeKaXukQ6APupJau1TpEdb
wx0c5KSkqU0Lj0636YczNuX66zAnN1l1HmQVtNCrusBJRHYAjkdRP/LcY5iQAc4T
QGqhoY/7h6tdpoX8rpB8NfXiEiUmAX20vRSuf/jkILyLRHz3+xmq48OOXarzjkag
JjfoJ7BrXP2yUPVWRXmOtK5XYg/W1SN8x2FX+mWi/67YKKkl5DwIoNCPSiruRVO8
pO1pkPp2KaexQWjoIAw3cVP9CAc/AZ1Or8UGHXKZer54CIh1WZR2hIP6VreZ+Eyp
hh1cHcGlJggtImr3sb9CM6dV74lYQO9AuO/1fjgu4qWMjrGegjsxMmmfktla7clW
0oL1N21JQk/P9aLl/KAIdL+xHSU46iVLZ0A6Cl6KjWpLGKyircA=
=xu6Y
-----END PGP SIGNATURE-----
