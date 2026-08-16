-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: gjs
Binary: gjs, gjs-tests, libgjs0g, libgjs-dev
Architecture: any
Version: 1.72.2-0ubuntu2
Maintainer: Ubuntu Developers <ubuntu-devel-discuss@lists.ubuntu.com>
Uploaders: Iain Lane <laney@debian.org>, Jeremy Bicha <jbicha@ubuntu.com>, Tim Lunn <tim@feathertop.org>
Homepage: https://gitlab.gnome.org/GNOME/gjs/wikis
Standards-Version: 4.6.0
Vcs-Browser: https://salsa.debian.org/gnome-team/gjs/tree/ubuntu/jammy
Vcs-Git: https://salsa.debian.org/gnome-team/gjs.git -b ubuntu/jammy
Testsuite: autopkgtest
Testsuite-Triggers: build-essential, dbus, dbus-x11, gnome-desktop-testing, xauth, xvfb
Build-Depends: debhelper-compat (= 13), dh-sequence-gir, dh-sequence-gnome, pkg-config (>= 0.28), libcairo2-dev, libffi-dev (>= 3.3), libglib2.0-dev (>= 2.58.0), libgirepository1.0-dev (>= 1.64), gir1.2-gtk-3.0, gobject-introspection (>= 1.64), libmozjs-91-dev (>= 91.3.0), libreadline-dev, meson (>= 0.50.0), dbus <!nocheck>, dbus-x11 <!nocheck>, at-spi2-core <!nocheck>, xauth <!nocheck>, xvfb <!nocheck>
Package-List:
 gjs deb interpreters optional arch=any
 gjs-tests deb interpreters optional arch=any
 libgjs-dev deb libdevel optional arch=any
 libgjs0g deb libs optional arch=any
Checksums-Sha1:
 f8a5f4c9257fbf933b0cb2425c81037f8185512f 620380 gjs_1.72.2.orig.tar.xz
 391f057cc9002752d9727d5a2f006b674e55aca2 23408 gjs_1.72.2-0ubuntu2.debian.tar.xz
Checksums-Sha256:
 ddee379bdc5a7d303a5d894be2b281beb8ac54508604e7d3f20781a869da3977 620380 gjs_1.72.2.orig.tar.xz
 a9e6949b9af926ae6d9373cecd0ba803e3ce6df27194d5dcb0cdfececfc94495 23408 gjs_1.72.2-0ubuntu2.debian.tar.xz
Files:
 e0a715951ee3941132f5b1149f28ba5d 620380 gjs_1.72.2.orig.tar.xz
 7ff60e634775994a8ee62d7c76be9a12 23408 gjs_1.72.2-0ubuntu2.debian.tar.xz
Debian-Vcs-Browser: https://salsa.debian.org/gnome-team/gjs
Debian-Vcs-Git: https://salsa.debian.org/gnome-team/gjs.git
Original-Maintainer: Debian GNOME Maintainers <pkg-gnome-maintainers@lists.alioth.debian.org>

-----BEGIN PGP SIGNATURE-----

iQJJBAEBCgAzFiEEO+EUUxKLErUg53wTEr7aOaHncEIFAmRvXq4VHGRnYWRvbXNr
aUB1YnVudHUuY29tAAoJEBK+2jmh53BCfYUP/1PuxS0ad3OSkJF+fmP7kFk32yWV
IovvSW8Urm5UnKTR04qa6CyRkqxeDpOZ9TbhfnDBUJ0TVwqyh8gVmNLwrhrM59Pe
gpQTkHkSShfeuu08FEcCE5XZM3h42xXILUqknt53gXschZzEmP7jU+6zoVpbDYRx
9JxQ+oTqwNf+l8UJ6MjtDK6La96iy6HnFv0jU5x0rLm/Yy4vkNeVhUc9gTUe2NQj
0aC0IZQSApbgLDGWufl28QBYtto0frrEzA1xWnc3E2LcofK5n9KBmf7fjntfUW/0
k5BHnZjs3b8D6pVe5bWQlegnbcycIhbMsgg7hqgHfwZbhCATATEXxhEhyc5cFXmy
/c9jorItBpViv7r1Gx5yo27EWxevGKDavme3TyE+rTrQytkcVBVJGxJKV4lQjUp1
mTSxiUf+faE/YiTSjaiTI4f8fYp7GfAeYJgf6ovIcKEn4W4tJbjs9Q6hLcI9CX25
CM2kn3eIURHWnCu9bnQuIEypltHkyxK0vf8QRbcSW0Dxzj9C1RsAiwCBlNKnxzyh
wMxNc3+Ux8Qt/MIN4qmAKz9jhQIu6frQBb7aa9F6J2+VmJGDYqXUqJuGPQsCsX6r
rnrRW88t8/Mmo1GU/iGRinkpdh/ACutd4nFJiJsBY+ydzHosXmrK9V1rdB752XDm
gZVsQ8zGSR8Hz5PW
=aUkG
-----END PGP SIGNATURE-----
