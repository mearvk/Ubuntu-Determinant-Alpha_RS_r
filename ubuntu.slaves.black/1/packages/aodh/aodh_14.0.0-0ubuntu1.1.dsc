-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

Format: 3.0 (quilt)
Source: aodh
Binary: aodh-api, aodh-doc, aodh-evaluator, aodh-expirer, aodh-listener, aodh-notifier, python3-aodh, aodh-common
Architecture: all
Version: 1:14.0.0-0ubuntu1.1
Maintainer: Ubuntu Developers <ubuntu-devel-discuss@lists.ubuntu.com>
Uploaders:  Thomas Goirand <zigo@debian.org>,
Homepage: https://github.com/openstack/aodh
Standards-Version: 4.1.2
Vcs-Browser: https://git.launchpad.net/~ubuntu-openstack-dev/ubuntu/+source/aodh
Vcs-Git: git://git.launchpad.net/~ubuntu-openstack-dev/ubuntu/+source/aodh
Testsuite: autopkgtest, autopkgtest-pkg-python
Testsuite-Triggers: rabbitmq-server
Build-Depends: apache2-dev, debhelper-compat (= 13), dh-apache2, dh-python, openstack-pkg-tools, python3-all, python3-pbr (>= 2.0.0), python3-setuptools, python3-sphinx (>= 2.0.0)
Build-Depends-Indep: crudini, python3-babel, python3-cachetools (>= 1.1.6), python3-cotyledon, python3-coverage, python3-croniter (>= 0.3.4), python3-dateutil, python3-debtcollector (>= 1.2.0), python3-futurist (>= 0.11.0), python3-gabbi, python3-gnocchiclient (>= 6.0.0), python3-heatclient (>= 1.17.0), python3-jsonschema (>= 3.2.0), python3-keystoneauth1 (>= 2.1), python3-keystoneclient (>= 1:1.6.0), python3-keystonemiddleware (>= 5.1.0), python3-lxml (>= 2.3), python3-mock (>= 2.0.0), python3-octaviaclient (>= 1.8.0), python3-openstackdocstheme (>= 2.2.1), python3-os-testr (>= 1.0.0), python3-oslo.config (>= 1:6.8.0), python3-oslo.context (>= 1:2.22.0), python3-oslo.db (>= 4.8.0), python3-oslo.i18n (>= 1.5.0), python3-oslo.log (>= 4.3.0), python3-oslo.messaging (>= 5.2.0), python3-oslo.middleware (>= 3.22.0), python3-oslo.policy (>= 3.7.0), python3-oslo.reports (>= 1.18.0), python3-oslo.utils (>= 3.5.0), python3-oslo.upgradecheck (>= 1.3.0), python3-oslosphinx, python3-oslotest, python3-pastedeploy (>= 1.5.0), python3-pecan (>= 0.8.0), python3-psycopg2, python3-pymysql, python3-reno, python3-requests (>= 2.5.2), python3-retrying, python3-six (>= 1.9.0), python3-sphinxcontrib-pecanwsme (>= 0.10.0), python3-sphinxcontrib.httpdomain, python3-sqlalchemy (>= 1.4.1), python3-sqlalchemy-utils, python3-stevedore (>= 1:1.5.0), python3-tempest, python3-tenacity (>= 3.2.1), python3-testresources (>= 2.0.0), python3-testscenarios, python3-tooz (>= 1.28.0), python3-tz (>= 2013.6), python3-voluptuous (>= 0.8.10), python3-webob (>= 1:1.2.3), python3-webtest, python3-werkzeug, python3-wsme (>= 0.8), subunit, testrepository
Package-List:
 aodh-api deb web optional arch=all
 aodh-common deb web optional arch=all
 aodh-doc deb doc optional arch=all
 aodh-evaluator deb web optional arch=all
 aodh-expirer deb web optional arch=all
 aodh-listener deb web optional arch=all
 aodh-notifier deb web optional arch=all
 python3-aodh deb python optional arch=all
Checksums-Sha1:
 ee65196fc4e12a4a75701d7fef57ff69b11f9349 258618 aodh_14.0.0.orig.tar.gz
 82ed3f4704dc20cc7077047fd806afbca2ecb188 11940 aodh_14.0.0-0ubuntu1.1.debian.tar.xz
Checksums-Sha256:
 004da6ddf487b3993d09ae5f55497124a25a08dd073ad941ed5d4000a64bf38f 258618 aodh_14.0.0.orig.tar.gz
 09cd004fe3024a372181f32534bf78ee0fbd3e5770cb5df7143f74bf6dc7bbe5 11940 aodh_14.0.0-0ubuntu1.1.debian.tar.xz
Files:
 3a8ea195a3be4321ef37f8a48881f975 258618 aodh_14.0.0.orig.tar.gz
 f703e927903bb3030a99db0e9c579d42 11940 aodh_14.0.0-0ubuntu1.1.debian.tar.xz
Original-Maintainer: PKG OpenStack <openstack-devel@lists.alioth.debian.org>

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEENRbRpb8Ad+cUFOGXFbmz7g3N+AYFAmPJuZ4ACgkQFbmz7g3N
+Aao4RAArtTJF+7/OS8aGqEL9PYy5RTfwDz+KEC37xxjiil1qS5N6Ut0dhTNZa8w
oLbTsheg7yH6McaQG2tQdyPkcsCBqLl1t4ZPmm1gPpeJqew+XJdoaOkT6Dxy9PDk
p+I4Omr+fYRy73GKvBoxU5yknqVuSeJfTSn+4bQRNo/XxXkwcezg8L1yDTa1B8ik
eUABLPYHBUn+V4/EYHZKyfFdqGCRAXp5jKPcwRzTGAWchFznpd6ULPC/JBsDvz7c
JN/qRk8YwAgSpFjD8uAPtF5OaRCPdz98qQZCbK7wVIYtTk//S8Bp56cxvwd7s8Ka
eqUM4KIsSQsrWQ8ql6fl4Lnd7MadJxkO7MLYEu5TguiksrpMRxRwFo1uM+I+XGKu
EU/48E+pSuSSPXEEfcK4+V41atGAqf4pKZvrZxNY0qrzqtGQOBHFiO9C9h4ciYCE
6q6u0Ok7qUacBkSUjDjndDPESBh0+uWFN+4lL2J7lHM6oI8rvEXQLgRrRABUoMIZ
VhS7T+vZCk8xEKwAV00nQejWsT5W+EBywKTx6U+Nk9HHKV4s4gLLBqQtX/7eqv0m
Yc3qCt2lGKOK9WyvI5sCfVCNAkob/B4Ohh/Og5wsJ9qbcNBGd1Xfkc14CgoiHY6f
B5fHpoWHSIbeGXiu7VjTjygwgOX8MMEzhJPiSK6bND1MTLI9Zm4=
=LI3e
-----END PGP SIGNATURE-----
