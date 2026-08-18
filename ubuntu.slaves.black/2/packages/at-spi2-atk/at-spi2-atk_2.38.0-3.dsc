-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: at-spi2-atk
Binary: libatk-adaptor, libatk-adaptor-udeb, libatk-bridge2.0-0, libatk-bridge-2.0-0-udeb, libatk-bridge2.0-dev
Architecture: any
Version: 2.38.0-3
Maintainer: Debian Accessibility Team <pkg-a11y-devel@alioth-lists.debian.net>
Uploaders: Samuel Thibault <sthibault@debian.org>, Jordi Mallach <jordi@debian.org>
Homepage: https://wiki.gnome.org/Accessibility
Standards-Version: 4.6.0
Vcs-Browser: https://salsa.debian.org/a11y-team/at-spi2-atk
Vcs-Git: https://salsa.debian.org/a11y-team/at-spi2-atk.git
Testsuite: autopkgtest
Testsuite-Triggers: @builddeps@, at-spi2-core, build-essential, dbus, xauth, xvfb
Build-Depends: at-spi2-core <!nocheck>, dbus <!nocheck>, debhelper-compat (= 13), libdbus-1-dev, libatk1.0-dev (>= 2.36.0~), libatspi2.0-dev (>= 2.33.92), libglib2.0-dev, libxml2-dev (>= 2.9.1), libx11-dev, meson (>= 0.40), xauth <!nocheck>, xvfb <!nocheck>
Package-List:
 libatk-adaptor deb misc optional arch=any
 libatk-adaptor-udeb udeb debian-installer optional arch=any
 libatk-bridge-2.0-0-udeb udeb debian-installer optional arch=any
 libatk-bridge2.0-0 deb libs optional arch=any
 libatk-bridge2.0-dev deb libdevel optional arch=any
Checksums-Sha1:
 fc0a650bb0dd137889e882e33d9235ee9115df34 97464 at-spi2-atk_2.38.0.orig.tar.xz
 0f70243b4bcbd6c97466337be43895546e6bb0b8 10740 at-spi2-atk_2.38.0-3.debian.tar.xz
Checksums-Sha256:
 cfa008a5af822b36ae6287f18182c40c91dd699c55faa38605881ed175ca464f 97464 at-spi2-atk_2.38.0.orig.tar.xz
 4209f16cfb970c97320fb9842604edf4c3ea362de29ba0b00e22543b023838f2 10740 at-spi2-atk_2.38.0-3.debian.tar.xz
Files:
 aed95be54ef213d210331dda88298b92 97464 at-spi2-atk_2.38.0.orig.tar.xz
 92367a1822a77af0fa214ba293cc60cd 10740 at-spi2-atk_2.38.0-3.debian.tar.xz

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEi6MnFvk67auaclLJ5pG0tXV4H2IFAmH1Pe8ACgkQ5pG0tXV4
H2K2lw//V8ntavnPdzg2sfOploc0QoVsbo44LyimKI0HdcaqOkCJBO+JLSW+uHw+
os2GD0e6nSTP8zqdSTkc2J9YHx7hetBzoKmU8uu1M0gNBwBd4iEM/iJ+l91r0S3G
lnEEJm1tWB/ScxqxVTaMtIMWV+aq4TNqY6Ntc5KH6S08Wm87I2IhRotZ4oO3cWZP
rK2VsVd6hfgUucZjUtQwozdCuv/5xewCa20KRV9+3WovNx4/QKVGHJ0/yswfMB0I
VNfyFbiiC7mFI7hVTMLUpftZy0LZa7cwg6byjuW7hI46SKRGO/FgGqzsM60A5Olp
/2kY2r22z6V6VlbwT774HXe8m6bNsgx1gr0vYxK7164WYEGXOcOBYAnHhlCkak/p
t77qGVA3bW10i/DNinNybc+LBt8659tgMNnHLWBqxjAl3VhmfayFBRqKT4nqZFXf
pJwotaGR6jXzrwA8Q95WiHffBqIKytKxqwPvAMEnOVPRR1KSyfCMdRll3qBEm25v
LTdP8llDt7nM15r6l83MnBz4VJ/iSeSGiRxfWAwUiJ1M2Dy4bRMrmvM6eOtZL1d2
vW7HSpqaPoWzxee9JXH0KDjIc69gcj3BpQSr3MJ12g7j7d8FNyg3sUlBBUHrl6q5
D7aGrQfWeve0SBtwpaGKl+aJk2oYK0UEEuc52hBS3xZVoGeV4PU=
=WE0t
-----END PGP SIGNATURE-----
