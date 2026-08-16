-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

Format: 3.0 (quilt)
Source: ibus
Binary: ibus, ibus-data, ibus-tests, libibus-1.0-5, libibus-1.0-dev, ibus-gtk, ibus-gtk3, ibus-gtk4, ibus-wayland, ibus-doc, gir1.2-ibus-1.0, python3-ibus-1.0
Architecture: any all
Version: 1.5.26-4
Maintainer: Debian Input Method Team <debian-input-method@lists.debian.org>
Uploaders: Aron Xu <aron@debian.org>, Changwoo Ryu <cwryu@debian.org>, Osamu Aoki <osamu@debian.org>,
Homepage: https://github.com/ibus/ibus
Standards-Version: 4.6.0
Vcs-Browser: https://salsa.debian.org/debian/ibus
Vcs-Git: https://salsa.debian.org/debian/ibus.git
Testsuite: autopkgtest
Build-Depends: dbus-x11 (>= 1.8) <!nocheck>, debhelper-compat (= 13), desktop-file-utils, dh-python, gettext (>= 0.19.8), gnome-pkg-tools, gobject-introspection (>= 0.9.6~), gtk-doc-tools <!nodoc>, iso-codes, libdconf-dev (>= 0.7.5~), libgirepository1.0-dev, libglib2.0-dev (>= 2.46.0~), libgtk-3-bin, libgtk-3-dev (>= 3.12.0), libgtk-4-bin, libgtk-4-dev, libgtk2.0-dev (>= 2.24.5-4), libtool, libwayland-dev (>= 1.2.0~) [linux-any], pkg-config (>= 0.16), python-gi-dev (>= 3.0.0~), python3-all, systemd, unicode-cldr-core, unicode-data (>= 13.0.0-2), valac (>= 0.20), xauth <!nocheck>, xvfb <!nocheck>
Build-Depends-Indep: libglib2.0-doc <!nodoc>
Package-List:
 gir1.2-ibus-1.0 deb introspection optional arch=any
 ibus deb utils optional arch=any
 ibus-data deb utils optional arch=all
 ibus-doc deb doc optional arch=all profile=!nodoc
 ibus-gtk deb utils optional arch=any
 ibus-gtk3 deb utils optional arch=any
 ibus-gtk4 deb utils optional arch=any
 ibus-tests deb utils optional arch=any profile=!noinsttest
 ibus-wayland deb utils optional arch=linux-any
 libibus-1.0-5 deb libs optional arch=any
 libibus-1.0-dev deb libdevel optional arch=any
 python3-ibus-1.0 deb python optional arch=all
Checksums-Sha1:
 7ef8c58871f36fb8cf460f5fb68e335b6d50e831 3715263 ibus_1.5.26.orig.tar.gz
 64e7a8424ace9bd2b9b7e8797bff7af6d7c7e3a1 30944 ibus_1.5.26-4.debian.tar.xz
Checksums-Sha256:
 5c2fd118e7bfd4e9a42c3a20e6175a263426c90b6256f94989ed3d0384f4c9fc 3715263 ibus_1.5.26.orig.tar.gz
 0a7c789a57a4b1e86d883bcc2044d1f110c114a1737598f942e4cd6a8d17bda8 30944 ibus_1.5.26-4.debian.tar.xz
Files:
 3c39a4906b2c35a2896a44b428e91736 3715263 ibus_1.5.26.orig.tar.gz
 4648e1f2195d547329a82ae520179df3 30944 ibus_1.5.26-4.debian.tar.xz

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEDP6Ze3JFgKf6cvjP8LEQ51ppLzIFAmJSzKYACgkQ8LEQ51pp
LzLoSwf/Uat9JsaJqOwU5eDcg85NzJXip/tBOXVuvTIGyqCBVO43UqW8KodmZ9Xl
5LRSHpzVZ4V7kwwBhHL785/aMCCZ421Gry23fe+7ng8HNfxowdKUvgtCCKvRKkbC
5HoRsLfWJKfkIjQzAsanyDZ0DnBJTJISZnQyct0RsruOe1wwQh/r3SorgbYJIwWg
XGtUQcu9Z2LCxGb++kxVUr/1Ac31ERt5r42y7y2w34Ry1ve5dynn4SIoB6ilG9ZV
0voW5CLXnjBV5GPRTRXrwcfLspkrKgB11PFU8IaJXpZBt0cw2vQfBFVZxVgUexoK
xZjwiyi6CCB0I/B3sk2fGsl/c3N+cw==
=Ztfw
-----END PGP SIGNATURE-----
