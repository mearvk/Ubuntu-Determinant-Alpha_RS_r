-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Format: 3.0 (quilt)
Source: libmbim
Binary: libmbim-glib4, libmbim-glib-dev, libmbim-glib-doc, libmbim-utils, libmbim-proxy, gir1.2-mbim-1.0
Architecture: any all
Version: 1.28.0-1~ubuntu20.04.1
Maintainer: Ubuntu Developers <ubuntu-devel-discuss@lists.ubuntu.com>
Uploaders: Arnaud Ferraris <arnaud.ferraris@gmail.com>, Guido Günther <agx@sigxcpu.org>, Henry-Nicolas Tourneur <debian@nilux.be>, Martin <debacle@debian.org>
Homepage: https://www.freedesktop.org/wiki/Software/libmbim/
Standards-Version: 4.6.0
Vcs-Browser: https://salsa.debian.org/DebianOnMobile-team/libmbim
Vcs-Git: https://salsa.debian.org/DebianOnMobile-team/libmbim.git
Build-Depends: bash-completion, debhelper-compat (= 13), gobject-introspection, gtk-doc-tools <!nodoc>, help2man, libgirepository1.0-dev, libglib2.0-dev (>= 2.56), meson, pkg-config
Build-Depends-Indep: libglib2.0-doc <!nodoc>
Package-List:
 gir1.2-mbim-1.0 deb introspection optional arch=linux-any
 libmbim-glib-dev deb libdevel optional arch=any
 libmbim-glib-doc deb doc optional arch=all profile=!nodoc
 libmbim-glib4 deb libs optional arch=any
 libmbim-proxy deb net optional arch=any
 libmbim-utils deb net optional arch=any
Checksums-Sha1:
 09f8845ca5282f4434e2573a843080308d52c290 203032 libmbim_1.28.0.orig.tar.xz
 a660350dad73b4aceacb302b3ab50e772b51bb1a 12292 libmbim_1.28.0-1~ubuntu20.04.1.debian.tar.xz
Checksums-Sha256:
 5079169594087ea8dcb508c68bbc56ea5f55bd886e9941ba25b45431c3b010e5 203032 libmbim_1.28.0.orig.tar.xz
 3ba2d21c99007d67a8efce21b48989237177e81c0a1b49b73107f9feb928bd5d 12292 libmbim_1.28.0-1~ubuntu20.04.1.debian.tar.xz
Files:
 d935d1b6f166826a8a5c3f427577bae7 203032 libmbim_1.28.0.orig.tar.xz
 df96cc8a47a156907a33f8f998aa1c6d 12292 libmbim_1.28.0-1~ubuntu20.04.1.debian.tar.xz
Original-Maintainer: DebianOnMobile Maintainers <debian-on-mobile-maintainers@alioth-lists.debian.net>

-----BEGIN PGP SIGNATURE-----

iHAEARECADAWIQTgLv71TsYonmdA1hxDGjztotfSkgUCY5hxkBIcc2ViMTI4QHVi
dW50dS5jb20ACgkQQxo87aLX0pJSagCgyQEKhZstIM+DalbgH7siS/kkwS4An00W
9PZbdypc8oSB9xbLe0aMkX4d
=bAnv
-----END PGP SIGNATURE-----
