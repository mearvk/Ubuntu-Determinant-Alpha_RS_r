-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Format: 3.0 (quilt)
Source: network-manager
Binary: network-manager, network-manager-dev, libnm0, libnm-dev, gir1.2-nm-1.0, network-manager-config-connectivity-debian, network-manager-config-connectivity-ubuntu
Architecture: linux-any all
Version: 1.36.6-0ubuntu2
Maintainer: Ubuntu Developers <ubuntu-devel-discuss@lists.ubuntu.com>
Uploaders: Michael Biebl <biebl@debian.org>, Sjoerd Simons <sjoerd@debian.org>, Aron Xu <aron@debian.org>
Homepage: https://wiki.gnome.org/Projects/NetworkManager
Standards-Version: 4.6.0
Vcs-Browser: https://git.launchpad.net/network-manager
Vcs-Git: https://git.launchpad.net/network-manager
Testsuite: autopkgtest
Testsuite-Triggers: build-essential, dnsmasq-base, hostapd, isc-dhcp-client, iw, linux-headers-generic, python3, python3-dbusmock, python3-netaddr, rfkill, urfkill, wpasupplicant
Build-Depends: debhelper-compat (= 13), automake (>= 1.12), pkg-config, intltool, libglib2.0-dev (>= 2.32), ppp-dev (>= 2.4.7-1+1), libselinux1-dev, libaudit-dev, libgnutls28-dev (>= 2.12), uuid-dev, systemd (>= 185), libsystemd-dev (>= 209), libudev-dev (>= 175), libgirepository1.0-dev (>= 0.10.7-1~), gobject-introspection (>= 0.9.12-4~), python3-gi, libpsl-dev (>= 0.1), libcurl4-gnutls-dev (>= 7.24.0), gtk-doc-tools, libglib2.0-doc, libmm-glib-dev (>= 0.7.991), libndp-dev, libreadline-dev, libnewt-dev (>= 0.52.15), libteam-dev (>= 1.9), libjansson-dev, libbluetooth-dev (>= 5), valac (>= 0.17.1.24), dbus <!nocheck>, python3-dbus <!nocheck>, iproute2 <!nocheck>
Package-List:
 gir1.2-nm-1.0 deb introspection optional arch=linux-any
 libnm-dev deb libdevel optional arch=linux-any
 libnm0 deb libs optional arch=linux-any
 network-manager deb net optional arch=linux-any
 network-manager-config-connectivity-debian deb net optional arch=all
 network-manager-config-connectivity-ubuntu deb net optional arch=all
 network-manager-dev deb devel optional arch=all
Checksums-Sha1:
 30d9f3c3089e1b9f0e66dd354455e7dcb907c5cb 5436124 network-manager_1.36.6.orig.tar.xz
 a48caad11ef3dfc85d17913fbf63cce31eff4b42 69072 network-manager_1.36.6-0ubuntu2.debian.tar.xz
Checksums-Sha256:
 4bc24122a8f6930a246c6ddb9406f2d5109724b9c588504fa5b45cb8d778c321 5436124 network-manager_1.36.6.orig.tar.xz
 1b5f9651568f987bd902c1f12d921877fcadf3d70e350035bd0228e00f95932b 69072 network-manager_1.36.6-0ubuntu2.debian.tar.xz
Files:
 a9d1ef185bf211288d265a7c4038a29c 5436124 network-manager_1.36.6.orig.tar.xz
 297b28f3bdeb67c5cbe6075a301fcb15 69072 network-manager_1.36.6-0ubuntu2.debian.tar.xz
Debian-Vcs-Browser: https://salsa.debian.org/utopia-team/network-manager
Debian-Vcs-Git: https://salsa.debian.org/utopia-team/network-manager.git
Original-Maintainer: Utopia Maintenance Team <pkg-utopia-maintainers@lists.alioth.debian.org>

-----BEGIN PGP SIGNATURE-----

iHAEARECADAWIQTgLv71TsYonmdA1hxDGjztotfSkgUCYqH31RIcc2ViMTI4QHVi
dW50dS5jb20ACgkQQxo87aLX0pKGKwCdEazoLoNMcp8tSU1i+QZMeWbvi9QAmwe0
uzNl5zc0EUNn6JcwnJN/0Bap
=jFJu
-----END PGP SIGNATURE-----
