-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

Format: 3.0 (quilt)
Source: heat
Binary: heat-api, heat-api-cfn, heat-engine, python3-heat, heat-common
Architecture: all
Version: 1:18.0.1-0ubuntu1
Maintainer: Ubuntu Developers <ubuntu-devel-discuss@lists.ubuntu.com>
Uploaders:  Loic Dachary (OuoU) <loic@debian.org>, Julien Danjou <acid@debian.org>, Thomas Goirand <zigo@debian.org>, Ghe Rivero <ghe.rivero@stackops.com>, Mehdi Abaakouk <sileht@sileht.net>, David Della Vecchia <ddv@canonical.com>,
Homepage: https://wiki.openstack.org/Heat
Standards-Version: 4.5.0
Vcs-Browser: https://git.launchpad.net/~ubuntu-openstack-dev/ubuntu/+source/heat
Vcs-Git: https://git.launchpad.net/~ubuntu-openstack-dev/ubuntu/+source/heat
Testsuite: autopkgtest, autopkgtest-pkg-python
Build-Depends: debhelper-compat (= 13), dh-python, openstack-pkg-tools, python3-all, python3-pbr (>= 3.1.1), python3-setuptools, python3-sphinx (>= 2.0.0)
Build-Depends-Indep: bandit, python3-aodhclient (>= 0.9.0), python3-babel (>= 2.3.4), python3-bandit (>= 1.1.0), python3-barbicanclient (>= 4.5.2), python3-blazarclient (>= 1.0.1), python3-cinderclient (>= 1:3.3.0), python3-coverage (>= 4.0), python3-croniter (>= 0.3.4), python3-cryptography (>= 2.5), python3-ddt (>= 1.4.1), python3-debtcollector (>= 1.19.0), python3-designateclient (>= 2.7.0), python3-doc8, python3-eventlet (>= 0.18.2), python3-fixtures (>= 3.0.0), python3-gabbi (>= 1.35.0), python3-glanceclient (>= 1:2.8.0), python3-gnocchiclient (>= 3.3.1), python3-greenlet (>= 0.4.10), python3-hacking, python3-heatclient (>= 1.10.0), python3-ironicclient (>= 2.8.0), python3-keystoneauth1 (>= 3.18.0), python3-keystoneclient (>= 1:3.8.0), python3-keystonemiddleware (>= 5.1.0), python3-kombu (>= 5.0.1), python3-lxml (>= 4.5.0), python3-magnumclient (>= 2.3.0), python3-manilaclient (>= 1.16.0), python3-migrate (>= 0.13.0), python3-mistralclient (>= 1:3.1.0), python3-mock (>= 2.0.0), python3-monascaclient (>= 1.12.0), python3-mox3 (>= 0.20.0), python3-netaddr (>= 0.7.18), python3-neutron-lib (>= 1.14.0), python3-neutronclient (>= 1:6.14.0), python3-novaclient (>= 2:9.1.0), python3-octaviaclient (>= 1.8.0), python3-openstackclient (>= 3.12.0), python3-openstackdocstheme (>= 2.2.1), python3-openstacksdk (>= 0.28.0), python3-os-api-ref (>= 1.4.0), python3-os-testr (>= 1.0.0), python3-oslo.cache (>= 1.26.0), python3-oslo.concurrency (>= 3.26.0), python3-oslo.config (>= 1:6.8.0), python3-oslo.context (>= 1:2.22.0), python3-oslo.db (>= 6.0.0), python3-oslo.i18n (>= 3.20.0), python3-oslo.log (>= 4.3.0), python3-oslo.messaging (>= 5.29.0), python3-oslo.middleware (>= 3.31.0), python3-oslo.policy (>= 3.7.0), python3-oslo.reports (>= 1.18.0), python3-oslo.serialization (>= 2.25.0), python3-oslo.service (>= 1.24.0), python3-oslo.upgradecheck (>= 1.3.0), python3-oslo.utils (>= 4.5.0), python3-oslo.versionedobjects (>= 1.31.2), python3-oslotest (>= 1:3.2.0), python3-osprofiler (>= 1.4.0), python3-paramiko (>= 2.0), python3-pastedeploy (>= 1.5.0), python3-psycopg2 (>= 2.7), python3-pygments (>= 2.2.0), python3-pymysql (>= 0.8.0), python3-requests (>= 2.23.0), python3-routes (>= 2.3.1), python3-saharaclient (>= 1.4.0), python3-senlinclient (>= 1.1.0), python3-six (>= 1.10.0), python3-sphinxcontrib.apidoc (>= 0.2.0), python3-sphinxcontrib.httpdomain (>= 1.3.0), python3-sqlalchemy (>= 1.0.10), python3-stestr (>= 2.0.0), python3-stevedore (>= 1:3.1.0), python3-swiftclient (>= 1:3.2.0), python3-tempest (>= 1:17.1.0), python3-tenacity (>= 6.1.0), python3-testresources (>= 2.0.0), python3-testscenarios (>= 0.4), python3-testtools (>= 2.2.0), python3-troveclient (>= 1:2.2.0), python3-tz (>= 2013.6), python3-vitrageclient (>= 2.7.0), python3-webob (>= 1:1.7.1), python3-yaml (>= 5.1), python3-yaql (>= 1.1.3), python3-zaqarclient (>= 1.3.0), subunit
Package-List:
 heat-api deb web optional arch=all
 heat-api-cfn deb web optional arch=all
 heat-common deb web optional arch=all
 heat-engine deb web optional arch=all
 python3-heat deb python optional arch=all
Checksums-Sha1:
 5b72f90178afb1b8892af767af3295434587dcfc 2450762 heat_18.0.1.orig.tar.gz
 054c0de6fbbd9bb4e3778f2b3a6237189286900d 22408 heat_18.0.1-0ubuntu1.debian.tar.xz
Checksums-Sha256:
 e2d38d9398b5f9afd6188e8de8b496a7fb2b233d61037289100188e3f7434027 2450762 heat_18.0.1.orig.tar.gz
 c2ca5df19d7df11aedb117b07486918f7daf0b35d727770f4caf48d5dcde768d 22408 heat_18.0.1-0ubuntu1.debian.tar.xz
Files:
 8f8d56084847b05dab604d899408ebd2 2450762 heat_18.0.1.orig.tar.gz
 b7ed5607e82745f1f14017c2a0ab0b6f 22408 heat_18.0.1-0ubuntu1.debian.tar.xz
Original-Maintainer: PKG OpenStack <openstack-devel@lists.alioth.debian.org>

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEENRbRpb8Ad+cUFOGXFbmz7g3N+AYFAmRilRAACgkQFbmz7g3N
+Aa/eA//emaFcKheWBDyRh/SbGt0flsUYPzXNKLacNcfHyFRjEJTJEdftwjgJ8Ri
Q3TtiCz4khp7yBclt7KPRB3IsQ1ZfJX/HDwhdsKqc3v/WUrEfsD0+9weKUfQUFQg
gGGAJ60xI1iSy2L8HdMMTwQQ/t+U4w2o88M9PxOZ81u0Ehp3qio2CfIs9O965IQw
yUQtn62fK5dEN9bsncSIqiP4KdlthYiB0gK+ZBPxp+Ug1QgLunOiwvc/p8EmI1uF
Ke6ZZozlf+2fD77gKIP7sUPSZNzSLcCz+IdP5usrA12NdxL/GWWGi5mFHq65PB4r
AZkHASdRF44EZSzpul5g07u95ZibDh5P98+zJprTbKz0/7CWmWowpu42E53Q44x8
jhewbfO0kyZWmeAuiZcB7pqRSNnefR4A1pAupOSpiOg1QHgxpWuBUy3CdQK5TNfN
pctFW3taKhbtRebbGitHtAZxmwoIiSIui3eC637ECWMsCiyFXipBcrzgdgBcU0Dd
D5SCU/nqIzvNEg0QKV1keBqUL0AdZXGHVLlK9nx6/jsvRWFxJ8LHqA5UNOsG7Gfp
WhleqvPVq5MzcmaTfO0+CX/BO7Ukmq1D8UAzcTxXLgpcP2B+kFMR9Jy1k1NVjavS
h14BbAVXXE9qb8pmGEVHOPI9Yzhda7XGFcCmkzu+y0oMt0iBidc=
=qszT
-----END PGP SIGNATURE-----
