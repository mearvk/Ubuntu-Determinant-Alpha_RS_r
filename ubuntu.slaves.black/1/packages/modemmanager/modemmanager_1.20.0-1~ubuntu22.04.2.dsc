-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Format: 3.0 (quilt)
Source: modemmanager
Binary: modemmanager, modemmanager-dev, modemmanager-doc, libmm-glib0, libmm-glib-dev, libmm-glib-doc, gir1.2-modemmanager-1.0
Architecture: linux-any all
Version: 1.20.0-1~ubuntu22.04.2
Maintainer: Ubuntu Developers <ubuntu-devel-discuss@lists.ubuntu.com>
Uploaders: Arnaud Ferraris <aferraris@debian.org>, Guido Günther <agx@sigxcpu.org>, Henry-Nicolas Tourneur <debian@nilux.be>, Martin <debacle@debian.org>
Homepage: https://www.freedesktop.org/wiki/Software/ModemManager/
Standards-Version: 4.6.1
Vcs-Browser: https://salsa.debian.org/DebianOnMobile-team/modemmanager
Vcs-Git: https://salsa.debian.org/DebianOnMobile-team/modemmanager.git
Build-Depends: bash-completion, debhelper-compat (= 13), dbus <!nocheck>, gnome-common, gobject-introspection, libdbus-1-dev, libgirepository1.0-dev, libglib2.0-dev (>= 2.56.0), libgudev-1.0-dev (>= 232), libmbim-glib-dev (>= 1.28.0~), libpolkit-gobject-1-dev (>= 0.97), libqmi-glib-dev (>= 1.32.0~), libsystemd-dev (>= 209), meson, polkitd, python3-dbus, python3-gi, udev, valac (>= 0.22), gtk-doc-tools <!nodoc>, libglib2.0-doc <!nodoc>
Package-List:
 gir1.2-modemmanager-1.0 deb introspection optional arch=linux-any
 libmm-glib-dev deb libdevel optional arch=linux-any
 libmm-glib-doc deb doc optional arch=all
 libmm-glib0 deb libs optional arch=linux-any
 modemmanager deb net optional arch=linux-any
 modemmanager-dev deb libdevel optional arch=linux-any
 modemmanager-doc deb doc optional arch=all
Checksums-Sha1:
 c180cbc71455de861191eed4d7d3aaadba9af2ff 1329232 modemmanager_1.20.0.orig.tar.xz
 69ef5306a343842eaf2984d80460b13ff0ff6ba1 30568 modemmanager_1.20.0-1~ubuntu22.04.2.debian.tar.xz
Checksums-Sha256:
 9bb5f4a1fd5206184ae7e4818647fd34b6688b12a5e0ba6cd580c82bcd182c85 1329232 modemmanager_1.20.0.orig.tar.xz
 75ac25d5f294e5c938a8080285e2754fc48d2cefb65ca428f2055d59cc47ee88 30568 modemmanager_1.20.0-1~ubuntu22.04.2.debian.tar.xz
Files:
 71fff1fe1989a7e7384fdadd4a45b514 1329232 modemmanager_1.20.0.orig.tar.xz
 8c710fe5b42341af1b05be723707b455 30568 modemmanager_1.20.0-1~ubuntu22.04.2.debian.tar.xz
Original-Maintainer: DebianOnMobile Maintainers <debian-on-mobile-maintainers@alioth-lists.debian.net>

-----BEGIN PGP SIGNATURE-----

iF0EARECAB0WIQTgLv71TsYonmdA1hxDGjztotfSkgUCZImIRQAKCRBDGjztotfS
kr5FAKDNkPreJgM+vbKzsZ/wYsvT8ISeiACbB/CkUogoL21gTQyYAR6Jag9Hsgs=
=9ikX
-----END PGP SIGNATURE-----
