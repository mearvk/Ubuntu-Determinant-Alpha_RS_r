-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: libsoup3
Binary: libsoup-3.0-dev, libsoup-3.0-0, libsoup-3.0-common, libsoup-3.0-doc, gir1.2-soup-3.0, libsoup-3.0-tests
Architecture: any all
Version: 3.0.7-0ubuntu1
Maintainer: Ubuntu Developers <ubuntu-devel-discuss@lists.ubuntu.com>
Uploaders: Iain Lane <laney@debian.org>, Jeremy Bicha <jbicha@ubuntu.com>, Michael Biebl <biebl@debian.org>, Sebastien Bacher <seb128@debian.org>
Homepage: https://wiki.gnome.org/Projects/libsoup
Standards-Version: 4.6.0
Vcs-Browser: https://salsa.debian.org/gnome-team/libsoup3/tree/ubuntu/jammy
Vcs-Git: https://salsa.debian.org/gnome-team/libsoup3.git -b ubuntu/jammy
Testsuite: autopkgtest
Testsuite-Triggers: build-essential, dbus, gnome-desktop-testing, winbind, xauth, xvfb
Build-Depends: apache2 (>= 2.4) <!nocheck> <!noinsttest>, curl <!nocheck> <!noinsttest>, debhelper-compat (= 13), dh-sequence-gir, dh-sequence-gnome, glib-networking (>= 2.32.0), gtk-doc-tools, libapache2-mod-php (<< 2:9) <!nocheck> <!noinsttest>, libapache2-mod-php (>= 2:7) <!nocheck> <!noinsttest>, libbrotli-dev, libgirepository1.0-dev (>= 0.9.5), libglib2.0-dev (>= 2.69), libgnutls28-dev (>= 3.6.0) <!nocheck>, libkrb5-dev, libnghttp2-dev, libnss-myhostname [linux-any] <!nocheck>, libpsl-dev (>= 0.20), libsqlite3-dev, libsysprof-capture-4-dev [linux-any], meson (>= 0.54), php (<< 2:9) <!nocheck> <!noinsttest>, php (>= 2:7) <!nocheck> <!noinsttest>, python3-quart <!nocheck>, valac, winbind
Build-Depends-Indep: libglib2.0-doc
Package-List:
 gir1.2-soup-3.0 deb introspection optional arch=any
 libsoup-3.0-0 deb libs optional arch=any
 libsoup-3.0-common deb devel optional arch=all
 libsoup-3.0-dev deb libdevel optional arch=any
 libsoup-3.0-doc deb doc optional arch=all
 libsoup-3.0-tests deb misc optional arch=any profile=!noinsttest
Checksums-Sha1:
 815fdf0bef486dd8bb7b359a9ec6d77b3606b386 1525104 libsoup3_3.0.7.orig.tar.xz
 530b89c70c2982489115fe2e2bd14f5b3cf44e22 25536 libsoup3_3.0.7-0ubuntu1.debian.tar.xz
Checksums-Sha256:
 ebdf90cf3599c11acbb6818a9d9e3fc9d2c68e56eb829b93962972683e1bf7c8 1525104 libsoup3_3.0.7.orig.tar.xz
 41f8224a492af1f917cdf7d9284154ed2b921031b4b6f331925447fcc35410d2 25536 libsoup3_3.0.7-0ubuntu1.debian.tar.xz
Files:
 289bc07a960e32953ad1d66030803ab1 1525104 libsoup3_3.0.7.orig.tar.xz
 bdf5a790c312b6cffab260847245b7eb 25536 libsoup3_3.0.7-0ubuntu1.debian.tar.xz
Original-Maintainer: Debian GNOME Maintainers <pkg-gnome-maintainers@lists.alioth.debian.org>

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEETQvhLw5HdtiqzpaW5mx3Wuv+bH0FAmK992UACgkQ5mx3Wuv+
bH0AGw//S081C4fbDB+DVFDlPChn6V7wQgKQfZxaYOFCNyOCK1ffeXrSdNNL9pB6
4+IHSGBdySZFn73wiUVU1Jl2e8vge7++24a0W9fG/uAAJaC5fptN9zhaR58KBjgL
sTQw5+4OC6c1vGl/q5yyYG+SEwWXGX3WHHkpcUAMnsCQU2ajXiN29UBOBm4kKErn
DBZ+gOfDEvCfPE2cG0xPuRPGV8XP3pHiX575yNHOGeshYqvpdugPf2gfPUYqQN7M
bo/7ryNjeyYXnpEO0Zk69KNH2W/vLUv1Hgd06h+NFEX3XxsnP5g8f7gNOxjzSrCC
xZhiCtg8AdJPZVBFU2HcDt5rjr+2X4aYLIub2pvUTGdxrZSXOkt2wFuTRZPwaj/n
qwdGOwC6qhqyYMUKO5PNs1MbTmN1Az04l09NUtngSDCx69plhxDgk2yYwvS81KYs
A10eMUCbhwqr56a+EikpEpCDnSRLwNfc8dMbLaDOhF/foX2VSEdDR6zKCF2+5Sz8
9i5jUdgyxjXBhzECIGrG1zSVxs1mgQwrQI7/v+9oY7NeIYVDm8kqcfcI3XKNe1bE
UKbXtEL5+jGs25Im3FXg5JK+gi06Ul+gOF/jo12Xats16s7W50AAOUOFOoqvL7g7
MuxRgBV9sSIPA2qaUhfVY3AXiVCLgmXmz6KLwqcOpJu4YtabICs=
=3yg+
-----END PGP SIGNATURE-----
