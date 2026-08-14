-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: apache2
Binary: apache2, apache2-data, apache2-bin, apache2-utils, apache2-suexec-pristine, apache2-suexec-custom, apache2-doc, apache2-dev, apache2-ssl-dev, libapache2-mod-md, libapache2-mod-proxy-uwsgi
Architecture: any all
Version: 2.4.52-1ubuntu4.6
Maintainer: Ubuntu Developers <ubuntu-devel-discuss@lists.ubuntu.com>
Uploaders: Stefan Fritsch <sf@debian.org>, Arno Töll <arno@debian.org>, Ondřej Surý <ondrej@debian.org>, Yadd <yadd@debian.org>
Homepage: https://httpd.apache.org/
Standards-Version: 4.6.0
Vcs-Browser: https://salsa.debian.org/apache-team/apache2
Vcs-Git: https://salsa.debian.org/apache-team/apache2.git
Testsuite: autopkgtest
Testsuite-Triggers: build-essential, curl, dpkg-dev, expect, gcc, libanyevent-perl, libcrypt-ssleay-perl, libdatetime-perl, libfcgi-perl, libhtml-parser-perl, libhttp-dav-perl, libnet-ssleay-perl, libprotocol-http2-perl, libtime-hires-perl, libwww-perl, nghttp2-client, perl-doc, ssl-cert, wget
Build-Depends: debhelper-compat (= 13), dpkg-dev (>= 1.16.1~), bison, gawk | awk, jdupes, libapr1-dev, libaprutil1-dev, libbrotli-dev, liblua5.3-dev, libnghttp2-dev, libpcre3-dev, libssl-dev, libxml2-dev, lsb-release, perl, zlib1g-dev, libcurl4-openssl-dev | libcurl4-dev, libjansson-dev
Build-Conflicts: autoconf2.13
Package-List:
 apache2 deb httpd optional arch=any
 apache2-bin deb httpd optional arch=any
 apache2-data deb httpd optional arch=all
 apache2-dev deb httpd optional arch=any
 apache2-doc deb doc optional arch=all
 apache2-ssl-dev deb httpd optional arch=any
 apache2-suexec-custom deb httpd optional arch=any
 apache2-suexec-pristine deb httpd optional arch=any
 apache2-utils deb httpd optional arch=any
 libapache2-mod-md deb oldlibs optional arch=any
 libapache2-mod-proxy-uwsgi deb oldlibs optional arch=any
Checksums-Sha1:
 f616eac56f9d48f8b5c1e124267ee392cdc1ac5c 9719976 apache2_2.4.52.orig.tar.gz
 c2c349d1ec7f11dbc0abecd86c733b6dd3c28f06 926104 apache2_2.4.52-1ubuntu4.6.debian.tar.xz
Checksums-Sha256:
 296c74a8adde1a8acd6617b21fc3d19719ff4fa39319b2bdbd898aca4d5df97f 9719976 apache2_2.4.52.orig.tar.gz
 6a4062a1d0dafdc564735a83357713276b65ee1f07a5cf3ec980035e4561ee40 926104 apache2_2.4.52-1ubuntu4.6.debian.tar.xz
Files:
 ff86e0e57e3172c21a3dc495909be002 9719976 apache2_2.4.52.orig.tar.gz
 43aa4eadbfab6ba11f8a7ee39a07c168 926104 apache2_2.4.52-1ubuntu4.6.debian.tar.xz
Original-Maintainer: Debian Apache Maintainers <debian-apache@lists.debian.org>

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEpmEQCz2sHU8srYpU5gOyV4+48PsFAmRTFkgACgkQ5gOyV4+4
8Ps7NA//XvzqGj7qK8YpD61smwQcXNrTSWHymFB5SyfwsqMQS+j0P/YYWn+/BjuD
69sRcqDfk2QpL7An2z0cL27Gf9QcxY06w5iYtQiIDdY/fsKqYUwkhrnHP3Rlk9HC
CnsNbEBzfm43NExiW7nfxMnXIsaBZ4X8uY5uTPsy9CijNjyOe03Wqq6MIjdr3tfc
9xVYrznwH7lKeN/dqhF7s3mZjKpgLcmTEcXHOgQUSZgfhpnhi3qLj7mv/h6AeBK4
hbCIpl2RPA86IqPtvr366oPHXVs/sQqe6TNF8AQ4sQZZHCsTRwyNu01+KZ6sVJ7z
cJ0bCSp3yxh1CAcDQopLtTNFNRiCQenxKjUXhnGjW9+QD73STdoO33V2lgef6L3i
DbfqWSrVAhBhHpbLlSJvbO1/k7N7l5dWtAm22WRmm8kLx4PmNfIZWbW9kP3gRBLI
y/ejV8ZxWEAX8/S4EeUcFoKY/4uyrmjxlE6APsjYCb6Ic35Djrfb5jgsM/Mc46Pi
peTxwPB3fN6C2AIJ8v9nPkQxP1RQEdrOUosH1c9AYtQphAi3HZMXmLB90MXqvXa0
Ze06qcKb9Lg7SF3MKL4Z/C12N5tXVh/6wUbw+GyC+MEwjlV8UCumYc4TfLw7f7YC
V0e74MiLD/6Uc2kcATVMOqGPwLHXCMrB+u4uIdg8tHAIzTxcrpA=
=EYm+
-----END PGP SIGNATURE-----
