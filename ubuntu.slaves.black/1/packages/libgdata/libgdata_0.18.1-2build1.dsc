-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: libgdata
Binary: libgdata22, libgdata-common, libgdata-dev, libgdata-doc, libgdata-tests, gir1.2-gdata-0.0
Architecture: any all
Version: 0.18.1-2build1
Maintainer: Ubuntu Developers <ubuntu-devel-discuss@lists.ubuntu.com>
Uploaders: Jeremy Bicha <jbicha@debian.org>, Laurent Bigonville <bigon@debian.org>, Michael Biebl <biebl@debian.org>, Sebastien Bacher <seb128@debian.org>
Homepage: https://wiki.gnome.org/Projects/libgdata
Standards-Version: 4.5.1
Vcs-Browser: https://salsa.debian.org/gnome-team/libgdata
Vcs-Git: https://salsa.debian.org/gnome-team/libgdata.git
Testsuite: autopkgtest
Testsuite-Triggers: build-essential, dpkg-dev, gnome-desktop-testing, libuhttpmock-0.0-0, pkg-config, umockdev
Build-Depends: debhelper-compat (= 13), dh-sequence-gir, dh-sequence-gnome, meson (>= 0.50), pkg-config (>= 0.14), libglib2.0-dev (>= 2.44.0), libgcr-3-dev, libgoa-1.0-dev (>= 3.12.0), libjson-glib-dev (>= 0.15), libxml2-dev, libsoup2.4-dev (>= 2.56.0), libgdk-pixbuf2.0-dev, libuhttpmock-0.0-dev (>= 0.5.0), libgirepository1.0-dev (>= 0.10.7-1~), valac
Build-Depends-Indep: gtk-doc-tools (>= 1.25) <!nodoc>, libglib2.0-doc <!nodoc>, libgoa-1.0-doc <!nodoc>, libjson-glib-doc <!nodoc>, libsoup2.4-doc <!nodoc>
Package-List:
 gir1.2-gdata-0.0 deb introspection optional arch=any
 libgdata-common deb libs optional arch=all
 libgdata-dev deb libdevel optional arch=any
 libgdata-doc deb doc optional arch=all profile=!nodoc
 libgdata-tests deb libs optional arch=any
 libgdata22 deb libs optional arch=any
Checksums-Sha1:
 83884ff5defe2c1b3a5f9586d615e21474b608e5 851584 libgdata_0.18.1.orig.tar.xz
 d0ea54fa99096ea81e77ff6986075999bfe374b5 13428 libgdata_0.18.1-2build1.debian.tar.xz
Checksums-Sha256:
 dd8592eeb6512ad0a8cf5c8be8c72e76f74bfe6b23e4dd93f0756ee0716804c7 851584 libgdata_0.18.1.orig.tar.xz
 1e2e7eca69fffe2b7d879a8ffe2c5cb9892dc9f04884cf35292eaec6cef37810 13428 libgdata_0.18.1-2build1.debian.tar.xz
Files:
 92b058d1a0af5d1b96c86c21820f1eff 851584 libgdata_0.18.1.orig.tar.xz
 c6a297c0b2a6258e134854a75f5dfaaa 13428 libgdata_0.18.1-2build1.debian.tar.xz
Original-Maintainer: Debian GNOME Maintainers <pkg-gnome-maintainers@lists.alioth.debian.org>

-----BEGIN PGP SIGNATURE-----

iQJHBAEBCgAxFiEET7WIqEwt3nmnTHeHb6RY3R2wP3EFAmI8YCUTHGp1bGlhbmtA
dWJ1bnR1LmNvbQAKCRBvpFjdHbA/cXwiD/9W21p+0klalTT2QUrWCb67OCzJ4fRj
UcYNZatFLmeGjEZ9tgDv26HqDEZNG3t3n4FMYnlIAuNhrE/x4uRe73iYnSoUNtRM
TyRgcTL6R0ur75jkwtSPFV6JC4RPZAGdJ7+hGsAGIjpSUapPsuRcREKpzrPwNwu4
laqZjknmeBLKr74SQOLJUoqUoRmnuDKeDhV9+4m4/rW0Cq9Kg1/LfEVBzaVTTnJh
WiIsmOhp8g63tR25HHHsSw+pBECg1mCDobH0L82HXztWENsqC/PYoRjk2WpmpwpV
9vd7J4srDETQXgg3zw3X6ej+sObdSH9n1akeM4I0viLBUF/RMOSnYKmjcH3Fs31R
pT3WAbPpbXI/bgnYi78b/HN8H1lHF3lKzNUcUgKhn9f2GXUzS8H84G7T4dCw5Hwj
xYy/H9SnkR7DralB+ao5CZP6hJYAQc8Yl6UJhbjg/Wo3P4Fvwvu/Ns3gk2i5oJFW
ETovGJ57XR4VaEEbVKWLqwAGC8/pkHUCs0htzx+RTkgpk3Cv2+4snJHW6Zt1gCCT
hpUFn3RdtQlM/XELtC+1+wdzcfzmNsJuao1haCFWwb5qvorOTmYtkRI6ojB/Kb4x
zauF+jlO3Qaq7Z2SywJjiLUye7b+NXyP0bJcX1MpqlsTf1NstF1ws97QOVjNLKom
WWeqNqd+lpyjIQ==
=EajR
-----END PGP SIGNATURE-----
