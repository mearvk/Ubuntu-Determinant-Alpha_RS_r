-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

Format: 3.0 (quilt)
Source: appstream
Binary: appstream, appstream-compose, libappstream4, libappstream-dev, gir1.2-appstream-1.0, libappstreamqt2, libappstreamqt-dev, libappstream-compose0, libappstream-compose-dev, gir1.2-appstreamcompose-1.0, appstream-doc, apt-config-icons, apt-config-icons-hidpi, apt-config-icons-large, apt-config-icons-large-hidpi
Architecture: any all
Version: 0.15.2-2
Maintainer: Matthias Klumpp <mak@debian.org>
Homepage: https://www.freedesktop.org/wiki/Distributions/AppStream/
Standards-Version: 4.6.0
Vcs-Browser: https://salsa.debian.org/pkgutopia-team/appstream
Vcs-Git: https://salsa.debian.org/pkgutopia-team/appstream.git
Testsuite: autopkgtest
Testsuite-Triggers: build-essential
Build-Depends: debhelper-compat (= 13), gettext, gobject-introspection, gperf, gtk-doc-tools, itstool, libcairo2-dev, libcurl4-gnutls-dev | libcurl-dev (>= 7.62), libfontconfig-dev, libgdk-pixbuf-2.0-dev, libgirepository1.0-dev (>= 1.62), libglib2.0-dev (>= 2.62), libjs-highlight.js, libpango1.0-dev, librsvg2-dev (>= 2.48) [amd64 arm64 armel armhf i386 mips64el mipsel ppc64el s390x powerpc ppc64 riscv64 sparc64 x32], libstemmer-dev, libxml2-dev, libxmlb-dev (>= 0.3.6), libyaml-dev, meson (>= 0.56), qtbase5-dev, valac
Package-List:
 appstream deb admin optional arch=any
 appstream-compose deb admin optional arch=amd64,arm64,armel,armhf,i386,mips64el,mipsel,powerpc,ppc64,ppc64el,riscv64,s390x,sparc64,x32
 appstream-doc deb doc optional arch=all
 apt-config-icons deb misc optional arch=all
 apt-config-icons-hidpi deb misc optional arch=all
 apt-config-icons-large deb misc optional arch=all
 apt-config-icons-large-hidpi deb misc optional arch=all
 gir1.2-appstream-1.0 deb introspection optional arch=any
 gir1.2-appstreamcompose-1.0 deb introspection optional arch=amd64,arm64,armel,armhf,i386,mips64el,mipsel,powerpc,ppc64,ppc64el,riscv64,s390x,sparc64,x32
 libappstream-compose-dev deb libdevel optional arch=amd64,arm64,armel,armhf,i386,mips64el,mipsel,powerpc,ppc64,ppc64el,riscv64,s390x,sparc64,x32
 libappstream-compose0 deb libs optional arch=amd64,arm64,armel,armhf,i386,mips64el,mipsel,powerpc,ppc64,ppc64el,riscv64,s390x,sparc64,x32
 libappstream-dev deb libdevel optional arch=any
 libappstream4 deb libs optional arch=any
 libappstreamqt-dev deb libdevel optional arch=any
 libappstreamqt2 deb libs optional arch=any
Checksums-Sha1:
 cb5d655f13c5f271ff99d2015baabc623af9d955 2463900 appstream_0.15.2.orig.tar.xz
 6cb21e1c677e2e795019b92a52e657447a0604c9 833 appstream_0.15.2.orig.tar.xz.asc
 9273e788231f85a7ab34d298387c9c9c7ac504a3 17388 appstream_0.15.2-2.debian.tar.xz
Checksums-Sha256:
 8f6c1cd288c7c59f5bf21746a6cfd1424cd9d7cbeb0b7920dbcdf9ef10e9c74a 2463900 appstream_0.15.2.orig.tar.xz
 8d63f1a2e287efb3812d8011ec93aae190ef807a334094f07a78f55b4bc06500 833 appstream_0.15.2.orig.tar.xz.asc
 34c18b685f85d5decd90d712d6f8f8a58b8ec5d6c5025e3d9d17571fe4c2ca04 17388 appstream_0.15.2-2.debian.tar.xz
Files:
 dacfee68b59f5fabbf3d62c6ea888024 2463900 appstream_0.15.2.orig.tar.xz
 38fe8f3cded7579275a6480077354ebc 833 appstream_0.15.2.orig.tar.xz.asc
 632292271be5c4f89fbba7910f2a1411 17388 appstream_0.15.2-2.debian.tar.xz

-----BEGIN PGP SIGNATURE-----

iQJDBAEBCAAtFiEE0zo/DKFrCsxRpgc4SUyKX79N7OsFAmIXAucPHG1ha0BkZWJp
YW4ub3JnAAoJEElMil+/TezrGasP+wTcb4mlt11u7prDHTuptrTEjvtFV5LRfUc9
fG/u/bFBe9KXuOYUk812/T2rl9ELuJ47fjPgCbARMLg3TQ+dq9Hyck9I6fDMA6gd
8YhcQMZNe5yRA90HPVtEw/3MqMuIMX3foq29OUQkb2gOsAEyYGSAuCmKEV/K7i7t
z0yNAExDTNAWmqnUpp3m7azewd0Qd4j0dNFp4aHnZ1rPJCxq7zXyYLfP30ZdXSVI
avu4BNbwHtk6M9g6qY9RE13mqFeg/bb7C9E5vwC46kYW7zYMmzZQroAXqqRMOw5X
2WG/Gw0oGgh9Ub4rsVvZp55AN1e+eDDWNHSDok2IQoyPbdKDSGo2ACdqgLhj4g3l
jWDQU9LsM1sSr4vJ16jTARH820jisrdXbx7/VVp97aBmXeDKHYTf8NmO2Fqxnjp1
flKLAq2eyDH0Da+32JK68HAFhR+rLKVWj9rjIG3jbV2vtad/uNAFB/zNOj7HQeV4
pcrk89Vne1lBy7/5JRBo0RL26tITqOjsZ/dH/5Ik6XYpb2b1kPQ9LMig0h94tFT2
A8E3SPEzPnbOCsE8RhlYhkHR8mmJAMnk13Cz7GoxwkQXFm7dIrui1iIzxggqHTVL
N4IJYcHkEZwJNU0D8MJeY6CxJE3ufiK8glmtwIFyOo+6AsiKg/6Y0Tf/KKq9F4rG
XuPA6wed
=CehQ
-----END PGP SIGNATURE-----
