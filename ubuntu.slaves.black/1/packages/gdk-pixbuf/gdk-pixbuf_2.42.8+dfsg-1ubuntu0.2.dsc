-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Format: 3.0 (quilt)
Source: gdk-pixbuf
Binary: libgdk-pixbuf-2.0-0, libgdk-pixbuf2.0-bin, libgdk-pixbuf2.0-common, libgdk-pixbuf-2.0-dev, libgdk-pixbuf2.0-doc, libgdk-pixbuf2.0-0-udeb, libgdk-pixbuf-2.0-0-udeb, gir1.2-gdkpixbuf-2.0, gdk-pixbuf-tests
Architecture: any all
Version: 2.42.8+dfsg-1ubuntu0.2
Maintainer: Ubuntu Developers <ubuntu-devel-discuss@lists.ubuntu.com>
Uploaders: Emilio Pozuelo Monfort <pochu@debian.org>, Iain Lane <laney@debian.org>, Jeremy Bicha <jbicha@ubuntu.com>, Laurent Bigonville <bigon@debian.org>
Homepage: https://www.gtk.org/
Standards-Version: 4.5.1
Vcs-Browser: https://salsa.debian.org/gnome-team/gdk-pixbuf
Vcs-Git: https://salsa.debian.org/gnome-team/gdk-pixbuf.git
Testsuite: autopkgtest
Testsuite-Triggers: build-essential, gnome-desktop-testing, pkg-config
Build-Depends: debhelper-compat (= 13), dh-sequence-gir, dh-sequence-gnome, docbook-xml, docbook-xsl, gi-docgen, libgirepository1.0-dev (>= 0.9.3), libglib2.0-dev (>= 2.56.0), libjpeg-dev, libpng-dev (<< 1.7), libpng-dev (>= 1.6), libtiff-dev, meson (>= 0.55.3), shared-mime-info (>= 1.2), xsltproc
Package-List:
 gdk-pixbuf-tests deb libs optional arch=any
 gir1.2-gdkpixbuf-2.0 deb introspection optional arch=any
 libgdk-pixbuf-2.0-0 deb libs optional arch=any
 libgdk-pixbuf-2.0-0-udeb udeb debian-installer optional arch=any profile=!noudeb
 libgdk-pixbuf-2.0-dev deb libdevel optional arch=any
 libgdk-pixbuf2.0-0-udeb udeb debian-installer optional arch=any profile=!noudeb
 libgdk-pixbuf2.0-bin deb libs optional arch=any
 libgdk-pixbuf2.0-common deb libs optional arch=all
 libgdk-pixbuf2.0-doc deb doc optional arch=all profile=!nodoc
Checksums-Sha1:
 346917f8e2cbcaad11b5064cfdb7222666045314 6439548 gdk-pixbuf_2.42.8+dfsg.orig.tar.xz
 d7626da0941e1f99e03dc57b2a4b872d2e21d7a9 22020 gdk-pixbuf_2.42.8+dfsg-1ubuntu0.2.debian.tar.xz
Checksums-Sha256:
 c1f00d4419e164d160c9d9b49a90890e516c1624bcd0c2a120eb7f529835b5d3 6439548 gdk-pixbuf_2.42.8+dfsg.orig.tar.xz
 d86e1bac673c9b6cfacaf824f7f15c061baccaf59424bfe040d76af739b6fc16 22020 gdk-pixbuf_2.42.8+dfsg-1ubuntu0.2.debian.tar.xz
Files:
 05aa08f0f6302e52dd4219f5e50eacb7 6439548 gdk-pixbuf_2.42.8+dfsg.orig.tar.xz
 fa6033a7b24da604cc103e87a014187b 22020 gdk-pixbuf_2.42.8+dfsg-1ubuntu0.2.debian.tar.xz
Original-Maintainer: Debian GNOME Maintainers <pkg-gnome-maintainers@lists.alioth.debian.org>

-----BEGIN PGP SIGNATURE-----

iHAEARECADAWIQTgLv71TsYonmdA1hxDGjztotfSkgUCY1JJ+xIcc2ViMTI4QHVi
dW50dS5jb20ACgkQQxo87aLX0pIV0gCfeLdahBUaDVPJaeNOtaeRFvURjPEAoLAT
9NR/sm0JXF3huzK0lGUk3fJl
=IKJU
-----END PGP SIGNATURE-----
