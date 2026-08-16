-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: gcab
Binary: gcab, libgcab-1.0-0, libgcab-dev, libgcab-doc, libgcab-tests, gir1.2-gcab-1.0
Architecture: any all
Version: 1.4-3build2
Maintainer: Stephen Kitt <skitt@debian.org>
Homepage: https://wiki.gnome.org/msitools
Standards-Version: 4.5.1
Vcs-Browser: https://salsa.debian.org/debian/gcab
Vcs-Git: https://salsa.debian.org/debian/gcab.git
Testsuite: autopkgtest
Testsuite-Triggers: build-essential, gnome-desktop-testing, pkg-config
Build-Depends: debhelper-compat (= 13), gobject-introspection, gtk-doc-tools, intltool, libgirepository1.0-dev, libglib2.0-dev, meson (>= 0.50.0), pkg-config, valac
Package-List:
 gcab deb utils optional arch=any
 gir1.2-gcab-1.0 deb introspection optional arch=any
 libgcab-1.0-0 deb libs optional arch=any
 libgcab-dev deb libdevel optional arch=any
 libgcab-doc deb doc optional arch=all
 libgcab-tests deb misc optional arch=any
Checksums-Sha1:
 a7d88dc6da46ade0d4e4bb70e7350690692283a1 78240 gcab_1.4.orig.tar.xz
 4aac2ff47a1af1cfc6038ae1cef3c5105ce38c52 6504 gcab_1.4-3build2.debian.tar.xz
Checksums-Sha256:
 67a5fa9be6c923fbc9197de6332f36f69a33dadc9016a2b207859246711c048f 78240 gcab_1.4.orig.tar.xz
 c6b0c0cf3d8ed7794651c68117b43b0b8e8075edc8553ca89443e2e182a55fc8 6504 gcab_1.4-3build2.debian.tar.xz
Files:
 2dcb17ec6e472411c06551773cbb156f 78240 gcab_1.4.orig.tar.xz
 f5e1cbc0af5757ee61becfb8e640f7d2 6504 gcab_1.4-3build2.debian.tar.xz

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEqx+XcX7ftBm4bj5/AhnKGdA0MwwFAmI7JlsACgkQAhnKGdA0
MwxetggAjrzPW96kgQDyLzCNPeRAzrzDWpILhxYrgrfdq+5LKtqP4Fbteaj9FOAq
MSecgzYePEdY9hACC9I79fYrwXo9Zyn6PJKcCIHk+NRvIOVf+eynhCiCZvXYxopu
zzJ13KPdJFfmbq2gYZFeRFhpf/8jfEhZjp+5y0kNVdqWfbeN8RMfeE1EtR79HmBp
YgNjd6vyMYOphWVDlTD06IzH1GfFpl2rkzmkWsuwD88aclBZalLypORzQZ3/Y3yg
M0nLdL6En1rKkFquQb9Fo2n9+J03G34iKM7P81pIs5wnOajdwolekX0pXklqQ6Ax
izkao1WmhOETTn/8Ckeq7L+XSW12+g==
=Nq6R
-----END PGP SIGNATURE-----
