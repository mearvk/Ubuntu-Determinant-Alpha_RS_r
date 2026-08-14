-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: protobuf
Binary: ruby-google-protobuf, libprotobuf23, libprotobuf-lite23, libprotobuf-dev, libprotoc23, libprotoc-dev, protobuf-compiler, python3-protobuf, libprotobuf-java, elpa-protobuf-mode
Architecture: any all
Version: 3.12.4-1ubuntu7.22.04.1
Maintainer: Ubuntu Developers <ubuntu-devel-discuss@lists.ubuntu.com>
Homepage: https://github.com/google/protobuf/
Standards-Version: 4.5.1
Testsuite: autopkgtest
Testsuite-Triggers: build-essential, default-jdk, make, pkg-config, python3, zlib1g-dev
Build-Depends: debhelper-compat (= 12), dh-elpa [!i386], zlib1g-dev, libgmock-dev, libgtest-dev, dh-python, python3-all:any, libpython3-all-dev, python3-setuptools, python3-six, xmlto, unzip, rake-compiler, gem2deb
Build-Depends-Indep: ant, default-jdk, maven-repo-helper, libguava-java, libgoogle-gson-java
Package-List:
 elpa-protobuf-mode deb editors optional arch=all
 libprotobuf-dev deb libdevel optional arch=any
 libprotobuf-java deb java optional arch=all
 libprotobuf-lite23 deb libs optional arch=any
 libprotobuf23 deb libs optional arch=any
 libprotoc-dev deb libdevel optional arch=any
 libprotoc23 deb libs optional arch=any
 protobuf-compiler deb devel optional arch=any
 python3-protobuf deb python optional arch=any
 ruby-google-protobuf deb ruby optional arch=any
Checksums-Sha1:
 ecb79a1809b08bf186ecdd4b232814072efd341d 5310348 protobuf_3.12.4.orig.tar.gz
 6b243d57a7358ab6f7d0ad95bfddeb68ac542eaa 37932 protobuf_3.12.4-1ubuntu7.22.04.1.debian.tar.xz
Checksums-Sha256:
 512e5a674bf31f8b7928a64d8adf73ee67b8fe88339ad29adaa3b84dbaa570d8 5310348 protobuf_3.12.4.orig.tar.gz
 9c25c3c9505de19deb5ce0c36231bbc329de64808e5d0b684b9cfabcffb10c66 37932 protobuf_3.12.4-1ubuntu7.22.04.1.debian.tar.xz
Files:
 0f29b5c4a0d1903ba59606d37ddde318 5310348 protobuf_3.12.4.orig.tar.gz
 b612027beb8972b77ab891c5ef88c2a4 37932 protobuf_3.12.4-1ubuntu7.22.04.1.debian.tar.xz
Original-Maintainer: Laszlo Boszormenyi (GCS) <gcs@debian.org>
Ruby-Versions: all

-----BEGIN PGP SIGNATURE-----

iQHSBAEBCgA8FiEEs16801xnF7wK3rCK7Ic6ztRocjwFAmQJ07ceHG5pc2hpdC5t
YWppdGhpYUBjYW5vbmljYWwuY29tAAoJEOyHOs7UaHI8urwL/jtl9T/n1JlzZ1RC
O2LTpDm7DixO97orojg1JnhVxGbSNTT++/n75wlVqWbIX3NBfNQPyVV4TNsHoZnV
L8CGr1Y0+NUYQxvRJEntLVIzv7tOguAyY8m3+8w2x1dHDiAmuP2H7m5GhBg8T0oX
sD6AtvVncCIz0O+bQLoAXNKJZ9BFKwULWeRApQQA30LrVrmfz+qHR6isk4RkHKpI
0w/wUgr+nyWEPt0qFSC/+zha+iqHNMLei6PYss0NeL+A3h3stegjIDVdmEYlgiw9
Y4pCdqdGdzH/G2FWBrRwrPd3dh5iE1iFT5BF5NWgnDlWPpXkwVh+zlgixh5WAOOG
ftH6E1MV9Pja1oHMqHA5lj4CXp9f6jrw/Bqi9fQP+TaJw+h3NbeBE2NDF5Q8eoLH
aU6C7ycuU4WB34nLI8QvruPlCyiOv4DXlAOXvQonKLJIBnkM7jhPBswo1OwLaVNv
PyLSORD6eQuRrhVjhDFhMeX7do9Muhprs0ByTTssdbR7HWkV5g==
=GvcN
-----END PGP SIGNATURE-----
