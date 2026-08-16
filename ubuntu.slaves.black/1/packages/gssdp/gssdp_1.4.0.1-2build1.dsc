-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: gssdp
Binary: libgssdp-1.2-0, gir1.2-gssdp-1.2, libgssdp-1.2-dev, libgssdp-doc, gssdp-tools
Architecture: any all
Version: 1.4.0.1-2build1
Maintainer: Debian GNOME Maintainers <pkg-gnome-maintainers@lists.alioth.debian.org>
Uploaders: Jeremy Bicha <jbicha@debian.org>, Laurent Bigonville <bigon@debian.org>, Sebastien Bacher <seb128@debian.org>
Homepage: https://wiki.gnome.org/Projects/GUPnP
Standards-Version: 4.6.0
Vcs-Browser: https://salsa.debian.org/gnome-team/gssdp
Vcs-Git: https://salsa.debian.org/gnome-team/gssdp.git
Build-Depends: debhelper-compat (= 13), dh-sequence-gir, dh-sequence-gnome, gtk-doc-tools, libglib2.0-dev (>= 2.54), libgirepository1.0-dev (>= 0.9.12), gir1.2-glib-2.0, libsoup2.4-dev (>= 2.26.1), libgtk-4-dev [amd64 arm64 armel armhf i386 mips64el mipsel ppc64 ppc64el sh4 s390x], meson (>= 0.54.0), python3-jinja2, python3-toml, python3-typogrify, valac (>= 0.14)
Build-Depends-Indep: libglib2.0-doc <!nodoc>, libsoup2.4-doc <!nodoc>
Package-List:
 gir1.2-gssdp-1.2 deb introspection optional arch=any
 gssdp-tools deb net optional arch=amd64,arm64,armel,armhf,i386,mips64el,mipsel,ppc64,ppc64el,sh4,s390x
 libgssdp-1.2-0 deb libs optional arch=any
 libgssdp-1.2-dev deb libdevel optional arch=any
 libgssdp-doc deb doc optional arch=all profile=!nodoc
Checksums-Sha1:
 e06ac30f74eaaaf554ef73eb704529eee849d028 1228372 gssdp_1.4.0.1.orig.tar.xz
 e2e875bf63aa933fc487879bb2d420592146a970 14956 gssdp_1.4.0.1-2build1.debian.tar.xz
Checksums-Sha256:
 aa79e34b966eb0cf3624db92ee93320347157e4f56196217efe143db0dc51236 1228372 gssdp_1.4.0.1.orig.tar.xz
 080918f1d02efe0dca2575244528ecdf0d1801d68d19eebe3a719e116e469998 14956 gssdp_1.4.0.1-2build1.debian.tar.xz
Files:
 c778f4f21e044299cf22d5571a63da26 1228372 gssdp_1.4.0.1.orig.tar.xz
 22b62911c59e2905b643ca8b2ab4a767 14956 gssdp_1.4.0.1-2build1.debian.tar.xz

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEqx+XcX7ftBm4bj5/AhnKGdA0MwwFAmI7Jx4ACgkQAhnKGdA0
Mwzk/Qf/ajbXTXaElQxvZE5xBYATUjghzkKsk1wFvWDUfYE9I36E3Z4513ucKJrV
UjB86jYK2nELTq11sPMj53cheMfizxWfa0GwUUfRqMGbEfPG6YUYKwaNOwer+Ioj
jSS4HftKs5mglfv2kYWDIFXhJgLwwf2wBTknUaYhbvjYR2GIMWaTJpTzidMyi58H
qanHDIUtoEZJ49dWdzAksh0TwtCNHriR+fj4AQqjYbZQvF1hd6HwcjyKVF00LeXu
ouURgbqKhma8ezJCh/WlmStQZYq4zYRNf5xsG2p2BIOPSmrxAYFFosizWybe40Vg
CeEH+nvAkyuqVGiTMlq8E+8Cfs6TKg==
=RsGM
-----END PGP SIGNATURE-----
