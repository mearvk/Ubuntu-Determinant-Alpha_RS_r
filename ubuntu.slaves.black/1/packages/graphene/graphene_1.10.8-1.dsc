-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: graphene
Binary: libgraphene-1.0-0, libgraphene-1.0-dev, libgraphene-doc, graphene-tests, gir1.2-graphene-1.0
Architecture: any all
Version: 1.10.8-1
Maintainer: Debian GNOME Maintainers <pkg-gnome-maintainers@lists.alioth.debian.org>
Uploaders: Jeremy Bicha <jbicha@ubuntu.com>, Laurent Bigonville <bigon@debian.org>
Homepage: https://ebassi.github.io/graphene/
Standards-Version: 4.5.1
Vcs-Browser: https://salsa.debian.org/gnome-team/graphene
Vcs-Git: https://salsa.debian.org/gnome-team/graphene.git
Testsuite: autopkgtest
Testsuite-Triggers: build-essential, gnome-desktop-testing, pkg-config, python3-gi, python3-tap
Build-Depends: debhelper-compat (= 13), dh-sequence-gir, dh-sequence-gnome, libglib2.0-dev, libgirepository1.0-dev, meson (>= 0.50.1), pkg-config
Build-Depends-Indep: gtk-doc-tools <!nodoc>, libglib2.0-doc <!nodoc>
Package-List:
 gir1.2-graphene-1.0 deb introspection optional arch=any
 graphene-tests deb libs optional arch=any
 libgraphene-1.0-0 deb libs optional arch=any
 libgraphene-1.0-dev deb libdevel optional arch=any
 libgraphene-doc deb doc optional arch=all profile=!nodoc
Checksums-Sha1:
 fa78b8e2a7ed1475c37ad0d75b1cc3da9d5761a7 248540 graphene_1.10.8.orig.tar.xz
 7999c00bbb8480bebfe83324e91a494476fe873e 7476 graphene_1.10.8-1.debian.tar.xz
Checksums-Sha256:
 52e3f69828a2e1895a29d08d8a457ecad7a7a554901596069284fd9cf092fcf9 248540 graphene_1.10.8.orig.tar.xz
 86a328a846f666393364e5cc384f2aba3218a8da3f5907f98e6d4075a7ce44ae 7476 graphene_1.10.8-1.debian.tar.xz
Files:
 daf48c12b6e0b0bf6115fd4275dbadb4 248540 graphene_1.10.8.orig.tar.xz
 89960ca56fa1dec7cf34b9095d9da856 7476 graphene_1.10.8-1.debian.tar.xz

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEETQvhLw5HdtiqzpaW5mx3Wuv+bH0FAmI4m8oACgkQ5mx3Wuv+
bH0JrRAArQf37CavnavZDEtrReVf/4Ix3UXAj4FT88JbDjfgxYjla94rlVh8ALIQ
vbSGj7ZJGfWsd4VbPfxWxIFAcwKx6t9gbSORaBoTz/7mdSd5SpiqMBhg0iL2ckzg
B/9oLjvFZwfU7XvR7Kk1jNo96H1kwGtgsYlRviZ4EnaZaW4HWTF3kbwQnshEmsXS
8t5wITwG0axLwN+Gr7972EBG8uzT4KkuqDjGpwD3L2wpXPMw5XOHcAtQJLnIxKrn
3i0ftK325Tv+JHCwuQBjPi7Wj5+RUz+aJx1idBupDk0ah5YUCxaPqyHpPrhYQVZK
3a9/p1Ms6+ifrtoHPUQF0Md3kwyS5z/eSrds/+PpbU3s7y7kbMRtR/kbUUOuO7BR
l/tmSFxCFduPDw+5VkbToVpdkBVG5Hdn6Afqw1ikixStDQ/HwUGRiJ61LTQ24vIl
RqnfSqs1laDIuox1Gg2QIXIGIsCIS0K03HxU+7WWZe3yZwmVEljraPYRNyF3rP9R
Ltl9RtaB6ybt/xK+Rtg+1RPAJPmhbsHwfAcMEnZGths0QznwkR8+gbpTOCh8GE79
nweXg/4JUj2oWSqW8BNpx6WhZkLeqTxegec3k+8QbKRBLgsa4aYcqXgriQeVItBZ
TjYxYXJVbNs3jftrLVYYY6rjPZrM7f+XXtke7TqqS/c6Msx3lUI=
=7PtJ
-----END PGP SIGNATURE-----
