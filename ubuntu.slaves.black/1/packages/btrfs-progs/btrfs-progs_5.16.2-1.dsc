-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: btrfs-progs
Binary: btrfs-progs, libbtrfs0, libbtrfs-dev, libbtrfsutil1, libbtrfsutil-dev, python3-btrfsutil, btrfs-progs-udeb
Architecture: linux-any
Version: 5.16.2-1
Maintainer: Adam Borowski <kilobyte@angband.pl>
Homepage: http://btrfs.wiki.kernel.org/
Standards-Version: 4.6.0
Vcs-Browser: https://salsa.debian.org/debian/btrfs-progs/tree/debian
Vcs-Git: https://salsa.debian.org/debian/btrfs-progs.git -b debian
Build-Depends: debhelper-compat (= 13), e2fslibs-dev, pkg-config, libacl1-dev, libblkid-dev, liblzo2-dev, libudev-dev, libzstd-dev, uuid-dev, udev, zlib1g-dev, asciidoctor, xmlto, bash-completion, python3-dev, python3-setuptools, dh-python
Package-List:
 btrfs-progs deb admin optional arch=linux-any
 btrfs-progs-udeb udeb debian-installer optional arch=linux-any
 libbtrfs-dev deb libdevel optional arch=linux-any
 libbtrfs0 deb libs optional arch=linux-any
 libbtrfsutil-dev deb libdevel optional arch=linux-any
 libbtrfsutil1 deb libs optional arch=linux-any
 python3-btrfsutil deb python optional arch=linux-any
Checksums-Sha1:
 3d5f94b2aeded999fb4cbbab04b91305864955d6 2334464 btrfs-progs_5.16.2.orig.tar.xz
 0a6dcf29d1a323d9ff89d289a5554c23b2a2962f 16488 btrfs-progs_5.16.2-1.debian.tar.xz
Checksums-Sha256:
 9e9b303a1d0fd9ceaaf204ee74c1c8fa1fd55794e223d9fe2bc62875ecbd53d2 2334464 btrfs-progs_5.16.2.orig.tar.xz
 bb688ad673ffd72b92448f170b7b50e20570940abe78dbda932c42690d14d6f6 16488 btrfs-progs_5.16.2-1.debian.tar.xz
Files:
 31112fa4de9b9286b2bb1a560addc0f4 2334464 btrfs-progs_5.16.2.orig.tar.xz
 33b906e3dfad8e8fbff30804c5655a4d 16488 btrfs-progs_5.16.2-1.debian.tar.xz

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEkjZVexcMh/iCHArDweDZLphvfH4FAmIYiXkACgkQweDZLphv
fH5SEBAArL1z2IBwtIfUYb3ub3jZfUaGKV5hunOfA7qeTh+Omblz27iwG6C55rlR
eYtSBqLdKfkjU8ffeczNp6ocrDOAAvLIlPqT2A+udADJdIEipqkeHMqFTtD8OooV
d9R3zfuxKjEvhTjdijITKP4Ub3sG99YSa+q38H3a/289nRNySAMeHfwlMXsyiqA/
PzRPKXTINRP28PzyJBPjFkKCt8huX+GiZzCMdDeUGO53tb0wHhaY1lJ7m2pjfBzw
hL/boy641Lfj88AZA1Zb5CoPcGn7GQtsXkhBihhk13QtdJLShOfELT+88/GYhf2I
vrPMio23+LRGOdCjTHwiwMYKhlplMCK/RymNjQ+f4IWU/fRanXZF+glRNGpf21Rn
suRPyWCTFbuJQQzrBz82MkmAbqd1Uqr4gQNdlmSA+iXcSlAFLedE0iq7tAmXBy3O
DNrYkhUqO5WMUKpkl1Yi6uIr3LZzwsc6UaMY0tPpdNH4kzHFSSNUGdEb3zrGdKfi
Ix+GXkYXAqH7jpEEy+VLeMvh3j7vicPK1BT7K4PqeLEzzY5gaxp4A8/UEatVsk/A
Fu3YVhmn+CjWUD01HHQraQ4bq0xfFE+2lrXsEOS/XN2b+hOtbUrApkotDh0LBiyP
khQP7IUReVjmK5KB4AhdnfnGzltYaAnuWLk8DpA0Od67cofYApQ=
=vgSJ
-----END PGP SIGNATURE-----
