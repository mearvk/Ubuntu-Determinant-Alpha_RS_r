-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: colord
Binary: libcolord-dev, libcolord2, colord, colord-data, gir1.2-colord-1.0, libcolorhug-dev, libcolorhug2, gir1.2-colorhug-1.0, colord-tests
Architecture: linux-any all
Version: 1.4.6-1
Maintainer: Christopher James Halse Rogers <raof@ubuntu.com>
Homepage: http://www.freedesktop.org/software/colord/
Standards-Version: 4.5.0
Vcs-Browser: https://salsa.debian.org/debian/colord
Vcs-Git: https://salsa.debian.org/debian/colord.git
Testsuite: autopkgtest
Testsuite-Triggers: dbus, gnome-desktop-testing, gnome-session, gnome-settings-daemon, xauth, xvfb
Build-Depends: bash-completion, debhelper-compat (= 13), dh-sequence-gir, docbook-xsl-ns, gtk-doc-tools, libdbus-1-dev, libgirepository1.0-dev, libglib2.0-dev (>= 2.58), libgudev-1.0-dev, libgusb-dev (>= 0.2.7), liblcms2-dev, libpolkit-gobject-1-dev (>= 0.103), libsane-dev [linux-any], libsqlite3-dev, libsystemd-dev [linux-any], libudev-dev, meson (>= 0.52.0), shared-mime-info <!nocheck>, systemd [linux-any], valac (>= 0.20), xsltproc
Package-List:
 colord deb graphics optional arch=linux-any
 colord-data deb graphics optional arch=all
 colord-tests deb graphics optional arch=linux-any
 gir1.2-colord-1.0 deb introspection optional arch=linux-any
 gir1.2-colorhug-1.0 deb introspection optional arch=linux-any
 libcolord-dev deb libdevel optional arch=linux-any
 libcolord2 deb libs optional arch=linux-any
 libcolorhug-dev deb libdevel optional arch=linux-any
 libcolorhug2 deb libs optional arch=linux-any
Checksums-Sha1:
 0ed216268b3b259e963ffe71d3ec46d9ed79f217 1872528 colord_1.4.6.orig.tar.xz
 b916eca92b4822d4cedff6679e2dfff939ead43a 488 colord_1.4.6.orig.tar.xz.asc
 8a7ad07ed3102cdee45078f7d7f9d8e38b256ed0 30032 colord_1.4.6-1.debian.tar.xz
Checksums-Sha256:
 7407631a27bfe5d1b672e7ae42777001c105d860b7b7392283c8c6300de88e6f 1872528 colord_1.4.6.orig.tar.xz
 abfafd2c6c564fdbd9bda8c3f9271783afa6777ddfcdc335cbe77d48b7d5dee0 488 colord_1.4.6.orig.tar.xz.asc
 b6a5e07475b184c555e0f03f641f8996d7fd432bb2745b41ab574ea976130f5d 30032 colord_1.4.6-1.debian.tar.xz
Files:
 7dbdc807495890c13e8242385f4c641f 1872528 colord_1.4.6.orig.tar.xz
 661c3cef9ee0c9a22cb6e684d67aceba 488 colord_1.4.6.orig.tar.xz.asc
 72a581b4a9cc33e1a55810999b20742c 30032 colord_1.4.6-1.debian.tar.xz

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEETQvhLw5HdtiqzpaW5mx3Wuv+bH0FAmIU5JoACgkQ5mx3Wuv+
bH3OfA//e4BRZH/AIOSuZ+qtGuFW+CE+quNQjzVV9dp9mwwoM600kByE4qmMung1
wXrGfExsQKwlOm3JnC1tBT9lExUB1GOD0Vbs4zRbgCfYUh7CTpNWBfUEVXwCzfSk
Xlm4W+jBID4dbWUv1vt3lMZb9+smKVYHQJndwJ95qGx3acR+SJfTZ9wM/H/K/4Ep
PwStrBxhgU4GmO5KmW1S4PoPw0ME3i+ru8CDPEpa/QkBqyCjbFdgZhqkuuDZAL8p
6qvV4wun/IcM+f8smKUXs/uTgBZ3ngC92ExbpH4W3/JfcE6TyXCMENwL43N1L5r2
zxswyGjSv9iwKCsdfSDYhkkfcuWLClpWYLQYFy2907ZtKlbC3K2NHCaoZS4g8xO/
y3pEebVnPHWWzBEj3mNQqikTdWV+DNnBsvmXlvcugOLsMywI1jl21FMzgwNcLIsj
mXmdEqe7mNgAGNbJ6xF6qKhbyfFvktHDrhcS7diKRGIRpo0iWWxkI8GcOVCz99/q
4FeNgpK9M54rpxquUWy/wlldQpPXxj+aAqfohNi/2HpxuVp8NjjnqvpVKpQo/AZy
a+2e2Uea0fV7bY+IPzhb1PPubEjgGnwEyFs861yHGu0xuauXncwscjvkNOoOYqYQ
ZIzVluzIvf9RyF5VbsvaLvaXTqB+JN8UKpmpizu+4LLxwNomqlc=
=ORbx
-----END PGP SIGNATURE-----
