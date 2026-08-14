-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: pam
Binary: libpam0g, libpam-modules, libpam-modules-bin, libpam-runtime, libpam0g-dev, libpam-cracklib, libpam-doc
Architecture: any all
Version: 1.4.0-11ubuntu2.3
Maintainer: Ubuntu Developers <ubuntu-devel-discuss@lists.ubuntu.com>
Uploaders: Sam Hartman <hartmans@debian.org>
Homepage: http://www.linux-pam.org/
Standards-Version: 4.3.0
Vcs-Git: https://code.launchpad.net/~ubuntu-core-dev/ubuntu/+source/pam/+git/pam
Build-Depends: libcrack2-dev (>= 2.8), bzip2, debhelper (>= 9), quilt (>= 0.48-1), flex, libdb-dev, libselinux1-dev [linux-any], po-debconf, dh-autoreconf, autopoint, libaudit-dev [linux-any] <!stage1>, pkg-config, libfl-dev, libfl-dev:native, docbook-xsl, docbook-xml, xsltproc, libxml2-utils, w3m
Build-Conflicts: libdb4.2-dev, libxcrypt-dev
Build-Conflicts-Indep: fop
Package-List:
 libpam-cracklib deb admin optional arch=any
 libpam-doc deb doc optional arch=all
 libpam-modules deb admin required arch=any
 libpam-modules-bin deb admin required arch=any
 libpam-runtime deb admin required arch=all
 libpam0g deb libs optional arch=any
 libpam0g-dev deb libdevel optional arch=any
Checksums-Sha1:
 e26c6594c14680da42ea2875b60664ec159670bf 988908 pam_1.4.0.orig.tar.xz
 0b6eef1711fd6e83393fe6bdd333952236318ad0 168864 pam_1.4.0-11ubuntu2.3.debian.tar.xz
Checksums-Sha256:
 cd6d928c51e64139be3bdb38692c68183a509b83d4f2c221024ccd4bcddfd034 988908 pam_1.4.0.orig.tar.xz
 e5b522e94bdfba1800632a5b1adc1233cb7b028978c7eb6665382b010613c8ad 168864 pam_1.4.0-11ubuntu2.3.debian.tar.xz
Files:
 39fca0523bccec6af4b63b5322276c84 988908 pam_1.4.0.orig.tar.xz
 aaa7491f2456d2bb0f4d4691864fbf66 168864 pam_1.4.0-11ubuntu2.3.debian.tar.xz
Debian-Vcs-Browser: https://salsa.debian.org/vorlon/pam
Debian-Vcs-Git: https://salsa.debian.org/vorlon/pam.git
Original-Maintainer: Steve Langasek <vorlon@debian.org>

-----BEGIN PGP SIGNATURE-----

iQHSBAEBCgA8FiEEs16801xnF7wK3rCK7Ic6ztRocjwFAmPcAw0eHG5pc2hpdC5t
YWppdGhpYUBjYW5vbmljYWwuY29tAAoJEOyHOs7UaHI8tYUMAM/dlNXv/U8cZ5pg
clwCL77J6Qz9T+xC0dULvvQX1Dae2lS0h5BY6fI6SZPuzU6EhRW4H+/qIA8SmdlE
BmHj2PXsiCH3jyD56iaFznZOHRjDkfKSYYDmzm7q29+pohmC1eeP4IQjk2H1OJIW
nhgglzJWO77r8sbCDm4jzYXZL+lC+kFTXgOlNse29hRpsGxztGiD8UECZ+r5BwSw
bf3IfZfaXkoiu8vaUXT81odY5KyMlTK/t9CHyXWXd9Zk1vw9nRu7xQf6fbWrFc15
s0rCxOXPcIVtf0l0Qq2jIb1veX3FuxMDImS2ZpaRQpO63t8A7Vq7mbs/H6zwqr2V
mLRNpVrzAcrVpz22rM/GPExjdI/VBg6MzK8pD2oLV4wI2DYhkouyQLd0nY8rXyuI
989oJx8JwH7+fzxxMKevKE36VdokRQYxVTQh7aRqvj8k+4r5mLO0XGr2MSo8aviJ
igBc5yk1zLW3rxVXyFRJQZRShx7+Ded20eMBI0R/x4XLNPPIBg==
=l1gm
-----END PGP SIGNATURE-----
