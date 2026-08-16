-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Format: 3.0 (quilt)
Source: gettext
Binary: gettext-base, gettext, gettext-el, gettext-doc, autopoint, libgettextpo0, libasprintf0v5, libgettextpo-dev, libasprintf-dev
Architecture: any all
Version: 0.21-4ubuntu4
Maintainer: Ubuntu Developers <ubuntu-devel-discuss@lists.ubuntu.com>
Homepage: https://www.gnu.org/software/gettext/
Standards-Version: 4.5.1
Build-Depends: debhelper-compat (= 13), dh-exec (>= 0.13), bison, file, help2man, xz-utils, default-jdk <!nojava>, maven-repo-helper <!nojava>, libunistring-dev, libxml2-dev, groff
Build-Depends-Indep: dh-sequence-elpa
Package-List:
 autopoint deb devel optional arch=all
 gettext deb devel optional arch=any
 gettext-base deb utils standard arch=any
 gettext-doc deb doc optional arch=all
 gettext-el deb editors optional arch=all
 libasprintf-dev deb libdevel optional arch=any
 libasprintf0v5 deb libs optional arch=any
 libgettextpo-dev deb libdevel optional arch=any
 libgettextpo0 deb libs optional arch=any
Checksums-Sha1:
 9d75b47baed1a612c0120991c4b6d9cf95e0d430 9714352 gettext_0.21.orig.tar.xz
 b56f3358813526db83269ca2b2edc233b2115d59 819 gettext_0.21.orig.tar.xz.asc
 7783e7019afc534357d8a0728bbcd6d07c1f6551 38424 gettext_0.21-4ubuntu4.debian.tar.xz
Checksums-Sha256:
 d20fcbb537e02dcf1383197ba05bd0734ef7bf5db06bdb241eb69b7d16b73192 9714352 gettext_0.21.orig.tar.xz
 d2587b13a73000e67bce860106c55b726c3e6b5bad06390d073f077334f4b5f3 819 gettext_0.21.orig.tar.xz.asc
 1e592ee18aa14c867ab2a28bbb248c270337854fd47c78f8a616b4c3b83191f6 38424 gettext_0.21-4ubuntu4.debian.tar.xz
Files:
 40996bbaf7d1356d3c22e33a8b255b31 9714352 gettext_0.21.orig.tar.xz
 532b6937f73151c0f4b2d633c9934c87 819 gettext_0.21.orig.tar.xz.asc
 83e47e131afb4435be34d97242e04e6e 38424 gettext_0.21-4ubuntu4.debian.tar.xz
Original-Maintainer: Santiago Vila <sanvila@debian.org>

-----BEGIN PGP SIGNATURE-----

iHAEARECADAWIQTgLv71TsYonmdA1hxDGjztotfSkgUCYj2aCRIcc2ViMTI4QHVi
dW50dS5jb20ACgkQQxo87aLX0pKOMgCgwgs+eGBy7gz7BjSmWycO924WpHcAnR2V
AIlcoFHiUcIMxYydA+14kfzk
=cFWR
-----END PGP SIGNATURE-----
