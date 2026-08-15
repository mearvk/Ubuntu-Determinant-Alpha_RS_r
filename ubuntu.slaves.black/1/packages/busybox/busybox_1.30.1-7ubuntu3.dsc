-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: busybox
Binary: busybox, busybox-static, busybox-initramfs, busybox-udeb, busybox-syslogd, udhcpc, udhcpd
Architecture: any all
Version: 1:1.30.1-7ubuntu3
Maintainer: Ubuntu Developers <ubuntu-devel-discuss@lists.ubuntu.com>
Uploaders:  Chris Boot <bootc@debian.org>, Christoph Biedl <debian.axhn@manchmal.in-ulm.de>,
Homepage: http://www.busybox.net
Standards-Version: 4.1.5
Vcs-Browser: https://salsa.debian.org/installer-team/busybox
Vcs-Git: https://salsa.debian.org/installer-team/busybox.git
Build-Depends: debhelper (>= 11~), zip
Package-List:
 busybox deb utils optional arch=any
 busybox-initramfs deb shells optional arch=any
 busybox-static deb shells optional arch=any
 busybox-syslogd deb utils optional arch=all
 busybox-udeb udeb debian-installer optional arch=any
 udhcpc deb net optional arch=linux-any
 udhcpd deb net optional arch=linux-any
Checksums-Sha1:
 5d9a78fa2789cd22cdac78058296e195e67faf59 7793781 busybox_1.30.1.orig.tar.bz2
 e50a175f94b7c5f74d7687c75f81c2827f25b66c 68652 busybox_1.30.1-7ubuntu3.debian.tar.xz
Checksums-Sha256:
 3d1d04a4dbd34048f4794815a5c48ebb9eb53c5277e09ffffc060323b95dfbdc 7793781 busybox_1.30.1.orig.tar.bz2
 4449e5cd772947f776f27b48d22b18b0e9d6d2cac9729692a646ca19e9c0ad86 68652 busybox_1.30.1-7ubuntu3.debian.tar.xz
Files:
 4f72fc6abd736d5f4741fc4a2485547a 7793781 busybox_1.30.1.orig.tar.bz2
 3e0b2bba475f673b66e19af4e5b964bb 68652 busybox_1.30.1-7ubuntu3.debian.tar.xz
Original-Maintainer: Debian Install System Team <debian-boot@lists.debian.org>

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE7iQKBSojGtiSWEHXm47ISdXvcO0FAmH90zAACgkQm47ISdXv
cO1CqhAAsnvTJPddct3ExcZvyEzoZ0kGL9SsbUoRw5apb2LzlzRP70Ui/q4oAbw+
jiPQ0A9mauESE6M3nNsnZ5p4LdA/SRGqqq49VkNMw4geGQ8o8TJwLytLRmmlk8Uf
ZGkCs1APpt71dhnKTcHoJvpUZxSf4+ZTX8RTjvNq6cGuaBaI1uPE1In9AMpeEZrj
PVhZph5ICj0jtl3dPbQ43eOuOmBwpvIUHQqgl9AOdFz02PQwo7SLJNbMOnH2o6Sx
lj8RPEk0LOQifF35J1ipB0ExSXItUO8+rWoTTj9kjhzsi+vrvWsciMa7rrCDc3x/
xfRy/Oxr1iCgTQv0X3jLsFRIddZBuTs0sroXFQrR3rkexCXEkmJEe+upLTXOoU5X
n8IZrLb8CdtPGmZG/4AkovW2upG2bVkMxfQlkLhyjc2aUQfU7Kx3PFSd9OlXcf1w
LBcE+nD3+9VlhyodTisRwGfvwNW9WyKVPvxml1koWMmPe04JFv8MO2W1gWcxFCuB
doylROZZXPMlj/xS6oUuK1IWj4xcumyszTPjAdyWVX1f5l0L4obGpVaTJl2Qu7cB
XFTNpQj0Q4ZRePfkPDmG7bi69JsIZhGEMz+r697q49tAMHOayqSt5FD87UINoN80
6pRuu6Mzr3oujw5yfq58AJLRbgzEhRT0/Y8BV/P8z3qDhfW5U2o=
=tNs1
-----END PGP SIGNATURE-----
