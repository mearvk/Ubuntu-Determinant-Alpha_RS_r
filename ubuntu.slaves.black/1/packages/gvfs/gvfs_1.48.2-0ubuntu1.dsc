-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: gvfs
Binary: gvfs, gvfs-backends, gvfs-common, gvfs-daemons, gvfs-fuse, gvfs-libs
Architecture: any all
Version: 1.48.2-0ubuntu1
Maintainer: Ubuntu Developers <ubuntu-devel-discuss@lists.ubuntu.com>
Uploaders: Iain Lane <laney@debian.org>, Laurent Bigonville <bigon@debian.org>, Michael Biebl <biebl@debian.org>, Sebastien Bacher <seb128@debian.org>
Homepage: https://wiki.gnome.org/Projects/gvfs
Standards-Version: 4.5.1
Vcs-Browser: https://salsa.debian.org/gnome-team/gvfs/tree/ubuntu/jammy
Vcs-Git: https://salsa.debian.org/gnome-team/gvfs.git -b ubuntu/jammy
Testsuite: autopkgtest
Testsuite-Triggers: apache2, apache2-dev, dbus, gir1.2-umockdev-1.0, openssh-client, policykit-1, python3-dbus, python3-gi, python3-twisted, samba, sudo, umockdev
Build-Depends: debhelper-compat (= 12), dh-exec (>= 0.13), gnome-pkg-tools (>= 0.7), gsettings-desktop-schemas-dev (>= 3.33.0), gtk-doc-tools, libarchive-dev, libavahi-client-dev (>= 0.6), libavahi-glib-dev (>= 0.6), libbluetooth-dev (>= 4.0) [linux-any], libbluray-dev, libcap-dev [linux-any], libcdio-paranoia-dev (>= 0.78.2) [linux-any], libdbus-1-dev, libexpat1-dev, libfuse3-dev (>= 3.0.0) [!hurd-any], libgcr-3-dev, libgcrypt20-dev (>= 1.2.2), libgdata-dev (>= 0.18), libglib2.0-dev (>= 2.65.1), libgoa-1.0-dev (>= 3.17.1), libgphoto2-dev (>= 2.5.0) [linux-any], libgudev-1.0-dev (>= 147) [linux-any], libimobiledevice-dev (>= 1.2) [!hurd-any], libltdl-dev, libmtp-dev (>= 1.1.6) [linux-any], libnfs-dev (>= 1.9.7), libplist-dev, libpolkit-gobject-1-dev [linux-any], libsecret-1-dev, libsmbclient-dev (>= 3.4.0) [!hurd-any], libsoup2.4-dev (>= 2.58.0), libsystemd-dev [linux-any], libudisks2-dev (>= 1.97) [linux-any], libusb-1.0-0-dev (>= 1.0.21) [linux-any], libxml2-dev, meson (>= 0.53), openssh-client, pkg-config, policykit-1 (>= 0.105-18~) [linux-any], systemd (>= 206) [linux-any]
Package-List:
 gvfs deb libs optional arch=any
 gvfs-backends deb gnome optional arch=any
 gvfs-common deb libs optional arch=all
 gvfs-daemons deb libs optional arch=any
 gvfs-fuse deb gnome optional arch=kfreebsd-any,linux-any
 gvfs-libs deb libs optional arch=any
Checksums-Sha1:
 1bd73540bc018ad6a696e68260bdd05233c0ac3b 1217144 gvfs_1.48.2.orig.tar.xz
 99da201947fa2369bfb874a108af59aa360c7459 24844 gvfs_1.48.2-0ubuntu1.debian.tar.xz
Checksums-Sha256:
 2c415ce7282d97db13e9c71433ab3bb86c89ccdbe420c4efe9a4600db52f3e2d 1217144 gvfs_1.48.2.orig.tar.xz
 0e33e705625d4ffa01b125246772fbad54a519c4d3d0cf84e7710945393de949 24844 gvfs_1.48.2-0ubuntu1.debian.tar.xz
Files:
 19473e4841c9e16e0f4944edf8ced753 1217144 gvfs_1.48.2.orig.tar.xz
 8aa8513c0d2b6ecc31d5b12b8f7fda96 24844 gvfs_1.48.2-0ubuntu1.debian.tar.xz
Debian-Vcs-Browser: https://salsa.debian.org/gnome-team/gvfs
Debian-Vcs-Git: https://salsa.debian.org/gnome-team/gvfs.git
Original-Maintainer: Debian GNOME Maintainers <pkg-gnome-maintainers@lists.alioth.debian.org>

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEETQvhLw5HdtiqzpaW5mx3Wuv+bH0FAmKaZqoACgkQ5mx3Wuv+
bH1DwA//XcqDtYSJ7wL53jwYzhPKSWW+sSbcACAS7VKGHukqhU/CEuq4Kxy2PFjn
KCm0CP+fUx+f80sTaincV4kBMXCcdW/XePXWnlIRKeqouHdnsj6/e7NTYLsB+vm0
g5BfL5C2kqcJfhL4Asi9GvtmJVUYXTPoapvsYr6pmmkh6Y3bo/l7BGyLUXFRwEV4
mrVMLHuY9jatXAhDCRTszXYrCdk5eHybTe/j66uC7cdUVioGxs4uPB8kvn9AhjK1
/Fukc7TuUqgYfq99B3aloh3JG1AtbTXxG0jt5ded27rjkCjAThbfv+V9Fy1Kpbgl
bQOlvixR8pi/NZFLt9kuiWXddIq4bTk7ByT8O6JNge7gPacvV0ugkG3wNngbFrR6
eaK4/R/aB6zMLnAP2m+hTidyjys6DL0JLZ37zlD4H9LPGa9nkcSO9OezZziZOzl1
PPrLA0rPTB+GFUHXlCWtzmLAWpQtY9stSaqudyGn70p8tnVJQ9m9zZGXaiYo874u
aIs0gQFMZOYSWM6RAkyb0Gh4v0yrdKyVJ6qCu3sUaVddeP9uX+Z2JstCiD+YtrYa
9bo1gTLve+6jygZgm9cpfSZzU99QYDvgQv7tDwh7VPL/cQJncKh+EmpXQiz1De4m
iUJwTDgHzsvn/IkzjNlfJGDXR2ZxG+ri5zFmd6ZUH6NoeGzunuk=
=sYOr
-----END PGP SIGNATURE-----
