-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

Format: 3.0 (quilt)
Source: designate
Binary: designate, designate-agent, designate-api, designate-central, designate-common, designate-doc, designate-mdns, designate-pool-manager, designate-producer, designate-sink, designate-worker, designate-zone-manager, python3-designate
Architecture: all
Version: 1:14.0.2-0ubuntu1
Maintainer: Ubuntu Developers <ubuntu-devel-discuss@lists.ubuntu.com>
Uploaders:  Thomas Goirand <zigo@debian.org>, David Della Vecchia <ddv@canonical.com>,
Homepage: https://github.com/openstack/designate
Standards-Version: 4.5.0
Vcs-Browser: https://git.launchpad.net/~ubuntu-openstack-dev/ubuntu/+source/designate
Vcs-Git: https://git.launchpad.net/~ubuntu-openstack-dev/ubuntu/+source/designate
Testsuite: autopkgtest
Build-Depends: debhelper-compat (= 13), dh-python, openstack-pkg-tools, python3-all, python3-pbr (>= 3.1.1), python3-setuptools, python3-sphinx (>= 2.0.0), python3-sphinxcontrib.blockdiag (>= 1.5.4), python3-sphinxcontrib.httpdomain (>= 1.3.0)
Build-Depends-Indep: python3-babel (>= 2.3.4), python3-bandit (>= 1.1.0), python3-coverage (>= 4.0), python3-debtcollector (>= 1.19.0), python3-designateclient (>= 2.12.0), python3-dnspython (>= 1.16.0), python3-doc8 (>= 0.6.0), python3-edgegrid (>= 1.1.1), python3-eventlet (>= 0.26.1), python3-fixtures (>= 3.0.0), python3-flask (>= 0.10), python3-futurist (>= 1.2.0), python3-greenlet (>= 0.4.15), python3-hacking, python3-jinja2 (>= 2.10), python3-jsonschema (>= 3.2.0), python3-keystoneauth1 (>= 3.4.0), python3-keystonemiddleware (>= 4.17.0), python3-memcache (>= 1.56), python3-migrate (>= 0.11.0), python3-mock (>= 2.0.0), python3-monasca-statsd (>= 1.4.0), python3-netaddr (>= 0.7.18), python3-neutronclient (>= 1:6.7.0), python3-openstackdocstheme (>= 2.2.0), python3-os-api-ref (>= 1.4.0), python3-os-testr (>= 1.0.0), python3-os-win (>= 4.1.0), python3-oslo.concurrency (>= 4.2.0), python3-oslo.config (>= 1:6.8.0), python3-oslo.context (>= 1:2.22.0), python3-oslo.db (>= 8.3.0), python3-oslo.i18n (>= 3.20.0), python3-oslo.log (>= 4.3.0), python3-oslo.messaging (>= 12.4.0), python3-oslo.middleware (>= 3.31.0), python3-oslo.policy (>= 3.7.0), python3-oslo.reports (>= 1.18.0), python3-oslo.rootwrap (>= 5.8.0), python3-oslo.serialization (>= 2.25.0), python3-oslo.service (>= 1.31.0), python3-oslo.upgradecheck (>= 1.3.0), python3-oslo.utils (>= 4.7.0), python3-oslo.versionedobjects (>= 1.31.2), python3-oslotest (>= 1:3.2.0), python3-osprofiler (>= 3.4.0), python3-paste (>= 2.0.2), python3-pastedeploy (>= 1.5.0), python3-pecan (>= 1.0.0), python3-pygments (>= 2.2.0), python3-pymemcache (>= 1.2.9), python3-requests (>= 2.23.0), python3-requests-mock (>= 1.2.0), python3-sqlalchemy (>= 1.2.19), python3-stestr (>= 2.0.0), python3-stevedore (>= 1:1.20.0), python3-suds (>= 0.6), python3-tempest (>= 1:21.0.0), python3-tenacity (>= 6.0.0), python3-testrepository (>= 0.0.18), python3-testscenarios (>= 0.4), python3-testtools (>= 2.2.0), python3-tooz (>= 1.58.0), python3-webob (>= 1:1.7.1), python3-webtest (>= 2.0.27), python3-werkzeug (>= 0.9), python3-zake (>= 0.1.6)
Package-List:
 designate deb net optional arch=all
 designate-agent deb net optional arch=all
 designate-api deb net optional arch=all
 designate-central deb net optional arch=all
 designate-common deb net optional arch=all
 designate-doc deb doc optional arch=all
 designate-mdns deb net optional arch=all
 designate-pool-manager deb net optional arch=all
 designate-producer deb net optional arch=all
 designate-sink deb net optional arch=all
 designate-worker deb net optional arch=all
 designate-zone-manager deb net optional arch=all
 python3-designate deb python optional arch=all
Checksums-Sha1:
 b3dfd460bc9531c34d11115a42ee00bcfedde3e6 1007329 designate_14.0.2.orig.tar.gz
 4e5f374bc4f0c7fe73269ae8f54850be53c874e7 12132 designate_14.0.2-0ubuntu1.debian.tar.xz
Checksums-Sha256:
 e833a13f711e02f7485cf6699cb132c014f3fed1f04ea17e5947ddbc7efed6e4 1007329 designate_14.0.2.orig.tar.gz
 e4a59eb14126a4108276a1bd475b36cb67884ff2c0d44a655ca35cdb330c757a 12132 designate_14.0.2-0ubuntu1.debian.tar.xz
Files:
 b2cc4584f89d4db2eff292d98aaea44e 1007329 designate_14.0.2.orig.tar.gz
 9e4d9b87e9c1d6044fbd35d35cd1fcf9 12132 designate_14.0.2-0ubuntu1.debian.tar.xz
Original-Maintainer: PKG OpenStack <openstack-devel@lists.alioth.debian.org>

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEENRbRpb8Ad+cUFOGXFbmz7g3N+AYFAmRilVgACgkQFbmz7g3N
+AZijw//cS/amo1nLke8kEiQJiTG8M44GWG91krivTmeKJBTQ2spTGy7/0nL9IXz
D6uxZBG3adO+KL0vciWko8nqYYNaDTwkRGUc3dyhHakVxqpvhdf9AhKFIT/Zxg2h
znPqUhT1TJqKVpMDYhbiq3/4guZUpINekMB3dYCpTP9/STj9g0FCQudk60yYWf43
ClrWOcwqjydZA5NfEjoRIVeAcyFg420xXffw2sgzb5SGGal2H8IDxe3Mxhsa/ejo
yjUDlnzxLxf5TWxev1m+nP6PHHo/+QG4gpTeiwcZ0o+0mQvRd/Ew/z0XpCwrZF+Y
IkjEkeSn6+YoPjNoI+WQefwd00EXHjtyt0TmFJpXTDOe6ZqFyKmBPttlstj1okg0
hmY4sJceFNGdXDSOd7ODeBgvEzAiO2JK3OcJFzz/XG9sqestXjIkenp4RR8N0zB7
VpBKjXUXLKkLiYf/bXgS8OwgICm1VMq+R/5B55R98kh+y+KUmLGW0QHdi19fPM23
nstaZ1ayPUTxs2OzrmKv24KJWNX5mEV5A9ki0Y9mgpxybl0lEO5JWypwTQYz8rwd
nB2FPUddDg/NcpV+BNiAXhTIysJZXn6eGJ54DnoB1nsdMAarIi7Ne9QJOMvWLnJ+
/3gOWtRR3KeY88HDFDnxQmx6grqtP86485zWOJYpXqg07A1JwI8=
=f5Z0
-----END PGP SIGNATURE-----
