-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: gtk+3.0
Binary: libgtk-3-0, libgtk-3-0-udeb, libgtk-3-common, libgtk-3-bin, libgtk-3-dev, libgtk-3-doc, gtk-3-examples, gir1.2-gtk-3.0, gtk-update-icon-cache, libgail-3-0, libgail-3-dev, libgail-3-doc
Architecture: any all
Version: 3.24.33-1ubuntu2
Maintainer: Ubuntu Developers <ubuntu-devel-discuss@lists.ubuntu.com>
Uploaders: Simon McVittie <smcv@debian.org>, Debian GNOME Maintainers <pkg-gnome-maintainers@lists.alioth.debian.org>
Homepage: https://www.gtk.org/
Standards-Version: 4.6.0
Vcs-Browser: https://salsa.debian.org/gnome-team/gtk3/tree/ubuntu/jammy
Vcs-Git: https://salsa.debian.org/gnome-team/gtk3.git -b ubuntu/jammy
Testsuite: autopkgtest
Testsuite-Triggers: adwaita-icon-theme-full, at-spi2-core, build-essential, dbus, gnome-desktop-testing, librsvg2-common, python3-gi, xauth, xvfb
Build-Depends: adwaita-icon-theme-full <!nocheck>, at-spi2-core <!nocheck>, dbus <!nocheck>, debhelper-compat (= 13), dh-sequence-gir, dh-sequence-translations, fonts-cantarell <!nocheck>, fonts-dejavu-core <!nocheck>, gnome-pkg-tools (>= 0.11), gobject-introspection (>= 1.41.3), gsettings-desktop-schemas <!nocheck>, gtk-doc-tools (>= 1.20), libatk-bridge2.0-dev (>= 2.15.1), libatk1.0-dev (>= 2.35.1), libcairo2-dev (>= 1.14.0), libcolord-dev (>= 0.1.9), libcups2-dev (>= 1.7), libegl1-mesa-dev [linux-any], libepoxy-dev (>= 1.4), libfontconfig1-dev, libfribidi-dev (>= 0.19.7), libgdk-pixbuf-2.0-dev (>= 2.40.0) | libgdk-pixbuf2.0-dev (>= 2.40.0), libgirepository1.0-dev (>= 1.39.0), libglib2.0-dev (>= 2.57.2), libharfbuzz-dev (>= 2.2.0), libjson-glib-dev:native, libpango1.0-dev (>= 1.44.0), librsvg2-common [amd64 arm64 armel armhf i386 mips64el mipsel ppc64el s390x powerpc ppc64 riscv64 sparc64] <!nocheck>, libwayland-dev (>= 1.14.91) [linux-any], libx11-dev, libxcomposite-dev, libxcursor-dev, libxdamage-dev, libxext-dev, libxfixes-dev, libxi-dev, libxinerama-dev, libxkbcommon-dev (>= 0.2.0), libxkbfile-dev, libxml2-utils, libxrandr-dev (>= 2:1.5.0), pkg-config, sassc, wayland-protocols (>= 1.17) [linux-any], xauth <!nocheck>, xvfb <!nocheck>
Build-Depends-Indep: docbook-xml, docbook-xsl, libatk1.0-doc, libcairo2-doc, libglib2.0-doc, libpango1.0-doc, xsltproc
Package-List:
 gir1.2-gtk-3.0 deb introspection optional arch=any
 gtk-3-examples deb x11 optional arch=any
 gtk-update-icon-cache deb misc optional arch=any
 libgail-3-0 deb libs optional arch=any
 libgail-3-dev deb libdevel optional arch=any
 libgail-3-doc deb doc optional arch=all
 libgtk-3-0 deb libs optional arch=any
 libgtk-3-0-udeb udeb debian-installer optional arch=any profile=!noudeb
 libgtk-3-bin deb misc optional arch=any
 libgtk-3-common deb misc optional arch=all
 libgtk-3-dev deb libdevel optional arch=any
 libgtk-3-doc deb doc optional arch=all
Checksums-Sha1:
 d4b66783e6dfe41cad8365e689de78cd30e9f13c 22449472 gtk+3.0_3.24.33.orig.tar.xz
 3eb44251ea823d407612c2871bfad1ef003322a7 430772 gtk+3.0_3.24.33-1ubuntu2.debian.tar.xz
Checksums-Sha256:
 588b06522e25d1579e989b6f9d8a1bdbf2fe13cde01a04e904ff346a225e7801 22449472 gtk+3.0_3.24.33.orig.tar.xz
 f5f1f6eee95b8c9abac1ddc64d431bdd09f450a16b735bcd9691ff361b03eb0e 430772 gtk+3.0_3.24.33-1ubuntu2.debian.tar.xz
Files:
 83c42707e9be61d6d7a8b4dddce1eb4a 22449472 gtk+3.0_3.24.33.orig.tar.xz
 fa40a6cab22b26cc8126a6a3b2ce5ff6 430772 gtk+3.0_3.24.33-1ubuntu2.debian.tar.xz
Debian-Vcs-Browser: https://salsa.debian.org/gnome-team/gtk3
Debian-Vcs-Git: https://salsa.debian.org/gnome-team/gtk3.git
Original-Maintainer: Debian GNOME Maintainers <pkg-gnome-maintainers@lists.alioth.debian.org>

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEETQvhLw5HdtiqzpaW5mx3Wuv+bH0FAmJ5dxMACgkQ5mx3Wuv+
bH1qkBAAiqXjJVAbMJbqKXe3dKywjbKGm76PSY4/LfFM+N81dgIJdywqh29Z30c9
qtBatAC46Wiu0+boJUs8T4yCo+Q0rWx64E4+Vo6PQlVSdIXu24ucdN4M6DLkZaG7
omV1ZTLFtjapGt1ifzliXVpcVL/wzQ+L6UQH83Dr8lpCbHABTOh7js3bbs42RKJe
5ykqe9W5ThSmxt4tTK9bjlEMMsiyFgcTWUQj5elh2vhG9bFMMw9QzhoCX0Oxk49W
O9OMMlLNSP64gVni2Q9ES7B5vfGYEl0jSGoZjaB6/k6wyUt2+vVb4WZ+I4Mm6jef
a4PB2URG7Dsn7xubi0Gn+9SOa6U4UR9yAYx25eDb98i0oBaDNRi1VbXqm9E+HNMF
FOLVMDk6vTnS+37i/7W8q6YF+IaZopYnooYRePF8JwzCB6JsqnmDpyFipQvNCoon
9ew/qYYJoQ9b5XJqawwGJ4K1eIQtOLdW2LUvM05FyiCO0jxl4kAsHePF+i2iF2gB
7INexQtHfdtNQGzxRIQHJDQrOrCCEnD00NmG1i5E/tl4pgKerhWc7q+kU4u1pAEB
1nJd+yj+fSEHbweXyiDXmcmZjWpzcIiBqDdYKsl8E5QyrWLO7y1PkARS+oMuEk5V
1+4YWjzE15tuSUUivqSIWcKTcPV93qvgJEcf82guAh3tAh8/uWE=
=54T7
-----END PGP SIGNATURE-----
