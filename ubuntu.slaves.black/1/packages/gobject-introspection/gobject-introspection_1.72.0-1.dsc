-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

Format: 3.0 (quilt)
Source: gobject-introspection
Binary: libgirepository-1.0-1, libgirepository1.0-dev, libgirepository1.0-doc, gobject-introspection, gir1.2-glib-2.0, gir1.2-freedesktop
Architecture: any all
Version: 1.72.0-1
Maintainer: Debian GNOME Maintainers <pkg-gnome-maintainers@lists.alioth.debian.org>
Uploaders: Iain Lane <laney@debian.org>, Jeremy Bicha <jeremy.bicha@canonical.com>, Laurent Bigonville <bigon@debian.org>, Matthias Klumpp <mak@debian.org>, Michael Biebl <biebl@debian.org>, Tim Lunn <tim@feathertop.org>
Homepage: https://wiki.gnome.org/GObjectIntrospection
Standards-Version: 4.6.0
Vcs-Browser: https://salsa.debian.org/gnome-team/gobject-introspection
Vcs-Git: https://salsa.debian.org/gnome-team/gobject-introspection.git
Testsuite: autopkgtest
Testsuite-Triggers: build-essential, file, gir1.2-gtk-3.0, libcairo2-dev
Build-Depends: debhelper-compat (= 13), dh-sequence-gnome, dh-sequence-python3, meson (>= 0.58.2), python3:native, python3-debian:native, python3-dev (>= 3.6), python3-distutils, pkg-config, flex, gtk-doc-tools (>= 1.19), bison, libglib2.0-dev (>= 2.70.0), libcairo2-dev, libffi-dev (>= 3.4), libtool, python3-mako, python3-markdown
Build-Depends-Indep: libglib2.0-doc (>= 2.70.0)
Package-List:
 gir1.2-freedesktop deb introspection optional arch=any
 gir1.2-glib-2.0 deb introspection optional arch=any
 gobject-introspection deb devel optional arch=any
 libgirepository-1.0-1 deb libs optional arch=any
 libgirepository1.0-dev deb libdevel optional arch=any
 libgirepository1.0-doc deb doc optional arch=all
Checksums-Sha1:
 e4b69f2d9ea311d1f0788df00c6e9c5bbb3fdeb5 1040936 gobject-introspection_1.72.0.orig.tar.xz
 9d07387ba35ae84afcfaf6ac23584e85efa42a1b 25752 gobject-introspection_1.72.0-1.debian.tar.xz
Checksums-Sha256:
 02fe8e590861d88f83060dd39cda5ccaa60b2da1d21d0f95499301b186beaabc 1040936 gobject-introspection_1.72.0.orig.tar.xz
 aceb2c5e23f504af03eeaa2eef0007cfdca388f64dbef3642af20e038da5fb88 25752 gobject-introspection_1.72.0-1.debian.tar.xz
Files:
 13cbf9bca8f906ee275c8b107311d815 1040936 gobject-introspection_1.72.0.orig.tar.xz
 69ddbae541950c0d05cf724fe6a9317e 25752 gobject-introspection_1.72.0-1.debian.tar.xz
Dgit: a6952392add37ee6b842d8c3e78c17b5847dd7ab debian archive/debian/1.72.0-1 https://git.dgit.debian.org/gobject-introspection

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEENuxaZEik9e95vv6Y4FrhR4+BTE8FAmI0hgkACgkQ4FrhR4+B
TE/wUg/+NtG6mbDP/jdQRBNEtsDQpzH9qGdBZNTTjgp/89xsmCMGjvYpBVjxiP02
yYXdlWfOJ878DxWWLLCDTmp7q+LsxX6ebWq9Xez1rsXfIMnEqnKQ6BSwlhWoTRhn
rCUJ04Xe35jHzXK6bJVtW7i/u9045D/J6s36WBtxnbn/VYJ/JVdaD3F0r3BaWxlX
+anGUhsyPZjOl78EHwTqhhEiKofsEYiZEd/7djbzVkW6Bx+TsEE1G5KKG1/maFOL
aaNmWqwZBG9XnTH/X5nX/TTg2EqNxzC9gNytPpJpqretoJinYIEpwHsjNKFaTsTT
BW6w6CajlXehWbj7Ec7Jgs/p8+EYgiFD/NffxSV/IaAlihHpltjz0Qw7n4XhWWqB
215s76pYxfCvNO/oaXfV+lcImtuwlFjACMnwqa5WcbdTVtYd8JweJFdlY3Ht2YTh
7wjxOO/D7bznJnw4/cjots3buiNhD7Lgw8qpvfWPr4n1EXM8ZPnvVYKqMTxZvU9M
yjGKrmv1mA5l5DSLRolotsaSWbxj0itKo2H4l+b5KYD6ce8RzIT1IKhlLM/8XTvY
dNsxURKGTbM3wWYgOQWYmfb6xMgXsbVrrOl0K0c0GEf7QnTfMvY7oWlXw9XJ5f/k
LYxADk1tTo3/I2LWYfxlArUy2cnl87YjOQPULvGPBsRyUUijHbM=
=9ovW
-----END PGP SIGNATURE-----
