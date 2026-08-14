-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

Format: 3.0 (quilt)
Source: barbican
Binary: barbican-api, barbican-common, barbican-doc, barbican-keystone-listener, barbican-worker, python3-barbican
Architecture: all
Version: 2:14.0.2-0ubuntu1
Maintainer: Ubuntu Developers <ubuntu-devel-discuss@lists.ubuntu.com>
Uploaders:  Thomas Goirand <zigo@debian.org>, David Della Vecchia <ddv@canonical.com>,
Homepage: https://github.com/openstack/barbican
Standards-Version: 4.1.4
Vcs-Browser: https://git.launchpad.net/~ubuntu-openstack-dev/ubuntu/+source/barbican
Vcs-Git: https://git.launchpad.net/~ubuntu-openstack-dev/ubuntu/+source/barbican
Testsuite: autopkgtest, autopkgtest-pkg-python
Build-Depends: apache2-dev, debhelper-compat (= 13), dh-apache2, dh-python, openstack-pkg-tools, python3-all, python3-pbr (>= 2.0.0), python3-setuptools, python3-sphinx (>= 2.0.0)
Build-Depends-Indep: python3-alembic (>= 0.8.10), python3-babel (>= 2.3.4), python3-bandit (>= 1.1.0), python3-castellan (>= 3.0.1), python3-cffi (>= 1.7.0), python3-coverage (>= 4.0), python3-cryptography (>= 2.1), python3-ddt (>= 1.0.1), python3-doc8 (>= 0.8.0), python3-eventlet (>= 0.18.2), python3-fixtures (>= 3.0.0), python3-hacking (>= 1.1.0), python3-jsonschema (>= 3.2.0), python3-keystoneclient (>= 1:3.8.0), python3-keystonemiddleware (>= 5.1.0), python3-ldap (>= 3.0.0), python3-mock (>= 2.0.0), python3-openssl (>= 17.1.0), python3-openstackdocstheme (>= 2.2.1), python3-os-api-ref (>= 1.5.0), python3-os-testr (>= 1.0.0), python3-oslo.config (>= 1:6.4.0), python3-oslo.context (>= 1:2.22.0), python3-oslo.db (>= 4.27.0), python3-oslo.i18n (>= 3.15.3), python3-oslo.log (>= 4.3.0), python3-oslo.messaging (>= 5.29.0), python3-oslo.middleware (>= 3.31.0), python3-oslo.policy (>= 3.6.0), python3-oslo.serialization (>= 2.18.0), python3-oslo.service (>= 1.24.0), python3-oslo.upgradecheck (>= 1.3.0), python3-oslo.utils (>= 3.33.0), python3-oslo.versionedobjects (>= 1.31.2), python3-oslotest (>= 1:3.2.0), python3-paste (>= 2.0.2), python3-pastedeploy (>= 1.5.0), python3-pecan (>= 1.0.0), python3-pep8, python3-pygments (>= 2.2.0), python3-pykmip (>= 0.7.0), python3-reno (>= 2.11.2), python3-requests (>= 2.18.0), python3-six (>= 1.10.0), python3-sphinxcontrib.blockdiag (>= 1.5.4), python3-sphinxcontrib.httpdomain (>= 1.3.0), python3-sphinxcontrib.svg2pdfconverter (>= 0.1.0), python3-sqlalchemy (>= 1.0.10), python3-stestr (>= 2.0.0), python3-stevedore (>= 1:1.20.0), python3-tempest (>= 1:17.1.0), python3-testrepository (>= 0.0.18), python3-testtools (>= 2.2.0), python3-webob (>= 1:1.7.1), python3-webtest (>= 2.0.27)
Package-List:
 barbican-api deb net extra arch=all
 barbican-common deb net extra arch=all
 barbican-doc deb doc extra arch=all
 barbican-keystone-listener deb net extra arch=all
 barbican-worker deb net extra arch=all
 python3-barbican deb python extra arch=all
Checksums-Sha1:
 425a1939b3cd3e020a7d91ed9728338dfcff61aa 689355 barbican_14.0.2.orig.tar.gz
 7851dc870c1ed74017b42484417dbeec0f46c7f8 11836 barbican_14.0.2-0ubuntu1.debian.tar.xz
Checksums-Sha256:
 7585ac384e4e0a2a492ae7d6dd069e2aabf2ce4a42d38a16dfdc8523c849c259 689355 barbican_14.0.2.orig.tar.gz
 c8904ff8e6e67c92c67bbb30bbe9819c4d23c04fa0fa95714fdc5429321e2e77 11836 barbican_14.0.2-0ubuntu1.debian.tar.xz
Files:
 7dbda1e8b9936064d565736872ee89c5 689355 barbican_14.0.2.orig.tar.gz
 ed117daf37464e11ca99c945c4b58fc1 11836 barbican_14.0.2-0ubuntu1.debian.tar.xz
Original-Maintainer: PKG OpenStack <openstack-devel@lists.alioth.debian.org>

-----BEGIN PGP SIGNATURE-----

iQJPBAEBCAA5FiEENRbRpb8Ad+cUFOGXFbmz7g3N+AYFAmOJV8IbHGNvcmV5LmJy
eWFudEBjYW5vbmljYWwuY29tAAoJEBW5s+4NzfgGGx0P/3y96OsGYRjH30wFYNu1
GqtPfDn9goFfe/AZqejGOGNcc5kAS92brjPUQ2ftKIV02TnRRHbx+1YPgLrW6qHr
xERSK87AAHy56VhZRGoYTYEjpAsQXYsBfCMAJCpvfjqAdILtNOG4ElhfNs+GtkkJ
0/iw2v9Ywi6I2dVPrxwvhxuHy7BQGCIA0UZdBejUiTnrah0z5ZwOYqgk0bBd97Jm
KaKDWy/zoUpuEwXMHjPmuF2eQ/fbn+Qndh1LSamOIRAije1J6epUCPT/g+C2LVkq
9ZW52vg5jl3/YvPDxOjWtEJdrKP+qM8/kH3fG6a0Mc5x1H2bXaqgO2iqG6BH8Ypb
5f+qhYyQ8dDOlSnhBIpjDeX6Tdq3WvO7l71UOxYJ9cG69KvgKUuCV2Qy82vRuNGK
A3FGHC9nX5wxH3az2ccHfVRNUSgOBEdHotZqpIotAXl8QqnyZE2wGKqQM4coJ3mA
6FfoG6GDDIwVDTfNOW4aLpp5xdWKsC1LGCmZPR9oDyKM3pmbkK3wLYZ78dMBx8vX
iGp5ESIVbCTTdIhRNKGPJHCoKAMvrG6DIC4h/uSsvnHMG6PzCy2R45WNGGt8IBti
z71GZ/KhPP2qNvPWJ8OLLS3FjWvREDtuwVx2c2J0OLBcw3NEDG9O3jdJLvGKk1H0
6mRO0kqm286sR5w10sBJR0TI
=M6s7
-----END PGP SIGNATURE-----
