-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: fuse
Binary: fuse, libfuse2, libfuse-dev, fuse-udeb, libfuse2-udeb
Architecture: linux-any kfreebsd-any
Version: 2.9.9-5ubuntu3
Maintainer: Ubuntu Developers <ubuntu-devel-discuss@lists.ubuntu.com>
Homepage: https://github.com/libfuse/libfuse/wiki
Standards-Version: 4.4.0
Build-Depends: debhelper-compat (= 11), libselinux-dev [linux-any], gettext
Package-List:
 fuse deb utils optional arch=linux-any
 fuse-udeb udeb debian-installer optional arch=linux-any profile=!noudeb
 libfuse-dev deb libdevel optional arch=linux-any,kfreebsd-any
 libfuse2 deb libs optional arch=linux-any,kfreebsd-any
 libfuse2-udeb udeb debian-installer optional arch=linux-any,kfreebsd-any
Checksums-Sha1:
 943ba651b14bc4a3c6fd959ed4b8c04f4a59032d 1813177 fuse_2.9.9.orig.tar.gz
 b5d3a07106bfd03de062f39f12c96fb1d22f7cb3 1012 fuse_2.9.9.orig.tar.gz.asc
 89f9f050ef237c2622cc81389c5bb2a17ef42ca6 23696 fuse_2.9.9-5ubuntu3.debian.tar.xz
Checksums-Sha256:
 d0e69d5d608cc22ff4843791ad097f554dd32540ddc9bed7638cc6fea7c1b4b5 1813177 fuse_2.9.9.orig.tar.gz
 2306ebb33ecc560701f1b569cff3b1cee3dd1c02b46462a9f2c5ba0e5c263a51 1012 fuse_2.9.9.orig.tar.gz.asc
 15c760975260d868081f2c447937d663e78df28d75ce97da8516478c034a91cc 23696 fuse_2.9.9-5ubuntu3.debian.tar.xz
Files:
 8000410aadc9231fd48495f7642f3312 1813177 fuse_2.9.9.orig.tar.gz
 8e617f77c41a15537bcb5094eb11a9de 1012 fuse_2.9.9.orig.tar.gz.asc
 3ee28716645fb622329ab463e5a26b50 23696 fuse_2.9.9-5ubuntu3.debian.tar.xz
Original-Maintainer: Laszlo Boszormenyi (GCS) <gcs@debian.org>

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEqx+XcX7ftBm4bj5/AhnKGdA0MwwFAmI7JkMACgkQAhnKGdA0
MwzGcQf/fhj5DTZvvgz9lXHhJvrbR3dNjYXzECSk0HnHrfjdkPY0KKfP1Z9my0SQ
x6t+VQX/xST/qw78SBGiOMXhvbkM477/ecDRIXJXcW26egr/TXCrSxoBqZIeb8aV
aQVOudQci37j2Q8imPn5J3s2mAktPg2LWxtDBUiAIuGovvU9kzXbaumx68qT0V+5
sKPza/ya/ayqGBv53o7lyPEf0SH2qWoMs0+OyeC8qgNycK/f1yvtmkztTVeQXlKG
4RZ2SjdhNnG3TVIdwHujwONhdOkVnndnV4wnGvhM1jDeiKQJgOIteE8P8O/RhHHb
E5uQBNfzDbejLWcObyjv4cRbOY5zHQ==
=k3wH
-----END PGP SIGNATURE-----
