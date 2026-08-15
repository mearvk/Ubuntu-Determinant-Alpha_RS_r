-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: bzip2
Binary: libbz2-1.0, libbz2-dev, bzip2, bzip2-doc
Architecture: any all
Version: 1.0.8-5build1
Maintainer: Anibal Monsalve Salazar <anibal@debian.org>
Uploaders: Santiago Ruano Rincón <santiago@debian.org>, Anthony Fok <foka@debian.org>
Homepage: https://sourceware.org/bzip2/
Standards-Version: 4.6.0
Vcs-Browser: https://salsa.debian.org/debian/bzip2
Vcs-Git: https://salsa.debian.org/debian/bzip2.git
Testsuite: autopkgtest
Testsuite-Triggers: @builddeps@, build-essential
Build-Depends: debhelper-compat (= 13)
Build-Depends-Indep: texinfo, docbook-xml, docbook2x, xsltproc
Package-List:
 bzip2 deb utils standard arch=any
 bzip2-doc deb doc optional arch=all
 libbz2-1.0 deb libs important arch=any
 libbz2-dev deb libdevel optional arch=any
Checksums-Sha1:
 bf7badf7e248e0ecf465d33c2f5aeec774209227 810029 bzip2_1.0.8.orig.tar.gz
 d70c5599f47306fc6955ea28b3ce7a6ba7911d82 26870 bzip2_1.0.8-5build1.debian.tar.bz2
Checksums-Sha256:
 ab5a03176ee106d3f0fa90e381da478ddae405918153cca248e682cd0c4a2269 810029 bzip2_1.0.8.orig.tar.gz
 d31878008c269a4338324b3984f1b3177c3de003cf8254559cf898b4ab044e12 26870 bzip2_1.0.8-5build1.debian.tar.bz2
Files:
 67e051268d0c475ea773822f7500d0e5 810029 bzip2_1.0.8.orig.tar.gz
 a4523c91037cc1511fb578e1aa7e8c5d 26870 bzip2_1.0.8-5build1.debian.tar.bz2

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEqx+XcX7ftBm4bj5/AhnKGdA0MwwFAmI67CsACgkQAhnKGdA0
MwyJBggAmPCkib7pKvegENbifmLN+lgOtWghsokeYqG8FmZPov0gvh6jqfe4uH0i
WE24kkdYTDedgkcZtH47UliTJxGnZOz4MUYRr0qI7OUrir9gxqXM7JResBTKyu2N
Ths/kN33T+Ogz/witbwODlWgwI69e2a1d6g54LO8zqwjXLNofC12zy48ThN5n3tv
jUNrrcogCOzAPhGSVZyf3IOwFKyhq80za0WaHTBINWgU7jevSpzhw7qytcVvIF0u
JiFOlc+ZB9Uaf4IgqQAsPLZAYwwNKr3H9NeUCXvwo3qJqTBIIYvyN5buOTrYuQzx
6PeKQ2b4uHvj/qkf75ZGK7G8C5fqiA==
=eCcK
-----END PGP SIGNATURE-----
