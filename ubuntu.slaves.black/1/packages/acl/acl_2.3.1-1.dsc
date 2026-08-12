-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: acl
Binary: acl, libacl1-dev, libacl1, acl-udeb, libacl1-udeb
Architecture: any
Version: 2.3.1-1
Maintainer: Guillem Jover <guillem@debian.org>
Homepage: https://savannah.nongnu.org/projects/acl/
Standards-Version: 4.5.1
Vcs-Browser: https://git.hadrons.org/cgit/debian/pkgs/acl.git
Vcs-Git: https://git.hadrons.org/git/debian/pkgs/acl.git
Testsuite: autopkgtest
Testsuite-Triggers: autoconf, automake, autopoint, build-essential, libattr1-dev, libtool, pkg-config
Build-Depends: debhelper-compat (= 13), autoconf, automake, gettext, libtool, libattr1-dev (>= 1:2.4.46-8)
Package-List:
 acl deb utils optional arch=any
 acl-udeb udeb debian-installer optional arch=any profile=!noudeb
 libacl1 deb libs optional arch=any
 libacl1-dev deb libdevel optional arch=any
 libacl1-udeb udeb debian-installer optional arch=any profile=!noudeb
Checksums-Sha1:
 0be3fb59bc12e85a660bf0d9a67ffee03284bba8 355676 acl_2.3.1.orig.tar.xz
 dee731342daa83c6a83f0cf3312e687152061f80 833 acl_2.3.1.orig.tar.xz.asc
 b3716ae967c0fd882dba9fe7b9badb2c23baeafa 27732 acl_2.3.1-1.debian.tar.xz
Checksums-Sha256:
 c0234042e17f11306c23c038b08e5e070edb7be44bef6697fb8734dcff1c66b1 355676 acl_2.3.1.orig.tar.xz
 54fb8fcd6ae6901f2257e18d503e5e18ad956babf8d80d2ea29f280fc7264662 833 acl_2.3.1.orig.tar.xz.asc
 900e8993f3a8b95e2c83fc7f530cc15b5cd165b6f517a639239f51cd60d06f2a 27732 acl_2.3.1-1.debian.tar.xz
Files:
 95ce715fe09acca7c12d3306d0f076b2 355676 acl_2.3.1.orig.tar.xz
 0bb5efccb4ecfeba55d28529a38adfb3 833 acl_2.3.1.orig.tar.xz.asc
 a732308477935be69bde4e6b38bb2b6c 27732 acl_2.3.1-1.debian.tar.xz

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEETz509DYFDBD1aWV0uXK/PqSuV6MFAmErmXcACgkQuXK/PqSu
V6Manw//aSGeNKZO/ZPoMlu5YEpuJ9dFW6otOPg3LorQ+KT66m3ukeER8kgD2Tec
fA7A//LvXbOR7eNvfDwr4NgYbCupLJfZRGmhZu+u7DED4V+9NgywPYeWN9aKwaUH
MgE96iZVQnNwUEq8Zb0JgwWfWSJ+/a5tReyL1Fk+xgM98oVp1Nz0g4zR/0xbcEvk
0Awn6Yk3rs6bGQfTD5/OLpAP6Ub/MzsZ41saVj3aNb9D8GKuTmDDuBpTkZM7ZLnO
ZfNu4TjHpEcVmVNL3aG5KqP9FOPRMEPX4CMHwphqGEzPtGwWj3L28r64xv36OHUj
K6nUU368cUU/YgH9dRLfHKILyYf69SwiCP2hxYV9LqJi4VoyHyCz5DJWiPGRR/N1
0OAvbusg/waX0IjLQRY8OH5+3mldwAMmvVzGCLjTNWunuoaC+sn+a5pB/IOzHtEY
z3gJXl/x1Cz1EGkSzGggojNqF0J/lPTYQIUZICRgiuGuewAPacimTX9KiA/fAeKi
Y6lRFgJsu2Ca+656pESHTBnOnG2Tp+NwYay4jsVQVNBE8aJifn9f+wb/M6ugHlk+
Y94Q6+1RoUuFFeBnkeKZ9Lid5319ZTU1+wmnOJNiLu01GEX3kVaF3NfLiRVvhCSg
urfr+KGY3dL4hxfKfzXnq7BOfjxvPLEH1bCf2uwNgL8MQPsuB8Q=
=eOPN
-----END PGP SIGNATURE-----
