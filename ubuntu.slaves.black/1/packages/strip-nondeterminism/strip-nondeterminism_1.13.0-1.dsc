-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: strip-nondeterminism
Binary: libfile-stripnondeterminism-perl, strip-nondeterminism, dh-strip-nondeterminism
Architecture: all
Version: 1.13.0-1
Maintainer: Reproducible builds folks <reproducible-builds@lists.alioth.debian.org>
Uploaders:  Andrew Ayer <agwa@andrewayer.name>, Holger Levsen <holger@debian.org>, Mattia Rizzolo <mattia@debian.org>, Chris Lamb <lamby@debian.org>,
Homepage: https://reproducible-builds.org/
Standards-Version: 4.6.0.1
Vcs-Browser: https://salsa.debian.org/reproducible-builds/strip-nondeterminism
Vcs-Git: https://salsa.debian.org/reproducible-builds/strip-nondeterminism.git
Testsuite: autopkgtest
Testsuite-Triggers: libarchive-cpio-perl
Build-Depends: debhelper-compat (= 13)
Build-Depends-Indep: libarchive-cpio-perl <!nocheck>, libarchive-zip-perl, libdevel-cover-perl, libsub-override-perl, perl
Package-List:
 dh-strip-nondeterminism deb devel optional arch=all
 libfile-stripnondeterminism-perl deb perl optional arch=all
 strip-nondeterminism deb devel optional arch=all
Checksums-Sha1:
 061c87ef5318ce0fc63e64e103163faefaacbacb 241215 strip-nondeterminism_1.13.0.orig.tar.bz2
 565dff8db15428eefcc84551648c486d8123c3c3 833 strip-nondeterminism_1.13.0.orig.tar.bz2.asc
 6a325ace80bacfb25dc89b44263d0dc22b1ec267 33304 strip-nondeterminism_1.13.0-1.debian.tar.xz
Checksums-Sha256:
 a70cdad5d728ea78b75d09880c4b51c7d887e89d0b610149b10cfb2abc70b4fc 241215 strip-nondeterminism_1.13.0.orig.tar.bz2
 eaadd8962fae5320f5da489da634292c40cc5f13277da092981b77959ee9bce5 833 strip-nondeterminism_1.13.0.orig.tar.bz2.asc
 cc128139301e53b1599431df3d7eac6366a76d162bd115958c5a6a655ff0283f 33304 strip-nondeterminism_1.13.0-1.debian.tar.xz
Files:
 f7a65b3eda2f7a49b199e34734c90f0e 241215 strip-nondeterminism_1.13.0.orig.tar.bz2
 43146f4fda7c5448fa86825ac2e88179 833 strip-nondeterminism_1.13.0.orig.tar.bz2.asc
 8ac27bf3c598d134fd89838ea0eef83f 33304 strip-nondeterminism_1.13.0-1.debian.tar.xz

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEuL9UE3sJ01zwJv6dCRq4VgaaqhwFAmHAvMMACgkQCRq4Vgaa
qhyt5g/+NDesKSup5+Dmt19rdUvbt5BaAQJd9EcrdJrPx/hEeUYjCSmVk5t5GyZ0
av+uoiWNy1vdby8Wq2WbH2kYKTxpEMQkNjerET6nXlaygBg4WXw02T+22vNE0ES6
Uo+d5bRVRghkGdSBqKQ7CjRiqrKJUGYgTF7a6700ktvfub6TjOQDt2y7+/XReXd5
cyAjYFnJjOmSmp1c4KNs6farHzawAStabNWwKPFfPEn0NQqLb46Pe7+/6VgTNhmi
Dt/v5wKt1Y+t56DSp3p5HQL9oPVx3NZ2yXWM9EkDV7JeaEXfddomMUo5F0Lc4pyc
93fhTdZ39rSc/nJVHy+wWnxmOnE9seb3jyNz5Ffx/C3tH8/C3r1JWWSCvQe7Z5Ft
sy0pjBv01vtJzeLGMgFzS3WODQG6NS/hjCdELnRXBx4TCg7pz7Ewy/Nawd4yg7o5
hi1w6F7zOcbRda/y0A8bTwf7qLliHjC+xJdyIpUvGg/0ISFKIwolcnsyuTOzGBGr
daeTjNHCJmyObOavmLi7PJDPUvPGKdKxiL+D6+22jiG109HEJFUt3MngA6otmY8r
7EjtT89O9M9m/KNiQvToCBrz/w59qzuUVxQtdjBtGBmHfINrb4MjIEYOKcxXETlT
cAnVe0mIoTPXaao2NmeoKX8rxrzG3Sbwye1eMfXYMv5nhP5QUjQ=
=jF75
-----END PGP SIGNATURE-----
