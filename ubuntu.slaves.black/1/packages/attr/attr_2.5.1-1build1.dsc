-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: attr
Binary: attr, libattr1-dev, libattr1, attr-udeb, libattr1-udeb
Architecture: any
Version: 1:2.5.1-1build1
Maintainer: Guillem Jover <guillem@debian.org>
Homepage: https://savannah.nongnu.org/projects/attr/
Standards-Version: 4.5.1
Vcs-Browser: https://git.hadrons.org/cgit/debian/pkgs/attr.git
Vcs-Git: https://git.hadrons.org/git/debian/pkgs/attr.git
Testsuite: autopkgtest
Testsuite-Triggers: autoconf, automake, autopoint, build-essential, libtool
Build-Depends: debhelper-compat (= 13), autoconf, automake, gettext, libtool
Package-List:
 attr deb utils optional arch=any
 attr-udeb udeb debian-installer optional arch=any profile=!noudeb
 libattr1 deb libs optional arch=any
 libattr1-dev deb libdevel optional arch=any
 libattr1-udeb udeb debian-installer optional arch=any profile=!noudeb
Checksums-Sha1:
 cd0cce2f621b5c5e3443d805b276f9875ed9eba0 318188 attr_2.5.1.orig.tar.xz
 b886937d79d2843147f42a827d77f9c28ce2a0ec 833 attr_2.5.1.orig.tar.xz.asc
 c5e14abb5de2fdc9ee6ec0a7bee24d4dfa724b17 28032 attr_2.5.1-1build1.debian.tar.xz
Checksums-Sha256:
 db448a626f9313a1a970d636767316a8da32aede70518b8050fa0de7947adc32 318188 attr_2.5.1.orig.tar.xz
 67bc632e754efbadba846d0b40138b3fc3e306c3b909a9ba868c6dba1e2689d0 833 attr_2.5.1.orig.tar.xz.asc
 5486d1f904183bff993d23c84d9513f796464e30bf8d536bd2a211d6c5abd1ce 28032 attr_2.5.1-1build1.debian.tar.xz
Files:
 e459262266bbd82b3dd348fc8cc68a6d 318188 attr_2.5.1.orig.tar.xz
 e2e236be0779557fcd591068c6ab28ff 833 attr_2.5.1.orig.tar.xz.asc
 b8588dc273dbe35269d41c087704ab80 28032 attr_2.5.1-1build1.debian.tar.xz

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEqx+XcX7ftBm4bj5/AhnKGdA0MwwFAmI662IACgkQAhnKGdA0
Mwwg2Qf/THXCtCHA1baqZj594uHzDVpzAbfqOQAwGCcW4X6inPFf7h+n3Muqp6M1
Jn+bqc7eJtFk92bvNOtFqRxmm9ghSHv8S9w4PXVNz6JWc5WN7sHvAPzMwhp7DVoS
vtknIE+BE8VpbwII3LNTTHAdh+NdCqNvVKTvv5o2LPP1iznkB8CzuNPJ+RfqXW2B
w/euZ68X2fBb97yKhZ1IzM2BFQwN6nFiJzf7TK6X0z/LpDTXQgKznJLizqngc8Df
FEZR7bf0kvWY17gZPTp5rat7ieS5FYUuSMx5dShNAwqgkv19VjFgjFgNW9QhwQYL
083kCX8alX9+P09wNuwwpLFMcO6chA==
=+RMY
-----END PGP SIGNATURE-----
