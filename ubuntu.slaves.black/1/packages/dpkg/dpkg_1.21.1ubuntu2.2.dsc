-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (native)
Source: dpkg
Binary: dpkg, libdpkg-dev, dpkg-dev, libdpkg-perl, dselect
Architecture: any all
Version: 1.21.1ubuntu2.2
Maintainer: Ubuntu Developers <ubuntu-devel-discuss@lists.ubuntu.com>
Uploaders: Guillem Jover <guillem@debian.org>
Homepage: https://wiki.debian.org/Teams/Dpkg
Standards-Version: 4.6.0
Vcs-Browser: https://git.dpkg.org/cgit/dpkg/dpkg.git
Vcs-Git: https://git.dpkg.org/git/dpkg/dpkg.git
Testsuite: autopkgtest
Testsuite-Triggers: autoconf, build-essential, eatmydata, file, pkg-config
Build-Depends: debhelper-compat (= 13), pkg-config, gettext (>= 0.19.7), po4a (>= 0.59), zlib1g-dev, zstd, libbz2-dev, libzstd-dev, liblzma-dev, libselinux1-dev [linux-any], libncurses-dev (>= 6.1+20180210) | libncursesw5-dev, bzip2 <!nocheck>, xz-utils <!nocheck>
Package-List:
 dpkg deb admin required arch=any essential=yes
 dpkg-dev deb utils optional arch=all
 dselect deb admin optional arch=any
 libdpkg-dev deb libdevel optional arch=any
 libdpkg-perl deb perl optional arch=all
Checksums-Sha1:
 9a5984813f9ab7169e6cd7a28cfb2bdc5bce9a69 5213340 dpkg_1.21.1ubuntu2.2.tar.xz
Checksums-Sha256:
 2b6d8ea2f1d977f9395601c1a75057ea7c66c210f23d401d2162467641c215a8 5213340 dpkg_1.21.1ubuntu2.2.tar.xz
Files:
 385ee4176934c8ad8bae262f1d332548 5213340 dpkg_1.21.1ubuntu2.2.tar.xz
Original-Maintainer: Dpkg Developers <debian-dpkg@lists.debian.org>

-----BEGIN PGP SIGNATURE-----

iQJDBAEBCgAtFiEET7WIqEwt3nmnTHeHb6RY3R2wP3EFAmQr6DkPHGpha0BkZWJp
YW4ub3JnAAoJEG+kWN0dsD9xJRsP/0gE+K4UFxjnBSI6p201+P92yST8DpNy4tUR
DDj+BqNK0B27nUiI8958ba31nyCPOehpJDrdF6J8DXnXwCSq4O2dp3umA7KO+rVU
YD+lQszr32SRr9kTXEi9nbnj1tVycxHm93WWygS3LKCNUl6tVenRbON4yChgMiJP
ZWzP3unb/0bbiYQL+to1Xqn15Hcb3sgBC2j+CfF5zaY/ssJbsdaxcWCg3fz07yDS
zHMfJEKOVb98i/XiVCJLyvIf6y9W6rKvfmo/1hKu6u+1PTjqq+NJFNLeEXOXcGVz
0flooC9lrLqHJ8XKCtz4NT6swDecBYSs9mKFQVl+qCdW9nvmoe5t6bWwRFEYRqWm
RzlRADJ2kgrddhteNtlnhzccOLxfgnNrbuVpUpu40YZfyEr+Sldq7AdXS2B1gzUe
6lI3WhW2kVHGzTtGBbhGVuMS6878UPaaY08YMGNGHFRBN/h04oZuvWo/VRGB2U9X
GIzJMcL9u0+dJFOdUc1KKQe+8IbNqaZ0E7uhFYr78ifvLJTkfDsQR7MMA3UBXqhK
qHkx6g5vpH8ONQu+7VoMpO5HMPS/UtwGvQWIxEfZaZmiY48Krp5vljUJdvHW5kA1
lt3Dbau0ZDN8pqkak+SZxujfUzfPMVKHJUzjZ6AAea4Us8kCJymPAcaYix9vR7Zk
+MHcI5uC
=j8wX
-----END PGP SIGNATURE-----
