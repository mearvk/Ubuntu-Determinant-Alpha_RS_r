-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: evolution-data-server
Binary: evolution-data-server, evolution-data-server-common, evolution-data-server-tests, evolution-data-server-dev, evolution-data-server-doc, libedataserver-1.2-26, libedataserver1.2-dev, gir1.2-edataserver-1.2, libedataserverui-1.2-3, libedataserverui1.2-dev, gir1.2-edataserverui-1.2, libcamel-1.2-63, libcamel1.2-dev, gir1.2-camel-1.2, libebook-1.2-20, libebook1.2-dev, gir1.2-ebook-1.2, libedata-book-1.2-26, libedata-book1.2-dev, gir1.2-edatabook-1.2, gir1.2-ebookcontacts-1.2, libebook-contacts-1.2-3, libebook-contacts1.2-dev, libecal-2.0-1, libecal2.0-dev, gir1.2-ecal-2.0, libedata-cal-2.0-1, libedata-cal2.0-dev, gir1.2-edatacal-2.0, libebackend-1.2-10, libebackend1.2-dev, gir1.2-ebackend-1.2
Architecture: any all
Version: 3.44.4-0ubuntu1.1
Maintainer: Ubuntu Developers <ubuntu-devel-discuss@lists.ubuntu.com>
Uploaders: Iain Lane <laney@debian.org>, Jeremy Bicha <jbicha@ubuntu.com>, Laurent Bigonville <bigon@debian.org>
Homepage: https://wiki.gnome.org/Apps/Evolution
Standards-Version: 4.5.0
Vcs-Browser: https://salsa.debian.org/gnome-team/evolution-data-server/tree/ubuntu/jammy
Vcs-Git: https://salsa.debian.org/gnome-team/evolution-data-server.git -b ubuntu/jammy
Testsuite: autopkgtest
Testsuite-Triggers: dbus-test-runner, python3, python3-gi
Build-Depends: cmake, debhelper-compat (= 13), dh-sequence-gir, dh-sequence-gnome, libtool, intltool (>= 0.35.5), libcanberra-gtk3-dev (>= 0.25), libdb-dev, libglib2.0-dev (>= 2.40), libglib2.0-doc (>= 2.40), libgdata-dev (>= 0.10), libgirepository1.0-dev (>= 1.59.1), libsecret-1-dev (>= 0.5), libgcr-3-dev (>= 3.4), libgoa-1.0-dev (>= 3.8), libgtk-3-dev (>= 3.10), libgweather-3-dev (>= 40.0), libical-dev (>= 3.0.7), libicu-dev, libjson-glib-dev (>= 1.0.4) [!ia64 !kfreebsd-any], libkrb5-dev, libldap2-dev, liboauth-dev (>= 0.9.4), librest-dev (>= 0.7), libnss3-dev, libnspr4-dev, libsoup2.4-dev (>= 2.42), libsqlite3-dev (>= 3.7.17), libwebkit2gtk-4.0-dev [!ia64 !kfreebsd-any], libxml2-dev (>= 2.0.0), gtk-doc-tools (>= 1.14), gperf, pkg-config (>= 0.16), valac (>= 0.22), libphonenumber-dev [!hppa !hurd-any !ia64 !kfreebsd-amd64 !kfreebsd-i386], db-util <!nocheck>, dbus <!nocheck>
Package-List:
 evolution-data-server deb gnome optional arch=any
 evolution-data-server-common deb gnome optional arch=all
 evolution-data-server-dev deb devel optional arch=any
 evolution-data-server-doc deb doc optional arch=all
 evolution-data-server-tests deb gnome optional arch=any
 gir1.2-camel-1.2 deb introspection optional arch=any
 gir1.2-ebackend-1.2 deb introspection optional arch=any
 gir1.2-ebook-1.2 deb introspection optional arch=any
 gir1.2-ebookcontacts-1.2 deb introspection optional arch=any
 gir1.2-ecal-2.0 deb introspection optional arch=any
 gir1.2-edatabook-1.2 deb introspection optional arch=any
 gir1.2-edatacal-2.0 deb introspection optional arch=any
 gir1.2-edataserver-1.2 deb introspection optional arch=any
 gir1.2-edataserverui-1.2 deb introspection optional arch=any
 libcamel-1.2-63 deb libs optional arch=any
 libcamel1.2-dev deb libdevel optional arch=any
 libebackend-1.2-10 deb libs optional arch=any
 libebackend1.2-dev deb libdevel optional arch=any
 libebook-1.2-20 deb libs optional arch=any
 libebook-contacts-1.2-3 deb libs optional arch=any
 libebook-contacts1.2-dev deb libdevel optional arch=any
 libebook1.2-dev deb libdevel optional arch=any
 libecal-2.0-1 deb libs optional arch=any
 libecal2.0-dev deb libdevel optional arch=any
 libedata-book-1.2-26 deb libs optional arch=any
 libedata-book1.2-dev deb libdevel optional arch=any
 libedata-cal-2.0-1 deb libs optional arch=any
 libedata-cal2.0-dev deb libdevel optional arch=any
 libedataserver-1.2-26 deb libs optional arch=any
 libedataserver1.2-dev deb libdevel optional arch=any
 libedataserverui-1.2-3 deb libs optional arch=any
 libedataserverui1.2-dev deb libdevel optional arch=any
Checksums-Sha1:
 dea1a370f5bc96d6d102ed1e44ae9375251a186d 4784388 evolution-data-server_3.44.4.orig.tar.xz
 3559df9fdb6e82bf0ab45a21be191fd757fa8c22 55784 evolution-data-server_3.44.4-0ubuntu1.1.debian.tar.xz
Checksums-Sha256:
 c0c6658838d58ba46042a4b9e50a3bb1129691e4cdb84b5eba0bf330b2ccb2eb 4784388 evolution-data-server_3.44.4.orig.tar.xz
 072654533df41d71a87ebb5c5daccd73cf672f938238c4cf413fa225b29dc411 55784 evolution-data-server_3.44.4-0ubuntu1.1.debian.tar.xz
Files:
 fe8f0b1b77594589d6897de4b160015e 4784388 evolution-data-server_3.44.4.orig.tar.xz
 9833f0a6ee03b934586666b94b9e923a 55784 evolution-data-server_3.44.4-0ubuntu1.1.debian.tar.xz
Debian-Vcs-Browser: https://salsa.debian.org/gnome-team/evolution-data-server
Debian-Vcs-Git: https://salsa.debian.org/gnome-team/evolution-data-server.git
Original-Maintainer: Debian GNOME Maintainers <pkg-gnome-maintainers@lists.alioth.debian.org>

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEUMSg3c8x5FLOsZtRZWnYVadEvpMFAmSRkGsACgkQZWnYVadE
vpNP2A/7BtfvGkjmUk7t4ceJROJowC5rp6DeXgRVIvAfwSchjmgaSAQVg7mYu3RQ
jAW90LPL3fmMX5ODj42NMTP8nYfdQeZcU2DjqbJsox3whJyQSwhIfKbodP1qt0QW
lLKqumAzxmLGJ2cvkMlqVG1G+eBXmERZHK9aQWoTOXEHNdTV43B1uWNis6fIflbH
xaDzbA7AtmimIt3M9ZCHSRLZ2w40uN6VA0PnPZush7fORkimAWXXaGXpDYAWSDDZ
ti4oema/Rjd6D1wL2KD9kNtHOOxVxSoPoQ8mmc4pfd+Kzrb69PLiS0EaebPNlop9
IA2mPIw+CXZ/HRcm0ZnlSJRm2wz70+TsIS1B9nsKeBZH/y08CEz9aMrnZvyTFxN/
1Ma8LmdI2hhgLlEPVFImcPUgzWq2fEmpi8kLwqWGCzpVUS72es8A2nTu5aa/YCeA
hHp8h21kTBDUQEFYkqeaPT+3bddo7OAr9Hml6oR2spc1I7peY+SfnzUwpgnhPuVB
UQH2RDGNxQSXvvpGD0WN8VmL2XrRwWEMsz1OMNKIoemHKbux0YottsTVA0lQUY5S
dG5LNfV7YXc4NDLiTaED5wFqVl8r0pWjh0qv3W+wOXqsrf31pnhE/duUTZwHVSE0
6DL16M0A9Lg4U0bWwDLY5+01eJannWqSqR3bbAWEFFnKHpJ1EwU=
=o8fq
-----END PGP SIGNATURE-----
