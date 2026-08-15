-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: db5.3
Binary: db5.3-doc, libdb5.3-dev, libdb5.3, db5.3-util, db5.3-sql-util, libdb5.3++, libdb5.3++-dev, libdb5.3-tcl, libdb5.3-dbg, libdb5.3-java-jni, libdb5.3-java, libdb5.3-java-dev, libdb5.3-sql-dev, libdb5.3-sql, libdb5.3-stl-dev, libdb5.3-stl
Architecture: any all
Version: 5.3.28+dfsg1-0.8ubuntu3
Maintainer: Ubuntu Developers <ubuntu-devel-discuss@lists.ubuntu.com>
Uploaders: Ondřej Surý <ondrej@debian.org>
Homepage: http://www.oracle.com/technetwork/database/database-technologies/berkeleydb/overview/index.html
Standards-Version: 3.9.6
Vcs-Browser: https://salsa.debian.org/debian/db5.3
Vcs-Git: https://salsa.debian.org/debian/db5.3.git
Build-Depends: debhelper (>= 10), autotools-dev, dh-autoreconf, tcl <cross !pkg.db5.3.notcl>, tcl-dev <!pkg.db5.3.notcl>, procps [!hurd-i386] <!nocheck>, javahelper <!nojava>, default-jdk <!nojava>
Package-List:
 db5.3-doc deb doc optional arch=all
 db5.3-sql-util deb database extra arch=any
 db5.3-util deb database optional arch=any
 libdb5.3 deb libs standard arch=any
 libdb5.3++ deb libs optional arch=any
 libdb5.3++-dev deb libdevel extra arch=any
 libdb5.3-dbg deb debug extra arch=any
 libdb5.3-dev deb libdevel extra arch=any
 libdb5.3-java deb java optional arch=all profile=!nojava
 libdb5.3-java-dev deb libdevel optional arch=any profile=!nojava
 libdb5.3-java-jni deb java optional arch=any profile=!nojava
 libdb5.3-sql deb libs extra arch=any profile=!pkg.db5.3.nosql
 libdb5.3-sql-dev deb libdevel extra arch=any
 libdb5.3-stl deb libs extra arch=any
 libdb5.3-stl-dev deb libdevel extra arch=any
 libdb5.3-tcl deb interpreters extra arch=any profile=!pkg.db5.3.notcl
Checksums-Sha1:
 98d30e5ba942cc4a818ac29270ac72a3ffc2c374 19723860 db5.3_5.3.28+dfsg1.orig.tar.xz
 155ce6c1876a45edff8b9e8b18abb7e36542681e 32028 db5.3_5.3.28+dfsg1-0.8ubuntu3.debian.tar.xz
Checksums-Sha256:
 b19bf3dd8ce74b95a7b215be9a7c8489e8e8f18da60d64d6340a06e75f497749 19723860 db5.3_5.3.28+dfsg1.orig.tar.xz
 b141784b0395dcd4b9c2e3bf4eb1e7948d938a6f8643fac5285ca43e643bf63b 32028 db5.3_5.3.28+dfsg1-0.8ubuntu3.debian.tar.xz
Files:
 1dd7f0f45b985b661dc3c6edbd646d80 19723860 db5.3_5.3.28+dfsg1.orig.tar.xz
 041b9f670038e40ddb3b11afb55052a9 32028 db5.3_5.3.28+dfsg1-0.8ubuntu3.debian.tar.xz
Original-Maintainer: Debian Berkeley DB Team <team+bdb@tracker.debian.org>

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEqx+XcX7ftBm4bj5/AhnKGdA0MwwFAmI7JXMACgkQAhnKGdA0
MwwutAf8DQI71JlpdyP2Xvo1mUIwXifJg8UgXHr/hpLLdDPIGM1RrMkVlQgpqYRw
VECrWS8qzEP6obghZNXSKlCb27UhLrKa8wLghe0eKAq8FPRDnGr1KtmYy6OptseJ
znUVMhDFdBCi4Oj/d/aB69MWyki7irBEeIzjm6yBrrjWvgC/oCBnhUkT88xnSRdt
xvkbpzNgHM/ITGyfNtoIF4LzvZsE4FKG2ZXxAEqSsQdWitPw9RphMzOTcGFaOWzZ
vIOw2ktQfz/aKn33Fg28r9drXYqnGxIAgC5EV2m8c5WdCLjaXXNtV+ewElzjCEm4
NSLTi+ys3+3jg36+FdcLdDlX8Vw7sg==
=clc/
-----END PGP SIGNATURE-----
