-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: parted
Binary: parted, parted-udeb, libparted2, libparted-fs-resize0, libparted2-udeb, libparted-fs-resize0-udeb, libparted-i18n, libparted-dev, parted-doc
Architecture: any all
Version: 3.4-2build1
Maintainer: Ubuntu Developers <ubuntu-devel-discuss@lists.ubuntu.com>
Uploaders: Bastian Blank <waldi@debian.org>, Colin Watson <cjwatson@debian.org>
Homepage: https://www.gnu.org/software/parted
Standards-Version: 3.9.8
Vcs-Browser: https://salsa.debian.org/parted-team/parted
Vcs-Git: https://salsa.debian.org/parted-team/parted.git
Build-Depends: debhelper-compat (= 13), libncurses-dev | libncurses5-dev, libreadline-dev | libreadline6-dev, libdevmapper-dev [linux-any], uuid-dev, gettext, texinfo, libblkid-dev, pkg-config, check, autoconf, automake, autopoint, gperf
Package-List:
 libparted-dev deb libdevel optional arch=any
 libparted-fs-resize0 deb libs optional arch=any
 libparted-fs-resize0-udeb udeb debian-installer optional arch=any
 libparted-i18n deb localization optional arch=all
 libparted2 deb libs optional arch=any
 libparted2-udeb udeb debian-installer optional arch=any
 parted deb admin optional arch=any
 parted-doc deb doc optional arch=all
 parted-udeb udeb debian-installer optional arch=any
Checksums-Sha1:
 903c58fab429d3b62aa324033a3e41b0b96ad810 1860300 parted_3.4.orig.tar.xz
 71266bb4dc9883728972466fae61fbc9e7d20b6f 508 parted_3.4.orig.tar.xz.asc
 d1c81cf2b47dde979e51d038c71318bd409293ab 56408 parted_3.4-2build1.debian.tar.xz
Checksums-Sha256:
 e1298022472da5589b7f2be1d5ee3c1b66ec3d96dfbad03dc642afd009da5342 1860300 parted_3.4.orig.tar.xz
 d830f6d27ef3e11723e9cafa3f4f3b6aaa8cb00ec6ebbfa9cf1e0cf991913257 508 parted_3.4.orig.tar.xz.asc
 f924f690e01a94045d8bbe81080a63d862409e5be48f78980210e492d8194ac0 56408 parted_3.4-2build1.debian.tar.xz
Files:
 357d19387c6e7bc4a8a90fe2d015fe80 1860300 parted_3.4.orig.tar.xz
 2148025ea942dd50b38bd896c5a27a63 508 parted_3.4.orig.tar.xz.asc
 ed465840446be90fb72f9a64a118b255 56408 parted_3.4-2build1.debian.tar.xz
Original-Maintainer: Parted Maintainer Team <parted-maintainers@alioth-lists.debian.net>

-----BEGIN PGP SIGNATURE-----

iQJHBAEBCgAxFiEET7WIqEwt3nmnTHeHb6RY3R2wP3EFAmI8msATHGp1bGlhbmtA
dWJ1bnR1LmNvbQAKCRBvpFjdHbA/cUB9D/906ZIBy+6bRo16KlBRBit/uBu1bbOc
+nFpyBEZ7w1uU/G7WP3tGJwOsIG7DpdGTeXxdMclPSHcwyhnE0QzVOdEJ/QttFRC
JwkuBihXHvQJUSpBI3ejWjXHLnbaCn9gA6oX52L5Wk2lYABqTxm+GuefA4dBvbwm
TOFFWM22AqeR+sxsagNyC/Gol+9nVGHF+IJ2SadolKywcQInZWVPJW+0f1j/7Yu6
YIIFo9vsWbhhjzvlm8IxborEUhsDHaK006mYuy5nhOSdXe+/rcX5r6NB3seFxvmz
Ii1bGAy0NJ6OcxliLutXbFyDfqeWR/gC9FvXdRjTn8SIA3zp2YWanOnms8bkzI8M
gX0KilqYt2mExCcv4C5TrtIVKI4wQQdQyE8qx1KyyI7hEoqeS/okUvPioXaQ/mSq
JSgrJ8OieZ8jCG5gSqXQ+3bJpgXAWOZio/NzmzRVvwSH6pooEC1dUZjhIeFsXBqq
YTbspVucmnJTG9tAdNtqyWZ3O3sgCLt3fTWVaGLNcFsCv5Ony/rO2jEjyr1cvhbA
VyWRrZ6yI8uJ3gEtFmlDjL1IenrsSXpn5NBOAs4TCVZo2VHTmepYs2Iw6RhTkbDh
mntRzxaIAW9d/y3TtOENnAo2QY2xeUT+/QGoAltal7VFQkB+5lQS3EpDRKrMSBcK
NZ5OkvjtH+OI/Q==
=OMkQ
-----END PGP SIGNATURE-----
