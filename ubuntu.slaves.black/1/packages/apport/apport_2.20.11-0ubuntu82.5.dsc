-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 1.0
Source: apport
Binary: apport, python3-problem-report, python3-apport, apport-retrace, apport-valgrind, apport-gtk, apport-kde, dh-apport, apport-noui
Architecture: all
Version: 2.20.11-0ubuntu82.5
Maintainer: Ubuntu Developers <ubuntu-devel-discuss@lists.ubuntu.com>
Homepage: https://wiki.ubuntu.com/Apport
Standards-Version: 3.9.8
Vcs-Browser: https://code.launchpad.net/~ubuntu-core-dev/ubuntu/+source/apport/+git/apport
Vcs-Git: https://git.launchpad.net/~ubuntu-core-dev/ubuntu/+source/apport -b ubuntu/jammy
Testsuite: autopkgtest
Testsuite-Triggers: at-spi2-core, build-essential, dbus-x11, gnome-icon-theme, gvfs-daemons, libglib2.0-dev, psmisc, python3-mock, python3-systemd, python3-twisted, xterm, xvfb
Build-Depends: debhelper (>= 9), dh-translations, gdb, python3-gi, gir1.2-glib-2.0 (>= 1.29.17), lsb-release, net-tools, python3-all
Build-Depends-Indep: python3-distutils-extra (>= 2.24~), python3-apt (>= 0.7.9), dh-python, intltool, xvfb, python3-mock, procps, psmisc, gir1.2-gtk-3.0 (>= 3.1.90), gir1.2-wnck-3.0, pycodestyle | pep8, pyflakes3, xterm, dbus-x11, gvfs-daemons, libglib2.0-dev, libc6-dbg | libc-dbg, default-jdk | java-sdk
Package-List:
 apport deb utils optional arch=all
 apport-gtk deb gnome optional arch=all
 apport-kde deb kde optional arch=all
 apport-noui deb utils optional arch=all
 apport-retrace deb devel optional arch=all
 apport-valgrind deb devel optional arch=all
 dh-apport deb devel optional arch=all
 python3-apport deb python optional arch=all
 python3-problem-report deb python optional arch=all
Checksums-Sha1:
 e937feaf2543855b66b897d08bedcfdd41d6ba18 1457704 apport_2.20.11-0ubuntu82.5.tar.gz
Checksums-Sha256:
 0aae706416fb855c55a37fa0b5f8d7f865decbe3e76440ec56ff216d6ae171bc 1457704 apport_2.20.11-0ubuntu82.5.tar.gz
Files:
 e86cce4d4d1278c9a58c8daa7ff8fb93 1457704 apport_2.20.11-0ubuntu82.5.tar.gz

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEpi0s+9ULm1vzYNVLFZ61xO/Id0wFAmQ4mHEACgkQFZ61xO/I
d0yu5A/9F8OJdeUegaRiArjvKSk0Axf0xy3YBVlM7u49QDGM//T1LpMU4z+KOMdb
U5srA7OZXHbewBeSFRARn6bHJlnUO8CyDEsi9zOJxYKfwzq+YSEw1G32rur9Hd4E
nieok//NWQhqUY2bahOSHyXhZfV027cL5Me6LgCSE2FBw4ygLFZmG8SMNKrPX1/N
VzDp1g9gFeLloU+raUEuGRvi+wy1Hv/qBJT7sGNpyg+L2tbqkGRR+hBd4kh35cWB
WUJyi60WBvLf1glRVo5zNHae8jEhsUxyImXz/UqphYjHUfsfjUhtbXPJSLg/9IOy
wwvspnwVnYuU/l8ymFgWltGSys4TMIT3tKSNcb0rPAADj59zWoBr+2OcCRdgNDPE
ckuhKFbjyLjnIZI3Dpt5nEvOLaRUsb2qx4eAzn/tzg5RcA82uyXaUTStJUMal2FA
YBpJ71Q1emnpdF7Qe8bmiTcb6Olp8uFOICZQS79QUueu+8xJFGPapNlxNF372cVb
z44YN7qE61GPzAsID4TlcE+mykDB3qLAouhXRWkX7BTzTXWB58fxpM49d8RYOKVS
V5FPrW74JbqwIbTNtRyLJ7xVKyzngLQVMAjy0F6ue1MoHFQrApU0LAgKKOiMjKUC
BLVm6deDH8hkumUWuf1Xl98rHXEVJsbJJ/huz3/TJJ7y1Ld0wlc=
=0Oyi
-----END PGP SIGNATURE-----
