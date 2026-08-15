-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

Format: 3.0 (quilt)
Source: ceilometer
Binary: ceilometer-agent-central, ceilometer-agent-compute, ceilometer-agent-ipmi, ceilometer-agent-notification, ceilometer-common, ceilometer-polling, python3-ceilometer
Architecture: all
Version: 2:18.1.0-0ubuntu1
Maintainer: Chuck Short <zulcss@ubuntu.com>
Standards-Version: 4.1.2
Vcs-Browser: https://git.launchpad.net/~ubuntu-openstack-dev/ubuntu/+source/ceilometer
Vcs-Git: git://git.launchpad.net/~ubuntu-openstack-dev/ubuntu/+source/ceilometer
Testsuite: autopkgtest, autopkgtest-pkg-python
Testsuite-Triggers: libvirt-daemon-system, nova-compute, python3-libvirt, rabbitmq-server
Build-Depends: debhelper-compat (= 13), dh-python, openstack-pkg-tools, python3-all, python3-pbr (>= 2.0.0), python3-setuptools, python3-sphinx (>= 2.0.0)
Build-Depends-Indep: python3-awsauth (>= 0.1.4), python3-cachetools (>= 2.1.0), python3-cinderclient (>= 1:3.3.0), python3-confluent-kafka (>= 0.11.0), python3-cotyledon (>= 1.3.0), python3-coverage (>= 4.0), python3-croniter, python3-cryptography, python3-dateutil (>= 2.4.2), python3-debtcollector (>= 1.2.0), python3-eventlet (>= 0.30.1), python3-fixtures (>= 3.0.0), python3-futurist (>= 1.8.0), python3-gabbi (>= 1.30.0), python3-glanceclient (>= 1:2.8.0), python3-gnocchiclient (>= 7.0.0), python3-jsonpath-rw-ext (>= 1.1.3), python3-keystoneauth1 (>= 3.18.0), python3-keystoneclient (>= 1:3.18.0), python3-lxml (>= 4.5.1), python3-mock (>= 2.0.0), python3-monascaclient (>= 1.12.0), python3-monotonic (>= 0.6), python3-msgpack (>= 0.5.2), python3-neutronclient (>= 1:6.7.0), python3-novaclient (>= 2:9.1.0), python3-openssl (>= 17.5.0), python3-openstackdocstheme (>= 2.2.1), python3-os-api-ref (>= 1.4.0), python3-os-testr (>= 1.0.0), python3-os-win (>= 3.0.0), python3-os-xenapi (>= 0.3.3), python3-oslo.cache (>= 1.26.0), python3-oslo.concurrency (>= 3.29.0), python3-oslo.config (>= 1:8.6.0), python3-oslo.i18n (>= 3.15.3), python3-oslo.log (>= 3.36.0), python3-oslo.messaging (>= 10.3.0), python3-oslo.privsep (>= 1.32.0), python3-oslo.reports (>= 1.18.0), python3-oslo.rootwrap (>= 2.0.0), python3-oslo.serialization (>= 2.18.0), python3-oslo.upgradecheck (>= 0.1.1), python3-oslo.utils (>= 4.7.0), python3-oslo.vmware (>= 2.17.0), python3-oslotest (>= 1:3.8.0), python3-pysnmp4 (>= 4.2.3), python3-requests (>= 2.25.1), python3-sphinxcontrib.blockdiag (>= 1.5.4), python3-sphinxcontrib.httpdomain (>= 1.3.0), python3-stestr (>= 2.0.0), python3-stevedore (>= 1:1.20.0), python3-swiftclient (>= 1:3.2.0), python3-tempest (>= 1:14.0.0), python3-tenacity (>= 6.3.1), python3-testrepository (>= 0.0.18), python3-testresources (>= 2.0.1), python3-testscenarios (>= 0.4), python3-testtools (>= 2.2.0), python3-tooz (>= 1.47.0), python3-yaml (>= 5.1), python3-zake (>= 0.2.2), python3-zaqarclient (>= 1.3.0)
Package-List:
 ceilometer-agent-central deb python optional arch=all
 ceilometer-agent-compute deb python optional arch=all
 ceilometer-agent-ipmi deb python optional arch=all
 ceilometer-agent-notification deb python optional arch=all
 ceilometer-common deb python optional arch=all
 ceilometer-polling deb python optional arch=all
 python3-ceilometer deb python optional arch=all
Checksums-Sha1:
 b15dd90c0912e18b5b7c7c6a0ec4c1b8af945228 907458 ceilometer_18.1.0.orig.tar.gz
 c49f6709d773dcfc6fbf308cd8ce04e179c86fad 15428 ceilometer_18.1.0-0ubuntu1.debian.tar.xz
Checksums-Sha256:
 aa2390517c27b198774465244894da379dff727b19bfeefffb2a120a6659c502 907458 ceilometer_18.1.0.orig.tar.gz
 273f702fc31d337d827e7db9769ba9620a4b3eb01df3a54eb3e5b2197371abfe 15428 ceilometer_18.1.0-0ubuntu1.debian.tar.xz
Files:
 3a464f7220d788c09290de385da51d04 907458 ceilometer_18.1.0.orig.tar.gz
 b862db819e20166a7a749b7433940201 15428 ceilometer_18.1.0-0ubuntu1.debian.tar.xz

-----BEGIN PGP SIGNATURE-----

iQJPBAEBCAA5FiEENRbRpb8Ad+cUFOGXFbmz7g3N+AYFAmSfKfsbHGNvcmV5LmJy
eWFudEBjYW5vbmljYWwuY29tAAoJEBW5s+4NzfgGog8QAJUPeJFCKyv+DJWruXAa
QvCYz1hkBD6X9MR8+a/74M02Gbk1x5aF0WhLfk0Z2/34rD6ufkM98ZKv+6+RXb/U
8icSE7hdBiL70SdbS9c1u718+jfK3AXiUp9NIPni8DTS2abhWqwmA0Ag1GNDTEnW
KuDhL+18cNljzO+Bfehf5BrP1Xn4hEcO8cNBJ8i6PiEd96KzQYxzsxKt2ztqUv3v
/ThtkATwKTGUv0RgpJenKRWSKqeWoJZ3lO+FNeX39Rh/C8XU1qpY/iFWXXESx50Y
S8fnsFHp4QXv2/2QMgDYvDtog4x2Opbu5lFq8s1EFvrY+DKqp9fP8snbqpV4itfq
qi8tajy36VNibcZWVEhdob4mpJsoNelUgRIC7EYnjKcQxriNijr8ghP2A4SQrYPM
WaoNtKQkrdkPvPJSMUfCmeXINYaeA0ByI0DgFix7+TQtaFrhXZlSjiy9TiNYqTOO
3j9RbIp/LeJIB6GnHi8WKUhSw/7z7oSt1YtCF21qFw0KAL2CocP2CINILimvUtk0
HHOKXQr1wD0Xe77vckfOlTOe3v8/R3m/I1nsJrORg8S1Wo/5tYMwlnU8QXJkbuhr
GFezUxc9rUS2C4uln0SSnInXX0H3UfXnO/BecvOQVhvPi1emsdJhQd69c20vLPqZ
aMsf+/MId/2bOWs6dnW1GY6u
=/BaY
-----END PGP SIGNATURE-----
