-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

Format: 3.0 (quilt)
Source: keystone
Binary: keystone, keystone-common, keystone-doc, python3-keystone
Architecture: all
Version: 2:21.0.0-0ubuntu1
Maintainer: Ubuntu Developers <ubuntu-devel-discuss@lists.ubuntu.com>
Homepage: https://opendev.org/openstack/keystone
Standards-Version: 4.5.0
Vcs-Browser: https://git.launchpad.net/~ubuntu-openstack-dev/ubuntu/+source/keystone
Vcs-Git: https://git.launchpad.net/~ubuntu-openstack-dev/ubuntu/+source/keystone
Testsuite: autopkgtest, autopkgtest-pkg-python
Build-Depends: apache2-dev, debhelper-compat (= 13), dh-apache2, dh-python, openstack-pkg-tools, python3-all, python3-pbr (>= 2.0.0), python3-setuptools, python3-sphinx (>= 2.0.0), python3-sphinx-feature-classification (>= 0.3.2)
Build-Depends-Indep: crudini, python3-bashate (>= 0.5.1), python3-bcrypt (>= 3.1.3), python3-coverage (>= 4.0), python3-cryptography (>= 2.7), python3-dogpile.cache (>= 1.0.2), python3-fixtures (>= 3.0.0), python3-flake8-docstrings (>= 0.2.1.post1), python3-flask (>= 1.0.2), python3-flask-restful (>= 0.3.5), python3-freezegun (>= 0.3.6), python3-hacking, python3-jsonschema (>= 3.2.0), python3-jwt (>= 1.6.1), python3-keystoneclient (>= 1:3.8.0), python3-keystonemiddleware (>= 7.0.0), python3-ldap (>= 3.0.0), python3-ldappool (>= 2.0.0), python3-lxml (>= 4.5.0), python3-memcache, python3-migrate (>= 0.13.0), python3-mock (>= 2.0.0), python3-msgpack (>= 0.5.0), python3-oauthlib (>= 0.6.2), python3-openstackdocstheme (>= 2.2.1), python3-os-api-ref (>= 1.4.0), python3-oslo.cache (>= 1.26.0), python3-oslo.config (>= 1:6.8.0), python3-oslo.context (>= 1:2.22.0), python3-oslo.db (>= 8.5.0+really.8.4.0), python3-oslo.i18n (>= 3.15.3), python3-oslo.log (>= 3.44.0), python3-oslo.messaging (>= 5.29.0), python3-oslo.middleware (>= 3.31.0), python3-oslo.policy (>= 3.10.0), python3-oslo.serialization (>= 2.18.0), python3-oslo.upgradecheck (>= 1.3.0), python3-oslo.utils (>= 3.33.0), python3-oslotest (>= 1:3.2.0), python3-osprofiler (>= 1.4.0), python3-passlib (>= 1.7.0), python3-paste (>= 2.0.2), python3-pastedeploy (>= 1.5.0), python3-pep8, python3-pycadf (>= 1.1.0), python3-pycodestyle (>= 2.0.0), python3-pymongo, python3-pymysql, python3-pysaml2 (>= 5.0.0), python3-requests (>= 2.14.2), python3-scrypt (>= 0.8.0), python3-sphinxcontrib.apidoc (>= 0.2.0), python3-sphinxcontrib.blockdiag (>= 1.5.5), python3-sphinxcontrib.seqdiag (>= 0.8.4), python3-sqlalchemy (>= 1.3.0), python3-stestr (>= 1.0.0), python3-stevedore (>= 1:1.20.0), python3-tempest (>= 1:17.1.0), python3-testresources (>= 2.0.0), python3-testtools (>= 2.2.0), python3-tz (>= 2013.6), python3-webob (>= 1:1.7.1), python3-webtest (>= 2.0.27)
Package-List:
 keystone deb python extra arch=all
 keystone-common deb python extra arch=all
 keystone-doc deb doc extra arch=all
 python3-keystone deb python extra arch=all
Checksums-Sha1:
 b81aeda1dd9af12ba5f4332a2fea6b3df0906b3f 1697791 keystone_21.0.0.orig.tar.gz
 3b7572bf0a949d8e9ae01aa61aa8c46d3694c0a8 19372 keystone_21.0.0-0ubuntu1.debian.tar.xz
Checksums-Sha256:
 b190648c5282ef14c52252efd288ca164ffea1b74291107ce160da66d2323dda 1697791 keystone_21.0.0.orig.tar.gz
 13010030b4a8aae122eb211e1239393faa7b1f20aa03741f3a61f210ef08610a 19372 keystone_21.0.0-0ubuntu1.debian.tar.xz
Files:
 6970dba57b5c47383179396341d52a77 1697791 keystone_21.0.0.orig.tar.gz
 1b09ed5417e6164683d79951e4edddb1 19372 keystone_21.0.0-0ubuntu1.debian.tar.xz
Original-Maintainer: Monty Taylor <mordred@inaugust.com>
Python-Version: >= 2.7

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEENRbRpb8Ad+cUFOGXFbmz7g3N+AYFAmJE+sEACgkQFbmz7g3N
+AZefQ//e+sZSlYi3DcPfuWpA6pOwTCUr9hFC6DDiDoJKgiC+zejHJxyNVcaDYsQ
RCXpjixADulO5y11duGR0m583IS061cW5PToAPWIq8Nq6gwqNIrnZLnXfehxxeGG
oBcF+dEd2WZ9D/kD+259mUkY+kuZ01JPleag+H6fZju3NWgKaTOSDbsrJdCgMJ/y
0qwWa0sc96FaYJwo67eKys2SXSf4ihj+vtPXvtgx2H3fcx2JHHD7zk71CKf+aeJ8
ppraNq47xrhWgde6J5YPmLi7vDh0vdIwEwo/tAAM9cxnTGpdSW7v9l6qTtJVw3xY
C5pR98BC6Peon/0/Fk+kE2eRUt8cFagPEtHcdiux58xawvj7pmTabac9T3rQZZHr
b3wRm8BMuPkfZzkOv5UlSJTA9pIbHHnJ4Etqwqo1RAmMOhz/rXSVejUv7ZoXzFSi
NgROdmueto+KHZ75Vqk2/b89cN8VEPMDZU1ZyAoLFnChy8vZrEFOMAW9O5ToDbJd
/hjnIJWaJKbc1bufSaJ+GHNT8oL5MRnEYu538fyqd7W2JowE1bU3ERKSr6FjQpjc
s6sTCeJ7sjkiGa7lBS3ISCEAjrzYDFPJ4+hZ+II6o+ebDMM+amhQDHRePwzPDDg3
vPNDLp4rPNbTHJ3c12NP26eFguAMcZxpQM22LBp8T3LbyQfizBQ=
=4elW
-----END PGP SIGNATURE-----
