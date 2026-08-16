-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: glade
Binary: libgladeui-2-13, libgladeui-common, libgladeui-dev, libgladeui-doc, gir1.2-gladeui-2.0, glade
Architecture: any all
Version: 3.38.2-7
Maintainer: Debian GNOME Maintainers <pkg-gnome-maintainers@lists.alioth.debian.org>
Uploaders: Jeremy Bicha <jbicha@debian.org>, Laurent Bigonville <bigon@debian.org>
Homepage: https://glade.gnome.org/
Standards-Version: 4.6.0
Vcs-Browser: https://salsa.debian.org/gnome-team/glade
Vcs-Git: https://salsa.debian.org/gnome-team/glade.git
Testsuite: autopkgtest
Testsuite-Triggers: build-essential, dbus, pkg-config, python3-gi, xauth, xvfb
Build-Depends: at-spi2-core <!nocheck>, dbus <!nocheck>, debhelper-compat (= 13), dh-sequence-gir, dh-sequence-gnome, itstool, libxml2-dev (>= 2.4.0), libgjs-dev (>= 1.64.0) [amd64 arm64 armel armhf i386 mips64el mipsel ppc64el s390x powerpc ppc64 riscv64], libglib2.0-dev (>= 2.64.0), libgtk-3-dev (>= 3.24.0), libwebkit2gtk-4.0-dev (>= 2.28.0) [!ia64 !kfreebsd-any], meson (>= 0.49.0), python-gi-dev (>= 3.8.0), python3-dev, gtk-doc-tools (>= 1.13) <!nodoc>, xauth <!nocheck>, xvfb <!nocheck>, libgirepository1.0-dev (>= 0.10.1)
Build-Depends-Indep: libglib2.0-doc <!nodoc>, libgtk-3-doc <!nodoc>
Package-List:
 gir1.2-gladeui-2.0 deb introspection optional arch=any
 glade deb devel optional arch=any
 libgladeui-2-13 deb libs optional arch=any
 libgladeui-common deb libs optional arch=all
 libgladeui-dev deb libdevel optional arch=any
 libgladeui-doc deb doc optional arch=all profile=!nodoc
Checksums-Sha1:
 d433fb5085c8f07d559f5a310be31238c1fdf36e 2709224 glade_3.38.2.orig.tar.xz
 8419eafd0e0468000e558a88b206d8de27144b84 23624 glade_3.38.2-7.debian.tar.xz
Checksums-Sha256:
 98fc87647d88505c97dd2f30f2db2d3e9527515b3af11694787d62a8d28fbab7 2709224 glade_3.38.2.orig.tar.xz
 00c97172f1ef055c5014612d29d723dc566ec2e0842ddc7e14c164dc62d72db7 23624 glade_3.38.2-7.debian.tar.xz
Files:
 f1ac9d9b6404308efb74adc548289455 2709224 glade_3.38.2.orig.tar.xz
 190e90df41487f2c31123ef2677c8d18 23624 glade_3.38.2-7.debian.tar.xz

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEETQvhLw5HdtiqzpaW5mx3Wuv+bH0FAmHv6DQACgkQ5mx3Wuv+
bH2NuRAAtVeR2YGlxunoB/Gjai5rpTJMZ6jxtusPM2jt+NlEVliaNGEpsHKvs7Wn
EQ+5KwbDk+eqtB2CMNNJsZdn6BJR0wy5PtZ3PwBNUmVxDjUAG+7tHLmh02a4fGHZ
LGvyAF2v9RHFmJ1uSzBchnL5AnGaCWA62vUsfbY73ULcL1TR5LmQ2J+eRgEGLAi2
IFwVFs4o3sKmDBFGIImJvAMJWPNxfyrNf2xn8xxM96dO3gE6UGlmsUsq9DFK4T+Q
4hMv+shX8EThcqUHI+M4xSjPNSEGeKbV/4ILfgE2LhYx/CpagEzBOMHZpX7qq1Lr
66nFLPk200AaYeINarIxv/F5Ei/p/CK95tJU7OubFJlNJrkYBOMFfKtYe36IXmXO
VpDMrr0qjUd6kay6Gn8+2IaZ+w/Vpy4DMXFFghJ8wiw08ohwF1ecCoIiT9hYN2I0
BI7pZdp/m6E8CxjBtIVeIRUzz172KE1BSpEZS1v7vf/sAGaFgHn6M2h/2XzcJp9O
T6VqPHL4NnOd8907U16DpV0ThoNvQOYjL0HDaRDax9kgwLcm2yoWgQO9j0oDXN5J
F2d4+YNU6EoHMBXImLSDjyGrMRIFjvmzC9D/ifBrgp3OLOhTdHaNw0kmPm0C0H7J
C0HBIdv/YuaXxrrJ81g9tMJqhznKDoimSGa8G7yrtVSuIoDF5FM=
=mlGh
-----END PGP SIGNATURE-----
