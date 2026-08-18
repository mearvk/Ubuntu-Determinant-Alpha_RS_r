-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: fftw3
Binary: libfftw3-3, libfftw3-single3, libfftw3-double3, libfftw3-long3, libfftw3-quad3, libfftw3-bin, libfftw3-mpi3, libfftw3-dev, libfftw3-mpi-dev, libfftw3-doc
Architecture: any all
Version: 3.3.8-2ubuntu8
Maintainer: Ubuntu Developers <ubuntu-devel-discuss@lists.ubuntu.com>
Uploaders: Paul Brossier <piem@debian.org>, Julian Taylor <jtaylor.debian@googlemail.com>
Homepage: http://fftw.org
Standards-Version: 4.2.1
Vcs-Browser: https://salsa.debian.org/science-team/fftw3
Vcs-Git: https://salsa.debian.org/science-team/fftw3.git
Testsuite: autopkgtest
Testsuite-Triggers: build-essential
Build-Depends: chrpath, debhelper (>= 9), dh-autoreconf, dpkg (>= 1.16.0), gfortran, mpi-default-dev [!i386], texinfo
Build-Depends-Indep: ghostscript (>> 8.63), transfig
Package-List:
 libfftw3-3 deb oldlibs optional arch=any
 libfftw3-bin deb libs optional arch=any
 libfftw3-dev deb libdevel optional arch=any
 libfftw3-doc deb doc optional arch=all
 libfftw3-double3 deb libs optional arch=any
 libfftw3-long3 deb libs optional arch=amd64,arm64,hurd-i386,i386,ia64,kfreebsd-amd64,kfreebsd-i386,mips64,mips64el,powerpc,powerpcspe,ppc64el,riscv64,s390,s390x,sparc,x32
 libfftw3-mpi-dev deb libdevel optional arch=amd64,arm64,armhf,ppc64el,riscv64,s390x
 libfftw3-mpi3 deb libs optional arch=amd64,arm64,armhf,ppc64el,riscv64,s390x
 libfftw3-quad3 deb libs optional arch=amd64,hurd-i386,i386,kfreebsd-amd64,kfreebsd-i386,x32
 libfftw3-single3 deb libs optional arch=any
Checksums-Sha1:
 59831bd4b2705381ee395e54aa6e0069b10c3626 4110137 fftw3_3.3.8.orig.tar.gz
 9af244106c9fdbb7933ed0e7da465ed00881b2e1 14356 fftw3_3.3.8-2ubuntu8.debian.tar.xz
Checksums-Sha256:
 6113262f6e92c5bd474f2875fa1b01054c4ad5040f6b0da7c03c98821d9ae303 4110137 fftw3_3.3.8.orig.tar.gz
 2bddf40b42383167b221d7adfc7937b102b366053c3e6055f3864fb7b98c3050 14356 fftw3_3.3.8-2ubuntu8.debian.tar.xz
Files:
 8aac833c943d8e90d51b697b27d4384d 4110137 fftw3_3.3.8.orig.tar.gz
 92b78c0fe1b906351e64c358575fdf38 14356 fftw3_3.3.8-2ubuntu8.debian.tar.xz
Original-Maintainer: Debian Science Team <debian-science-maintainers@lists.alioth.debian.org>

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEqx+XcX7ftBm4bj5/AhnKGdA0MwwFAmI7JgAACgkQAhnKGdA0
Mwwu2Qf/R4ufRlAHjUdhGo2IOLBEcwrxwDp7NnZ4vF9/fkHUZedFMtdpdPm50m4j
yI09sm4LdgviMhzqkz2YZFuLGit42eaAUQVRDJjOQdvreRaVVyapyGrNtDq/vxl/
eDDhyRZNYtSvNWb49tJW2XZ1kxqPHKvB9BCDIbPwcIDsBu/KDiiC7nG4wXVSye+C
jhpMKxJWoEeJ5h6D2yc8thtVGbr/+hFb1Po+crkQ9Add8JNMYp1H/049JVmek1Kc
EwZ8WJ2Sq05Sg/4vHLEJFpkq+tPV9aYiEmmUaO0gOd+FtmLVBSNgdAVPCd0gJkeW
lCrsoXrP29qnny287f9chmOHFIpdNw==
=+mHC
-----END PGP SIGNATURE-----
