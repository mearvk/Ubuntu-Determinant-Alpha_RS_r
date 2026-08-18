-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: libarchive
Binary: libarchive-dev, libarchive13, libarchive-tools
Architecture: any
Version: 3.6.0-1ubuntu1
Maintainer: Ubuntu Developers <ubuntu-devel-discuss@lists.ubuntu.com>
Homepage: https://www.libarchive.org/
Standards-Version: 4.6.0
Vcs-Browser: https://salsa.debian.org/debian/libarchive
Vcs-Git: https://salsa.debian.org/debian/libarchive.git
Testsuite: autopkgtest
Testsuite-Triggers: build-essential, file, pkg-config
Build-Depends: debhelper-compat (= 13), pkg-config, libbz2-dev, liblz4-dev, liblzma-dev, libxml2-dev, libzstd-dev, zlib1g-dev, libacl1-dev [!hurd-any], libext2fs-dev, sharutils <!nocheck>, nettle-dev, locales <!nocheck> | locales-all <!nocheck>
Package-List:
 libarchive-dev deb libdevel optional arch=any
 libarchive-tools deb utils optional arch=any
 libarchive13 deb libs optional arch=any
Checksums-Sha1:
 b9aefcdd4ba117ca8c26d65040d563004ec60e19 6400620 libarchive_3.6.0.orig.tar.xz
 71c52950cfba58dc0667087a27d99219a858b41d 833 libarchive_3.6.0.orig.tar.xz.asc
 7ee77a6987f94a6599f3cfeef943d6fb465da5b8 24852 libarchive_3.6.0-1ubuntu1.debian.tar.xz
Checksums-Sha256:
 df283917799cb88659a5b33c0a598f04352d61936abcd8a48fe7b64e74950de7 6400620 libarchive_3.6.0.orig.tar.xz
 75d1524d2aba1bed0d7ad3e38807d94b595c2bbbd4a14bb860f7d4a494a12f2c 833 libarchive_3.6.0.orig.tar.xz.asc
 90a3a48997c1aaae27322325a7057c80dc5fc886d791269fc88b8eddb293c540 24852 libarchive_3.6.0-1ubuntu1.debian.tar.xz
Files:
 93f96acdb9e7277278edb154e5d76e49 6400620 libarchive_3.6.0.orig.tar.xz
 c9f88d98bf8e4bf912114b5c9031d6d7 833 libarchive_3.6.0.orig.tar.xz.asc
 9159b424064b0c7078dc49c421c021be 24852 libarchive_3.6.0-1ubuntu1.debian.tar.xz
Original-Maintainer: Peter Pentchev <roam@debian.org>

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEETQvhLw5HdtiqzpaW5mx3Wuv+bH0FAmJOy1oACgkQ5mx3Wuv+
bH10YhAA2Gi9oEjBXXiauNSZhRwdXRNXM+DItHl1ZPli1FyCWn4BdM6UVvQwPAg3
fXt9yQ85FnI2osho+2AtsuZygR/OeQUg7xxbyvNxpYD7e1dF3L6yyzTMeNAjB9jn
meb4evaQRSp6LetjmS3A4RprWDP5b/Wunnhnevv1TneuBhIEPrNV+6Qufe8ggJp4
sZlQfKd8bm1TA9/TQCsgnPhwzOVn24TbCjCtG1BEosxv3UGuN4JsWztcbuS2QNiN
e8uZ3i4cDKLSDrNMQaPmfl784sorS+UDK0EFmkhJAUKcZzMwkACrRX26LHyU+8oK
9QNhmK/mJUwkmp22HjPiZjKoGsXO7cjjWGyKmv/cgx5WbLweAOW1PUFgicxCojJa
IWW9+EpfceYVBYZ12rkcR0G3px1dLHhByNqchNiuQ0bMn9HSFX8hYz+fiJVxpNen
Od+4WJUXczEbd/X8pKu/vYfNj3oKVsdBE9SATWwJZaB9vTdq+f6Ss0+DzsiJUzON
rpa0/4VcjGHYpmd7P1+nvNCxl+VRIXvOzwNyZZw4BM2AGEjBR5z5SOazDhFMHv/2
z+asFTzvreS4dUJoE6cIHixqAx37TwkedIdSi485Jc17WTR1Nur6wDBaaoftZOio
NW8PsDmQkdoOyThJzt4ozlqYddZIzMpaYk512RUHNlARCK3PSYU=
=WZYk
-----END PGP SIGNATURE-----
