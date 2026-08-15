-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: cyrus-sasl2
Binary: sasl2-bin, cyrus-sasl2-doc, libsasl2-2, libsasl2-modules, libsasl2-modules-db, libsasl2-modules-ldap, libsasl2-modules-otp, libsasl2-modules-sql, libsasl2-modules-gssapi-mit, libsasl2-dev, libsasl2-modules-gssapi-heimdal
Architecture: any all
Version: 2.1.27+dfsg2-3ubuntu1.2
Maintainer: Ubuntu Developers <ubuntu-devel-discuss@lists.ubuntu.com>
Uploaders: Fabian Fagerholm <fabbe@debian.org>, Roberto C. Sanchez <roberto@debian.org>, Ondřej Surý <ondrej@debian.org>, Bastian Germann <bage@debian.org>, Adam Conrad <adconrad@0c3.net>
Homepage: https://www.cyrusimap.org/sasl/
Standards-Version: 4.3.0.1
Vcs-Browser: https://salsa.debian.org/debian/cyrus-sasl2
Vcs-Git: https://salsa.debian.org/debian/cyrus-sasl2.git
Testsuite: autopkgtest
Testsuite-Triggers: krb5-admin-server, krb5-kdc, krb5-user, ldap-utils, slapd
Build-Depends: chrpath, debhelper-compat (= 12), default-libmysqlclient-dev <!pkg.cyrus-sasl2.nosql>, docbook-to-man, groff-base, heimdal-multidev <!pkg.cyrus-sasl2.nogssapi>, krb5-multidev <!pkg.cyrus-sasl2.nogssapi>, libdb-dev, libkrb5-dev <!pkg.cyrus-sasl2.nogssapi>, libldap2-dev <!pkg.cyrus-sasl2.noldap>, libpam0g-dev, libpod-pom-view-restructured-perl:native, libpq-dev <!pkg.cyrus-sasl2.nosql>, libsqlite3-dev, libssl-dev, po-debconf, python3-sphinx-rtd-theme:native, quilt
Build-Conflicts: heimdal-dev
Package-List:
 cyrus-sasl2-doc deb doc optional arch=all
 libsasl2-2 deb libs standard arch=any
 libsasl2-dev deb libdevel optional arch=any
 libsasl2-modules deb libs optional arch=any
 libsasl2-modules-db deb libs standard arch=any
 libsasl2-modules-gssapi-heimdal deb libs optional arch=any profile=!pkg.cyrus-sasl2.nogssapi
 libsasl2-modules-gssapi-mit deb libs optional arch=any profile=!pkg.cyrus-sasl2.nogssapi
 libsasl2-modules-ldap deb libs optional arch=any profile=!pkg.cyrus-sasl2.noldap
 libsasl2-modules-otp deb libs optional arch=any
 libsasl2-modules-sql deb libs optional arch=any profile=!pkg.cyrus-sasl2.nosql
 sasl2-bin deb utils optional arch=any
Checksums-Sha1:
 5d214761dd22183b1b4fb477b311f27b8046accd 829892 cyrus-sasl2_2.1.27+dfsg2.orig.tar.xz
 f906e3f74d2c18746acebfb7cd8ccab718318eba 98836 cyrus-sasl2_2.1.27+dfsg2-3ubuntu1.2.debian.tar.xz
Checksums-Sha256:
 f3d90671718e7dc1d46db7ccbad548d60ffe1edd1e9a620e5d3b779e6a0a9326 829892 cyrus-sasl2_2.1.27+dfsg2.orig.tar.xz
 1b152ebdeb96d901f801d286e4d3e5e78bcf262d4d3b9c937c216770aeaeb262 98836 cyrus-sasl2_2.1.27+dfsg2-3ubuntu1.2.debian.tar.xz
Files:
 4244d1ac6b4f8ddb6ffe0a4aabed60b3 829892 cyrus-sasl2_2.1.27+dfsg2.orig.tar.xz
 d56fbeb1fd986955b96854b9c8b8aaea 98836 cyrus-sasl2_2.1.27+dfsg2-3ubuntu1.2.debian.tar.xz
Original-Maintainer: Debian Cyrus Team <team+cyrus@tracker.debian.org>

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEiv0I09G4F7LfiYL1AaxLQINZCpgFAmO1zlAACgkQAaxLQINZ
Cph/jRAAnuJhJQZJ+K9NQpdT/7DkTfQ/u335oanbHFrmgTRbayB5MXRZ9+lqhYX5
Gg1DrQuS96YSeJvJ1/MF5xKaEClCpwg8/O0AzMW4AHGsauUfPKjkzgBhHE8lOa3s
5ojnpX11yuI7lhOIAx0nbUNen+M1a8zrWHlI0CGmUcWTP85ETPflc17X4A0ICuKn
/RYc+UXq6D1htdNhfjdizdTaIjY5lbt+ucGfZxZKtqLwajRV2B3FBmZ8QIcEca8t
4gjtIz2aep2EmVRJUiA87n94VvFJaqxLC8jopZLMOMvAYupQb+6nS6eLXjua6F1X
GIsUQhqhpu87iwfVoscPg6WYzgvtmqBlYtRRrwP1cU+xNUZBMS3mZ+cucqq8b1pX
Vc5nwzB3HfL8fUAQ7bFhy2qRjyt9c7vtRpPsAXX5j3DPPm7wBGX3gkWaSqvLBrRg
3NEldeJ+kth//JpEUdCedX9/fzomQgSffKhU6FMVYaERkkCsbx/KBWRpkpsAH7Qx
/Vwhc+OmVeAHI/0hLkQyi2Dco/Sw5Vi5LzjwOcwYTG4ntkXfhF70fUxRvvzXJGDt
FtfgTT1YrS5sw1t3TQMZPO1SyC0IrnwVhzbnC2fVCFLNd2J2SqkccFChqOqD421Q
hVeDpLdldqnBAmplG0Sn/sqgPp7zfs71LMgbnalVaflHpgtZxBc=
=k2Fr
-----END PGP SIGNATURE-----
