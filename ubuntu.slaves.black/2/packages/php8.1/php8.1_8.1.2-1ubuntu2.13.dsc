-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: php8.1
Binary: libapache2-mod-php8.1, libapache2-mod-php7.4, libapache2-mod-php8.0, libphp8.1-embed, php8.1, php8.1-cgi, php8.1-cli, php8.1-dev, php8.1-fpm, php8.1-phpdbg, php8.1-xsl, php8.1-bcmath, php8.1-bz2, php8.1-common, php8.1-curl, php8.1-dba, php8.1-enchant, php8.1-gd, php8.1-gmp, php8.1-imap, php8.1-interbase, php8.1-intl, php8.1-ldap, php8.1-mbstring, php8.1-mysql, php8.1-odbc, php8.1-opcache, php8.1-pgsql, php8.1-pspell, php8.1-readline, php8.1-snmp, php8.1-soap, php8.1-sqlite3, php8.1-sybase, php8.1-tidy, php8.1-xml, php8.1-zip
Architecture: any all
Version: 8.1.2-1ubuntu2.13
Maintainer: Ubuntu Developers <ubuntu-devel-discuss@lists.ubuntu.com>
Uploaders: Ondřej Surý <ondrej@debian.org>, Lior Kaplan <kaplan@debian.org>
Homepage: http://www.php.net/
Standards-Version: 4.5.0.0
Vcs-Browser: https://salsa.debian.org/php-team/php/-/tree/debian/main/8.1
Vcs-Git: https://salsa.debian.org/php-team/php.git -b debian/main/8.1
Testsuite: autopkgtest
Testsuite-Triggers: apache2, wget
Build-Depends: apache2-dev (>= 2.4), autoconf (>= 2.63), automake, bison, chrpath, debhelper (>= 9.20160709~), default-libmysqlclient-dev | libmysqlclient-dev, dh-apache2, dpkg-dev (>= 1.16.1~), firebird-dev [!hurd-any !m68k !hppa !ppc64] | firebird2.5-dev [!hurd-any !m68k !hppa !ppc64] | firebird2.1-dev [!hurd-any !m68k !hppa !ppc64], flex, freetds-dev, libapparmor-dev [linux-any], libacl1-dev, libapr1-dev (>= 1.2.7-8), libargon2-dev | libargon2-0-dev, libbz2-dev, libc-client-dev, libcurl4-openssl-dev | libcurl-dev, libdb-dev, libedit-dev (>= 2.11-20080614-4), libenchant-2-dev | libenchant-dev, libevent-dev (>= 1.4.11), libexpat1-dev (>= 1.95.2-2.1), libffi-dev, libfreetype6-dev, libgcrypt20-dev (>> 1.6.3) | libgcrypt11-dev (<< 1.5.4), libgd-dev (>= 2.1.0) | libgd2-dev, libglib2.0-dev, libgmp3-dev, libicu-dev, libjpeg-dev | libjpeg62-dev, libkrb5-dev, libldap2-dev, liblmdb-dev, libmagic-dev, libmhash-dev (>= 0.8.8), libnss-myhostname [linux-any], libonig-dev, libpam0g-dev, libpcre2-dev (>= 10.30), libpng-dev, libpq-dev, libpspell-dev, libqdbm-dev, libsasl2-dev, libsnmp-dev, libsodium-dev, libsqlite3-dev, libssl-dev, libsystemd-dev [linux-any], libtidy-dev (>= 1:5.2.0), libtool (>= 2.2), libwebp-dev, libwrap0-dev, libxml2-dev, libxmltok1-dev, libxslt1-dev (>= 1.0.18), libzip-dev (>= 1.0.0), locales-all | language-pack-de, netbase, netcat-openbsd, re2c, systemtap-sdt-dev [amd64 i386 powerpc armel armhf ia64], tzdata, unixodbc-dev, zlib1g-dev
Build-Conflicts: bind-dev, libxmlrpc-core-c3-dev
Package-List:
 libapache2-mod-php7.4 deb httpd optional arch=any
 libapache2-mod-php8.0 deb httpd optional arch=any
 libapache2-mod-php8.1 deb httpd optional arch=any
 libphp8.1-embed deb php optional arch=any
 php8.1 deb php optional arch=all
 php8.1-bcmath deb php optional arch=any
 php8.1-bz2 deb php optional arch=any
 php8.1-cgi deb php optional arch=any
 php8.1-cli deb php optional arch=any
 php8.1-common deb php optional arch=any
 php8.1-curl deb php optional arch=any
 php8.1-dba deb php optional arch=any
 php8.1-dev deb php optional arch=any
 php8.1-enchant deb php optional arch=any
 php8.1-fpm deb php optional arch=any
 php8.1-gd deb php optional arch=any
 php8.1-gmp deb php optional arch=any
 php8.1-imap deb php optional arch=any
 php8.1-interbase deb php optional arch=any
 php8.1-intl deb php optional arch=any
 php8.1-ldap deb php optional arch=any
 php8.1-mbstring deb php optional arch=any
 php8.1-mysql deb php optional arch=any
 php8.1-odbc deb php optional arch=any
 php8.1-opcache deb php optional arch=any
 php8.1-pgsql deb php optional arch=any
 php8.1-phpdbg deb php optional arch=any
 php8.1-pspell deb php optional arch=any
 php8.1-readline deb php optional arch=any
 php8.1-snmp deb php optional arch=any
 php8.1-soap deb php optional arch=any
 php8.1-sqlite3 deb php optional arch=any
 php8.1-sybase deb php optional arch=any
 php8.1-tidy deb php optional arch=any
 php8.1-xml deb php optional arch=any
 php8.1-xsl deb php optional arch=all
 php8.1-zip deb php optional arch=any
Checksums-Sha1:
 bdba68806c42a4fc74c0429f98b2397253e1ed15 11681132 php8.1_8.1.2.orig.tar.xz
 036880873d5eeda0433ac67117ce0c80522000b0 88676 php8.1_8.1.2-1ubuntu2.13.debian.tar.xz
Checksums-Sha256:
 6b448242fd360c1a9f265b7263abf3da25d28f2b2b0f5465533b69be51a391dd 11681132 php8.1_8.1.2.orig.tar.xz
 cca9f37949f602364c1c91dc0f27c662c061bf9c024e752a5974d2f34ea8f275 88676 php8.1_8.1.2-1ubuntu2.13.debian.tar.xz
Files:
 f3e890952af5b374f4b724c0e1430e96 11681132 php8.1_8.1.2.orig.tar.xz
 e4360c438887456d2f1c64754ef61826 88676 php8.1_8.1.2-1ubuntu2.13.debian.tar.xz
Original-Maintainer: Debian PHP Maintainers <team+pkg-php@tracker.debian.org>

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEf+ebRFcoyOoAQoOeRbznW4QLH2kFAmScbDcACgkQRbznW4QL
H2lSlw/9FpIHE5kY+9pJ8gmxcUD2nwEAlSxloxBmpKvGCD6peDEFFpDgwDaOzBOt
YmJvek9znJ7WdXOrLjWJHlPy9DCxNa5ubWDoedoWuQeyRqJ6K/sRIOHMfxZxVVgC
5y/60V8kNbIWg3RGBtOPQ+00tgTHNdl/FhqAN3M6pH9CotHvS16n9ig7XzPGwIEp
IjMUsemRv08hMIVr5/CX5vO5giJdqpeX/w+cgnmvSfkyDKX3uil4qgO1NYi01rOd
qPaZti/ot0Ok3iLlvwBU3EFdEg9yG2NFXPyYUOhABoXRG/VP/V0vctccWRYnWWUe
gVeQs38HAzIDY6iN2xPfJ79Od2C/OK0ZEiZcynXWNPzURK+x2c3rrpN/KrLLcmdX
6l4wO/znpu54XIhKleEHjr7bYPtoi/zCsSSkz9TWqhlzMpzeJ7TviLMvMdqCdeoO
E0/DS96E95DYHZ3lAbJpICmDljROdzuyrDRbGhptn0f3cpoKD7eirIPzvBzclpL3
T8TqKzTGpBpKelKo7/Jhyk107SOzB/TTb1+svwIgw96suzTndlNQucEdcvpEso6p
izbKYj7qL154U/+8PlORkGq98KI2zF8LCj+I+uumuwypfF+lyfmD0TQBqIt6m+P8
ky2c4QPiuCpkzg3NqFS4g9ehEfLvXQ2MtAhOzyyY1/lhDDUeAL0=
=LK1h
-----END PGP SIGNATURE-----
