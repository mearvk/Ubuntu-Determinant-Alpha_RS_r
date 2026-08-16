-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: udisks2
Binary: udisks2, udisks2-bcache, udisks2-btrfs, udisks2-lvm2, udisks2-zram, udisks2-doc, libudisks2-0, libudisks2-dev, gir1.2-udisks-2.0
Architecture: linux-any all
Version: 2.9.4-1ubuntu2
Maintainer: Ubuntu Developers <ubuntu-devel-discuss@lists.ubuntu.com>
Uploaders: Michael Biebl <biebl@debian.org>, Martin Pitt <mpitt@debian.org>,
Homepage: https://www.freedesktop.org/wiki/Software/udisks
Standards-Version: 4.6.0
Vcs-Browser: https://salsa.debian.org/utopia-team/udisks2
Vcs-Git: https://salsa.debian.org/utopia-team/udisks2.git
Testsuite: autopkgtest
Testsuite-Triggers: cryptsetup-bin, dosfstools, exfat-fuse, exfatprogs, gir1.2-glib-2.0, kpartx, libatasmart-bin, libblockdev-crypto2, lvm2, make, mdadm, ntfs-3g, policykit-1, python3-dbus, python3-distutils, python3-gi, reiserfsprogs, targetcli-fb, xfsprogs
Build-Depends: debhelper-compat (= 13), docbook-xml, docbook-xsl, gtk-doc-tools, gettext (>= 0.19.8), gobject-introspection (>= 1.30), libacl1-dev, libatasmart-dev (>= 0.17), libblockdev-btrfs-dev, libblockdev-crypto-dev, libblockdev-dev (>= 2.25), libblockdev-fs-dev, libblockdev-kbd-dev, libblockdev-loop-dev, libblockdev-lvm-dev, libblockdev-mdraid-dev, libblockdev-part-dev (>= 2.10), libblockdev-swap-dev, libgirepository1.0-dev (>= 1.30), libglib2.0-dev (>= 2.50), libgudev-1.0-dev (>= 165), libmount-dev (>= 2.30), libpolkit-agent-1-dev (>= 0.102), libpolkit-gobject-1-dev (>= 0.102), libsystemd-dev (>= 209), pkg-config, policykit-1 (>= 0.105-18), udev (>= 147), xsltproc
Build-Depends-Indep: libglib2.0-doc <!nodoc>, policykit-1-doc <!nodoc>
Package-List:
 gir1.2-udisks-2.0 deb introspection optional arch=linux-any
 libudisks2-0 deb libs optional arch=linux-any
 libudisks2-dev deb libdevel optional arch=linux-any
 udisks2 deb admin optional arch=linux-any
 udisks2-bcache deb admin optional arch=linux-any
 udisks2-btrfs deb admin optional arch=linux-any
 udisks2-doc deb doc optional arch=all profile=!nodoc
 udisks2-lvm2 deb admin optional arch=linux-any
 udisks2-zram deb admin optional arch=linux-any
Checksums-Sha1:
 e6f21e90456360723d80265c4d3372eb88ef7a6e 1699288 udisks2_2.9.4.orig.tar.bz2
 bb5ef817c8c3f01b6423c348ef20df3c74a20c16 19868 udisks2_2.9.4-1ubuntu2.debian.tar.xz
Checksums-Sha256:
 b6b60ebab0d5e09624120c5d158882e87d8c2473db60783b63deeba74cb18d1c 1699288 udisks2_2.9.4.orig.tar.bz2
 d7abf8c2b4c623557c50d1436220c4d14594d3030a5cac2f996d4565b2eaa169 19868 udisks2_2.9.4-1ubuntu2.debian.tar.xz
Files:
 576e057d2654894fab58f0393d105b7b 1699288 udisks2_2.9.4.orig.tar.bz2
 2ee53caf0f6e3e9210a759f18130c45f 19868 udisks2_2.9.4-1ubuntu2.debian.tar.xz
Original-Maintainer: Utopia Maintenance Team <pkg-utopia-maintainers@lists.alioth.debian.org>

-----BEGIN PGP SIGNATURE-----

iQFOBAEBCgA4FiEEiOlTC8vdwgBRe16w9JjS2d59rZwFAmJPVikaHGFsZXgubXVy
cmF5QGNhbm9uaWNhbC5jb20ACgkQ9JjS2d59rZzFyQf+OLJeYb9oYGsO52mYIoV1
CZZsdRU1gdj5NEfESPlFJBR+wYkVziGOG8L1HEEatOoKUkT0uHa8MCCI2ndmZtcF
7PvfBWbS9fIwGGdvzJyGt89lsJrVUI/+dw5wdZpqTXlnOUnJznZFGOB9WZcGQO/N
ozGPx6dxESNtmTYsKVuCBCOhChZZXVjSKz73Rqch4tPYUskAlJdRKx+B5h/Yx/Fm
29E3o39vHvndS7rt7vMgFQQywaUVK6wE42YtVx5FExoHtjI1/UmUoR+q6AJg17hF
OwaUYouHgX8sF6XPtmLFEVqvR4g+gmVcrwvlc4qXjlvGq1D01kmIpzrCjhkeveTM
Mg==
=vnpR
-----END PGP SIGNATURE-----
