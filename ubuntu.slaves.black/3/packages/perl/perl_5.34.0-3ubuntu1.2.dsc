-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: perl
Binary: perl-base, perl-doc, perl-debug, libperl5.34, libperl-dev, perl-modules-5.34, perl
Architecture: any all
Version: 5.34.0-3ubuntu1.2
Maintainer: Ubuntu Developers <ubuntu-devel-discuss@lists.ubuntu.com>
Uploaders: Dominic Hargreaves <dom@earth.li>
Homepage: http://dev.perl.org/perl5/
Standards-Version: 3.9.8
Vcs-Browser: https://salsa.debian.org/perl-team/interpreter/perl
Vcs-Git: https://salsa.debian.org/perl-team/interpreter/perl.git
Testsuite: autopkgtest
Testsuite-Triggers: build-essential, cpio, db-util, dist, dpkg-dev, gdbmtool, libapt-pkg-perl, libdpkg-perl, pkg-perl-autopkgtest
Build-Depends: file, cpio, libdb-dev, libgdbm-dev (>= 1.18-3), libgdbm-compat-dev, netbase <!nocheck>, procps [!hurd-any] <!nocheck>, debhelper-compat (= 13), zlib1g-dev | libz-dev, libbz2-dev, dpkg-dev (>= 1.17.14), dist (>= 3.5-236), libc6-dev (>= 2.19-9) [s390x]
Package-List:
 libperl-dev deb libdevel optional arch=any
 libperl5.34 deb libs optional arch=any
 perl deb perl standard arch=any
 perl-base deb perl required arch=any essential=yes
 perl-debug deb devel optional arch=any
 perl-doc deb doc optional arch=all
 perl-modules-5.34 deb libs standard arch=all
Checksums-Sha1:
 eca37348b91435b329a3e60376409ee265b9fda1 415412 perl_5.34.0.orig-regen-configure.tar.xz
 d461e206a1dca5e79d39e77debf0b564f6d77d37 12881416 perl_5.34.0.orig.tar.xz
 86093add285c5d594dce93873adfb53362be904b 192372 perl_5.34.0-3ubuntu1.2.debian.tar.xz
Checksums-Sha256:
 b168f566401fdccc13d0616c258854c1e1a461276922babca617097cd9dfd85b 415412 perl_5.34.0.orig-regen-configure.tar.xz
 82c2e5e5c71b0e10487a80d79140469ab1f8056349ca8545140a224dbbed7ded 12881416 perl_5.34.0.orig.tar.xz
 1c7dd2f42a3a2958b76c2c3a95362707cf00ee23e127fb4ab97f31d23b77798b 192372 perl_5.34.0-3ubuntu1.2.debian.tar.xz
Files:
 169eb75873e6bd40134abb028db49295 415412 perl_5.34.0.orig-regen-configure.tar.xz
 df7ecb0653440b26dc951ad9dbfab517 12881416 perl_5.34.0.orig.tar.xz
 28050babcb02e9eddb3d4b55b63b3d07 192372 perl_5.34.0-3ubuntu1.2.debian.tar.xz
Original-Maintainer: Niko Tyni <ntyni@debian.org>

-----BEGIN PGP SIGNATURE-----

iQFYBAEBCgBCFiEEGq96SdAIJY1vInRLbzAtCH6LqTYFAmRvar4kHGNhbWlsYS5j
YW1hcmdvZGVtYXRvc0BjYW5vbmljYWwuY29tAAoJEG8wLQh+i6k2SdcIAIbjOIKq
inDcGBw+bWcJkVZPSpXbnpMAEohDUt3I7w7Pr9Vcg3yXUBFVjbV9UYlNO0guLO5H
XXn0OcoZy9J3Pne+KCOfNBeQbwUKl+a1buUH7DTu9uJ6CZDilZFol9vlHdmQjbRy
bwdtDuB5D90Ma9JbDt8ZT78vYbxHvU+m3YL0tiLYOSyu5dwxurvULGir23250nEn
wcSo5hflSueG3TRk7/dMqK5tZpY5yGnitccEo3InDW0ZruWpBwwbpzGuO+BkRD6y
/4LcFEk1p0JYdtA610O6if5jWsasxbBhD/+yumnx7Vp7g8MdjirlpONpgbsKz6qk
Dn5NoCl1uSFJs/k=
=JZf+
-----END PGP SIGNATURE-----
