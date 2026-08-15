-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

Format: 3.0 (quilt)
Source: cinder
Binary: cinder-api, cinder-backup, cinder-common, cinder-scheduler, cinder-volume, python3-cinder
Architecture: all
Version: 2:20.3.0-0ubuntu1
Maintainer: Ubuntu Developers <ubuntu-devel-discuss@lists.ubuntu.com>
Homepage: https://launchpad.net/cinder
Standards-Version: 4.1.4
Vcs-Browser: https://git.launchpad.net/~ubuntu-openstack-dev/ubuntu/+source/cinder
Vcs-Git: https://git.launchpad.net/~ubuntu-openstack-dev/ubuntu/+source/cinder
Testsuite: autopkgtest, autopkgtest-pkg-python
Testsuite-Triggers: lvm2, mysql-server
Build-Depends: apache2-dev, debhelper-compat (= 13), dh-apache2, dh-python, openstack-pkg-tools, python3-all, python3-pbr (>= 5.8.0), python3-setuptools, python3-sphinx (>= 3.5.1), python3-tabulate (>= 0.8.7)
Build-Depends-Indep: python3-barbicanclient (>= 5.0.1), python3-boto3 (>= 1.16.51), python3-botocore, python3-castellan (>= 3.7.0), python3-coverage, python3-cryptography (>= 3.1), python3-cursive (>= 0.2.2), python3-ddt (>= 1.4.1), python3-decorator (>= 4.4.2), python3-doc8, python3-eventlet (>= 0.30.1), python3-fixtures (>= 3.0.0), python3-glanceclient (>= 1:3.2.2), python3-googleapi (>= 1.7.11), python3-greenlet (>= 0.4.16), python3-hacking, python3-httplib2 (>= 0.18.1), python3-importlib-metadata (>= 3.1.1), python3-iso8601 (>= 0.1.12), python3-jsonschema (>= 3.2.0), python3-keystoneauth1 (>= 4.2.1), python3-keystoneclient (>= 1:4.1.1), python3-keystonemiddleware (>= 9.1.0), python3-lxml (>= 4.5.2), python3-migrate (>= 0.13.0), python3-mock (>= 2.0.0), python3-novaclient (>= 2:17.2.1), python3-oauth2client (>= 4.1.3), python3-openstackdocstheme (>= 2.2.7), python3-os-api-ref (>= 2.1.0), python3-os-brick (>= 5.2.0), python3-os-win (>= 5.5.0), python3-oslo.concurrency (>= 4.5.0), python3-oslo.config (>= 1:8.3.2), python3-oslo.context (>= 1:3.4.0), python3-oslo.db (>= 11.0.0), python3-oslo.i18n (>= 5.1.0), python3-oslo.log (>= 4.6.1), python3-oslo.messaging (>= 12.5.0), python3-oslo.middleware (>= 4.1.1), python3-oslo.policy (>= 3.8.1), python3-oslo.privsep (>= 2.6.2), python3-oslo.reports (>= 2.2.0), python3-oslo.rootwrap (>= 6.2.0), python3-oslo.serialization (>= 4.2.0), python3-oslo.service (>= 2.8.0), python3-oslo.upgradecheck (>= 1.1.1), python3-oslo.utils (>= 4.12.1), python3-oslo.versionedobjects (>= 2.3.0), python3-oslo.vmware (>= 3.10.0), python3-oslotest (>= 1:4.5.0), python3-osprofiler (>= 3.4.0), python3-packaging (>= 20.4), python3-paramiko (>= 2.7.2), python3-paste (>= 3.4.3), python3-pastedeploy (>= 2.1.0), python3-pep8, python3-prettytable (>= 0.7.1), python3-psutil (>= 5.7.2), python3-psycopg2 (>= 2.8.5), python3-pymysql (>= 0.10.0), python3-pyparsing (>= 2.4.7), python3-requests (>= 2.25.1), python3-retrying (>= 1.2.3), python3-routes (>= 2.4.1), python3-rtslib-fb (>= 2.1.74), python3-six (>= 1.15.0), python3-sphinx-feature-classification, python3-sphinxcontrib.apidoc (>= 0.3.0), python3-sqlalchemy (>= 1.4.23), python3-sqlalchemy-utils (>= 0.37.8), python3-stestr, python3-stevedore (>= 1:3.2.2), python3-suds (>= 0.6), python3-swiftclient (>= 1:3.10.1), python3-taskflow (>= 4.5.0), python3-tempest (>= 1:17.1.0), python3-tenacity (>= 6.3.1), python3-testrepository (>= 0.0.18), python3-testresources (>= 2.0.0), python3-testscenarios (>= 0.4), python3-testtools (>= 2.4.0), python3-tooz (>= 2.7.1), python3-tz (>= 2020.1), python3-webob (>= 1:1.8.6), python3-zstd (>= 1.4.5.1)
Package-List:
 cinder-api deb net extra arch=all
 cinder-backup deb net extra arch=all
 cinder-common deb net extra arch=all
 cinder-scheduler deb net extra arch=all
 cinder-volume deb net extra arch=all
 python3-cinder deb python extra arch=all
Checksums-Sha1:
 9bb771521c192255f01a4291fd65ab0ad4631c0b 5973186 cinder_20.3.0.orig.tar.gz
 dfdc8d6c2fefdeed6138a1c16b7b19968162d575 20260 cinder_20.3.0-0ubuntu1.debian.tar.xz
Checksums-Sha256:
 c5cfc0adf5551cc3acad48d5e88fd548dbac44f2bd802cd6c58153a79e09b54f 5973186 cinder_20.3.0.orig.tar.gz
 2129e96269af0fcd3dacc72358066a161aae2d084e642315ad5e73c7247cff2c 20260 cinder_20.3.0-0ubuntu1.debian.tar.xz
Files:
 10e6d1cd11612975fade3af836ac942a 5973186 cinder_20.3.0.orig.tar.gz
 48c83dbb19355c383e27d74baf675fbf 20260 cinder_20.3.0-0ubuntu1.debian.tar.xz
Original-Maintainer: Chuck Short <zulcss@ubuntu.com>

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEENRbRpb8Ad+cUFOGXFbmz7g3N+AYFAmSfKooACgkQFbmz7g3N
+AaY5g/+Mz48AYh5Iai2glJKi8YKUiCP7weoiSwOgKLIXtlLQOt83VFzpZU8FIO0
JkICVXMsjZxyXWnrN2mjSeTlw90zOUcAtBzKxIlg1HtKBg63afj7BvDO8CyFblvb
kp6QfoycZbtAenlCtuzmw3HimpD8zycdQr5JqfGK5igF2Oi/QXwRLJ35a1lh/r8J
MY1jmtz2gBPjImToONphOeF9cqfcqjW11ZfDQ31Z8FfcHk1lmCHvTa/SejpSsCbC
d9ZCqblOtJDXj3xwdLPc5qREAmRzyivt0nIiap3REYEXQQUMfEw1DTzX3K+yww0K
GhhJQcgU8r8chqehZKiIC/NQvrPgfczK8TnoORWUv+swL0mrSMss8vqbITuDiC6M
GhGrUCWZ9k5kGQ6bKefZZubpUZBmDFaNiDkeDtRqqeMhg/nkHJy+jYXai9DQjHFg
GFarkv0JCOg0cFysVUbSnplxaREsJ3Qr9/oPBDSRWHDTTULEKLpcnTs1MNGG8Ak2
JPJGXvyr8SG/2C/Je59LYUzxNYuokEM/fcSpKvRhEWPGzMb2IfEqD4Zp/m/H5uDZ
+1wVw39hS7ln9tqO2QakJOnOVgUdPsPYG3tbBP09isEZULXCzuOcn0udQVcSqBCQ
SCD9czbs0M3yx591Qs0ManMQkK4iLH4mDrRa82Qd+Xs8w0kRP7s=
=O+BR
-----END PGP SIGNATURE-----
