-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Format: 3.0 (quilt)
Source: bluez
Binary: libbluetooth3, libbluetooth-dev, bluetooth, bluez, bluez-cups, bluez-obexd, bluez-meshd, bluez-hcidump, bluez-tests
Architecture: linux-any all
Version: 5.64-0ubuntu1
Maintainer: Ubuntu Bluetooth team <ubuntu-bluetooth@lists.ubuntu.com>
Uploaders: Nobuhiro Iwamatsu <iwamatsu@debian.org>
Homepage: http://www.bluez.org
Standards-Version: 3.9.6
Vcs-Browser: https://git.launchpad.net/~bluetooth/bluez
Vcs-Git: https://git.launchpad.net/~bluetooth/bluez
Testsuite: autopkgtest
Build-Depends: debhelper (>= 9.20160709), autotools-dev, dh-autoreconf, flex, bison, libdbus-glib-1-dev, libglib2.0-dev (>= 2.28), libcap-ng-dev, udev, libudev-dev, libreadline-dev, libical-dev, check (>= 0.9.8-1.1), systemd, libebook1.2-dev (>= 3.12), python3-docutils, libjson-c-dev
Package-List:
 bluetooth deb admin optional arch=all
 bluez deb admin optional arch=linux-any
 bluez-cups deb admin optional arch=linux-any
 bluez-hcidump deb admin optional arch=linux-any
 bluez-meshd deb admin optional arch=linux-any
 bluez-obexd deb admin optional arch=linux-any
 bluez-tests deb admin optional arch=linux-any
 libbluetooth-dev deb libdevel optional arch=linux-any
 libbluetooth3 deb libs optional arch=linux-any
Checksums-Sha1:
 4d8fb1328e15df4021329d3eb6329b64777badaa 2175148 bluez_5.64.orig.tar.xz
 84790eb99230f8f6bf8205c4b2114de6da9d665e 37512 bluez_5.64-0ubuntu1.debian.tar.xz
Checksums-Sha256:
 ae437e65b6b3070c198bc5b0109fe9cdeb9eaa387380e2072f9de65fe8a1de34 2175148 bluez_5.64.orig.tar.xz
 b41eba65a09528487fef9c6a2f6ebcc4db2936db8483ae0928f6cfc7bfe5463b 37512 bluez_5.64-0ubuntu1.debian.tar.xz
Files:
 d89a1c660eaf33ae360af93e3e2951bd 2175148 bluez_5.64.orig.tar.xz
 9a561ca35ad47163ec729591b5b1a478 37512 bluez_5.64-0ubuntu1.debian.tar.xz
Original-Maintainer: Debian Bluetooth Maintainers <pkg-bluetooth-maintainers@lists.alioth.debian.org>

-----BEGIN PGP SIGNATURE-----

iF0EARECAB0WIQTgLv71TsYonmdA1hxDGjztotfSkgUCYjw0twAKCRBDGjztotfS
ko6MAJ4oMM4A9FPzRpbJ70tUIgZ1iLppqQCeM+lAtHOsNEMAgfLw3ypwCA7yfXk=
=E/8l
-----END PGP SIGNATURE-----
