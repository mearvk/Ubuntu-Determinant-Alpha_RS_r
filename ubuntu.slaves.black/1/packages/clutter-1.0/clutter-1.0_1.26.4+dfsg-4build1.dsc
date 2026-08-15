-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: clutter-1.0
Binary: libclutter-1.0-0, libclutter-1.0-common, libclutter-1.0-dev, libclutter-1.0-doc, clutter-1.0-tests, gir1.2-clutter-1.0
Architecture: any all
Version: 1.26.4+dfsg-4build1
Maintainer: Debian GNOME Maintainers <pkg-gnome-maintainers@lists.alioth.debian.org>
Uploaders: Jeremy Bicha <jbicha@debian.org>, Laurent Bigonville <bigon@debian.org>, Rico Tzschichholz <ricotz@ubuntu.com>,
Homepage: https://blogs.gnome.org/clutter/
Standards-Version: 4.6.0
Vcs-Browser: https://salsa.debian.org/gnome-team/clutter
Vcs-Git: https://salsa.debian.org/gnome-team/clutter.git
Testsuite: autopkgtest
Testsuite-Triggers: build-essential, dbus, gnome-desktop-testing, libgl1-mesa-dri, xauth, xvfb
Build-Depends: autopoint, dbus <!nocheck>, debhelper-compat (= 13), gnome-pkg-tools, gobject-introspection (>= 1.39.0), gtk-doc-tools (>= 1.20), libatk1.0-dev (>= 2.5.3), libcairo2-dev (>= 1.14.0), libcogl-dev (>= 1.21.2), libcogl-pango-dev (>= 1.14.0), libcogl-path-dev, libdrm-dev [!hurd-any], libgdk-pixbuf-2.0-dev (>= 2.0) | libgdk-pixbuf2.0-dev (>= 2.0), libgirepository1.0-dev (>= 1.35.8), libgl-dev, libglib2.0-dev (>= 2.53.4), libgtk-3-dev (>= 3.16), libgudev-1.0-dev [linux-any], libinput-dev (>= 0.19.0) [linux-any], libjson-glib-dev (>= 0.12.0), libpango1.0-dev (>= 1.30), libudev-dev (>= 136) [linux-any], libxcomposite-dev (>= 1:0.4), libxdamage-dev, libxext-dev, libxi-dev, libxkbcommon-dev, xauth <!nocheck>, xsltproc, xvfb <!nocheck>
Build-Depends-Indep: libatk1.0-doc <!nodoc>, libcairo2-doc <!nodoc>, libclutter-gtk-1.0-doc <!nodoc>, libcogl-doc <!nodoc>, libgdk-pixbuf2.0-doc <!nodoc>, libglib2.0-doc <!nodoc>, libgtk-3-doc <!nodoc>, libpango1.0-doc <!nodoc>
Package-List:
 clutter-1.0-tests deb misc optional arch=any
 gir1.2-clutter-1.0 deb introspection optional arch=any
 libclutter-1.0-0 deb libs optional arch=any
 libclutter-1.0-common deb libs optional arch=all
 libclutter-1.0-dev deb libdevel optional arch=any
 libclutter-1.0-doc deb doc optional arch=all profile=!nodoc
Checksums-Sha1:
 e6613ed43b421cd2bd8c7edc65c4e11173afaf78 3623520 clutter-1.0_1.26.4+dfsg.orig.tar.xz
 d38fc68422905734b4c871a70ff792a722215ebb 23544 clutter-1.0_1.26.4+dfsg-4build1.debian.tar.xz
Checksums-Sha256:
 3795be3c07042c6d67b191c416c85183b8c3291a214dd5fd7dc1dd1c7a9de290 3623520 clutter-1.0_1.26.4+dfsg.orig.tar.xz
 f504643df7dc586d50eeccbecab94ccdd29952a61c83fc153467a46cfe1f9bad 23544 clutter-1.0_1.26.4+dfsg-4build1.debian.tar.xz
Files:
 9326096cd42e6d353d896499e27cc936 3623520 clutter-1.0_1.26.4+dfsg.orig.tar.xz
 fea916d720a4f09a287d50a9bbf351e2 23544 clutter-1.0_1.26.4+dfsg-4build1.debian.tar.xz

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEqx+XcX7ftBm4bj5/AhnKGdA0MwwFAmI67IgACgkQAhnKGdA0
MwyYwAf+KjG/JkEGQlNRXnYxdSITvfVhUr/Kflwf+PmxX3sIu4MQdrGm4fetRWGp
waYrbEbyaNQG39xWAG4YsXZsXdP+8uSsnSunjP5eHTALznv/zy+BQR2sX/G7A3JX
+tHYpUqnxlRsPl/oxodCD6gTus3Vgnze6boIpaah1AuhWxyK2AFMDBMlQ1prRr5r
AJ5nVzM3s/Yj9TwneMukbuCCg8REb3Dqhtykw0p1evMPE5wy5PM5Z47NnirffwBW
YkuuCqyemcZi7RiTbmLSWw8TpXh+hoxid3SEPDaL1B4ajN5pUCVFLjcD/L/NdPEZ
qmGfdzNPq9KvdkpvJPnSGkmAQz1cIQ==
=MxBz
-----END PGP SIGNATURE-----
