-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: libeatmydata
Binary: eatmydata, libeatmydata1, eatmydata-udeb
Architecture: any all
Version: 130-2build1
Maintainer: Ubuntu Developers <ubuntu-devel-discuss@lists.ubuntu.com>
Homepage: https://www.flamingspork.com/projects/libeatmydata/
Standards-Version: 4.6.0
Vcs-Browser: https://salsa.debian.org/debian/libeatmydata
Vcs-Git: https://salsa.debian.org/debian/libeatmydata.git
Testsuite: autopkgtest
Testsuite-Triggers: @builddeps@
Build-Depends: debhelper-compat (= 13)
Build-Depends-Arch: dh-exec, strace [!hurd-any !kfreebsd-any] <!nocheck>
Build-Depends-Indep: dh-exec, dh-sequence-bash-completion
Package-List:
 eatmydata deb utils optional arch=all
 eatmydata-udeb udeb debian-installer optional arch=all
 libeatmydata1 deb libs optional arch=any
Checksums-Sha1:
 883381cac878ffd29c046df65513e984ec1da51b 375627 libeatmydata_130.orig.tar.gz
 6e54d488b97d824e3ac2dd706795bcad3bee6fd7 833 libeatmydata_130.orig.tar.gz.asc
 16b0ca77ff28e33f335220395e8540f7a4904c8a 15696 libeatmydata_130-2build1.debian.tar.xz
Checksums-Sha256:
 48731cd7e612ff73fd6339378fbbff38dd3bcf6c243593b0d9773ca0051541c0 375627 libeatmydata_130.orig.tar.gz
 9296d99f3f289b353c2134a065a7231aada7cea24d699d196283ce761a62c058 833 libeatmydata_130.orig.tar.gz.asc
 b9e055b4954b81e826ea05c705e86c096c9f19192c8cb959c4d2d7037a594b08 15696 libeatmydata_130-2build1.debian.tar.xz
Files:
 865fe925372f1ed46138e826dfe3c436 375627 libeatmydata_130.orig.tar.gz
 4fb9d04f77e25d7e176a268e82d5e0cd 833 libeatmydata_130.orig.tar.gz.asc
 0ff094fa6fc343c1430f9eab54927a94 15696 libeatmydata_130-2build1.debian.tar.xz
Original-Maintainer: Mattia Rizzolo <mattia@debian.org>

-----BEGIN PGP SIGNATURE-----

iQJHBAEBCgAxFiEET7WIqEwt3nmnTHeHb6RY3R2wP3EFAmI8X+4THGp1bGlhbmtA
dWJ1bnR1LmNvbQAKCRBvpFjdHbA/caydD/9gA/cT7kvBbFUsOocKEVTsHOymkOoQ
KDSEjYZ4uVp7X37zoCfl+r3kC6SuXexNnYj36jIhYUnINfGbw+dbpJvKUdCqGkT1
nlzfUzkWhQtVhkbj1ABBvJbPFjbqf2k5SBPhdC1VD+yRZxMJuZZT+RxuNtaWJxxo
UjrFDGnN6KXcFm/dYyw82DlbPvjr1gLMOlYrIPTS2iYFUbOwe957oYUNdAgPxN/I
0mbgMIC7D265lGPGJLbPSxKZDltbytZ8j9C2c13rGqi8HSwsrs42rPAnsysndA6C
1SpqycdsXzfL942Z+FhKhjUFu4VLvFx8osKY65Ryyd5ATzzgW4f1ip0N/jrLJYYM
p2wRyptIYOB2D9eKv7cHnsL17tjoDzQiUmz9mjhgITf5KxTlOWn3xHZYf0fEECw0
lEgamDzTu80QkwJsoX6z6JlFSmCBlhbtcFP6arpARyuEuDrineLYU3fN388lmrAU
VYYLNujYBUXPSpajzmFw5GA/C6dS63Bb+6A9skiN9MpWCLQbrk4fHLW6t/CuPy3I
qblaH20tBsAJln5oEd/66XKyWRXIhjfiljmK4twwjlSt1hL/bS6TuVInKlVz5ETv
fa9C4Zftvl4EKRjGq+g9/r2Sjv5PvZerzxfH9maVG+weKUrsea4qfxi+ARB/tf4U
eqU6+VVP+/rvEg==
=2MBN
-----END PGP SIGNATURE-----
