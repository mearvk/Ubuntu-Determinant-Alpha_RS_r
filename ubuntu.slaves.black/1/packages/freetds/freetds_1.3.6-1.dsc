-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 1.0
Source: freetds
Binary: freetds-common, libct4, freetds-bin, tdsodbc, libsybdb5, freetds-dev
Architecture: any all
Version: 1.3.6-1
Maintainer: Steve Langasek <vorlon@debian.org>
Homepage: http://www.freetds.org/
Standards-Version: 4.6.0
Vcs-Browser: https://salsa.debian.org/vorlon/freetds
Vcs-Git: https://salsa.debian.org/vorlon/freetds.git
Build-Depends: debhelper-compat (= 12), unixodbc-dev (>= 2.2.11-10), libgnutls28-dev, libreadline-dev, libkrb5-dev, pkg-config
Package-List:
 freetds-bin deb database optional arch=any
 freetds-common deb libs optional arch=all
 freetds-dev deb devel optional arch=any
 libct4 deb libs optional arch=any
 libsybdb5 deb libs optional arch=any
 tdsodbc deb libs optional arch=any
Checksums-Sha1:
 bb7b330daf572c112a083efc98fc0d7b9ef2830f 3058640 freetds_1.3.6.orig.tar.gz
 a9264e30fa0697c3127286cefd5d6b13f1a20349 25236 freetds_1.3.6-1.diff.gz
Checksums-Sha256:
 8bde8865b11581b0860459b85d35c529646258a85f93e3f52b0a6f9933d865aa 3058640 freetds_1.3.6.orig.tar.gz
 8427d9beb7dcc4776091782eafbe0c0757d9bbfa2482d1599bd647cdf51106e8 25236 freetds_1.3.6-1.diff.gz
Files:
 c8141e9740f9ec61fee4d335da5a4966 3058640 freetds_1.3.6.orig.tar.gz
 1859ee3ff6490dd548f1c5f675472bc5 25236 freetds_1.3.6-1.diff.gz
Dgit: f47b894bf26439ddc25724babd576cd8bd77a32f debian archive/debian/1.3.6-1 https://git.dgit.debian.org/freetds

-----BEGIN PGP SIGNATURE-----

iQJGBAEBCgAwFiEErEg/aN5yj0PyIC/KVo0w8yGyEz0FAmHiagoSHHZvcmxvbkBk
ZWJpYW4ub3JnAAoJEFaNMPMhshM9h0gP+wVrRYu5EoBeL6doilDpG6aVDyoUT6SO
QgCzeYpE1I68La5NmfnWJaslqbHoVZgA1dyey2uH3+eW2U3fBLEkZql5Wa59PlPE
81IiKyV3D04dz2/c853Gk3iHywq5KcXelanzf+1Z7DdddTofpbGWUR0D5O/xmM8Z
QTHY/21YdVJuFVm0KtUXWJgrH8ux2w/oK/z48ziLKTqKqfo0sTR8snaglloIj1HU
emGDBa4vepFtFoofBa+MyfpQ/5DIrWcdxcsYtEKa4ftuJ6BxQMVGbi+gcYpJX9s+
OgrxZsLV7KlkUskeYZohpLFJHPvS69bWayA+RgyfAp60C6dNPX7T7q3wiAWKCIAs
O9aXhBkeZRxxi0N3BIjAIzbqDPNDxtsGtWc80xF4ZTahZv4DjvNAWPA+pkHo/Tcj
Nwt697VVjHvoEhXCxhSFecbeSb+VlQnE8MS63TL3mSIkTYL5k5l8JzLiDmTT2gIo
zJcXg5TeipJcXIjzAtbMdBjZQuf5BHM40ygDfUZVh4lSFhNxBmMVd992jmF9cEQU
ApHOpOEs2iYrpDoynwK8I5Yr98dU96hbBPEWFP7AO0Rep8epo5+5yThR4uOLvf2P
yLEcTLgsfMKozgfmDKtxLQV5F1AbhbpWcvsIKMoinLQnxfivYYTcT/pgNAVq5x0f
PEf6+Mi0EjZ+
=tu8s
-----END PGP SIGNATURE-----
