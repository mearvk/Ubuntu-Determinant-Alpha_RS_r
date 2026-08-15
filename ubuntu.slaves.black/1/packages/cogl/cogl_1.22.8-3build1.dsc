-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: cogl
Binary: libcogl20, libcogl-common, libcogl-dev, libcogl-doc, gir1.2-cogl-1.0, libcogl-path20, libcogl-path-dev, libcogl-pango20, libcogl-pango-dev, gir1.2-coglpango-1.0
Architecture: any all
Version: 1.22.8-3build1
Maintainer: Debian GNOME Maintainers <pkg-gnome-maintainers@lists.alioth.debian.org>
Uploaders: Emilio Pozuelo Monfort <pochu@debian.org>, Jeremy Bicha <jbicha@debian.org>, Laurent Bigonville <bigon@debian.org>, Michael Biebl <biebl@debian.org>, Sjoerd Simons <sjoerd@debian.org>, Rico Tzschichholz <ricotz@ubuntu.com>
Standards-Version: 4.6.0
Vcs-Browser: https://salsa.debian.org/gnome-team/cogl
Vcs-Git: https://salsa.debian.org/gnome-team/cogl.git
Testsuite: autopkgtest
Testsuite-Triggers: build-essential, xauth, xvfb
Build-Depends: debhelper-compat (= 13), gnome-pkg-tools, gobject-introspection (>= 1.33.4-1~), gtk-doc-tools (>= 1.13), libcairo2-dev (>= 1.10), libdrm-dev [linux-any], libegl-dev, libegl1-mesa-dev, libgbm-dev [linux-any], libgdk-pixbuf-2.0-dev (>= 2.0) | libgdk-pixbuf2.0-dev (>= 2.0), libgirepository1.0-dev (>= 0.9.12), libgl-dev, libgles-dev, libglib2.0-dev (>= 2.32.0), libpango1.0-dev (>= 1.28.3-5), libwayland-dev (>= 1.1.90) [linux-any], libx11-dev, libxcomposite-dev (>= 1:0.4), libxdamage-dev, libxext-dev, libxfixes-dev (>= 1:3), libxrandr-dev (>= 2:1.2), xauth <!nocheck>, xvfb <!nocheck>
Build-Depends-Indep: libclutter-1.0-doc <!nodoc>, libgdk-pixbuf2.0-doc <!nodoc>, libglib2.0-doc <!nodoc>
Package-List:
 gir1.2-cogl-1.0 deb introspection optional arch=any
 gir1.2-coglpango-1.0 deb introspection optional arch=any
 libcogl-common deb libs optional arch=all
 libcogl-dev deb libdevel optional arch=any
 libcogl-doc deb doc optional arch=all profile=!nodoc
 libcogl-pango-dev deb libdevel optional arch=any
 libcogl-pango20 deb libs optional arch=any
 libcogl-path-dev deb libdevel optional arch=any
 libcogl-path20 deb libs optional arch=any
 libcogl20 deb libs optional arch=any
Checksums-Sha1:
 b92d70f74b1df95ba5aeceff4dd203801982bc4f 1742632 cogl_1.22.8.orig.tar.xz
 a0af2ed404976db35a6c99d13bed2beb6844ffc6 17508 cogl_1.22.8-3build1.debian.tar.xz
Checksums-Sha256:
 a805b2b019184710ff53d0496f9f0ce6dcca420c141a0f4f6fcc02131581d759 1742632 cogl_1.22.8.orig.tar.xz
 b98bb3d45e0c2d68492f0d5cfb450f43363cded99bb582f45f53609c1c399e82 17508 cogl_1.22.8-3build1.debian.tar.xz
Files:
 7dd8b2e24171ef7399f851cea144b569 1742632 cogl_1.22.8.orig.tar.xz
 512c4325be565625910696961d37f804 17508 cogl_1.22.8-3build1.debian.tar.xz

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEqx+XcX7ftBm4bj5/AhnKGdA0MwwFAmI67KQACgkQAhnKGdA0
MwxJywf8DyWR4tG8koggIqpqs/9ITWjr8wjqQ0g2KuYt23mUXWzTEWVRyDUl8wZB
p35R6p2tZiztTUo4UGKyKT1yyCdG8RrbgItByY4ikx2qCoX31bLUzLWZEmjJ7bdG
5REgP1NaNVJzkwwMl3efVnMLvG/jU98LF/h7Onq+nVwaIAw+GDguIK5H/N3XqkJz
7nOUjIAlo78vIZmmMzBDV31eY0BYsk25jvbRFhFBjXfhvZF6eLkXt5kWTurQeLDr
J0CQFfMtK18xEg193Bu3+4OzXnnTFH7D/951D94tZtcqdSsbY/Rv2mCpwciV87Jm
sCsp/MVWFPCKVdyE15lOwQuLxoi6/A==
=VEAV
-----END PGP SIGNATURE-----
