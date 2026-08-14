-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: avahi
Binary: avahi-daemon, avahi-dnsconfd, avahi-autoipd, python3-avahi, avahi-utils, avahi-discover, libavahi-common3, libavahi-common-data, libavahi-common-dev, libavahi-core7, libavahi-core-dev, libavahi-client3, libavahi-client-dev, libavahi-glib1, libavahi-glib-dev, libavahi-gobject0, libavahi-gobject-dev, libavahi-compat-libdnssd1, libavahi-compat-libdnssd-dev, libavahi-ui-gtk3-0, libavahi-ui-gtk3-dev, avahi-ui-utils, gir1.2-avahi-0.6
Architecture: any all
Version: 0.8-5ubuntu5.1
Maintainer: Ubuntu Developers <ubuntu-devel-discuss@lists.ubuntu.com>
Uploaders: Sjoerd Simons <sjoerd@debian.org>, Sebastian Dröge <slomo@debian.org>, Loic Minier <lool@dooz.org>, Michael Biebl <biebl@debian.org>
Homepage: http://avahi.org/
Standards-Version: 4.5.0
Vcs-Browser: https://salsa.debian.org/utopia-team/avahi
Vcs-Git: https://salsa.debian.org/utopia-team/avahi.git
Build-Depends: debhelper-compat (= 12), dh-python, pkg-config, libcap-dev (>= 1:2.16) [linux-any], libgdbm-dev, libglib2.0-dev (>= 2.4), libgtk-3-dev <!pkg.avahi.nogui>, libexpat-dev, libdaemon-dev (>= 0.11), libdbus-1-dev (>= 0.60), python3, python3-gdbm, python3-dbus <!nopython>, python3-gi <!nopython>, python-gi-dev <!nopython>, gobject-introspection, libgirepository1.0-dev, xmltoman, intltool (>= 0.35.0)
Package-List:
 avahi-autoipd deb net optional arch=linux-any
 avahi-daemon deb net optional arch=any
 avahi-discover deb net optional arch=all profile=!nopython,!pkg.avahi.nogui
 avahi-dnsconfd deb net optional arch=any
 avahi-ui-utils deb utils optional arch=any profile=!pkg.avahi.nogui
 avahi-utils deb net optional arch=any
 gir1.2-avahi-0.6 deb introspection optional arch=any
 libavahi-client-dev deb libdevel optional arch=any
 libavahi-client3 deb libs optional arch=any
 libavahi-common-data deb libs optional arch=any
 libavahi-common-dev deb libdevel optional arch=any
 libavahi-common3 deb libs optional arch=any
 libavahi-compat-libdnssd-dev deb libdevel optional arch=any
 libavahi-compat-libdnssd1 deb libs optional arch=any
 libavahi-core-dev deb libdevel optional arch=any
 libavahi-core7 deb libs optional arch=any
 libavahi-glib-dev deb libdevel optional arch=any
 libavahi-glib1 deb libs optional arch=any
 libavahi-gobject-dev deb libdevel optional arch=any
 libavahi-gobject0 deb libs optional arch=any
 libavahi-ui-gtk3-0 deb libs optional arch=any profile=!pkg.avahi.nogui
 libavahi-ui-gtk3-dev deb libdevel optional arch=any profile=!pkg.avahi.nogui
 python3-avahi deb python optional arch=any profile=!nopython
Checksums-Sha1:
 969a50ae18c8d8e2288435a75666dd076e69852a 1591458 avahi_0.8.orig.tar.gz
 d9fa30978eb137623b1d26a700e695bd7b85bddb 40956 avahi_0.8-5ubuntu5.1.debian.tar.xz
Checksums-Sha256:
 060309d7a333d38d951bc27598c677af1796934dbd98e1024e7ad8de798fedda 1591458 avahi_0.8.orig.tar.gz
 54fdd6caf330e5d5e75b0de62ba7dabde3c24b55205b540ea87fba928d0c18c0 40956 avahi_0.8-5ubuntu5.1.debian.tar.xz
Files:
 229c6aa30674fc43c202b22c5f8c2be7 1591458 avahi_0.8.orig.tar.gz
 111454077a53d2b104912aee1399b46a 40956 avahi_0.8-5ubuntu5.1.debian.tar.xz
Original-Maintainer: Utopia Maintenance Team <pkg-utopia-maintainers@lists.alioth.debian.org>

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEUMSg3c8x5FLOsZtRZWnYVadEvpMFAmR3e9gACgkQZWnYVadE
vpMMDg//U1p+QdxoZnNS2S+1jFFt9uPXUiYSXSJYWSA5ae0Bn1KB31OrapPDeuhf
IgUJMrgvMOWgRgFSTfKzObk8nU912kcOho41MSw9DpR8rTokJtfLHXXd21PJ6r2T
SlbI2+kh4vYYkJ1j46o7THj1uqMGHixkawreSKlMFZTPIK5TMGN8Qsx+KeTX2VHu
AMv3PdbXWFUUIYbFEwiDVbA/ANMnkjG2ialuUP2gp6Z8z+CKmKp85F+jPqs9apJP
PfhQS206rm7jqG0/Hq4qfTsTTRQUCimp2Z3z+mXB0RpRlGkWZtjmSFGecc+ysawS
6XmBhCMerJ2iYkVP5OhMx3FIBK0bsKSzNeVW5Kk+ZUZaCDjlK8BPISKUxSuR24Uy
Hi/jAIllezDiRkxqCkmFNJFHXlhAkI3WC148uqItx2yYl/5jpX3hU+JT+MZVqoQY
AI6TfDtzkiEi9N3EWDrXY1fk1Swv1ZSs8DcLyd97mtjcCS6MwmsfZOHmeJ9u5SrW
Xi4gBk24KYZm/UH/rvWYbS+IMJIoD/ZrDb0l+6u3li32Spq4tpjYkJlnl2smyt3Z
bUiXSKY229KFt8vlP3VT1Q/ZBt8MXr6XFs6vTLppaTkEeyveB4/o7BSO+xch69Tk
mJmx9xFG+ddeqTnwtIdAwuj5zt6DOgJCXbbtAlNan8TyR1gXYNE=
=3AeC
-----END PGP SIGNATURE-----
