-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: umockdev
Binary: umockdev, libumockdev0, libumockdev-dev, gir1.2-umockdev-1.0
Architecture: any
Version: 0.17.7-1
Maintainer: Martin Pitt <mpitt@debian.org>
Homepage: https://github.com/martinpitt/umockdev/
Standards-Version: 4.6.0
Vcs-Browser: https://salsa.debian.org/debian/umockdev
Vcs-Git: https://salsa.debian.org/debian/umockdev.git
Testsuite: autopkgtest
Testsuite-Triggers: @builddeps@, evtest, gphoto2, usbutils, xinput, xserver-xorg-input-evdev, xserver-xorg-input-synaptics, xserver-xorg-video-dummy
Build-Depends: debhelper-compat (= 13), meson, pkg-config, valac (>= 0.16.1), libglib2.0-dev (>= 2.32.0), libudev-dev, libgudev-1.0-dev, libpcap-dev, python3-gi, gobject-introspection, libgirepository1.0-dev, gir1.2-glib-2.0, gir1.2-gudev-1.0, gtk-doc-tools, help2man, udev <!nocheck>, usbutils <!nocheck>
Package-List:
 gir1.2-umockdev-1.0 deb introspection optional arch=any
 libumockdev-dev deb libdevel optional arch=any
 libumockdev0 deb libs optional arch=any
 umockdev deb devel optional arch=any
Checksums-Sha1:
 e0b2aa28b932e78d12e339e9bc63719883d1f9bd 486964 umockdev_0.17.7.orig.tar.xz
 2544b47ce1f5c70f80d3285a27858576ce66772f 7676 umockdev_0.17.7-1.debian.tar.xz
Checksums-Sha256:
 05d642a16dd01cce0eb9ee1ba6e485b2ec08535bec679a63a95bfd4df18d0bb5 486964 umockdev_0.17.7.orig.tar.xz
 3adb2965ce6219a111965454ac7250f87824c0c607d785ecf89827d40b13c4e2 7676 umockdev_0.17.7-1.debian.tar.xz
Files:
 1dfefc76e6e61a22ccd46c5593c7cc74 486964 umockdev_0.17.7.orig.tar.xz
 d75ee4c847fbce619a7adda813dbbbbe 7676 umockdev_0.17.7-1.debian.tar.xz

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEPbRrVe+lnUDmIyFI0U7xXa/hE0cFAmIdtTcACgkQ0U7xXa/h
E0ca+Q//ROEouwMkfmk/CJcQDE+hBojcLeKcuNvBkvFsvy2GBcfSmz2N6XL7aJFk
axrZA5BXhlInXh0dSSiJbc1ud9yg3ZgwWGyj4c/9zNSqILNiv5hqYIWeXQIdbBdR
7UUAOIi6KGHIR4deJLt7Bhx1QARdAYmfE3yjHoN5uNR25FputtaXYy3DIQu3JUf9
VBCrs6BjlKu0JbclkMaV8bM+gF9rKHS1+FImr4zSLW+x9GHFZQZtE/jKynEBhn12
3hjCN8e4X1P+nSG2++7otoG10bIBvQBOf7Qr6o9O2NKgWurG+04Mj625f2vYNtlg
CBsrQBGqIL5EcNGn0dWMNnk4TdQCRGJuoH5E35MnC5BBpuDQ3PiRRwpleVsqsLlQ
jUOzZzk069rhwVVwh2srfTv1RkOC/z6bnbEuuo34tdJoUuCTPDi0XQ+HLZQzzRgK
a5djGwJOuSgoiJ3TwLja2GZ3UXRh4JhfkSWG5KZ2A0dcbZOfh6myAehOurH4ITvS
R0XWRTDo8HDHsLJ7gMpyJgmDD0WcjjMK8G00oGYDTNF7zLCFnLjgtTGa0iZTHamq
T8hipQilSBJGTEmohExH2gAXIqYqVAgbxY20pmYXKJscPIKdbk7pNlOBvhp91oYp
vxldEzQ9mXfrkptqIEp85ZOgMuuXGag5JFEaCDS4gxx5RKVJO4E=
=rjHf
-----END PGP SIGNATURE-----
