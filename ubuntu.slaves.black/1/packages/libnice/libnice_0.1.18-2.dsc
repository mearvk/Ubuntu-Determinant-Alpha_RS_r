-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

Format: 3.0 (quilt)
Source: libnice
Binary: libnice10, libnice-dev, gstreamer1.0-nice, libnice-doc, gir1.2-nice-0.1
Architecture: any all
Version: 0.1.18-2
Maintainer: Debian Telepathy maintainers <pkg-telepathy-maintainers@lists.alioth.debian.org>
Uploaders: Sjoerd Simons <sjoerd@debian.org>, Laurent Bigonville <bigon@debian.org>
Homepage: https://nice.freedesktop.org/
Standards-Version: 4.6.0
Vcs-Browser: https://salsa.debian.org/telepathy-team/libnice
Vcs-Git: https://salsa.debian.org/telepathy-team/libnice.git
Build-Depends: debhelper-compat (= 13), gobject-introspection (>= 1.30.0), libgirepository1.0-dev (>= 1.30.0), libglib2.0-dev (>= 2.54), libgnutls28-dev (>= 2.12.0), libgstreamer1.0-dev, libgupnp-igd-1.0-dev (>= 0.2.4), meson (>= 0.52)
Build-Depends-Indep: graphviz <!nodoc>, gtk-doc-tools <!nodoc>, libglib2.0-doc <!nodoc>
Package-List:
 gir1.2-nice-0.1 deb introspection optional arch=any
 gstreamer1.0-nice deb net optional arch=any
 libnice-dev deb libdevel optional arch=any
 libnice-doc deb doc optional arch=all profile=!nodoc
 libnice10 deb libs optional arch=any
Checksums-Sha1:
 b83bd147060d9fe7aacba275d2320f12aefc384a 439791 libnice_0.1.18.orig.tar.gz
 48dd541f8b928d85bdcf20b4e4704ad6c85bc873 195 libnice_0.1.18.orig.tar.gz.asc
 33207b7e3f9dc696241be56ffb16bafd215a3ac0 17136 libnice_0.1.18-2.debian.tar.xz
Checksums-Sha256:
 5eabd25ba2b54e817699832826269241abaa1cf78f9b240d1435f936569273f4 439791 libnice_0.1.18.orig.tar.gz
 0e1af924bb47a7751704554a0ecee0308674d279ef821b2e778a8b4996642cc4 195 libnice_0.1.18.orig.tar.gz.asc
 863a0f1c711842b3279529b6cd43b608523a983180a8a8e14010301154669310 17136 libnice_0.1.18-2.debian.tar.xz
Files:
 408482fa4bab7c6b884b0fb9ad57a038 439791 libnice_0.1.18.orig.tar.gz
 98589eb001679b2edec11b27ff738f39 195 libnice_0.1.18.orig.tar.gz.asc
 df6849870e08e9accea12300d14bc6c5 17136 libnice_0.1.18-2.debian.tar.xz

-----BEGIN PGP SIGNATURE-----

iQFFBAEBCAAvFiEEmRrdqQAhuF2x31DwH8WJHrqwQ9UFAmHRdfQRHGJpZ29uQGRl
Ymlhbi5vcmcACgkQH8WJHrqwQ9V30AgAndTrvTGBoRYAyQiPSaWTL1iU51rUoj/w
K4sQ6CGZkFJ6ipg9Ju1LqZFVm7x5snDHmvDhCcEz9OeLWFv6NX02nJrGVtURVo0P
w/mGkojiWIaLhQfwhlaZgxJKAVjY/3t/DZhxx8cUkBcKNeVY5uu5k3Bk9uinjqet
f2o8vac0mAZ6UKbj7hBR1OWQT7hEmorbaKqwwurHE+Kg6gdqFKJo/BIsZk4F44BX
BXnVFLboVplhY3nJw5P9y6su51haQy8Af8DqkCsr09kfzpYxTDgxKLh36q7CQHwh
GdCbWJU1CAYysuHf0AuqiyTzKyUPliQDFmxiwm+JJkGuHaF+Qrk1Sw==
=QBJZ
-----END PGP SIGNATURE-----
