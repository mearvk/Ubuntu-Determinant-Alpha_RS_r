-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: libassuan
Binary: libassuan0, libassuan-dev, libassuan-mingw-w64-dev
Architecture: any all
Version: 2.5.5-1build1
Maintainer: Ubuntu Developers <ubuntu-devel-discuss@lists.ubuntu.com>
Uploaders:  Eric Dorland <eric@debian.org>, Daniel Kahn Gillmor <dkg@fifthhorseman.net>,
Homepage: https://www.gnupg.org/related_software/libassuan/index.html
Standards-Version: 4.6.0.0
Vcs-Browser: https://salsa.debian.org/debian/libassuan
Vcs-Git: https://salsa.debian.org/debian/libassuan.git -b debian/master
Testsuite: autopkgtest
Testsuite-Triggers: build-essential, gcc-mingw-w64-i686, gcc-mingw-w64-x86-64, pkg-config, wine32, wine64
Build-Depends: debhelper-compat (= 13), libgpg-error-dev (>= 1.33)
Build-Depends-Indep: libgpg-error-mingw-w64-dev, mingw-w64
Package-List:
 libassuan-dev deb libdevel optional arch=any
 libassuan-mingw-w64-dev deb libdevel optional arch=all
 libassuan0 deb libs optional arch=any
Checksums-Sha1:
 ec4f67c0117ccd17007c748a392ded96dc1b1ae9 572263 libassuan_2.5.5.orig.tar.bz2
 b413c221b60b36f3ef852007082afe174de5ba85 228 libassuan_2.5.5.orig.tar.bz2.asc
 ffde9a13948dcafe4ecc60aab16f5695bf4989e9 14448 libassuan_2.5.5-1build1.debian.tar.xz
Checksums-Sha256:
 8e8c2fcc982f9ca67dcbb1d95e2dc746b1739a4668bc20b3a3c5be632edb34e4 572263 libassuan_2.5.5.orig.tar.bz2
 8bb0d1d818ac91fa27a8ebed2975dac12eac9a6e075dfba225cc488ac9b4133f 228 libassuan_2.5.5.orig.tar.bz2.asc
 53b3b6a66e131163924ca222d661705e5c55d8f506b0111763469b168f125b78 14448 libassuan_2.5.5-1build1.debian.tar.xz
Files:
 7194453152bb67e3d45da698762b5d6f 572263 libassuan_2.5.5.orig.tar.bz2
 d4642c6e0198f8eb576aa98adc10c1b0 228 libassuan_2.5.5.orig.tar.bz2.asc
 c5ecf0c51888a251ed340b21c39aa9b3 14448 libassuan_2.5.5-1build1.debian.tar.xz
Original-Maintainer: Debian GnuPG-Maintainers <pkg-gnupg-maint@lists.alioth.debian.org>

-----BEGIN PGP SIGNATURE-----

iQJHBAEBCgAxFiEET7WIqEwt3nmnTHeHb6RY3R2wP3EFAmI8X3oTHGp1bGlhbmtA
dWJ1bnR1LmNvbQAKCRBvpFjdHbA/caiPD/0Q+5PGKKUpvY5j5qy4N+GHZySNBEXC
73LZhOeS2FBpE9eD23COdIl/T5sLMwq3KrCep3YYefcbhOO5ksL7kUDdHasA3Fli
nNm+ciszjygvW9XLFzrsZsSFd1oN3siVq4oRwjcNzD8aUIGmXq2AlqgCOxWR6wP/
gJcMgvA6CUCUD0iwOpUKYDBmFaY9YqD93NQYDRHJlhIz4r8Pg8Zuxtu/kpjxLZU3
XcEikLB8qFNaji7v3dPPigH35n/TxK8JA1XRJpnRIifIoaTNeZKk+31X+grxBBJc
2pKtiqVB3RjZ0tPD6q3KxpejDj0F6J6c8U6oofV5qfu6g12CCp2xXvgwbW7mzc47
GS0K0bA1Hds0K8a72KNBUfWQoOA5t3TUDrGHYkb8bhnjeW1OuCCczukxi3+egaOE
AxohlfKHNpWPQ4gEGbHGoPcKvvQRNuZGLgXLaCn3NGPe7Bb2Q/q2hLleW9hwMW+5
f1s5CoLe0iYPN0TcRqnie7svzz3LHAFhE5kUGox0sZc3IJvxi3XQ8qzx7iZpLnXj
mDUYBSCCch9yeU6pQB9KLIvGbjN+DFP4pjjVpsJ7lfOzn/6W04Y94fJn7WGHpmME
3kTpVevDsduAx9V0FiAwQPTE2HzDfr4tmWphPjyNOqsqWhariOgk9P78NDctD5ra
pJAT9gBrfFPhwA==
=WRDY
-----END PGP SIGNATURE-----
