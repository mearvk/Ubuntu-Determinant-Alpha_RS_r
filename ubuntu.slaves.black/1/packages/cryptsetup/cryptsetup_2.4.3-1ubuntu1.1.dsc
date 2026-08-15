-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: cryptsetup
Binary: cryptsetup, cryptsetup-bin, cryptsetup-initramfs, cryptsetup-suspend, cryptsetup-run, libcryptsetup12, libcryptsetup-dev, cryptsetup-udeb, libcryptsetup12-udeb
Architecture: linux-any all
Version: 2:2.4.3-1ubuntu1.1
Maintainer: Ubuntu Developers <ubuntu-devel-discuss@lists.ubuntu.com>
Uploaders: Jonas Meurer <jonas@freesources.org>, Guilhem Moulin <guilhem@debian.org>
Homepage: https://gitlab.com/cryptsetup/cryptsetup
Standards-Version: 4.6.0
Vcs-Browser: https://salsa.debian.org/cryptsetup-team/cryptsetup
Vcs-Git: https://salsa.debian.org/cryptsetup-team/cryptsetup.git -b debian/latest
Testsuite: autopkgtest
Build-Depends: autoconf, automake (>= 1:1.12), autopoint, debhelper-compat (= 13), dh-strip-nondeterminism, docbook-xml <!nodoc>, docbook-xsl <!nodoc>, gettext, jq <!nocheck>, libargon2-dev, libblkid-dev, libdevmapper-dev, libjson-c-dev, libpopt-dev, libselinux1-dev, libsepol-dev, libssh-dev, libssl-dev, libtool, pkg-config, po-debconf, procps <!nocheck>, uuid-dev, xsltproc <!nodoc>, xxd <!nocheck>
Package-List:
 cryptsetup deb admin optional arch=linux-any
 cryptsetup-bin deb admin optional arch=linux-any
 cryptsetup-initramfs deb admin optional arch=all
 cryptsetup-run deb oldlibs optional arch=all
 cryptsetup-suspend deb admin optional arch=amd64,arm64,armhf,ppc64el,riscv64,s390x
 cryptsetup-udeb udeb debian-installer optional arch=linux-any profile=!noudeb
 libcryptsetup-dev deb libdevel optional arch=linux-any
 libcryptsetup12 deb libs optional arch=linux-any
 libcryptsetup12-udeb udeb debian-installer optional arch=linux-any profile=!noudeb
Checksums-Sha1:
 a35acf0d69229888089f31ad9b56ad3ea96b902b 11434956 cryptsetup_2.4.3.orig.tar.gz
 44de0d1c6e27aeeb7a38c9c957b72306303a9e04 140108 cryptsetup_2.4.3-1ubuntu1.1.debian.tar.xz
Checksums-Sha256:
 95ee4ec84d59e582eba2409281d8a41a1cc3eff3b4df91fed6dbe1df65b0614f 11434956 cryptsetup_2.4.3.orig.tar.gz
 116b9e2ca44149514d6a56dd611bf93de3d4d7847269220ee7e7c026dd9c7383 140108 cryptsetup_2.4.3-1ubuntu1.1.debian.tar.xz
Files:
 d6f5b44b4a775980c7f57b029e878cfd 11434956 cryptsetup_2.4.3.orig.tar.gz
 727fc106a4161701409d3c11806d336f 140108 cryptsetup_2.4.3-1ubuntu1.1.debian.tar.xz
Original-Maintainer: Debian Cryptsetup Team <pkg-cryptsetup-devel@alioth-lists.debian.net>

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEpi0s+9ULm1vzYNVLFZ61xO/Id0wFAmLs5IkACgkQFZ61xO/I
d0yuuQ/9F/8SPDlcyZL/h/SuSk7NlIHHt8F+nUusQ21jJbBeO9H7Tl/Xpdoo9m/b
1NCipMFJZZp4UAaIf6CNT7+lJscnXMQVqhHI5cug59geobsfTm/o7WbgH3wpUHcw
7hBzpFr1aAMgOH5IzVNosKMic6jyWNdFAPztFyA1H78nIYzOjJvYaXaaAEob2qp8
9ABvw79cfDNUlraDVuD9kIlLNzQWc/O0cLcPHSL9QUPzu4vTwDg0Rznbu2dlgYUl
+bO0UMBZpEhBwNYgvrzciLdyRnJ0AGGyOQJSz5Vlk67HkK4eT9SWloykS+dRn47C
IC9AHspzPNY7wySy0zxHuioJjTV8stAou6jbtKQzRg8ekoiQmgofaHwVujt4Y47e
8BGTv2H9t9CfT3j1moSyxlSqBhOVBzzb/PWrMogk9qyMhKVuPM14DqeDUXNAkevs
tV/s+WWtS2/E9tTsdV5Br/UD9v63rBdFJvyo5AepR2pN8cbQrsrGpiAO2a3HRsMj
K/dEZ8W491ZlfqPmRdr6DihzTYunIr6mIryb5AdVrVUOxg8igtvwqOHxcQRWOOOI
ckviC3JyqpH91fGkKBuRgic8wYUOvzMOF2YHJp6PHD3stP/iQTZuLn86MBd0JnIh
Uqg//9wTcPvvjI4iRT/fINqEPHTzXzkzYUv7oqxYXp98s2SLOOY=
=4nj/
-----END PGP SIGNATURE-----
