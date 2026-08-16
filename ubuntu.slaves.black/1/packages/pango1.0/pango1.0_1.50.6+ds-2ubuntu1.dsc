-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: pango1.0
Binary: libpango1.0-0, libpango-1.0-0, libpangocairo-1.0-0, libpangoxft-1.0-0, libpangoft2-1.0-0, libpango1.0-udeb, libpango1.0-dev, libpango1.0-doc, gir1.2-pango-1.0, pango1.0-tests, pango1.0-tools
Architecture: any all
Version: 1.50.6+ds-2ubuntu1
Maintainer: Ubuntu Developers <ubuntu-devel-discuss@lists.ubuntu.com>
Uploaders: Emilio Pozuelo Monfort <pochu@debian.org>, Iain Lane <laney@debian.org>, Jeremy Bicha <jbicha@ubuntu.com>, Laurent Bigonville <bigon@debian.org>, Martin Pitt <mpitt@debian.org>, Michael Biebl <biebl@debian.org>
Homepage: https://www.pango.org/
Standards-Version: 4.6.0
Vcs-Browser: https://salsa.debian.org/gnome-team/pango
Vcs-Git: https://salsa.debian.org/gnome-team/pango.git
Testsuite: autopkgtest
Testsuite-Triggers: build-essential, dbus, gir1.2-gdk-3.0, gnome-desktop-testing, locales, locales-all, pkg-config, python3-gi, xauth, xvfb
Build-Depends: debhelper-compat (= 13), dh-sequence-gir, dh-sequence-gnome, fonts-cantarell <!nocheck>, fonts-dejavu-core <!nocheck>, fonts-noto-color-emoji <!nocheck>, fonts-noto-core <!nocheck>, gnome-pkg-tools (>= 0.11), gobject-introspection (>= 0.9.12-4~), help2man, libcairo2-dev (>= 1.12.10), libfontconfig-dev (>= 2.13.0), libfreetype-dev (>= 2.1.7), libfribidi-dev (>= 1.0.6), libgirepository1.0-dev (>= 0.9.5), libglib2.0-dev (>= 2.62.0), libharfbuzz-dev (>= 2.6.0), libthai-dev (>= 0.1.22-3~), libx11-dev (>= 2:1.3.3-2), libxft-dev (>= 2.1.14-2), libxrender-dev (>= 1:0.9.0.2-2), libxt-dev, locales <!nocheck> | locales-all <!nocheck>, meson (>= 0.55.3), perl, pkg-config
Build-Depends-Indep: python3 (>= 3.6) <!nodoc>, python3-jinja2 <!nodoc>, python3-markdown <!nodoc>, python3-pygments <!nodoc>, python3-toml <!nodoc>, python3-typogrify <!nodoc>
Package-List:
 gir1.2-pango-1.0 deb introspection optional arch=any
 libpango-1.0-0 deb libs optional arch=any
 libpango1.0-0 deb oldlibs optional arch=any
 libpango1.0-dev deb libdevel optional arch=any
 libpango1.0-doc deb doc optional arch=all profile=!nodoc
 libpango1.0-udeb udeb debian-installer optional arch=any
 libpangocairo-1.0-0 deb libs optional arch=any
 libpangoft2-1.0-0 deb libs optional arch=any
 libpangoxft-1.0-0 deb libs optional arch=any
 pango1.0-tests deb libs optional arch=any
 pango1.0-tools deb libs optional arch=any
Checksums-Sha1:
 6956c15162ae561618256db05a9835b80bc7b82f 2673480 pango1.0_1.50.6+ds.orig.tar.xz
 b456d49af6ff75daf6117d3ea5123d47f552ad1b 51196 pango1.0_1.50.6+ds-2ubuntu1.debian.tar.xz
Checksums-Sha256:
 70f0323d6270ee12e8ae14a2959b7227088e3146801d09309558bebb1f2f9df7 2673480 pango1.0_1.50.6+ds.orig.tar.xz
 b16ad51d8b0837303fc57db029fbda8dc5d12e2fd03a1fedb647ce253a87b1f1 51196 pango1.0_1.50.6+ds-2ubuntu1.debian.tar.xz
Files:
 b345ef1f0cfade3f01db6ba7e752bbb2 2673480 pango1.0_1.50.6+ds.orig.tar.xz
 f48c8229e991c2673ef98028cf15e64c 51196 pango1.0_1.50.6+ds-2ubuntu1.debian.tar.xz
Original-Maintainer: Debian GNOME Maintainers <pkg-gnome-maintainers@lists.alioth.debian.org>

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEETQvhLw5HdtiqzpaW5mx3Wuv+bH0FAmPlIMAACgkQ5mx3Wuv+
bH0hXQ//ZBO7Ovr4PmCRvsorYmkvi01Cg77ukcz9fpAQ0VYgga2PgUhV1dGxQT+u
323QEju3AWC4gsg7jRT2HUTcYXebd6mB5DzLkGRIXK9Pwz9juJUjVLR+po1Sv5XB
Q7Tb7iTjjiECQNzVovq1uMqGrcLSODdN6y6waQb3BdCHZ+irFSHZRe2MfVkWzj1n
Sy9ozRPt8Z9Lnes5NAb7PJZ2QVIR5dLNl5qEQcmwc5YuiKy1AatN9giLhVgJ1wOb
pGopoHjt3UXHD/EZCQEpdJDgVTDWk7LbAJImd7yOuWcbeoHZfWOe1TYtkfjtW4mW
wx0uZkKxSRLf6rdHUVcfgFGrHD/D/UeArLn+wTxEqe+Xa7tkM5mdWqsx5zZWVJSk
FJO5/GkjWQVUvpCBYraMtwCDZmlm0yTs+PxtSmaAP5sPEOX9EYW/ZeAET/N/8S/g
ZmTko+9YlMoUGLA+TaQovezjvY5EL2x2MZj3whTl+uZ3dyvtsUDFP10oXg99hkp6
PAxxi9rN2XvLhsq+x6q4Jk6w/0vAGqJ2XKII+p3c0sAGVZ+lKNAk2F3rB5dkRmKq
S/LNrd+00mh+LvV+xHFp96Dpv5fgKVAptkH2d0/h2wvH/3nR21b8jgYe6B2zsXch
zBCG+4y65f7rSa5J1+zss7nv1tOe6SnO7FwTN3sAP1Ut5QCrvME=
=rhrl
-----END PGP SIGNATURE-----
