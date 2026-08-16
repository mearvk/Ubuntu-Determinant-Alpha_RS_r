-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: glib-networking
Binary: glib-networking, glib-networking-services, glib-networking-common, glib-networking-tests
Architecture: any all
Version: 2.72.0-1
Maintainer: Debian GNOME Maintainers <pkg-gnome-maintainers@lists.alioth.debian.org>
Uploaders: Iain Lane <laney@debian.org>, Jeremy Bicha <jbicha@ubuntu.com>
Standards-Version: 4.6.0
Vcs-Browser: https://salsa.debian.org/gnome-team/glib-networking
Vcs-Git: https://salsa.debian.org/gnome-team/glib-networking.git
Testsuite: autopkgtest
Testsuite-Triggers: dbus, gnome-desktop-testing, xauth, xvfb
Build-Depends: debhelper-compat (= 13), dh-sequence-gnome, meson (>= 0.47.0), libglib2.0-dev (>= 2.69.0), libgnutls28-dev (>= 3.7.2), libproxy-dev (>= 0.4), gsettings-desktop-schemas-dev, ca-certificates
Package-List:
 glib-networking deb libs optional arch=any
 glib-networking-common deb libs optional arch=all
 glib-networking-services deb libs optional arch=any
 glib-networking-tests deb misc optional arch=any
Checksums-Sha1:
 385bc31627b6fe9f4765f4de0eb200df00cbf486 265060 glib-networking_2.72.0.orig.tar.xz
 ffe2af53da4a467366be958ca8ff66c688278a74 11808 glib-networking_2.72.0-1.debian.tar.xz
Checksums-Sha256:
 100aaebb369285041de52da422b6b716789d5e4d7549a3a71ba587b932e0823b 265060 glib-networking_2.72.0.orig.tar.xz
 10f2ec2a1273e77510171bed2d8509edb3d7e640e1e9bcec492e7670eed63a54 11808 glib-networking_2.72.0-1.debian.tar.xz
Files:
 ff149a669ea3d1d193a468472bcdc696 265060 glib-networking_2.72.0.orig.tar.xz
 b701ac8ffb5abc6c6a0fc3a6a9184181 11808 glib-networking_2.72.0-1.debian.tar.xz

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEETQvhLw5HdtiqzpaW5mx3Wuv+bH0FAmI6G2oACgkQ5mx3Wuv+
bH1E6A//UnFDxCKwJOPedRKhxvi0MpNeC0W3tnYoh+E+XLu+gNVfdPqs07w2f1ra
e4rHdyivZnsVXUgWWb3ucYSrTH29eeLiIPEssWiZPKUU2eN3PREY9QnghbojSu9e
cSeV4do4BQH+viaAwUE3c3O2rf9ZZv4GRUdRF960Ail3LagwQMS90jFLdeyYW2q8
nkszTDkrUa/kBAvVcTIlPQvlQp+7PRnUzdZh8B8hD1x4R/iQoq1q5o6zA/h/v6YU
0ntqgJAWL2XhW+gXZ1cy++utuEyEkEXYApkRf0yZIlkznNzQx1b7t1sslnkm1O07
ep53m9mGJ9mOc2c6szKGdkYw0Aq43uSPXoT7a8reMG6z1mnnavTSYg5xozqenqkX
ZdsyN+pIrSVACeE9zwythGk43t1ZeWZSxz5ulqPER17A8/GnjDKJ56C+cM/eQEeu
bHNVcUhi0coPsyS1pCzoF6wgwow5EqjHeYDzBBj2HBeabmkyy8pz9chyUsP93l15
FPWInx5I57PJ6gdV6D8aMu60wqtxnRE4yKuli3+HfGqaFGd/Wb1Z6ST6pHYJQs+k
Iso0mcR3ookhdA1SgIPcdid0gfx3HAQkEajohDJt/MBoQaHUjW+yHhF8I1DZkkxW
zSY2L7ZibIWq0Q4JVZNr261BY74/0BxOqwZYJ3Wj9LBUmT6/wq4=
=gfvE
-----END PGP SIGNATURE-----
