-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: geocode-glib
Binary: libgeocode-glib0, libgeocode-glib-dev, libgeocode-glib-doc, gir1.2-geocodeglib-1.0, geocode-glib-tests
Architecture: any all
Version: 3.26.2-2build2
Maintainer: Debian GNOME Maintainers <pkg-gnome-maintainers@lists.alioth.debian.org>
Uploaders: Jeremy Bicha <jbicha@debian.org>, Laurent Bigonville <bigon@debian.org>, Michael Biebl <biebl@debian.org>
Standards-Version: 4.5.0
Vcs-Browser: https://salsa.debian.org/gnome-team/geocode-glib
Vcs-Git: https://salsa.debian.org/gnome-team/geocode-glib.git
Testsuite: autopkgtest
Testsuite-Triggers: build-essential
Build-Depends: debhelper-compat (= 12), gnome-pkg-tools, libglib2.0-dev (>= 2.44), libjson-glib-dev (>= 0.99.2), libsoup2.4-dev (>= 2.42), meson, gobject-introspection (>= 0.9.12-4~), libgirepository1.0-dev (>= 0.9.3)
Build-Depends-Indep: gtk-doc-tools (>= 1.13) <!nodoc>, libglib2.0-doc <!nodoc>
Package-List:
 geocode-glib-tests deb libs optional arch=any
 gir1.2-geocodeglib-1.0 deb introspection optional arch=any
 libgeocode-glib-dev deb libdevel optional arch=any
 libgeocode-glib-doc deb doc optional arch=all profile=!nodoc
 libgeocode-glib0 deb libs optional arch=any
Checksums-Sha1:
 b8fb9aed83f33685fafc2952383dbc5b46a78d31 72956 geocode-glib_3.26.2.orig.tar.xz
 f60dfe7f44522b2df01af7455eed380b7590ac4e 6320 geocode-glib_3.26.2-2build2.debian.tar.xz
Checksums-Sha256:
 01fe84cfa0be50c6e401147a2bc5e2f1574326e2293b55c69879be3e82030fd1 72956 geocode-glib_3.26.2.orig.tar.xz
 b36ac04ca1a3b834e5392ecb36edec78fdf4827a5c850f8204537eaabf847f9c 6320 geocode-glib_3.26.2-2build2.debian.tar.xz
Files:
 e1ef140a11a543643d170dc701009e39 72956 geocode-glib_3.26.2.orig.tar.xz
 667e04ace1e323cd33ca52181cc29456 6320 geocode-glib_3.26.2-2build2.debian.tar.xz

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEqx+XcX7ftBm4bj5/AhnKGdA0MwwFAmI7Jn8ACgkQAhnKGdA0
MwxDAgf/e4pWKnNCRIlAPwCsnMx4SmJHpWybrUXAvqYMRLVGc1QAG7WexcpX6oHF
iAGvJCePJPkgFLPlk6lbLJVHD1hQGC8mJakR4HbLh9xCXgNaJET+PEr05S2CDosR
NXzT953xclHmxEpHFW08A5rorQ4gw4OOD3CfyKKGt32RkG+7Sn+Yk+EFUxZyMjG8
B9xvnyPXQxgBlY+hhPhwbW9Nyjm9ummYvOgwMdllI/eDo6F3VagBUGX6niJaX+Ck
rkfDCC77m3ppyjZjt7fQmZqjqM7p1W7ZhkS1Zinc0r5k+hzsNVF7WSpnGUXYmg/J
2woAKEQWb0/sS9Y5Tfq6nmuoaqt6PA==
=j5/+
-----END PGP SIGNATURE-----
