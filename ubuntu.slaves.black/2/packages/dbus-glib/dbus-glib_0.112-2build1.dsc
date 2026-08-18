-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: dbus-glib
Binary: libdbus-glib-1-2, libdbus-glib-1-dev, libdbus-glib-1-dev-bin, libdbus-glib-1-doc
Architecture: any all
Version: 0.112-2build1
Maintainer: Utopia Maintenance Team <pkg-utopia-maintainers@lists.alioth.debian.org>
Uploaders:  Sjoerd Simons <sjoerd@debian.org>, Sebastian Dröge <slomo@debian.org>, Simon McVittie <smcv@debian.org>, Michael Biebl <biebl@debian.org>,
Homepage: https://www.freedesktop.org/wiki/Software/DBusBindings
Standards-Version: 4.5.1
Vcs-Browser: https://salsa.debian.org/debian/dbus-glib
Vcs-Git: https://salsa.debian.org/debian/dbus-glib.git
Testsuite: autopkgtest
Testsuite-Triggers: build-essential, dbus
Build-Depends: dbus (>= 1.8) <!nocheck>, debhelper-compat (= 12), gtk-doc-tools (>= 1.4), libdbus-1-dev (>= 1.8), libdbus-glib-1-dev-bin <cross>, libexpat-dev, libglib2.0-dev (>= 2.40)
Build-Depends-Indep: libglib2.0-doc
Package-List:
 libdbus-glib-1-2 deb oldlibs optional arch=any
 libdbus-glib-1-dev deb oldlibs optional arch=any
 libdbus-glib-1-dev-bin deb oldlibs optional arch=any
 libdbus-glib-1-doc deb doc optional arch=all profile=!nodoc
Checksums-Sha1:
 9eb81f50e36e349f57297d1a2a61b48707a551cc 715340 dbus-glib_0.112.orig.tar.gz
 718cf259649febd597fcf5bfc5324b6398e305de 833 dbus-glib_0.112.orig.tar.gz.asc
 7f009bf3ae084d965e5b89a2f74654d2f3aa2bb8 32748 dbus-glib_0.112-2build1.debian.tar.xz
Checksums-Sha256:
 7d550dccdfcd286e33895501829ed971eeb65c614e73aadb4a08aeef719b143a 715340 dbus-glib_0.112.orig.tar.gz
 649f1dff0ed50192f607d090c446ec4a2f8b39d1af1e1b34cdf7d868ebe105fe 833 dbus-glib_0.112.orig.tar.gz.asc
 ee20c44a013004b563af1ec77d9345d06fd21188a82bb2c9dab693384e996251 32748 dbus-glib_0.112-2build1.debian.tar.xz
Files:
 021e6c8a288df02c227e4aafbf7e7527 715340 dbus-glib_0.112.orig.tar.gz
 b56cec57ce507208843895c1bae3c9a7 833 dbus-glib_0.112.orig.tar.gz.asc
 bdf40ee092fb95f0939f37420e720848 32748 dbus-glib_0.112-2build1.debian.tar.xz

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEqx+XcX7ftBm4bj5/AhnKGdA0MwwFAmI7JXoACgkQAhnKGdA0
MwzkOgf+KjmIW2gjcXVg2UdhZALkgW+brDbDXEZHNeDBY1grhRWeI9zitcW4J37J
19RL6En82/WGuGdDWLzsixd4WH+n6K9l9QCKPEmbc2rtnso34LCQlySO3xd9mYsi
PorZKTphHw9XxEGMLUeTc42HqyZjTgsDlBCl3ScLu9wBaIdvCFWhrWzi+Y17y/tq
Nr0+WTQDssiTDcl4vm52b/8qzLRT71qMAn4ikpQZWMUsk6YbPDCxXaBxCuPV6KUY
kivjv2Af7WXKyUKQMlopfkmRql71BcuYa9RyTqGgYFO8ByeClqBJ5XG5+obBkmya
tgEcanQkxueJkRa7BBpTHKOP1oYGrg==
=BfmD
-----END PGP SIGNATURE-----
