-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Format: 3.0 (quilt)
Source: libinput
Binary: libinput10, libinput-bin, libinput10-udeb, libinput-dev, libinput-tools
Architecture: any
Version: 1.20.0-1ubuntu0.3
Maintainer: Ubuntu Developers <ubuntu-devel-discuss@lists.ubuntu.com>
Uploaders: Emilio Pozuelo Monfort <pochu@debian.org>, Héctor Orón Martínez <zumbi@debian.org>
Homepage: http://www.freedesktop.org/wiki/Software/libinput/
Standards-Version: 4.5.0
Vcs-Browser: https://salsa.debian.org/xorg-team/lib/libinput
Vcs-Git: https://salsa.debian.org/xorg-team/lib/libinput.git
Testsuite: autopkgtest
Testsuite-Triggers: build-essential
Build-Depends: debhelper-compat (= 12), meson, pkg-config, check, libgtk-3-dev, libmtdev-dev (>= 1.1.0), libudev-dev, libevdev-dev (>= 1.10.0), libwacom-dev (>= 0.20)
Package-List:
 libinput-bin deb libs optional arch=any
 libinput-dev deb libdevel optional arch=any
 libinput-tools deb libdevel optional arch=any
 libinput10 deb libs optional arch=any
 libinput10-udeb udeb debian-installer optional arch=any profile=!noudeb
Checksums-Sha1:
 8120764b4594671446f213ac1a5a0c28ad2fdc9c 982547 libinput_1.20.0.orig.tar.gz
 d9b5cb096a653251f91aa06eba8b424e5d85b4d2 14200 libinput_1.20.0-1ubuntu0.3.debian.tar.xz
Checksums-Sha256:
 04d27bce1eb8387e99740e43224b0de7ea65161826d120199bf96230132e5186 982547 libinput_1.20.0.orig.tar.gz
 94164aa60751c0dd1102ebdf985cad883f11da05d34e44bb2ccd270a15d2744c 14200 libinput_1.20.0-1ubuntu0.3.debian.tar.xz
Files:
 7ab70f7df14759b4b82490d073a8cb0e 982547 libinput_1.20.0.orig.tar.gz
 3b039fdbbade7df61478c617f20fe422 14200 libinput_1.20.0-1ubuntu0.3.debian.tar.xz
Original-Maintainer: Debian X Strike Force <debian-x@lists.debian.org>

-----BEGIN PGP SIGNATURE-----

iF0EARECAB0WIQTgLv71TsYonmdA1hxDGjztotfSkgUCZIq42AAKCRBDGjztotfS
kt87AJ9lZ3j7vb5GVFER6zvH5rhCLsaSJwCdG+nKhySdzi5piy4UNYyrWTnGLq8=
=E7GA
-----END PGP SIGNATURE-----
