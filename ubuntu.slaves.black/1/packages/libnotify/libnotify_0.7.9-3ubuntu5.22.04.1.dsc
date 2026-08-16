-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: libnotify
Binary: libnotify-dev, libnotify4, libnotify-bin, libnotify-doc, gir1.2-notify-0.7
Architecture: any all
Version: 0.7.9-3ubuntu5.22.04.1
Maintainer: Ubuntu Developers <ubuntu-devel-discuss@lists.ubuntu.com>
Uploaders: Emilio Pozuelo Monfort <pochu@debian.org>, Jeremy Bicha <jbicha@debian.org>, Laurent Bigonville <bigon@debian.org>, Martin Pitt <mpitt@debian.org>, Michael Biebl <biebl@debian.org>
Standards-Version: 4.5.1
Vcs-Browser: https://salsa.debian.org/gnome-team/libnotify/tree/ubuntu/jammy
Vcs-Git: https://salsa.debian.org/gnome-team/libnotify.git -b ubuntu/jammy
Testsuite: autopkgtest
Testsuite-Triggers: build-essential, dbus, pkg-config, xauth, xvfb
Build-Depends: debhelper-compat (= 12), docbook-xsl-ns, libglib2.0-dev (>= 2.26), libgtk-3-dev (>= 3.0.0), libgdk-pixbuf-2.0-dev | libgdk-pixbuf2.0-dev, gnome-pkg-tools (>= 0.7), gobject-introspection (>= 0.9.12-5~), libgirepository1.0-dev (>= 0.9.12), gtk-doc-tools (>= 1.14), meson (>= 0.47), xmlto
Package-List:
 gir1.2-notify-0.7 deb introspection optional arch=any
 libnotify-bin deb utils optional arch=any
 libnotify-dev deb libdevel optional arch=any
 libnotify-doc deb doc optional arch=all
 libnotify4 deb libs optional arch=any
Checksums-Sha1:
 75f80afad4d77b4968bfbcd47f4beea5ac2cc87b 98148 libnotify_0.7.9.orig.tar.xz
 fbdad6b22d130763382ee435bc0fdd4cd2841e7e 14652 libnotify_0.7.9-3ubuntu5.22.04.1.debian.tar.xz
Checksums-Sha256:
 66c0517ed16df7af258e83208faaf5069727dfd66995c4bbc51c16954d674761 98148 libnotify_0.7.9.orig.tar.xz
 85bac9c97178b31cf60a8d3ef066466374b9d179df2b55afb27c4a64def35a63 14652 libnotify_0.7.9-3ubuntu5.22.04.1.debian.tar.xz
Files:
 ccd9c53364174cc8d13e18a1988faa76 98148 libnotify_0.7.9.orig.tar.xz
 25ef8216e9e2a6b90d4e7468dc14e6db 14652 libnotify_0.7.9-3ubuntu5.22.04.1.debian.tar.xz
Debian-Vcs-Browser: https://salsa.debian.org/gnome-team/libnotify
Debian-Vcs-Git: https://salsa.debian.org/gnome-team/libnotify.git
Original-Maintainer: Debian GNOME Maintainers <pkg-gnome-maintainers@lists.alioth.debian.org>

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEETQvhLw5HdtiqzpaW5mx3Wuv+bH0FAmJqsoYACgkQ5mx3Wuv+
bH2Iww/9F/ouaO5CjsVgATkHncG+uaB479nQ3IEltrTPCo+xPXChRX4EMmlKPJds
nwVnhgIvcF4EePAm8HAo66gFstAzCxJqRIMXuNhd0BzAMkwGiz8ks2Ak13uuPMSj
00x1XKFf6mRQfswK1tGNcXgUOKCyWrQ9wwTYdFvOhEPnXGPTLaC64+/fJF04zxtl
dU5kHn5xB/wMjHanuFGcrNugqxuZN10KC9UlylLTLIBYpzYAMmEt/DRK7Vz5xklC
raaqK1gKZ1HaVPnF4XXbTRio+Dr+fEwfjHLsaPasZv0gotZwhCBZQlxLAqSlSr3X
4l1nPckp+RmeDfPWVXNYz+z6w5VGzL0TGKCdvUnu/SAzOIadmOcQ+QFI+pkMjReb
03AMB9w8EbwfJhv9X0VIGvKfXYoc3YDlMjeON4aQ4ulwG4uwknuZwz9Zz6Zho9DU
nJWPovmoQpC1tr8gEvX4u1+XbqleA4LaSSMQqk6rf1z2KqfXiUMZyPjTJRCzSSO2
1581EPZOU4Ma83KhsoO3AZIaaXwG6jFebsFJyCf6JySnCvWqK55GktthhS4C0hNb
3NrtAwYfjlsGYjWDA2G2QeiMOE4eGvwoYv+KsvFST+eR8yll1SBAt4so4iL1nDYa
0/yV2e4CoqJWLFvSmT/xRyFnsZr+pDs54sRsUJ5BHPLD4O8wBM4=
=OHwS
-----END PGP SIGNATURE-----
