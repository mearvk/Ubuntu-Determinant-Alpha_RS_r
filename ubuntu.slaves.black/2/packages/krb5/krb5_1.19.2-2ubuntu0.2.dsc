-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: krb5
Binary: krb5-user, krb5-kdc, krb5-kdc-ldap, krb5-admin-server, krb5-kpropd, krb5-multidev, libkrb5-dev, libkrb5-dbg, krb5-pkinit, krb5-otp, krb5-k5tls, krb5-doc, libkrb5-3, libgssapi-krb5-2, libgssrpc4, libkadm5srv-mit12, libkadm5clnt-mit12, libk5crypto3, libkdb5-10, libkrb5support0, libkrad0, krb5-gss-samples, krb5-locales, libkrad-dev
Architecture: any all
Version: 1.19.2-2ubuntu0.2
Maintainer: Ubuntu Developers <ubuntu-devel-discuss@lists.ubuntu.com>
Uploaders: Russ Allbery <rra@debian.org>, Benjamin Kaduk <kaduk@mit.edu>
Homepage: http://web.mit.edu/kerberos/
Standards-Version: 4.6.0
Vcs-Browser: https://salsa.debian.org/debian/krb5
Vcs-Git: https://salsa.debian.org/debian/krb5
Testsuite: autopkgtest
Testsuite-Triggers: ldap-utils, libsasl2-modules-gssapi-mit, slapd
Build-Depends: debhelper-compat (= 13), byacc | bison, comerr-dev, docbook-to-man, libkeyutils-dev [linux-any], libldap2-dev <!stage1>, libsasl2-dev <!stage1>, libssl-dev, ss-dev, libverto-dev (>= 0.2.4), pkg-config
Build-Depends-Indep: python3, python3-cheetah, python3-lxml, python3-sphinx, doxygen, doxygen-latex, tex-gyre
Package-List:
 krb5-admin-server deb net optional arch=any
 krb5-doc deb doc optional arch=all
 krb5-gss-samples deb net optional arch=any
 krb5-k5tls deb net optional arch=any
 krb5-kdc deb net optional arch=any
 krb5-kdc-ldap deb net optional arch=any profile=!stage1
 krb5-kpropd deb net optional arch=any
 krb5-locales deb localization optional arch=all
 krb5-multidev deb libdevel optional arch=any
 krb5-otp deb net optional arch=any
 krb5-pkinit deb net optional arch=any
 krb5-user deb net optional arch=any
 libgssapi-krb5-2 deb libs optional arch=any
 libgssrpc4 deb libs optional arch=any
 libk5crypto3 deb libs optional arch=any
 libkadm5clnt-mit12 deb libs optional arch=any
 libkadm5srv-mit12 deb libs optional arch=any
 libkdb5-10 deb libs optional arch=any
 libkrad-dev deb libdevel optional arch=any
 libkrad0 deb libs optional arch=any
 libkrb5-3 deb libs optional arch=any
 libkrb5-dbg deb debug optional arch=any
 libkrb5-dev deb libdevel optional arch=any
 libkrb5support0 deb libs optional arch=any
Checksums-Sha1:
 f6980dafd31eac22a047ad34a2b918e4d12a8be5 8741053 krb5_1.19.2.orig.tar.gz
 3e22865accb628415457c4d43fa89c1c94111ae1 108204 krb5_1.19.2-2ubuntu0.2.debian.tar.xz
Checksums-Sha256:
 10453fee4e3a8f8ce6129059e5c050b8a65dab1c257df68b99b3112eaa0cdf6a 8741053 krb5_1.19.2.orig.tar.gz
 dd96b365f5b293e62f9994d6a16247614595adafebd0740f001712316547a905 108204 krb5_1.19.2-2ubuntu0.2.debian.tar.xz
Files:
 eb51b7724111e1a458a8c9a261d45a31 8741053 krb5_1.19.2.orig.tar.gz
 37ed532bc0a63b3f72cb4656b4be3fcd 108204 krb5_1.19.2-2ubuntu0.2.debian.tar.xz
Original-Maintainer: Sam Hartman <hartmans@debian.org>

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEiv0I09G4F7LfiYL1AaxLQINZCpgFAmQvRjgACgkQAaxLQINZ
CpiyXA/9ER3K+PamplDWW3OS5YrRyHp8XzJpctozweaw5981PkQUwnPbnav5+5P5
VCILO3/Pg1PwsM8MVQ2jCmt3TXTzPaJxm2ku7nPizgAcTdReI/mB3quDqqIZCRGT
ot4FTUw/j/j/D2yt94Q4rwF8NhGO0uZS0k2lrdRAzQvb+h0nwBwwVgB9phzerD8o
1YFCvHkNt/pAsUVCSF+mnTqr0/AHyH58JruVKcI/0VNr0B/IpkGAzyDs8aeA4ul1
02SD/UcRKC6PY8p4uKA9hDVTIE6zI5GonBKncbn3EiWSCZQ9SOTE+0g5DNgDNCLv
rakALbyvt4KKGBDdlAs2Mn5Mk4R1bwVf7Ep+9RiBoPeHSf4Ip0f9qQUnOEjR7Xi+
Suna7icigZDLnsbrnR6+kwpbpHBoxTOS06VueXNx/kz3IgH42n2eCFPVEPAmqLSj
7ExBHUI893Zdn3ODI0AecmpSkiIqY/P+XCi9UbANeGnFitxwOzlksocxXf+dMagc
wUP/QS5e3AzHw/hDvczbA+iVbh9Gt1LxeC/tXZKbL0ftPBsQqW112PbiDiK8MMDR
HI/W6xzm9C/RWYkGN9QxshWxsRBD5Ej8GhfpJ1zR2rpXdIQVLqwu2GSrsjjudagn
+sXHkQYkM9mrgC6+jZy0TUFovQR9AXWTgf1H2YfvLsXekvb84Uo=
=o0Rp
-----END PGP SIGNATURE-----
