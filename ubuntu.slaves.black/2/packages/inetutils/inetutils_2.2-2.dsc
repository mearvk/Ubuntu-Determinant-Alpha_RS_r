-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: inetutils
Binary: inetutils-syslogd, inetutils-inetd, inetutils-ping, inetutils-traceroute, inetutils-tools, inetutils-ftp, inetutils-ftpd, inetutils-telnet, inetutils-telnetd, inetutils-talk, inetutils-talkd
Architecture: any
Version: 2:2.2-2
Maintainer: Guillem Jover <guillem@debian.org>
Homepage: https://www.gnu.org/software/inetutils/
Standards-Version: 4.5.1
Vcs-Browser: https://git.hadrons.org/cgit/debian/pkgs/inetutils.git
Vcs-Git: https://git.hadrons.org/git/debian/pkgs/inetutils.git
Testsuite: autopkgtest
Testsuite-Triggers: autoconf, automake, build-essential, file, gettext, net-tools, netbase
Build-Depends: debhelper-compat (= 13), netbase <!nocheck>, net-tools <!nocheck>, autoconf, automake, bison, libreadline-dev | libreadline6-dev | libreadline5-dev, libncurses-dev, libpam0g-dev, libwrap0-dev, libkrb5-dev
Build-Conflicts: autoconf2.13, automake1.4
Package-List:
 inetutils-ftp deb net optional arch=any
 inetutils-ftpd deb net optional arch=any
 inetutils-inetd deb net optional arch=any
 inetutils-ping deb net optional arch=any
 inetutils-syslogd deb net optional arch=any
 inetutils-talk deb net optional arch=any
 inetutils-talkd deb net optional arch=any
 inetutils-telnet deb net optional arch=any
 inetutils-telnetd deb net optional arch=any
 inetutils-tools deb net optional arch=any
 inetutils-traceroute deb net optional arch=any
Checksums-Sha1:
 a6b0783d315657e51a09ee281af1210cc5293b9f 1529508 inetutils_2.2.orig.tar.xz
 bcf6f5804cba5915d1fb513d2981b09164c162ac 488 inetutils_2.2.orig.tar.xz.asc
 8b03ed194bda254c1ed9eb62a1d3001a296f1f1d 77704 inetutils_2.2-2.debian.tar.xz
Checksums-Sha256:
 d547f69172df73afef691a0f7886280fd781acea28def4ff4b4b212086a89d80 1529508 inetutils_2.2.orig.tar.xz
 812c2c7837a9729f73e4af99a13ef649405b737530070cccb4a6f41d2cd81b74 488 inetutils_2.2.orig.tar.xz.asc
 4aeb942ae2913a527f1c301e8f52b280e96ebaa8eaf084228d9d7073562f7d0a 77704 inetutils_2.2-2.debian.tar.xz
Files:
 de8c1b49cbde2b30e481c61c65357ad4 1529508 inetutils_2.2.orig.tar.xz
 fc503b580068e616dbb85e4316435691 488 inetutils_2.2.orig.tar.xz.asc
 d25255292f4c9422976a4c816877ee53 77704 inetutils_2.2-2.debian.tar.xz

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEETz509DYFDBD1aWV0uXK/PqSuV6MFAmE0M+YACgkQuXK/PqSu
V6OYLxAAzzbtG10/gcHHTrzwLFz+QdvO/isFNSYcexm8KsBGMIHx+hf0zn2p1ypI
fTd7SmaLO3fgeWTEbJbbN58M7GMRigC++zuVyYSG/YaK/yGEUNBeazBDSN0UGEMH
qqeu1C2gqpZXuZoPhdi4hz4vMcx0xBNbKsKbwD6N0f9TP+nBCl3IwvllS3gFLoV8
T+4if5kNHDYjTEzAos32vPSprwLlh3DQsMYZ+XsnWp4+ecXfodIMrYyJbTYTKoaU
qbcaB9ZvpAjVaULvj/emOo1iXkxVGk9E6F9wwDsJVRAHYaG3vwK169RKEuzq3YPl
1WCcgalDwkIOJyoGZHQ5awh4NpYA/dalZdWd//qwPgeHbPOC4XMfb4OYk4jtROv/
SblZ5GFF8mJ9WVxkCzCIpioegU1CHpMAI/NuTmMpvjax4mSQPEXPuNOFcl5arx8v
tvFqLl5IsydU7neqGLOYBWHE0QqQKDjlVWi+suewZ8gAm9N0zDmOP1zzvPs0Nd7q
ZAS+OTEU2RTnjimam2SodsHfGyAc2Fv4qnGJGWkQowJGI6accbdjH9ieHkphd3Ga
gPTmE3fELK1aCJmKEGY1Ivti1xxbgXcyARQDG1QI7CVf0h6e3PiNg5xdwBrl57Fd
ynS7LNirZMFQc1Ggr8//K+HsEIk1KsIAbPCyPiCQrD9l3N9n/HA=
=Y+Aa
-----END PGP SIGNATURE-----
