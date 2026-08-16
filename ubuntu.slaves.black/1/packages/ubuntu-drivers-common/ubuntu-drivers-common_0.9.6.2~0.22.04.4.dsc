-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (native)
Source: ubuntu-drivers-common
Binary: ubuntu-drivers-common, dh-modaliases, nvidia-common, fglrx-pxpress
Architecture: any all
Version: 1:0.9.6.2~0.22.04.4
Maintainer: Ubuntu Developers <ubuntu-devel-discuss@lists.ubuntu.com>
Standards-Version: 3.9.8
Vcs-Browser: https://github.com/tseliot/ubuntu-drivers-common
Vcs-Git: git://github.com/tseliot/ubuntu-drivers-common.git
Testsuite: autopkgtest
Testsuite-Triggers: alsa-utils, apport, gir1.2-umockdev-1.0, libgl1-mesa-glx, liblocale-gettext-perl, linux-headers, linux-headers-generic, python3-gi, umockdev
Build-Depends: debhelper (>= 9.20160709), dh-python, po-debconf, dh-apport, python3-all (>= 3.2), python3-setuptools, python3-click, libpci-dev, lib32gcc-s1 [amd64], libc6-i386 [amd64], linux-libc-dev, pkg-config, python3-xkit (>= 0.5.0), aptdaemon, python3-aptdaemon.test (>= 0.43+bzr810-0ubuntu2~), python3-gi, gir1.2-glib-2.0, gir1.2-umockdev-1.0, umockdev, alsa-utils, apt-utils, dbus, udev, pciutils, libdrm-dev, python3-dbus, libkmod-dev, pycodestyle | pep8, pyflakes3
Package-List:
 dh-modaliases deb admin optional arch=all
 fglrx-pxpress deb oldlibs extra arch=i386,amd64
 nvidia-common deb oldlibs extra arch=i386,amd64,armel,armhf
 ubuntu-drivers-common deb admin optional arch=any
Checksums-Sha1:
 edefea641fee36d735cb0997aaaee91055ae5527 102592 ubuntu-drivers-common_0.9.6.2~0.22.04.4.tar.xz
Checksums-Sha256:
 6302bd61441e107b5b3d7a58dde14f71c4c71f0f97cac72771bce9225ba0cfad 102592 ubuntu-drivers-common_0.9.6.2~0.22.04.4.tar.xz
Files:
 bc791236a86476eac4b55968cf37a776 102592 ubuntu-drivers-common_0.9.6.2~0.22.04.4.tar.xz

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE9q/FE/ywo6zf0Lkwk31r/rPJjt0FAmSQaIsACgkQk31r/rPJ
jt1drA//WMhlp77/EDmSp1fME5n0lyu38SRNuHh7Uiome5wXRXPvc9r1LxX/VBE1
Z1pf+XFlxvL9lSyhguCqwQJguW+R/8CbU5aLzKg3wbCbpV2OPDshcaIZn1ODqGJa
YcT2xyk+DNtE++j/9y8HnNE15ZPcIjiM7E2Ia3XT55K3q0tQ0DNVifaht6Ryo80i
SA0Y0KUS91rw4siowG7C5rwmAduhgbVrm0NimDDoqIeVR/Yw3ahbAXK4Rn7GPVLl
mEkgG8SfFD0iJ4K88yehiDEskSA/E++5CFXUmgH2uvV1XRrEEIhWM2oaNWCADE9+
E/Fn+xRWElkXh8gnYbCYeniq0rxHaZMtaY3E3n6vYSpuLXyTwvPwdKaTPDcs1GgJ
+weWTK1+buS+twvEIxt+70PHrZrCDDs58q0sKlmwt+PdqJUDsr6+k45qmtXI5XRc
siLruLg7eCu6qvu++n2IlE/1lz2NlQRTEMt/BJQAeU9bD5Pcou86va8yHKD5Q1Je
RGxuanh7sSEyt92fDdobNGxJen/0wp/oblq+7qww5KRnJ3P/oChiZRQiFUGMVV5m
FCiN49oMqFdoeOGTZVFUcJ8THnyM7nS6kdvXHCa1EWH5ekeDXv68eEuQqx8BOiD2
JuPHFUhIHDB8H99qeYjLa7PacenlhG/sy7AbFbhmv48ml4cp51w=
=14vG
-----END PGP SIGNATURE-----
