-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: kronosnet
Binary: libknet-dev, libknet-doc, libknet1, libnozzle-dev, libnozzle1
Architecture: linux-any kfreebsd-any all
Version: 1.23-2build1
Maintainer: Ubuntu Developers <ubuntu-devel-discuss@lists.ubuntu.com>
Uploaders:  Ferenc Wágner <wferi@debian.org>,
Homepage: https://kronosnet.org/
Standards-Version: 4.6.0
Vcs-Browser: https://salsa.debian.org/ha-team/kronosnet
Vcs-Git: https://salsa.debian.org/ha-team/kronosnet.git
Testsuite: autopkgtest
Testsuite-Triggers: build-essential, iproute2, libbz2-dev, liblz4-dev, liblzma-dev, liblzo2-dev, libnl-3-dev, libnl-route-3-dev, libnss3-dev, libqb-dev, libsctp-dev, libssl-dev, libzstd-dev, net-tools, pkg-config, zlib1g-dev
Build-Depends: debhelper-compat (= 12), iproute2 [linux-any], net-tools [kfreebsd-any], libnl-3-dev, libnl-route-3-dev, libqb-dev, libsctp-dev [linux-any], pkg-config, libbz2-dev, liblz4-dev, liblzma-dev, liblzo2-dev, libzstd-dev, zlib1g-dev, libnss3-dev, libnspr4-dev, libssl-dev
Build-Depends-Indep: doxygen, doxygen2man
Package-List:
 libknet-dev deb libdevel optional arch=linux-any,kfreebsd-any
 libknet-doc deb doc optional arch=all
 libknet1 deb libs optional arch=linux-any,kfreebsd-any
 libnozzle-dev deb libdevel optional arch=linux-any,kfreebsd-any
 libnozzle1 deb libs optional arch=linux-any,kfreebsd-any
Checksums-Sha1:
 a690ed2d51f4b3692a65b43353a5df49af0bbcda 474048 kronosnet_1.23.orig.tar.xz
 5c9ca943835aa2e0cc29e358179bfaf3900314d1 833 kronosnet_1.23.orig.tar.xz.asc
 60edf33744389fa4334759965442738c86ff0bb1 11552 kronosnet_1.23-2build1.debian.tar.xz
Checksums-Sha256:
 1efd0c316bde929423ab088a1b247ee0b1e2d58870a86fcdcd30b7ce4aced2a1 474048 kronosnet_1.23.orig.tar.xz
 0f48d2e1c40efd55cde363f413129f291da995e80643ab906c6cd6d03790df0e 833 kronosnet_1.23.orig.tar.xz.asc
 c0a80ce2e5d59a44dc68792116b06260bd24ddfc16085f634123da029ef51fc3 11552 kronosnet_1.23-2build1.debian.tar.xz
Files:
 6e1d38ee47ce0401645b38007f3f8f7a 474048 kronosnet_1.23.orig.tar.xz
 dcac813065c5e119426d2e31da990572 833 kronosnet_1.23.orig.tar.xz.asc
 81b2d26253c54e527c9a241b693b2c2e 11552 kronosnet_1.23-2build1.debian.tar.xz
Original-Maintainer: Debian HA Maintainers <debian-ha-maintainers@alioth-lists.debian.net>

-----BEGIN PGP SIGNATURE-----

iQJHBAEBCgAxFiEET7WIqEwt3nmnTHeHb6RY3R2wP3EFAmI8XxwTHGp1bGlhbmtA
dWJ1bnR1LmNvbQAKCRBvpFjdHbA/cWkQD/9cLSqTqKXyT43FEq6a+nRr7M4SStrp
yMvntI/sd/9Gx8WsEqLv/W6CUu2p1vfBictaXMbFBzfXGUuNvX6Rcq+5zrz74gTp
AxrePyCSElZtNW6yizp8AQ15yS09dkMSZZZys5qtcuhPZSnsTcFsnONXm8h3SIm4
Y2Sy3/b4fo6rtFRbOZmLVBk5BgJmeMtdAY2ZsM1ziiKMa1S9joR703+gL+Sw1QKJ
hWH1gusiVwDqCqK0GxDg5Nf88qh3HEemH0TKROe6iHc7wc5kAIF9sV9S3adYfbo8
bkJg0To05d6aQ6I2hDUBbK5Rg5aGqNMf7oH6J2zY7lfzNtCsGCyCD6VklCNWCUZ0
AVBa1GH23lCLDu9yefwvkKHjhdVnpmfLsz8lL50PuAlunyPb67PhpCAJJ90tQWfT
jK9hxm3vyWgi3DjMEgAv1iLzp1pTOcHGLhrd9Nkmo1vZ8bNlwfIyLBuV6GsdEE0D
XvrWLcz4K0cSmeMvbQxgUEytNrfOac1JQ3cNhcICR5ydMK2FFoPBNZRuVS4nY8st
Ia2oBcsH29Xi/lVLsLFtL21Wa+/sj8iA3p5VYwspA0PQJ4ddcagfzlApmFzlSrb1
wbVhyDT0C1Xl7soOjB5fsJNSGCFpBMAdFhy3ARdjrBXZ62bBBYcv7wWJAd5xgL+B
SI68G639Ungy2Q==
=Hw54
-----END PGP SIGNATURE-----
