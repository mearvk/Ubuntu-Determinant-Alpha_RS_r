-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (native)
Source: apt
Binary: apt, libapt-pkg6.0, apt-doc, libapt-pkg-dev, libapt-pkg-doc, apt-utils, apt-transport-https
Architecture: any all
Version: 2.4.9
Maintainer: APT Development Team <deity@lists.debian.org>
Uploaders: Michael Vogt <mvo@debian.org>, Julian Andres Klode <jak@debian.org>, David Kalnischkies <donkult@debian.org>
Standards-Version: 4.1.1
Vcs-Browser: https://salsa.debian.org/apt-team/apt
Vcs-Git: https://salsa.debian.org/apt-team/apt.git
Testsuite: autopkgtest
Testsuite-Triggers: @builddeps@, aptitude, db-util, dpkg, fakeroot, gdb, gdb-minimal, gnupg, gnupg1, gnupg2, gpgv, gpgv1, gpgv2, libfile-fcntllock-perl, lsof, pkg-config, python3-apt, stunnel4, valgrind, wget
Build-Depends: cmake (>= 3.4), debhelper-compat (= 12), docbook-xml, docbook-xsl, dpkg-dev (>= 1.20.8), gettext (>= 0.12), googletest <!nocheck> | libgtest-dev <!nocheck>, libbz2-dev, libdb-dev, libgnutls28-dev (>= 3.4.6), libgcrypt20-dev, liblz4-dev (>= 0.0~r126), liblzma-dev, libseccomp-dev (>= 2.4.2) [amd64 arm64 armel armhf i386 mips mips64el mipsel ppc64el s390x hppa powerpc powerpcspe ppc64 x32], libsystemd-dev [linux-any], libudev-dev [linux-any], libxxhash-dev (>= 0.8), libzstd-dev (>= 1.0), ninja-build, pkg-config, po4a (>= 0.34-2), triehash, xsltproc, zlib1g-dev
Build-Depends-Indep: doxygen, graphviz, w3m
Package-List:
 apt deb admin important arch=any
 apt-doc deb doc optional arch=all
 apt-transport-https deb oldlibs optional arch=all
 apt-utils deb admin important arch=any
 libapt-pkg-dev deb libdevel optional arch=any
 libapt-pkg-doc deb doc optional arch=all
 libapt-pkg6.0 deb libs optional arch=any
Checksums-Sha1:
 1a3f82a6a3237c1a686efd69471f28354b77f441 2317652 apt_2.4.9.tar.xz
Checksums-Sha256:
 dc3a48bc210ca0529ad1bae8d2cbd7f5b95b467b7377c6a7bb93819a0f7f8fd8 2317652 apt_2.4.9.tar.xz
Files:
 8353cb9ed0061526247651c3936c014d 2317652 apt_2.4.9.tar.xz

-----BEGIN PGP SIGNATURE-----

iQJHBAEBCgAxFiEET7WIqEwt3nmnTHeHb6RY3R2wP3EFAmNf48kTHGp1bGlhbmtA
dWJ1bnR1LmNvbQAKCRBvpFjdHbA/cU0iD/9J0ka0FwQxQrAqjyfIX7YKjcQmrg7m
IxVt/k+1FgP0evyNmK6fa3W1zqDP3lSKGnOtPrsOYLhemq/gbkG8/WUQ8RcQZevr
41+0fo8HDNrSB5yEpUV0hdGpqJeEtWEuqKE1AGZLUBXowRN1OgRNKV4VGZFILzxL
Basm4aftY+A6A+jUKbBLtBdyarmiMn4YTQzpU+stIO8K9G/ZYuChcx4BJjUPSPo2
tQQ1ZaJHWqMZDKnCWjQSNAKEcyOjg0ipAhmjo7tby4msM5WxIneEgtEOeUQKFuwG
wrJm0B6n91dF20LrIkv8htNnYvrI5wCRO+R5QWeyu0B5uZLd1SHiUkgQtyJqWdiI
vQRWQYD9KlRMXJWTOly1vatoXeo7kmfQVaDerdWEw5TT6OboK/pmzVoq9h1lmVhu
/1BmcqhIaSk4sdVhPDff6skuB1GnVpl863ZfvwygfgWR04OjMmpnvUkOAIuup+aZ
OsSAaHAa3WC7vVYIjDauUufKSYxPXo9BA+Q5MezjPssXO4PjaugWCBG2Hfbc5eJ8
iOM+nhskH/t01y5HZkuvcqFx7smvSOEa9oWqX5TVXygi7iuGT+rXzy45lvRK1q7g
lW5NkwEJKyDVVgSD5SDvoNig4na4BAgJlM5qlkBCQGU78tD351v4COMxvfwxMtZg
KmBD7/9ahS/ndg==
=Cmzv
-----END PGP SIGNATURE-----
