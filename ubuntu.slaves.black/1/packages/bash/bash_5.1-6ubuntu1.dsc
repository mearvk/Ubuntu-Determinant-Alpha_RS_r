-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

Format: 3.0 (quilt)
Source: bash
Binary: bash, bash-static, bash-builtins, bash-doc
Architecture: any all
Version: 5.1-6ubuntu1
Maintainer: Ubuntu Developers <ubuntu-devel-discuss@lists.ubuntu.com>
Homepage: http://tiswww.case.edu/php/chet/bash/bashtop.html
Standards-Version: 4.6.0
Vcs-Browser: https://code.launchpad.net/~doko/+junk/pkg-bash-debian
Vcs-Bzr: http://bazaar.launchpad.net/~doko/+junk/pkg-bash-debian
Testsuite: autopkgtest
Build-Depends: autoconf, autotools-dev, bison, libncurses5-dev, texinfo, texi2html, debhelper (>= 11), gettext, sharutils, locales <!nocheck>, time <!nocheck>, xz-utils, dpkg-dev (>= 1.16.1)
Build-Depends-Indep: texlive-latex-base, ghostscript, texlive-fonts-recommended, man2html-base
Build-Conflicts: r-base-core
Package-List:
 bash deb shells required arch=any essential=yes
 bash-builtins deb utils optional arch=any
 bash-doc deb doc optional arch=all
 bash-static deb shells optional arch=any
Checksums-Sha1:
 b0039f7528b9c649c16982ea942d7054cfe06938 5802740 bash_5.1.orig.tar.xz
 e945dd18028b3f810f545dd859fe5fcb5f2cdcc1 99652 bash_5.1-6ubuntu1.debian.tar.xz
Checksums-Sha256:
 d5eeee4f953c09826409d572e2e8996a2140d67eb8f382ce1f3a9d23883ad696 5802740 bash_5.1.orig.tar.xz
 78e2cfa2399506de09e750e93a627f84b0ad6c8cfc99210e2717c337c88a861c 99652 bash_5.1-6ubuntu1.debian.tar.xz
Files:
 6ddb13b6111f601db08fc7c72afa0263 5802740 bash_5.1.orig.tar.xz
 7fc84c1304cfa0e2cb88353ac8a6b1c7 99652 bash_5.1-6ubuntu1.debian.tar.xz
Original-Maintainer: Matthias Klose <doko@debian.org>

-----BEGIN PGP SIGNATURE-----

iQJEBAEBCAAuFiEE1WVxuIqLuvFAv2PWvX6qYHePpvUFAmHXF/EQHGRva29AdWJ1
bnR1LmNvbQAKCRC9fqpgd4+m9c7+D/4oXWVY1vPkOCsY+3go/DNf/us0K+Aog57k
00GOmhlW1Y4B1lC51syGAV/cswLCoH6YZSqNtsk4MU5vxTgzSCXU99X5NmY5sNYz
60eWdPV6iU5stfq5J4fJP1zY/z5w7uTTdRDYZwBFRR9+KDmo2oUAdM8IIc063N7n
AOVaqxsR6j3hMiX0wWORn9Lr3lBIrQI8xHbAeNXtCA+ZePkqAF/uuyxxjfF/COlB
MIl69H1buCVUWxTSGD/MJrCjznoxvmddJ2RGUcKyAxWD2rXaMRzi61jFdPXG6Ypx
QVFe6EiArM/WK3clEEj/+x1wrzwli7bbGSWD5X3d1xFdJjbV6ahDZ3SbDFD/SL0j
bfDJyMLXYDN+ZXZbaShz8aHUSIZy5ZjDuSHcxAqgjTKDk7CVpglFtb1+pAhOZxz7
mqwHcCuLmhkT95ANkY1aLQtDFjb3qZ1MWTgBUJPH04cki/4YTFXFlYdO5DcbxL5J
ep34sPfJRWzKN6rySFhKFNp+MF5haR2KRbDImI8oF270mPEJo/RZhd+wbPCK6Z1k
wWMVMJbZhUN9jr+1BjZ21oTKzYLBAtmSVJEHPpDF8VGpM0IO3u8mxNjhLESmKDDx
cGqSktuCHvli6/IAD8iL5A5IM/8ZsDdE4OAX838AF9Sc8B+z5wsg0k3wQ7yaWHA6
x0r/uA/VCg==
=lpkp
-----END PGP SIGNATURE-----
