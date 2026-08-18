-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: glib2.0
Binary: libglib2.0-0, libglib2.0-tests, libglib2.0-udeb, libglib2.0-bin, libglib2.0-dev, libglib2.0-dev-bin, libglib2.0-data, libglib2.0-doc
Architecture: any all
Version: 2.72.4-0ubuntu2.2
Maintainer: Ubuntu Developers <ubuntu-devel-discuss@lists.ubuntu.com>
Uploaders: Iain Lane <laney@debian.org>, Jeremy Bicha <jbicha@ubuntu.com>, Simon McVittie <smcv@debian.org>
Homepage: https://wiki.gnome.org/Projects/GLib
Standards-Version: 4.6.0
Vcs-Browser: https://salsa.debian.org/gnome-team/glib/tree/ubuntu/jammy
Vcs-Git: https://salsa.debian.org/gnome-team/glib.git -b ubuntu/jammy
Testsuite: autopkgtest
Testsuite-Triggers: build-essential, dbus, dbus-x11, dpkg-dev, gnome-desktop-testing, locales, locales-all, xauth, xvfb
Build-Depends: dbus <!nocheck> <!noinsttest>, debhelper-compat (= 13), dh-sequence-python3, dh-sequence-gnome, docbook-xml, docbook-xsl, dpkg-dev (>= 1.17.14), gettext, libdbus-1-dev (>= 1.2.14) <!nocheck> <!noinsttest>, libelf-dev (>= 0.142), libffi-dev (>= 3.3), libgamin-dev [hurd-any] | libfam-dev [hurd-any], libmount-dev (>= 2.35.2-7~) [linux-any], libpcre3-dev (>= 1:8.35), libselinux1-dev [linux-any], libxml2-utils, linux-libc-dev [linux-any], meson (>= 0.52.0), pkg-config (>= 0.16.0), python3-distutils, python3:any (>= 2.7.5-5~), xsltproc, zlib1g-dev
Build-Depends-Arch: desktop-file-utils <!nocheck>, locales <!nocheck> | locales-all <!nocheck>, python3-dbus <!nocheck>, python3-gi <!nocheck>, shared-mime-info <!nocheck>, tzdata <!nocheck>, xterm <!nocheck>
Build-Depends-Indep: gtk-doc-tools (>= 1.32.1)
Package-List:
 libglib2.0-0 deb libs optional arch=any
 libglib2.0-bin deb misc optional arch=any
 libglib2.0-data deb libs optional arch=all
 libglib2.0-dev deb libdevel optional arch=any
 libglib2.0-dev-bin deb libdevel optional arch=any
 libglib2.0-doc deb doc optional arch=all
 libglib2.0-tests deb libs optional arch=any profile=!noinsttest
 libglib2.0-udeb udeb debian-installer optional arch=any profile=!noudeb
Checksums-Sha1:
 abb94eb7a918382272c98b39d70cad0a5bc02275 4884256 glib2.0_2.72.4.orig.tar.xz
 a3d4b855abbf92635da4021816b321b60cab6c68 128540 glib2.0_2.72.4-0ubuntu2.2.debian.tar.xz
Checksums-Sha256:
 8848aba518ba2f4217d144307a1d6cb9afcc92b54e5c13ac1f8c4d4608e96f0e 4884256 glib2.0_2.72.4.orig.tar.xz
 a4e09699a85f1c2e9d88e7d16af85ca19709a0e9ef86c17adf7b315fff72547c 128540 glib2.0_2.72.4-0ubuntu2.2.debian.tar.xz
Files:
 bfecfad1ab9754d3b8534fb99f1efaec 4884256 glib2.0_2.72.4.orig.tar.xz
 a05c31f676b189df3313f0380d735975 128540 glib2.0_2.72.4-0ubuntu2.2.debian.tar.xz
Debian-Vcs-Browser: https://salsa.debian.org/gnome-team/glib
Debian-Vcs-Git: https://salsa.debian.org/gnome-team/glib.git
Original-Maintainer: Debian GNOME Maintainers <pkg-gnome-maintainers@lists.alioth.debian.org>

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEUMSg3c8x5FLOsZtRZWnYVadEvpMFAmSCS2wACgkQZWnYVadE
vpNbzg//UlNfxckDc5whrdnUVXZnc1uX5rtF9Ya1jZF5BwgZxWYfKhkdBIbJ+G01
WOGGJ8tFbIqJB5cNiCV778Mq8qM8Vgt18eTqVbBdxnI+hIYhyDw+EVgW5eAKk2bz
74l+OrMfY5zFtTNbZExAKgsb3Sfp9RSlkSHCcJltfNtvqg7DTFohOVhhBJQOzuMI
M3GxPkz9uEtkdi1UZGtsg69TNfS+gSGf3JsH75yBVrkxv3VOCuZ0lOvOtr5dIXXd
PaL7qiuPfIjmPhlatY/TeOVspiweYExpHtGvNnwG+M0zClpMuDcAThfah6/7aWnn
lrKmcxD5xfBevjIOcAF7uZLq7qsd4YEPC1Tturb69YIhcqVh0JmGOBtYDZvqINJG
ZFmZ2aZdVO1sOxGtg3r6R/+oVCjlfi5kpvLPQbSruuGCoT53h6Dl6DE59j3VMP41
f+2zKpHJYxCwCG3ncztOB2wEIIpnn+skCoU4Q4V8jrVKFTSuw9AQ6kp9CqBTtrXW
8qQqVYyIoQpVSAh7++8gcVZDAriGvKFjyfOwUqnuWaR94c4CSMvjjk5eTo15PFKj
Q2e9Mu4qOQhdlSGAzBCpyImi8vZznzz9M1MSxGtFJVUVtTCcsCegY9L9xO6tD+0v
uBPzQKgPcE2NflsfaDBvaG2baJp/RItb1uH46sXOAgQWhDGNAUQ=
=mR1N
-----END PGP SIGNATURE-----
