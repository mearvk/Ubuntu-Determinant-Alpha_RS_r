-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Format: 3.0 (quilt)
Source: snapd-glib
Binary: libsnapd-glib1, gir1.2-snapd-1, libsnapd-glib-dev, libsnapd-qt1, qml-module-snapd, libsnapd-qt-dev, snapd-glib-tests
Architecture: linux-any kfreebsd-any
Version: 1.60-0ubuntu1
Maintainer: Ubuntu Developers <ubuntu-devel-discuss@lists.ubuntu.com>
Uploaders:  Jeremy Bicha <jbicha@debian.org>, Mike Gabriel <sunweaver@debian.org>, Robert Ancell <robert.ancell@canonical.com>
Homepage: https://github.com/snapcore/snapd-glib
Standards-Version: 4.6.0
Vcs-Browser: https://salsa.debian.org/debian-ayatana-team/snapd-glib
Vcs-Git: https://salsa.debian.org/debian-ayatana-team/snapd-glib.git
Testsuite: autopkgtest
Testsuite-Triggers: gnome-desktop-testing
Build-Depends: debhelper-compat (= 13), dh-translations, gobject-introspection, gtk-doc-tools (>= 1.20), libgirepository1.0-dev, libglib2.0-dev (>= 2.46), libjson-glib-dev (>= 1.2), libsoup2.4-dev (>= 2.32), meson (>= 0.43.0), qtbase5-dev, qtdeclarative5-dev, valac
Package-List:
 gir1.2-snapd-1 deb introspection optional arch=linux-any,kfreebsd-any
 libsnapd-glib-dev deb libdevel optional arch=linux-any,kfreebsd-any
 libsnapd-glib1 deb libs optional arch=linux-any,kfreebsd-any
 libsnapd-qt-dev deb libdevel optional arch=linux-any,kfreebsd-any
 libsnapd-qt1 deb libs optional arch=linux-any,kfreebsd-any
 qml-module-snapd deb libs optional arch=linux-any,kfreebsd-any
 snapd-glib-tests deb libs optional arch=linux-any,kfreebsd-any
Checksums-Sha1:
 3c20e81bb00595ae948de2a182fa9b530449b532 183900 snapd-glib_1.60.orig.tar.xz
 7e14135b3ca86d2e86c399360ce4339db4f66960 11828 snapd-glib_1.60-0ubuntu1.debian.tar.xz
Checksums-Sha256:
 02444a74c7f5024f0b1fb62efad94c711a5a204f919108bf7a4b2eeeaaa46111 183900 snapd-glib_1.60.orig.tar.xz
 f72bb7179a95413a72ab7a7f7f86c255146781db367f30d18a8953d73318a370 11828 snapd-glib_1.60-0ubuntu1.debian.tar.xz
Files:
 f40afd4c1b9f8a124c99bac8148be85f 183900 snapd-glib_1.60.orig.tar.xz
 710c98dad1f8eb72a27f6174b5271f75 11828 snapd-glib_1.60-0ubuntu1.debian.tar.xz
Original-Maintainer: Ayatana Packagers <pkg-ayatana-devel@alioth-lists.debian.net>

-----BEGIN PGP SIGNATURE-----

iHoEARECADoWIQRJeFG11FXGBlQ/K5MY6qGJD3yILgUCYg2R3Bwccm9iZXJ0LmFu
Y2VsbEBjYW5vbmljYWwuY29tAAoJEBjqoYkPfIguUa4AoLUW84TGT/ka5G825Xe2
Fe3Xi0qPAJ0RWqYBK8a8WEPdD6VNDMyBuullIw==
=fB4N
-----END PGP SIGNATURE-----
