-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

Format: 3.0 (quilt)
Source: libblockdev
Binary: libblockdev2, libblockdev-dev, gir1.2-blockdev-2.0, python3-blockdev, libblockdev-utils2, libblockdev-utils-dev, libblockdev-part-err2, libblockdev-part-err-dev, libblockdev-btrfs2, libblockdev-btrfs-dev, libblockdev-crypto2, libblockdev-crypto-dev, libblockdev-dm2, libblockdev-dm-dev, libblockdev-fs2, libblockdev-fs-dev, libblockdev-kbd2, libblockdev-kbd-dev, libblockdev-loop2, libblockdev-loop-dev, libblockdev-lvm2, libblockdev-lvm-dev, libblockdev-lvm-dbus2, libblockdev-lvm-dbus-dev, libblockdev-mdraid2, libblockdev-mdraid-dev, libblockdev-mpath2, libblockdev-mpath-dev, libblockdev-nvdimm2, libblockdev-nvdimm-dev, libblockdev-part2, libblockdev-part-dev, libblockdev-swap2, libblockdev-swap-dev, libblockdev-plugins-all
Architecture: linux-any all
Version: 2.26-1
Maintainer: Utopia Maintenance Team <pkg-utopia-maintainers@lists.alioth.debian.org>
Uploaders: Martin Pitt <mpitt@debian.org>
Homepage: https://github.com/storaged-project/libblockdev
Standards-Version: 4.5.1
Vcs-Browser: https://salsa.debian.org/utopia-team/libblockdev
Vcs-Git: https://salsa.debian.org/utopia-team/libblockdev.git
Build-Depends: debhelper-compat (= 13), dh-sequence-gir, dh-sequence-python3, libtool, autoconf-archive, python3:any, libglib2.0-dev (>= 2.42.2), libgirepository1.0-dev, libcryptsetup-dev (>= 1.6.7), libdevmapper-dev (>= 1.02.93), libudev-dev (>= 216), libsystemd-dev, libdmraid-dev, libvolume-key-dev, libbytesize-dev, libnss3-dev (>= 3.18.0), libndctl-dev (>= 63-1.2~) [!ia64], libparted-dev (>= 3.1), libmount-dev (>= 2.23.0), libblkid-dev (>= 2.23.0), libpython3-dev, libkmod-dev (>= 19), gtk-doc-tools, pylint
Package-List:
 gir1.2-blockdev-2.0 deb introspection optional arch=linux-any
 libblockdev-btrfs-dev deb libdevel optional arch=linux-any
 libblockdev-btrfs2 deb libs optional arch=linux-any
 libblockdev-crypto-dev deb libdevel optional arch=linux-any
 libblockdev-crypto2 deb libs optional arch=linux-any
 libblockdev-dev deb libdevel optional arch=linux-any
 libblockdev-dm-dev deb libdevel optional arch=linux-any
 libblockdev-dm2 deb libs optional arch=linux-any
 libblockdev-fs-dev deb libdevel optional arch=linux-any
 libblockdev-fs2 deb libs optional arch=linux-any
 libblockdev-kbd-dev deb libdevel optional arch=linux-any
 libblockdev-kbd2 deb libs optional arch=linux-any
 libblockdev-loop-dev deb libdevel optional arch=linux-any
 libblockdev-loop2 deb libs optional arch=linux-any
 libblockdev-lvm-dbus-dev deb libdevel optional arch=linux-any
 libblockdev-lvm-dbus2 deb libs optional arch=linux-any
 libblockdev-lvm-dev deb libdevel optional arch=linux-any
 libblockdev-lvm2 deb libs optional arch=linux-any
 libblockdev-mdraid-dev deb libdevel optional arch=linux-any
 libblockdev-mdraid2 deb libs optional arch=linux-any
 libblockdev-mpath-dev deb libdevel optional arch=linux-any
 libblockdev-mpath2 deb libs optional arch=linux-any
 libblockdev-nvdimm-dev deb libdevel optional arch=linux-any
 libblockdev-nvdimm2 deb libs optional arch=linux-any
 libblockdev-part-dev deb libdevel optional arch=linux-any
 libblockdev-part-err-dev deb libdevel optional arch=linux-any
 libblockdev-part-err2 deb libs optional arch=linux-any
 libblockdev-part2 deb libs optional arch=linux-any
 libblockdev-plugins-all deb libs optional arch=linux-any
 libblockdev-swap-dev deb libdevel optional arch=linux-any
 libblockdev-swap2 deb libs optional arch=linux-any
 libblockdev-utils-dev deb libdevel optional arch=linux-any
 libblockdev-utils2 deb libs optional arch=linux-any
 libblockdev2 deb libs optional arch=linux-any
 python3-blockdev deb python optional arch=all
Checksums-Sha1:
 bd9d9bbf783d4e1e37b3963e96807d1a438ca6e8 399120 libblockdev_2.26.orig.tar.gz
 5b7f88e4ef74d4df42269e51710b8ee6cc7f974c 10848 libblockdev_2.26-1.debian.tar.xz
Checksums-Sha256:
 a27ccc3798013287b148d38dbac82a4207e4e845679501c0e000aab170414236 399120 libblockdev_2.26.orig.tar.gz
 0d0467f85e14e53cb937837dd8582d23c988cde5a780d30fc2eb05e272ed9724 10848 libblockdev_2.26-1.debian.tar.xz
Files:
 49db51728839942ce6b08ae19db063ca 399120 libblockdev_2.26.orig.tar.gz
 582e73edca90529f65a2ba2757c28233 10848 libblockdev_2.26-1.debian.tar.xz

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEECbOsLssWnJBDRcxUauHfDWCPItwFAmEaQ2EACgkQauHfDWCP
ItwFGxAAgL2YJSMCiEt4w8XpBmLbg0OgMLX241lLt3cOgg6yEhCnagk/yysx+12t
gXiW/NO7pHsT95VppZJLUIhuAVtkrnSEYZknnofGxD+2s1j6X0r/P6+CCyD31lsD
FxKI/otlSm9Vmp/csqkhnTIIoP7WmPSFx9te8R1ZnXkcgOwXg9BrnCaUlX9VXWsy
7p2gN6hzBQBHjagLlxXWIEnIm5Lu4hQA0QhDk6A8tREF+fARdX+ovgVxttkJLHW3
baoqOTCyEe0yo5WTYX3Lgp4OlyuwUQHUMdsmy79Tiuq/pcGkL+sm+OmWY20FSne/
frGtGxbmIQ/Paxp9FmEt4XxQDXYcfpO3D/tI2T9Z1jNtEsAuFcViBpWTTTqCNYe1
1a0whqgFCUjVCo0bXva69VsA503lr25rhJVKTPUDov04YdWoYcTWWxPWt8ebu3bD
HJ5lks2P94Hp2A8DTza4MgZAGcoc8lIFuWFrRqc4yU+VoUkYKZv5CeU+VN1J16A+
aZr7j7RhQcfHrzTiPYtmyuU9pVzCZxZR3cUaayqGlAnQbZLzRNK2pYBl7iHWmO3J
x1x5ggIMBlLg4y68qcaLnJuolwOG6HODASa6P65LUmAEu6rTmjR9mYJaXfxJ6G1I
dJNG3McwanOShKxKkWXoQ834T+/RUrKQ/VJi6qBxVN9rA2L8s8Q=
=MxgM
-----END PGP SIGNATURE-----
