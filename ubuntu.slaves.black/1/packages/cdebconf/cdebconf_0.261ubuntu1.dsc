-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

Format: 3.0 (native)
Source: cdebconf
Binary: cdebconf, cdebconf-gtk, libdebconfclient0, libdebconfclient0-dev, cdebconf-udeb, cdebconf-priority, libdebconfclient0-udeb, cdebconf-text-udeb, cdebconf-newt-udeb, cdebconf-gtk-udeb
Architecture: any all
Version: 0.261ubuntu1
Maintainer: Ubuntu Developers <ubuntu-devel-discuss@lists.ubuntu.com>
Uploaders:  Colin Watson <cjwatson@debian.org>, Cyril Brulebois <kibi@debian.org>
Standards-Version: 3.9.7
Vcs-Browser: https://salsa.debian.org/installer-team/cdebconf
Vcs-Git: https://salsa.debian.org/installer-team/cdebconf.git
Build-Depends: debhelper-compat (= 12), po-debconf (>= 0.5.0), libslang2-dev, libnewt-dev, libtextwrap-dev (>= 0.1-5), libdebian-installer4-dev (>= 0.41) | libdebian-installer-dev, libglib2.0-dev (>= 2.50), libgtk2.0-dev (>= 2.24) <!pkg.cdebconf.nogtk>, libcairo2-dev (>= 1.8.10-3) <!pkg.cdebconf.nogtk>, libselinux1-dev (>= 2.3) [linux-any] | libselinux-dev [linux-any], dh-autoreconf, dh-exec
Package-List:
 cdebconf deb utils optional arch=any
 cdebconf-gtk deb admin optional arch=any profile=!pkg.cdebconf.nogtk
 cdebconf-gtk-udeb udeb debian-installer optional arch=any profile=!pkg.cdebconf.nogtk,!noudeb
 cdebconf-newt-udeb udeb debian-installer optional arch=any profile=!noudeb
 cdebconf-priority udeb debian-installer standard arch=all profile=!noudeb
 cdebconf-text-udeb udeb debian-installer optional arch=any profile=!noudeb
 cdebconf-udeb udeb debian-installer standard arch=any profile=!noudeb
 libdebconfclient0 deb libs optional arch=any
 libdebconfclient0-dev deb libdevel optional arch=any
 libdebconfclient0-udeb udeb debian-installer optional arch=any profile=!noudeb
Checksums-Sha1:
 ee756606e7f2e4a6d29607ef6d0261bd903f6c53 297016 cdebconf_0.261ubuntu1.tar.xz
Checksums-Sha256:
 e262301dbe365c56d5c15b0f30ce09d33bbc110303179f0300fb27bfe0443aa2 297016 cdebconf_0.261ubuntu1.tar.xz
Files:
 4cf4eb6264031477c2d1f628725800c7 297016 cdebconf_0.261ubuntu1.tar.xz
Original-Maintainer: Debian Install System Team <debian-boot@lists.debian.org>

-----BEGIN PGP SIGNATURE-----

iQJEBAEBCAAuFiEE1WVxuIqLuvFAv2PWvX6qYHePpvUFAmH9r3kQHGRva29AdWJ1
bnR1LmNvbQAKCRC9fqpgd4+m9YynEACw901Win6QInYZHsJn9c5oviu5ePgePO/P
3XYdLqCHXBnrDrxslZ9ABKSGEVK2i1hLMiNMIEs4WEM+jYzBa3HFCJReUcZR9Hzx
EPM2YB2PFdFkQ3LGyASvhO5BCUQx4ffb0j6lHZ3onjI4qILNrjGkVsoI+LL4HRL8
usSGUIMU8T+Yn9BQQtsTsv9lWS8IcVBQY5FBvURNrGlbTEf3sg46wtAkTS093iqB
05zZ80dkPdqWpZNi0rOTtjHjoWCe36FeGbby0UMKbEYquG9e3KCfDX9DREIBmDO+
uhSPYjP/ny7ff2jdbj/5kq76fQED5oUns9isXDE+0kssJvkayLzkvN/7gcKLGBhw
bnKK5f5fMujPfZSJo0zzRT5B8LJnzwa6E/r/TaqcMoUbQrMhdud7dAqiZ2B1UVpW
2FV6ymB5wW5t2z1x4JFWJ7iNz3zAEXuoWtzV9Cm6EG5rvnG19tedIvZH42Sa4nIf
x/zsxMSzqMPBVObS/y3I2xgqsXu3/LYIvDhiJ8LDv8pq46yJlwBPNHQlp3unRMgb
OO4VWlDzCdJBWQQ50ZdmmmDaZne/QWLg1A5Fbtpqf0/MpE0o42X79Qyslo2ntePR
pjcXtzFl3w0rpBp9puj+J1c6ZClG0VfWsynVFBlz38LK+FzjeZFKd76cZGpWJv0u
AjVugRDDXA==
=mJXZ
-----END PGP SIGNATURE-----
