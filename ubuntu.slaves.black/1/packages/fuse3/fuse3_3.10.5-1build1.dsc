-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: fuse3
Binary: fuse3, libfuse3-3, libfuse3-dev, fuse3-udeb, libfuse3-3-udeb
Architecture: linux-any kfreebsd-any
Version: 3.10.5-1build1
Maintainer: Laszlo Boszormenyi (GCS) <gcs@debian.org>
Homepage: https://github.com/libfuse/libfuse/wiki
Standards-Version: 4.5.1
Build-Depends: debhelper-compat (= 13), pkg-config, meson, udev [linux-any], python3 <!nocheck>, python3-pytest <!nocheck>
Package-List:
 fuse3 deb utils optional arch=linux-any
 fuse3-udeb udeb debian-installer optional arch=linux-any
 libfuse3-3 deb libs optional arch=linux-any,kfreebsd-any
 libfuse3-3-udeb udeb debian-installer optional arch=linux-any,kfreebsd-any profile=!noudeb
 libfuse3-dev deb libdevel optional arch=linux-any,kfreebsd-any
Checksums-Sha1:
 13c815b03150583a75f37b5cc300804c7f8650dd 2931828 fuse3_3.10.5.orig.tar.xz
 5ee45e06d7732d21b4a1957d5f27c5ea191d562d 1012 fuse3_3.10.5.orig.tar.xz.asc
 b71928bf93bdea8521552fbe05c12c49abb0b4bb 9948 fuse3_3.10.5-1build1.debian.tar.xz
Checksums-Sha256:
 b2e283485d47404ac896dd0bb7f7ba81e1470838e677e45f659804c3a3b69666 2931828 fuse3_3.10.5.orig.tar.xz
 e1aaa953cb82ad3e74ddce4b0b115b5882dbffb6139cf48627aa8061b76d721c 1012 fuse3_3.10.5.orig.tar.xz.asc
 be6d46df56d8c4b982d414b54e2305b55bc91e1a36d5788ae7b157c2e63441ef 9948 fuse3_3.10.5-1build1.debian.tar.xz
Files:
 d2eb13af5288047dc942fc84e608cfbd 2931828 fuse3_3.10.5.orig.tar.xz
 fc6062768da3855dc296dd8d5142992f 1012 fuse3_3.10.5.orig.tar.xz.asc
 dc12987f061ca2282a4f0cd2d7085bb9 9948 fuse3_3.10.5-1build1.debian.tar.xz

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEqx+XcX7ftBm4bj5/AhnKGdA0MwwFAmI7JkwACgkQAhnKGdA0
MwzPngf9FbdVZTugxTEKfUBipLaZfWzHXuKVQYBtIV9iuOhYdn5ecSYy08niz/Kk
jFa1lM9CY32vGa9KjYlaZqYXOKy5iz9Ek6qUaJc5vGz88i4vf12OszvjFV3vPBz6
KKhB9sv3WE96gy/poJPSCN9KenpxWSXrHr1Y9XbYFF8AgnRIxrJjwAe9dMYjKing
gg58AiCnC6MDE7LxtIP6zPb+b8IUier1St8SA4+oKGaDKPtQObWae6N7KdwpCcOd
kNTNhzZYqx94JXINlAsrEOYRxCW9rJ/tQvH8HmihL2rjtaG+K81QLpr09YOZcqmS
czkQKgFSNlaRnizBBYZeh5lAsCfNYg==
=2Wy3
-----END PGP SIGNATURE-----
