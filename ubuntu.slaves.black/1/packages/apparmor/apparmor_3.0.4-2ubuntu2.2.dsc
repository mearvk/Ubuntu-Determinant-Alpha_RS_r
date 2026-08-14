-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: apparmor
Binary: apparmor, apparmor-utils, apparmor-profiles, libapparmor-dev, libapparmor1, libapache2-mod-apparmor, libpam-apparmor, apparmor-notify, python3-libapparmor, python3-apparmor, dh-apparmor
Architecture: linux-any all
Version: 3.0.4-2ubuntu2.2
Maintainer: Ubuntu Developers <ubuntu-devel-discuss@lists.ubuntu.com>
Uploaders: intrigeri <intrigeri@debian.org>
Homepage: https://apparmor.net/
Standards-Version: 4.6.0.1
Vcs-Browser: https://salsa.debian.org/apparmor-team/apparmor/tree/ubuntu/master
Vcs-Git: https://salsa.debian.org/apparmor-team/apparmor.git -b ubuntu/master
Testsuite: autopkgtest
Testsuite-Triggers: @builddeps@, apparmor-profiles-extra, bind9, cups-browsed, cups-daemon, evince, haveged, libreoffice-common, libvirt-daemon-system, linux-image-amd64, linux-image-generic, man-db, ntp, onioncircuits, tcpdump, tor
Build-Depends: apache2-dev, autoconf, automake, bison, bzip2, chrpath, debhelper-compat (= 13), dejagnu <!nocheck>, dh-apache2, dh-python, dh-sequence-python3, flex, liblocale-gettext-perl <!nocheck>, libpython3-all-dev, libpam-dev, libtool, perl <!nocheck>, pkg-config, po-debconf, python3:any, python3-all:any, python3-all-dev:any, python3-setuptools, swig
Package-List:
 apparmor deb admin optional arch=linux-any
 apparmor-notify deb admin optional arch=all
 apparmor-profiles deb admin optional arch=all
 apparmor-utils deb admin optional arch=all
 dh-apparmor deb devel optional arch=all
 libapache2-mod-apparmor deb httpd optional arch=linux-any
 libapparmor-dev deb libdevel optional arch=linux-any
 libapparmor1 deb libs optional arch=linux-any
 libpam-apparmor deb admin optional arch=linux-any
 python3-apparmor deb python optional arch=all
 python3-libapparmor deb python optional arch=linux-any
Checksums-Sha1:
 aa5e5a84f5bfe9f621ee3d6cff1caffd95fbd825 7796852 apparmor_3.0.4.orig.tar.gz
 655b4b5165deb51eff7a3ed44702a2b66e5551b5 870 apparmor_3.0.4.orig.tar.gz.asc
 92a72c379c8432b5de4b45993873087335543838 119180 apparmor_3.0.4-2ubuntu2.2.debian.tar.xz
Checksums-Sha256:
 09bf48d7a171f9790c39a1404bad105a788934cfe77b7490c7f5c63c2576b725 7796852 apparmor_3.0.4.orig.tar.gz
 fc5d5cfb71dd48e8e8a5321f84359e3131f9e5780804d154ea769d543c35be61 870 apparmor_3.0.4.orig.tar.gz.asc
 ff1d6a2580ba102d65a8a9d17752b4dc48dd15f309b772b5147cc632c8846f56 119180 apparmor_3.0.4-2ubuntu2.2.debian.tar.xz
Files:
 5215a5751a90a45149c699fc3e61a6e8 7796852 apparmor_3.0.4.orig.tar.gz
 f6525989eeae9caf6474dc41e697b54a 870 apparmor_3.0.4.orig.tar.gz.asc
 8dc5da7e964f486befe0ae933ba9c32a 119180 apparmor_3.0.4-2ubuntu2.2.debian.tar.xz
Original-Maintainer: Debian AppArmor Team <pkg-apparmor-team@lists.alioth.debian.org>

-----BEGIN PGP SIGNATURE-----

iQFOBAEBCgA4FiEEiOlTC8vdwgBRe16w9JjS2d59rZwFAmNY7F0aHGFsZXgubXVy
cmF5QGNhbm9uaWNhbC5jb20ACgkQ9JjS2d59rZwxKAf/Tzpj6UbekJSo2rLFcqF/
1lggZ0E7yW0tUQB2OiLvsA77etKN6T9VhrOzoB3VqcnUViy/cyUJY4jGUcytetSh
K3gEi8eXOtrFDxBY5FMbLZgOW0IJDt68MwGxbII8DZ/aOiE38aK2Dj8BVgrcPxOQ
gNdPXu93lJk/ErzSxfhJHwCFjlXGwAxPpctsq3fmsBFDEO+D3QSadZv91NS2jkxp
PPjmFM9vHdUjCGJTdw8G9B9uRDyOduD/3xWRAa3I/skIWvQJgIvk1HcreVyjwsBX
o38PNr8xVG1++YJ7j6x2LDCWdOoAqog1LIOHNvVeAIuMqalBkfgom8WBl6l/i5ip
ug==
=CMcG
-----END PGP SIGNATURE-----
