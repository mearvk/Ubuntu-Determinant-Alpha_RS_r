-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: icu
Binary: libicu70, libicu-dev, icu-devtools, icu-doc
Architecture: any all
Version: 70.1-2
Maintainer: Laszlo Boszormenyi (GCS) <gcs@debian.org>
Homepage: https://icu.unicode.org/
Standards-Version: 4.5.1
Testsuite: autopkgtest
Testsuite-Triggers: build-essential, pkg-config
Build-Depends: debhelper-compat (= 13), autoconf-archive, pkg-config, python3-distutils
Build-Depends-Indep: doxygen (>= 1.7.1)
Build-Conflicts: clang
Package-List:
 icu-devtools deb libdevel optional arch=any
 icu-doc deb doc optional arch=all
 libicu-dev deb libdevel optional arch=any
 libicu70 deb libs optional arch=any
Checksums-Sha1:
 f7c1363edee6be7de8b624ffbb801892b3417d4e 25449582 icu_70.1.orig.tar.gz
 426958cf39d66a4e14e5b5d3d2bae66dc54e74f1 659 icu_70.1.orig.tar.gz.asc
 1573f1b9b7fde5c19d5402b0736e3f4c5bfbf86f 62440 icu_70.1-2.debian.tar.xz
Checksums-Sha256:
 8d205428c17bf13bb535300669ed28b338a157b1c01ae66d31d0d3e2d47c3fd5 25449582 icu_70.1.orig.tar.gz
 12c17203c3fcee4f4577f8927cbf7f7eea8ab9feddd878cc84f9c4cc0741faee 659 icu_70.1.orig.tar.gz.asc
 7e0847c3775ddb8d7d3f3762d15ec171d437119c6cdb074b346cfe8502419b37 62440 icu_70.1-2.debian.tar.xz
Files:
 65287befec8116d79af23a58aa50c60d 25449582 icu_70.1.orig.tar.gz
 ce18ed454b6a633513988e015f723757 659 icu_70.1.orig.tar.gz.asc
 a074defcbb8e37337aec004cc435a800 62440 icu_70.1-2.debian.tar.xz

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEfYh9yLp7u6e4NeO63OMQ54ZMyL8FAmGDfzMACgkQ3OMQ54ZM
yL96thAAiQ+cVlGp31q7WRyhVh8Z1k/Y/FyF1DWgdp/1612cqeLRVRORhqI2GoUV
Mk7BtrTCJ1C0qCfhB7gMDeuNhFuBG/QjWMKxChbUs/Re9/jbiUXL098+S46QHw75
lJXQd7dWlVoV5K+3LlsbBksl856VgRVUME9jz5l2NsuCP5Z4vXtlCM3VZsMVnprd
cLRlWK5ZscBi3+qpy4GGM9BDU4lHYXZuFy4iS3gPwWLxjiCGSp/+g6yEyee9tZ2m
/7HOVtVgApxur5DU7UHKjnRazVJku7Cw1yYuuiMoSebFMft5hftGvOjLXbsESJy0
1VA6hDEi9dYkfWdtwTO3C5GRW3Vy+NT29QO+z7zlNYDs89JArHqkpBwV77xruhBK
RR6zI0WJKlWbW6nQvM4dyMcPwn7mKahKCQncDZTSOcBmwZiWeUtyX4Rwqi0Ek/md
ThZ7QN51je8OFJp7sYyftwrb+OC14K4Rftc9GkxUe/yj8TUYVE5NOk/vEtpHFDEM
WTQbxogvQenA1ju0jyOOeRbVuJ9j50Z/bbEJ/+ZEC/3YC7x43JtWAkt1HsXzpyZz
kUMzqHhgf8U4Fh4isi3fPw+/+PWbXRv6DexMhs67H+2YWtBcS+1LdRr2DX0Qwvq/
u+DIbkTOBrpb1QF1ZVa8HrfIDynEY8sGzF8yJS+dA2MYsJp4lDs=
=LnBd
-----END PGP SIGNATURE-----
