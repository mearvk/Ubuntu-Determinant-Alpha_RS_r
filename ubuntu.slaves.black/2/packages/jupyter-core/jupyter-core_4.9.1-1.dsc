-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: jupyter-core
Binary: python3-jupyter-core, jupyter-core, python-jupyter-core-doc, jupyter
Architecture: all
Version: 4.9.1-1
Maintainer: Debian Python Team <team+python@tracker.debian.org>
Uploaders: Julien Puydt <jpuydt@debian.org>, Gordon Ball <gordon@chronitis.net>
Homepage: https://github.com/jupyter/jupyter_core
Standards-Version: 4.6.0
Vcs-Browser: https://salsa.debian.org/python-team/packages/jupyter-core
Vcs-Git: https://salsa.debian.org/python-team/packages/jupyter-core.git
Testsuite: autopkgtest, autopkgtest-pkg-python
Testsuite-Triggers: python3-all, python3-pytest
Build-Depends: debhelper-compat (= 13), dh-python, python3-all, python3-ipython <!nocheck>, python3-ipython-genutils, python3-pytest <!nocheck>, python3-setuptools, python3-sphinx, python3-traitlets
Package-List:
 jupyter deb metapackages optional arch=all
 jupyter-core deb utils optional arch=all
 python-jupyter-core-doc deb doc optional arch=all
 python3-jupyter-core deb python optional arch=all
Checksums-Sha1:
 5827251025a1eca6ba865c27b60d9329acd02e3f 71511 jupyter-core_4.9.1.orig.tar.gz
 e6ab0482091f27ff5782e4846d4ef85bb648fa07 6924 jupyter-core_4.9.1-1.debian.tar.xz
Checksums-Sha256:
 33eb66b21a40b51d92d8406e508967d677d3eca11af75ef5957a3eaa6cb96869 71511 jupyter-core_4.9.1.orig.tar.gz
 79f22c1fc37028b5b570090b281e16e35627260d353785f2058f06fc38d5cbc4 6924 jupyter-core_4.9.1-1.debian.tar.xz
Files:
 d2319609185f7a61219faaf656aebbe7 71511 jupyter-core_4.9.1.orig.tar.gz
 9d2fa95d7a7b96222af211b45a74c6cd 6924 jupyter-core_4.9.1-1.debian.tar.xz

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE6PwpXIa418BJ+Xuno12v+60p6N4FAmGBjfcACgkQo12v+60p
6N6aMA//Rn+3NT57ZASkhUbsat1NXomqeS+RL7K07EFaqgYGrX7qWFP5+84qAff7
217OQ7u6fDWCg6AN+YzYy8cjC/VNOPN4p9QolCVpP/I/nz6CX83VLxhUvwZtXYSN
0WMUHWdHSUQvPLbeUw12Uyc1PyKKf6a0r3QzL/MQMzg0oCcPVgzciLgl987Goo3r
KSJzR76NLU34/+EMzOneywXZxX6jTNIWgd11LCGf1c1dxWNFdoYexVA7w4NcK8hr
JdMNoVm8Xe5o7XRdKebokqOERC+Jjx+rV/jw740ohEphw7ZfpCMXwTJZSnfDjRCT
TOmhr3waNVAUmcexn7hsfv550fkWR9Q+4buXarJnVuawGzohwV7kkyWCfKOZwVAT
okKATpVPT7MhjpFrhTd2gYqqegnMietJ7RmFKyF+qw31V0SDlR0oYVCn+LNUhTSL
nEWhnDZHAmFUUomIgATPKvTXZr8bndAGa/dirvubT4u0oBAh2zBQCSdUGa6w/NOa
fnuLW4G0OAz0JEeHZeyOvosaAFuKl681BkV1hFEAjx0fMHtzYMA2zq+bfMXP0EUE
mrEpx5e/rqaPG/m9DzysT+eZHUafCDnFNVQ+9cbNgYGk4hqsmIcliPKng89EdvP+
e96ZKKykgHcPVqThKaCgvZD0UeHWVcDpOgfUJSv6U7F2ZlhvLso=
=sQ1I
-----END PGP SIGNATURE-----
