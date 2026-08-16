-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

Format: 3.0 (quilt)
Source: glance
Binary: glance, glance-api, glance-common, python-glance-doc, python3-glance
Architecture: all
Version: 2:24.2.0-0ubuntu1
Maintainer: Ubuntu OpenStack <openstack-packaging@lists.ubuntu.com>
Homepage: https://launchpad.net/glance
Standards-Version: 4.5.0
Vcs-Browser: https://git.launchpad.net/~ubuntu-openstack-dev/ubuntu/+source/glance
Vcs-Git: https://git.launchpad.net/~ubuntu-openstack-dev/ubuntu/+source/glance
Testsuite: autopkgtest, autopkgtest-pkg-python
Testsuite-Triggers: crudini, curl, mysql-server, python3-pymysql
Build-Depends: debhelper-compat (= 13), dh-python, openstack-pkg-tools, python3-all, python3-pbr (>= 3.1.1), python3-setuptools, python3-sphinx (>= 2.0.0)
Build-Depends-Indep: bandit, crudini, python3-alembic (>= 0.9.6), python3-babel (>= 2.3.4), python3-boto3 (>= 1.9.199), python3-castellan (>= 0.17.0), python3-cinderclient (>= 1:4.1.0), python3-cryptography (>= 2.6.1), python3-cursive (>= 0.2.1), python3-ddt (>= 1.0.1), python3-debtcollector (>= 1.19.0), python3-defusedxml (>= 0.6.0), python3-eventlet (>= 0.25.1), python3-fixtures (>= 3.0.0), python3-futurist (>= 1.2.0), python3-glance-store (>= 2.3.0), python3-httplib2 (>= 0.9.1), python3-iso8601 (>= 0.1.11), python3-jsonschema (>= 3.2.0), python3-keystoneauth1 (>= 3.4.0), python3-keystoneclient (>= 1:3.8.0), python3-keystonemiddleware (>= 5.1.0), python3-migrate (>= 0.11.0), python3-mock (>= 2.0.0), python3-openssl (>= 17.1.0), python3-openstackdocstheme (>= 2.2.1), python3-os-api-ref (>= 1.4.0), python3-os-brick (>= 3.1.0), python3-os-testr (>= 1.0.0), python3-os-win (>= 4.0.1), python3-oslo.concurrency (>= 3.26.0), python3-oslo.config (>= 1:8.1.0), python3-oslo.context (>= 1:2.22.0), python3-oslo.db (>= 5.0.0), python3-oslo.i18n (>= 5.0.0), python3-oslo.limit (>= 1.4.0), python3-oslo.log (>= 4.5.0), python3-oslo.messaging (>= 5.29.0), python3-oslo.middleware (>= 3.31.0), python3-oslo.policy (>= 3.8.1), python3-oslo.privsep (>= 1.32.0), python3-oslo.reports (>= 1.18.0), python3-oslo.upgradecheck (>= 1.3.0), python3-oslo.utils (>= 4.7.0), python3-oslotest (>= 1:3.2.0), python3-osprofiler (>= 1.4.0), python3-paste (>= 2.0.2), python3-pastedeploy (>= 1.5.0), python3-pep8, python3-prettytable (>= 0.7.1), python3-psutil (>= 3.2.2), python3-psycopg2 (>= 2.8.4), python3-pygments (>= 2.2.0), python3-pymysql (>= 0.7.6), python3-requests (>= 2.18.0), python3-retrying (>= 1.2.3), python3-routes (>= 2.3.1), python3-semantic-version (>= 2.3.1), python3-sendfile (>= 2.0.0), python3-sphinxcontrib.apidoc (>= 0.2.0), python3-sqlalchemy (>= 1.3.14), python3-sqlparse (>= 0.2.2), python3-stestr (>= 2.0.0), python3-stevedore (>= 1:1.20.0), python3-swiftclient (>= 1:3.2.0), python3-taskflow (>= 4.0.0), python3-testrepository (>= 0.0.18), python3-testresources (>= 2.0.0), python3-testscenarios (>= 0.4), python3-testtools (>= 2.2.0), python3-webob (>= 1:1.8.1), python3-wsme (>= 0.8.0), python3-xattr (>= 0.9.2), qemu-utils, subunit
Package-List:
 glance deb python extra arch=all
 glance-api deb python extra arch=all
 glance-common deb python extra arch=all
 python-glance-doc deb doc extra arch=all
 python3-glance deb python extra arch=all
Checksums-Sha1:
 f3ce649ed09b58b466842ebbc5937c864c5c2e94 2103147 glance_24.2.0.orig.tar.gz
 f91a82adb4c2cb275b73070e73ea26d0864469e6 18832 glance_24.2.0-0ubuntu1.debian.tar.xz
Checksums-Sha256:
 d0a22d82ebe0b94091328f8914be8569208ac505b49570f3b546c060b4f8c3bb 2103147 glance_24.2.0.orig.tar.gz
 9286418c81d61b3eeba86360ba34d78293dc1d6b5e62e6777366c6d1658f6f39 18832 glance_24.2.0-0ubuntu1.debian.tar.xz
Files:
 bd1c2efd2779c1d7bcbc3b923a39bd22 2103147 glance_24.2.0.orig.tar.gz
 be292a16b51b7a159fb7908fbc617424 18832 glance_24.2.0-0ubuntu1.debian.tar.xz
Python-Version: >= 2.7

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEENRbRpb8Ad+cUFOGXFbmz7g3N+AYFAmQRy0kACgkQFbmz7g3N
+AZ12w/8CeswdWmIYNMlmkEDJnCzTMp5IYo0no5xq/KC9zFJAskkdeMTjcU2yMQZ
uFiGUkiElPvBUuErflc3vPO4bELAUXSNeVKh08VLc4tVb+vRUzY7Ssy9DKmYfQk0
Wv/5acnpByZC/klRvVKFU5uJhcbmUgqjtC8f1sYPJUuvAXDc3XiX6G3dVw093aHX
bzi1btqYRyxS9RxXuIpa6QUXPxDyB/cRDvmAL4bWcIf2Saf/rQOuLGIoy3DKVNR0
npjfNXRq1PJDsGHHL8TQISfQCzlKTod7A0FrdBmq7xJ9J92kiS6Qm0/gD3AhtC5U
PmWYFL8bS9cDY2n0NhheOCOQ5699/XpYN4KvnjolCrk3dPNLpRrAkv0fFr64rPzM
TV47DMvXdRTC7rFfhaYB8+1vqFPm8BNg7SzADoccWDAQ2z57Sy9xSkL87Cx+uQM9
ARvaf8cs8ZZLzRZ1F8qjFHui1ni3Hf9H3M/ItrfakgWnUtCtX6sJrDyr8geligvV
hmBRKi9bmVQD9TIBPfe/oSZpo+pwTxbyLT6aVs0sE5RBF2LgLY8z37t4yfvvDohl
TcAwE7DOwuk7HUIoOYeWSXkqjVF5Pgg1xs/G68mzNNfL7cPqRSa51c3SKD7qavvO
f01OYGfCbva37kW2Crhc358RvcAyXyrU76+R4OC8AHqtq7jM6i4=
=kGAx
-----END PGP SIGNATURE-----
