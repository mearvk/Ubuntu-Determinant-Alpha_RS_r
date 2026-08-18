-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: graphite2
Binary: libgraphite2-3, libgraphite2-dev, libgraphite2-doc, libgraphite2-utils, python3-graphite2
Architecture: any all
Version: 1.3.14-1build2
Maintainer: Debian LibreOffice Maintainers <debian-openoffice@lists.debian.org>
Uploaders:  Rene Engelhard <rene@debian.org>, Daniel Glassey <wdg@debian.org>,
Homepage: http://graphite.sil.org/
Standards-Version: 4.4.1
Vcs-Browser: https://salsa.debian.org/libreoffice-team/graphite2
Vcs-Git: https://salsa.debian.org/libreoffice-team/graphite2.git
Testsuite: autopkgtest
Testsuite-Triggers: @builddeps@, dpkg-dev, python3-all
Build-Depends: cmake, debhelper-compat (= 12), dh-exec (>= 0.3), dh-python, dpkg-dev (>= 1.18.2~), python3:native (>= 3.6), python3-fonttools <!nocheck>
Build-Depends-Indep: asciidoc-dblatex, docbook-xsl, doxygen, graphviz, libxml2-utils, python3-all, python3-setuptools, texlive-latex-recommended
Package-List:
 libgraphite2-3 deb libs optional arch=any
 libgraphite2-dev deb libdevel optional arch=any
 libgraphite2-doc deb doc optional arch=all
 libgraphite2-utils deb fonts optional arch=any
 python3-graphite2 deb python optional arch=all
Checksums-Sha1:
 768d478d300253a855a7a15ba1e59b56d06ad01c 6629829 graphite2_1.3.14.orig.tar.gz
 dec9285c1b9956a3e36f6ae99d4dfd0f3b51e419 12224 graphite2_1.3.14-1build2.debian.tar.xz
Checksums-Sha256:
 7a3b342c5681921ce2e0c2496509d30b5b078399d5a7bd2358f95166d57d91df 6629829 graphite2_1.3.14.orig.tar.gz
 0f943ca490ae96766a2c674951cb903cac104ba3e1c6b4a356b9467aca703ae5 12224 graphite2_1.3.14-1build2.debian.tar.xz
Files:
 a3cb1dc0032a5875e2eaa4ed57cd38b1 6629829 graphite2_1.3.14.orig.tar.gz
 ad6ccae636eeb895b8be75952ff02025 12224 graphite2_1.3.14-1build2.debian.tar.xz

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEqx+XcX7ftBm4bj5/AhnKGdA0MwwFAmI7JvgACgkQAhnKGdA0
Mwwgcgf/VlvOD3WekGx1Rh/E7Su/52X+2y6mGX8PnyP2BOH+I49mD0e2Qx9rrxJz
YhKUIw4pl57qdmQAss4kKutc6hq5VQUHA+hL8MmZgak2+Tj5+NK5xXNvOkUd45Ct
JBthCQDdjFNdVAx5T5HE+mAnPXw5tv8NF7b2XYEDYensVlekVN1J3zT2x/Bv3C1v
l/6coTX+EeBE938C72SmWHn4tEPSXz7bsFh6NGBNHvZeBjKL+YKiGCOzRB202Tmq
xpZW5mUHVNd9c2DksDfRs7snjyeJeQe/sbGv8W1tSl0X+LS7cgsrmnEb8mGqAiVL
v4dOf1veKrrRDKHTRfjiEyspGNUfCA==
=Upe1
-----END PGP SIGNATURE-----
