-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: gtk4
Binary: libgtk-4-1, libgtk-4-1-udeb, libgtk-4-common, libgtk-4-bin, libgtk-4-dev, libgtk-4-doc, libgtk-4-media-gstreamer, libgtk-4-media-ffmpeg, gtk-4-examples, gtk-4-tests, gir1.2-gtk-4.0
Architecture: any all
Version: 4.6.9+ds-0ubuntu0.22.04.1
Maintainer: Ubuntu Developers <ubuntu-devel-discuss@lists.ubuntu.com>
Uploaders: Simon McVittie <smcv@debian.org>, Jeremy Bicha <jbicha@debian.org>
Homepage: https://www.gtk.org/
Standards-Version: 4.6.0
Vcs-Browser: https://salsa.debian.org/gnome-team/gtk4/-/tree/ubuntu/jammy
Vcs-Git: https://salsa.debian.org/gnome-team/gtk4.git -b ubuntu/jammy
Testsuite: autopkgtest
Testsuite-Triggers: build-essential, dbus, fonts-dejavu-core, gnome-desktop-testing, libgl1, libgl1-mesa-dri, locales, locales-all, python3-gi, ttf-bitstream-vera, weston, xauth, xvfb
Build-Depends: adwaita-icon-theme <!nocheck>, at-spi2-core <!nocheck>, dbus <!nocheck>, debhelper-compat (= 13), dh-sequence-translations, docbook-xml, docbook-xsl, dpkg-dev (>= 1.17.14), fonts-cantarell <!nocheck>, fonts-dejavu-core <!nocheck>, gnome-pkg-tools (>= 0.11), gobject-introspection (>= 1.41.3), gsettings-desktop-schemas <!nocheck>, iso-codes <!nocheck>, libavcodec-dev (>= 7:4.1.0) [amd64 arm64 armel armhf i386 mips64el mipsel ppc64el s390x], libavfilter-dev (>= 7:4.1.0) [amd64 arm64 armel armhf i386 mips64el mipsel ppc64el s390x], libavformat-dev (>= 7:4.1.0) [amd64 arm64 armel armhf i386 mips64el mipsel ppc64el s390x], libavutil-dev (>= 7:4.1.0) [amd64 arm64 armel armhf i386 mips64el mipsel ppc64el s390x], libcairo2-dev (>= 1.14.0), libcolord-dev (>= 0.1.9), libcloudproviders-dev (>= 0.3.1), libcups2-dev (>= 2.0), libegl1-mesa-dev [linux-any], libepoxy-dev, libfontconfig1-dev, libfribidi-dev (>= 0.19.7), libgdk-pixbuf-2.0-dev (>= 2.30.0), libgirepository1.0-dev (>= 1.39.0), libglib2.0-dev (>= 2.66.0), libgraphene-1.0-dev (>= 1.10.4~), libgstreamer1.0-dev (>= 1.12.3), libgstreamer-plugins-bad1.0-dev (>= 1.12.3), libharfbuzz-dev (>= 2.1.0), libjpeg-dev, libjson-glib-dev:native, libpango1.0-dev (>= 1.50.0), libpng-dev, libpolkit-gobject-1-dev (>= 0.105) [linux-any], librsvg2-common <!nocheck>, librsvg2-dev (>= 2.52.0), libswscale-dev (>= 7:4.1.0) [amd64 arm64 armel armhf i386 mips64el mipsel ppc64el s390x], libsysprof-capture-4-dev (>= 3.40.1) [linux-any], libtiff-dev, libvulkan-dev [linux-any], libwayland-dev (>= 1.20.0) [linux-any], libx11-dev, libxcomposite-dev, libxcursor-dev, libxdamage-dev, libxext-dev, libxfixes-dev, libxi-dev, libxinerama-dev, libxkbcommon-dev (>= 0.2.0), libxkbfile-dev, libxml2-utils, libxrandr-dev (>= 2:1.5.0), locales <!nocheck> | locales-all <!nocheck>, meson (>= 0.59), pkg-config, python3-docutils <!nodoc>, python3-gi (>= 3.40) <!nocheck>, sassc, ttf-bitstream-vera <!nocheck>, wayland-protocols (>= 1.23) [linux-any], weston [linux-any] <!nocheck>, xauth <!nocheck>, xsltproc, xvfb <!nocheck>
Build-Depends-Indep: libcairo2-doc, gi-docgen, libglib2.0-doc, libpango1.0-doc, pandoc, python3 (>= 3.6) <!nodoc>, python3-jinja2 <!nodoc>, python3-markdown <!nodoc>, python3-pygments <!nodoc>, python3-toml <!nodoc>, python3-typogrify <!nodoc>
Package-List:
 gir1.2-gtk-4.0 deb introspection optional arch=any
 gtk-4-examples deb x11 optional arch=any profile=!noinsttest
 gtk-4-tests deb x11 optional arch=any profile=!noinsttest
 libgtk-4-1 deb libs optional arch=any
 libgtk-4-1-udeb udeb debian-installer optional arch=any profile=!noudeb
 libgtk-4-bin deb misc optional arch=any
 libgtk-4-common deb misc optional arch=all
 libgtk-4-dev deb libdevel optional arch=any
 libgtk-4-doc deb doc optional arch=all profile=!nodoc
 libgtk-4-media-ffmpeg deb x11 optional arch=amd64,arm64,armel,armhf,i386,mips64el,mipsel,ppc64el,s390x profile=pkg.gtk4.ffmpeg
 libgtk-4-media-gstreamer deb x11 optional arch=any
Checksums-Sha1:
 19eda865ebce9d0f301f417d901cad44c9ddc27b 15945584 gtk4_4.6.9+ds.orig.tar.xz
 99fec06c60ef4bbf19253d3a1e1c89b19e7ca7bc 3025492 gtk4_4.6.9+ds-0ubuntu0.22.04.1.debian.tar.xz
Checksums-Sha256:
 1c1613217e580870275acd04c77965d177e196eba8b64f270081f67564d2310d 15945584 gtk4_4.6.9+ds.orig.tar.xz
 79b8ce393adfb47b1e01fc72f5c2afd5e48bc68cf04aec1d185ac11b452d5256 3025492 gtk4_4.6.9+ds-0ubuntu0.22.04.1.debian.tar.xz
Files:
 59bf37d3e8fbd58cf1f329d2a5e0ffac 15945584 gtk4_4.6.9+ds.orig.tar.xz
 dbaee7a8383c86cbfecd6aa6604a19a0 3025492 gtk4_4.6.9+ds-0ubuntu0.22.04.1.debian.tar.xz
Debian-Vcs-Browser: https://salsa.debian.org/gnome-team/gtk4
Debian-Vcs-Git: https://salsa.debian.org/gnome-team/gtk4.git
Original-Maintainer: Debian GNOME Maintainers <pkg-gnome-maintainers@lists.alioth.debian.org>

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE1MUB2kjreXoIF1CTlEnC9QmWY18FAmS1g8UACgkQlEnC9QmW
Y19UCg/5AWoKaBBOF3R+7bkaPoOsXs4yx6wVzrwcaKLRUqEIkwfDbHdV/bsi8ZMr
ZY4TS78dNwN5j3HoXgMlijEG7N9afvgCmoaeAOWoG2LfE3pfxLvmTRLdXl98LQGE
OxsPD8up0OSypVmiDnSQYbEiHLRYL3tCR/zSTrNXikHprvB0/uk6bQGXEdDv+84L
wEPlROVWGdDEHrds6DSXkUQDdMqZa3vTkz0a1Mgi2Pn/6a5HgJZUC16PzLrFG0IE
zvotPYDg6DHxEcqT4QJAhsU6y/wR2Ed1RBZ0gPbTNksm/+OkXLsmg7A5gLthk+kt
RZnA/2i4wS54rAUEs6ime3GQQdW5BLtOUj1ohSOgCgdDYx71heNrvPkzuPjFtYYc
x5zc5Kg4EvSaFZG8S/ibjMU/MmjkVP48CyRlogowsUJjnTYDBGOIJLX9qfXTb1CL
BbMeJ1cl3E+EuF/JApyBP6/BWHCQjkB7lXNffXtGYA1I9MBBCuNuQzigzVjxmVej
llQPHcED0wS+tRRu1pyYAS6nBDLT8LEen3zq5SHKKRZmQXwb/xB+RKBIrgn3g9Xt
G8Bc6NNJpTI1WasxwLXCP9jGyAncfE3fd3SJn/5msIEVk+SyG528Ehd0bN1bWnuM
KY6aNKymmV5n42IrJCRwGfAAgZgLXYdrW14X2T6cMuE3at+O0oM=
=Ib+8
-----END PGP SIGNATURE-----
