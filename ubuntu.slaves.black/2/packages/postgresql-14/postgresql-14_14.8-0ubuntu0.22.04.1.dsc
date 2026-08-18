-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: postgresql-14
Binary: libpq-dev, libpq5, libecpg6, libecpg-dev, libecpg-compat3, libpgtypes3, postgresql-14, postgresql-client-14, postgresql-server-dev-14, postgresql-doc-14, postgresql-plperl-14, postgresql-plpython3-14, postgresql-pltcl-14
Architecture: any all
Version: 14.8-0ubuntu0.22.04.1
Maintainer: Ubuntu Developers <ubuntu-devel-discuss@lists.ubuntu.com>
Uploaders:  Martin Pitt <mpitt@debian.org>, Peter Eisentraut <petere@debian.org>, Christoph Berg <myon@debian.org>,
Homepage: http://www.postgresql.org/
Standards-Version: 4.5.0
Vcs-Browser: https://salsa.debian.org/postgresql/postgresql
Vcs-Git: https://salsa.debian.org/postgresql/postgresql.git -b 14
Testsuite: autopkgtest
Testsuite-Triggers: build-essential, hunspell-en-us, locales, logrotate, net-tools, netcat-openbsd, perl
Build-Depends: autoconf, bison, clang [!alpha !hppa !hurd-i386 !ia64 !kfreebsd-amd64 !kfreebsd-i386 !m68k !powerpc !riscv64 !s390x !sh4 !sparc64 !x32], debhelper-compat (= 13), dh-exec (>= 0.13~), docbook-xml, docbook-xsl (>= 1.77), dpkg-dev (>= 1.16.1~), flex, gdb <!nocheck>, gettext, libicu-dev, libio-pty-perl <!nocheck>, libipc-run-perl <!nocheck>, libkrb5-dev, libldap2-dev, liblz4-dev, libpam0g-dev | libpam-dev, libperl-dev, libreadline-dev, libselinux1-dev [linux-any], libssl-dev, libsystemd-dev [linux-any], libxml2-dev, libxml2-utils, libxslt1-dev, llvm-dev [!alpha !hppa !hurd-i386 !ia64 !kfreebsd-amd64 !kfreebsd-i386 !m68k !powerpc !riscv64 !s390x !sh4 !sparc64 !x32], mawk, perl (>= 5.8), pkg-config, postgresql-common (>= 233~), python3-dev, systemtap-sdt-dev, tcl-dev, uuid-dev, xsltproc, zlib1g-dev | libz-dev
Package-List:
 libecpg-compat3 deb libs optional arch=any
 libecpg-dev deb libdevel optional arch=any
 libecpg6 deb libs optional arch=any
 libpgtypes3 deb libs optional arch=any
 libpq-dev deb libdevel optional arch=any
 libpq5 deb libs optional arch=any
 postgresql-14 deb database optional arch=any
 postgresql-client-14 deb database optional arch=any
 postgresql-doc-14 deb doc optional arch=all
 postgresql-plperl-14 deb database optional arch=any
 postgresql-plpython3-14 deb database optional arch=any
 postgresql-pltcl-14 deb database optional arch=any
 postgresql-server-dev-14 deb libdevel optional arch=any
Checksums-Sha1:
 d92b33cbd2fc5a9495330bb44bf5cc063d28e10b 29121140 postgresql-14_14.8.orig.tar.gz
 f316b3ae5c891df5a76c1b9af658077c3c27063f 25220 postgresql-14_14.8-0ubuntu0.22.04.1.debian.tar.xz
Checksums-Sha256:
 a3c32ff8168832d9637eb870f6e98f98506797fe5942555d70cd77558949a844 29121140 postgresql-14_14.8.orig.tar.gz
 8b573ee5fb5161cca8d54d0aafeb5e6cbe86ceaad054efafcc9660bf3e18952f 25220 postgresql-14_14.8-0ubuntu0.22.04.1.debian.tar.xz
Files:
 05a8078ee17d4f00779138767b802065 29121140 postgresql-14_14.8.orig.tar.gz
 681b46df3a120dc53b028d7469db62a6 25220 postgresql-14_14.8-0ubuntu0.22.04.1.debian.tar.xz
Original-Maintainer: Debian PostgreSQL Maintainers <team+postgresql@tracker.debian.org>

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEUMSg3c8x5FLOsZtRZWnYVadEvpMFAmRs18gACgkQZWnYVadE
vpNVIg/+J94D6u6f6537vtTNOOzD+5DmiO6+gzDANSogR/egtzXA8FJll68MiDgH
l+FjIkNslT43sDkXlCdV9l0h4mbqzpFcEkpuFy5jkp95El/5svRFSsc4lMnPc5og
dg8B9ONc/TC3YKVqA4ZskLYTIOr/vg/nQdR+G2F/1KiYYApxWYeBPWoLIsyGkwhL
25x2jHVw7oxRAIs0hut2NcsyZ/8Y6BAzjfJyLH9J/jsFquZyiniR4eWAQSkSl29t
VLv4xww5L6iz+TRLOBWsxfusDC8G2jwT4prEe2/9EySwfQ3YbQzqyNt02eQ71zBR
kryPnB2d6tdhxpb/ooXhECP+3TaigveRq3xRFRQDo9015NUuqXqqm0187RdmYUZ/
mKEev87EzwyyObMU1if2u7QofcW91EYNiO6Mpa//64IAv6HJTEcoIwbu+QQ9STmw
5JRxmGgscFjemM8tRjxKO/4NcqGhZLf1ftY8JQL1OJwoYWJZCz6d09Lu1I1Xa/bo
te1eiDm7usJ3C1n12yRGpXWHWFeSXonITV6KvVC+rtLUXx8l9sc+UWfFkneFTXCl
VB0GcWCD/n6E7mkdvCW4fRsFh5W/c3DH3ez/3zANzp2GGMfa4LNOVrvMdtRXvw/K
hDzlfJ6+g72ziDY9mPU/sgiyLduhuocqJhwcDzWuwvnQ40tpI58=
=dYbW
-----END PGP SIGNATURE-----
