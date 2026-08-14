-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

Format: 3.0 (quilt)
Source: horizon
Binary: openstack-dashboard, openstack-dashboard-ubuntu-theme, python3-django-horizon, python3-django-openstack-auth, openstack-dashboard-common
Architecture: all
Version: 4:22.1.0-0ubuntu2.1
Maintainer: Chuck Short <zulcss@ubuntu.com>
Homepage: https://launchpad.net/horizon
Standards-Version: 4.5.0
Vcs-Browser: https://git.launchpad.net/~ubuntu-openstack-dev/ubuntu/+source/horizon
Vcs-Git: https://git.launchpad.net/~ubuntu-openstack-dev/ubuntu/+source/horizon
Testsuite: autopkgtest
Build-Depends: debhelper-compat (= 13), dh-python, openstack-pkg-tools, python3-all, python3-pbr (>= 5.5.0), python3-setuptools, python3-sphinx (>= 2.0.0)
Build-Depends-Indep: python3-astroid (>= 2.1.0), python3-babel (>= 2.6.0), python3-bandit (>= 1.4.0), python3-cinderclient (>= 1:8.0.0), python3-coverage (>= 4.0), python3-debtcollector (>= 1.2.0), python3-django (>= 3.2), python3-django-compressor (>= 2.4), python3-django-debreach (>= 1.4.2), python3-django-pyscss (>= 2.0.2), python3-doc8, python3-futurist (>= 1.2.0), python3-glanceclient (>= 1:2.8.0), python3-heatclient (>= 1.10.0), python3-iso8601 (>= 0.1.11), python3-keystoneauth1 (>= 4.3.1), python3-keystoneclient (>= 1:3.22.0), python3-memcache (>= 1.59), python3-mock (>= 2.0.0), python3-mox3 (>= 0.20.0), python3-netaddr (>= 0.7.18), python3-neutronclient (>= 1:6.7.0), python3-novaclient (>= 2:9.1.0), python3-openstackdocstheme (>= 2.2.0), python3-oslo.concurrency (>= 4.5.0), python3-oslo.config (>= 1:8.8.0), python3-oslo.i18n (>= 5.1.0), python3-oslo.policy (>= 3.11.0), python3-oslo.serialization (>= 4.2.0), python3-oslo.upgradecheck (>= 1.5.0), python3-oslo.utils (>= 4.12.0), python3-osprofiler (>= 3.4.2), python3-pint (>= 0.5), python3-pymongo (>= 3.0.2), python3-pyscss (>= 1.3.7), python3-requests (>= 2.25.1), python3-semantic-version (>= 2.3.1), python3-six (>= 1.16.0), python3-swiftclient (>= 1:3.9.0-0ubuntu1.1~), python3-testscenarios (>= 0.4), python3-testtools (>= 2.2.0), python3-tz (>= 2013.6), python3-xvfbwrapper (>= 0.1.3), python3-yaml (>= 5.0)
Package-List:
 openstack-dashboard deb net extra arch=all
 openstack-dashboard-common deb net extra arch=all
 openstack-dashboard-ubuntu-theme deb net extra arch=all
 python3-django-horizon deb python extra arch=all
 python3-django-openstack-auth deb net extra arch=all
Checksums-Sha1:
 2b1f9098ddcb0473f8e3ea09ef414798c33249d3 11781747 horizon_22.1.0.orig-xstatic.tar.gz
 2c6746f175420311709537bfe0c03d1ea379bcd9 5558856 horizon_22.1.0.orig.tar.gz
 6c9a1137006fcd1c65f3a9263e0e6601672da331 112732 horizon_22.1.0-0ubuntu2.1.debian.tar.xz
Checksums-Sha256:
 b1378ff945c3a22cacecfcc159364cfe13ee81dd9aee924a9a3bdfd040e4482f 11781747 horizon_22.1.0.orig-xstatic.tar.gz
 32dca10bc7b8df784c7367ee0d6c126812e5b18e1d998710fa57b3098c0fdef2 5558856 horizon_22.1.0.orig.tar.gz
 46e10ae16a0d662976b11dd80cb6ad0833935b72221576e14288e8d409835350 112732 horizon_22.1.0-0ubuntu2.1.debian.tar.xz
Files:
 c246ab84d4bf37f934b9e34d0914c0e6 11781747 horizon_22.1.0.orig-xstatic.tar.gz
 1299fbfa17b1a02d417824eb4c0e0534 5558856 horizon_22.1.0.orig.tar.gz
 91e035a32211a1c8b2209a0e158a3224 112732 horizon_22.1.0-0ubuntu2.1.debian.tar.xz

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEENRbRpb8Ad+cUFOGXFbmz7g3N+AYFAmOPkLwACgkQFbmz7g3N
+AYDMw//WicyqQRzG5g5ladkweGlfqfYEcCoKG7TSp8aVweull6sbOZjsWan8QDG
228Rwb2QfxR4OW7fos8xRSQ4evMp15lETjiuS7jZ+JK8AR7fIgAjN/cTcO+HNeIr
Fb+zrDQTQNciKhDma+onKkEkr7cHC23jnCom3WZAA5xU8ViVW+DPnv4U8aExukvL
oz/nlb2IZwdDcf+7JSSibLTnRjNzua1GY+6/KCHRXwENWzEkyEYDlXe1QOgH/nJv
8TGrfx69QyxPQRtbIcSH2dHEyiArrXkn7v2UcbEGXvjA7xXPoBdd5ThykmHjfRlV
CJqB1gXVgctBToBi6m19k/QaujFdtDkbxVtP2yIdp3+HSejOsU4nGSP5DvHKqyyn
cJ9xvtbEBAGdN3oxToFvlezXAvwYiG61014QTv/CYy82jQ512NsbHuCqDTOXaLIg
qbu3gbbSuQ+xdFE/Wyk9ktphX0N/Sh6mbwoTmRwnBcxPgCkAOBi2YarNDdZFzQ6x
6ahi7HUd5ZNMITVmVAM0S+e2IomFl5ccwYMR9lNDuQzFQIeInOGHe1o9WebBtDTh
Fy5JnG1gf/FykVHu6S7oCtUbRSpBWAWKkAGta06SU2Vd+QVqwvd7i5kZNMwHl7Bu
YqFRpOzfwbbzMGjXDWKkUqou+ZB79IzlmQ6LDbWE1KO12KEX1CI=
=QEnH
-----END PGP SIGNATURE-----
