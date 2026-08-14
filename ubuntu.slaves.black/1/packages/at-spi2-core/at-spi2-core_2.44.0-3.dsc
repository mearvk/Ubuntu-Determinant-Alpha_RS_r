-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: at-spi2-core
Binary: at-spi2-core, at-spi2-core-udeb, libatspi2.0-0, libatspi0-udeb, libatspi2.0-dev, gir1.2-atspi-2.0, at-spi2-doc
Architecture: any all
Version: 2.44.0-3
Maintainer: Debian Accessibility Team <pkg-a11y-devel@alioth-lists.debian.net>
Uploaders: Samuel Thibault <sthibault@debian.org>, Jordi Mallach <jordi@debian.org>
Homepage: https://wiki.gnome.org/Accessibility
Standards-Version: 4.6.0
Vcs-Browser: https://salsa.debian.org/a11y-team/at-spi2-core
Vcs-Git: https://salsa.debian.org/a11y-team/at-spi2-core.git
Testsuite: autopkgtest
Testsuite-Triggers: build-essential, dbus, xauth, xvfb
Build-Depends: debhelper-compat (= 13), dbus, libdbus-1-dev, dbus-broker [linux-any], libsystemd-dev [linux-any], gedit <!nocheck>, libglib2.0-dev (>= 2.62), libx11-dev, libxtst-dev, meson, libgirepository1.0-dev, gtk-doc-tools, gobject-introspection | dh-sequence-gir, xauth <!nocheck>, xvfb <!nocheck>
Package-List:
 at-spi2-core deb misc optional arch=any
 at-spi2-core-udeb udeb debian-installer optional arch=any
 at-spi2-doc deb doc optional arch=all
 gir1.2-atspi-2.0 deb introspection optional arch=any
 libatspi0-udeb udeb debian-installer optional arch=any
 libatspi2.0-0 deb libs optional arch=any
 libatspi2.0-dev deb libdevel optional arch=any
Checksums-Sha1:
 2cf6e57c70e0b65cb766d0aeac0023993905acdb 209692 at-spi2-core_2.44.0.orig.tar.xz
 d320f07fc1aa94c7497fc03d37bad96d8c81f3b0 11896 at-spi2-core_2.44.0-3.debian.tar.xz
Checksums-Sha256:
 7eee3cf285b089060fd6b6e51b3eb2cacf752cca3a082c7f4c2c5ab841e51353 209692 at-spi2-core_2.44.0.orig.tar.xz
 60c996f063bb9722c729aa191b9e7a0ef51e479872544cf008d613ddb6a22c6d 11896 at-spi2-core_2.44.0-3.debian.tar.xz
Files:
 4bb4e416b8c4739b6c6e2472e2660d8d 209692 at-spi2-core_2.44.0.orig.tar.xz
 5a82d6141f5010f1bb1e26c76d34c7c6 11896 at-spi2-core_2.44.0-3.debian.tar.xz

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEi6MnFvk67auaclLJ5pG0tXV4H2IFAmI+AusACgkQ5pG0tXV4
H2L/+xAAvfrhq4sdP2F065M1svzWBb9u4OsFgb2662gFVoUf60aDf50peq5HjFQR
UmM5IvavjBW9ZV1Ew14IUSDp3d4VeJOs/c8RIcoxk9i5Wuiiojp+v9dbUoTIHwJh
tisRbm7rniUJCi2a8xJ6yIHe7UoV2sQz1J+fYnprfqb3catDffJsrxOJ7EVHr6t0
MMZB6nfoXpmKldIVHtTfOnIj9MHRD0wBD6ZHA8hGLtTODb2XpNqlhZkjlpx1NKiX
hud65IZxvqo2c9ML6O0l42WOIp9NkwYHOg8yRBZGS7rAPobTBGAp6YbIXibwNZag
wYFBZz8692RxAiBxusb0JmJ0i+QYtATwOWT2gPnO948GdsAnfm/2ZPSgRPb1VnAD
psg3JVelHHzPYUod/ukIhnIfT6JJyvgZIbHVqqDk1pIxUu1VbHQ+BmuQcJxNY8i7
RaeGDNAcbuInuCGTxQPsygEmXpxyRNQYob9m8QmK+4efxmD574+igrD+2/ju1P81
OYc4Cc+K/9RguoBqSrIu9PxIJAOnikswThctOh4A3foxddm7p5HdGxRg6rGdf+MF
FazWyvUTe+t+F/6cOSpGd2YIxOjEEXm75FcuKgJdH5ow7DN4Y0DnLeN3dMrLiRrE
7KbTUk1JTvNcjpwU5vSMU6pc64NJXiJARxBp6KqJ0QNNGjx9gs8=
=5eoJ
-----END PGP SIGNATURE-----
