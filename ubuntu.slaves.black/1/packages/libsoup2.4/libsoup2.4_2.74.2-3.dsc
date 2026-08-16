-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

Format: 3.0 (quilt)
Source: libsoup2.4
Binary: libsoup2.4-dev, libsoup2.4-1, libsoup-gnome2.4-1, libsoup-gnome2.4-dev, libsoup2.4-common, libsoup2.4-doc, gir1.2-soup-2.4, libsoup2.4-tests
Architecture: any all
Version: 2.74.2-3
Maintainer: Debian GNOME Maintainers <pkg-gnome-maintainers@lists.alioth.debian.org>
Uploaders: Iain Lane <laney@debian.org>, Jeremy Bicha <jbicha@debian.org>, Sebastien Bacher <seb128@debian.org>
Homepage: https://wiki.gnome.org/Projects/libsoup
Standards-Version: 4.6.0
Vcs-Browser: https://salsa.debian.org/gnome-team/libsoup
Vcs-Git: https://salsa.debian.org/gnome-team/libsoup.git
Testsuite: autopkgtest
Testsuite-Triggers: build-essential, dbus, gnome-desktop-testing, winbind, xauth, xvfb
Build-Depends: apache2 (>= 2.4) <!nocheck> <!noinsttest>, curl <!nocheck> <!noinsttest>, debhelper-compat (= 13), dh-sequence-gir, dh-sequence-gnome, glib-networking (>= 2.32.0), gtk-doc-tools, libapache2-mod-php (<< 2:9) <!nocheck> <!noinsttest>, libapache2-mod-php (>= 2:7) <!nocheck> <!noinsttest>, libbrotli-dev, libgirepository1.0-dev (>= 0.9.5), libglib2.0-dev (>= 2.58), libkrb5-dev, libnss-myhostname [linux-any] <!nocheck>, libpsl-dev (>= 0.20), libsqlite3-dev, libxml2-dev, meson (>= 0.48), php (<< 2:9) <!nocheck> <!noinsttest>, php (>= 2:7) <!nocheck> <!noinsttest>, php-xmlrpc <!nocheck> <!noinsttest> | php (>= 2:8.1+85+really8) <!nocheck> <!noinsttest>, python3, valac
Build-Depends-Indep: libglib2.0-doc
Package-List:
 gir1.2-soup-2.4 deb introspection optional arch=any
 libsoup-gnome2.4-1 deb libs optional arch=any
 libsoup-gnome2.4-dev deb libdevel optional arch=any
 libsoup2.4-1 deb libs optional arch=any
 libsoup2.4-common deb devel optional arch=all
 libsoup2.4-dev deb libdevel optional arch=any
 libsoup2.4-doc deb doc optional arch=all
 libsoup2.4-tests deb misc optional arch=any profile=!noinsttest
Checksums-Sha1:
 21177dcd3b04a10cacaa5b22bf233a4f2691eef6 1497356 libsoup2.4_2.74.2.orig.tar.xz
 df95d7ff9a0c1bb12615426a29b21b36839075d3 28448 libsoup2.4_2.74.2-3.debian.tar.xz
Checksums-Sha256:
 f0a427656e5fe19e1df71c107e88dfa1b2e673c25c547b7823b6018b40d01159 1497356 libsoup2.4_2.74.2.orig.tar.xz
 21065c1c8a71a0ff04a9ce1f64301401b1f4ba1721b4516bc373c78c1536a153 28448 libsoup2.4_2.74.2-3.debian.tar.xz
Files:
 d8c5bc7f471c7462c29cc2ccebe3d9ca 1497356 libsoup2.4_2.74.2.orig.tar.xz
 a28d2d8d87ed73302ec7f77fc3404acd 28448 libsoup2.4_2.74.2-3.debian.tar.xz
Dgit: bc96cda23f03db7d9e71622fce663dada84e5928 debian archive/debian/2.74.2-3 https://git.dgit.debian.org/libsoup2.4

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEENuxaZEik9e95vv6Y4FrhR4+BTE8FAmHKL7EACgkQ4FrhR4+B
TE9U8Q/8D03N0DKln4B2KyGCRg+K6g68ZKmVK1KIFMcQRD1DQOP1rvGyoZlg9x0r
fbNkvoiMdQ8I72NmYttOkEpHBEYafuruJDKMc6GrZjnRYbILp30+BUcFDveh5ieB
P8IKDjR5668hMGdT15royfGIIflH3juTYZsNRYFwHwOaIZpKMmK2AK8MAy83E6qx
i/21joW9wXLW8VVks5O9eonDRiWNws88UKtBk0Xcot0aOYdejWsaYkJ5b9JTICnM
nATckJFB1l4eS7992sVhtX4RKwCK95D2rbYsvew8KWP08nLjztmvGpOQKTZOrgdO
6gAFsmp5Bh1m00F3ixCwGx0ZIp6nyzXdr0NZb1QT3waNtpVi5kLyzPQ3E/wct7dJ
r4HcihbubArZJ8I4r8hn2h/EkbcqxV7eBi6S2mF2w5GaMBkS8wdoOvZ8N4ldJYHm
aMDmTKTWfiQN85fZdATOkzFZKWz8M0hbht+/5FfljtOWDRQC7wTxOcXf8NhYsMFN
gwCe8g8KuKkTiVU5Iu5l4/ZT4+Yk2B33tcip7dUQzTmop5zayxZouJ82LNdfUjwf
TF31ylUUC2mzc+y303SHhm+C/M101Qo5Ji5Ri28m3C8RsZoZ2lEz6jPyovNTS9ie
3i0QFXgQ/HSineRzISfvLRbWINDxZqi6LJbieFLgtsp5naa6E4Q=
=InZZ
-----END PGP SIGNATURE-----
