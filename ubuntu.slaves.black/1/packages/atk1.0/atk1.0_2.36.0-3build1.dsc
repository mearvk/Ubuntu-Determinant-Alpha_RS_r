-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: atk1.0
Binary: libatk1.0-0, libatk1.0-udeb, libatk1.0-data, libatk1.0-dev, libatk1.0-doc, gir1.2-atk-1.0
Architecture: any all
Version: 2.36.0-3build1
Maintainer: Debian Accessibility Team <pkg-a11y-devel@alioth-lists.debian.net>
Uploaders: Debian GNOME Maintainers <pkg-gnome-maintainers@lists.alioth.debian.org>, Samuel Thibault <sthibault@debian.org>, Jeremy Bicha <jbicha@debian.org>
Homepage: https://wiki.gnome.org/Accessibility
Standards-Version: 4.5.0
Vcs-Browser: https://salsa.debian.org/gnome-team/atk
Vcs-Git: https://salsa.debian.org/gnome-team/atk.git
Testsuite: autopkgtest
Testsuite-Triggers: build-essential
Build-Depends: debhelper-compat (= 12), dh-sequence-gir, dh-sequence-gnome, gtk-doc-tools (>= 1.13), libglib2.0-dev (>= 2.38.0), libgirepository1.0-dev (>= 1.32.0), meson (>= 0.46.0), pkg-config
Build-Depends-Indep: docbook-xml <!nodoc>, libglib2.0-doc <!nodoc>
Package-List:
 gir1.2-atk-1.0 deb introspection optional arch=any
 libatk1.0-0 deb libs optional arch=any
 libatk1.0-data deb misc optional arch=all
 libatk1.0-dev deb libdevel optional arch=any
 libatk1.0-doc deb doc optional arch=all profile=!nodoc
 libatk1.0-udeb udeb debian-installer optional arch=any
Checksums-Sha1:
 7e4accf756bb76323acf7f91d8618e739aff56e6 299100 atk1.0_2.36.0.orig.tar.xz
 ed292ce926c5f30a0fdd229689d9b06608854514 12228 atk1.0_2.36.0-3build1.debian.tar.xz
Checksums-Sha256:
 fb76247e369402be23f1f5c65d38a9639c1164d934e40f6a9cf3c9e96b652788 299100 atk1.0_2.36.0.orig.tar.xz
 2122335c9ac1e98a959766838fbb4b0dfefdcda8b89ddb6a34286655e33ac646 12228 atk1.0_2.36.0-3build1.debian.tar.xz
Files:
 01aa5ec5138f5f8c9b3a4e3196ed2900 299100 atk1.0_2.36.0.orig.tar.xz
 0b576ee2bbad7aa945f0f90854d11fa0 12228 atk1.0_2.36.0-3build1.debian.tar.xz

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEqx+XcX7ftBm4bj5/AhnKGdA0MwwFAmI6604ACgkQAhnKGdA0
MwwcYwf7BfvieXrsCJ/6jRXJ4vThPdXVQzNWKvT1zR34APWiYdsjiY/Ll14jtbqo
6IzoQGDVkC1wfEal+DW7go9Im09SWxHt6FJyUGbBBeoJFURa9JkeE3sy7SFlzGLP
R0eKvs8IIthNtS8vTKMA1cXVw+BTB6AsfQ+9ZvIEByyWDXqLgg/O1hzjP0avxi52
sYRGZ1BHUm5DCb0nMbiorQyR+19oUouYXtfXfJg9xrY2oiMzNkrlL/ry9ufTfiqG
mcw2X2kCcbMLyZ42VMYMhGTH5GPvgp2b/YxXhLrDkvxLswD2EIiqX3fjQ5soWspW
QB1r3CXMhMaT5ECcCINRHC201eZl+Q==
=ZXEZ
-----END PGP SIGNATURE-----
