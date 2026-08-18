-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: sssd
Binary: sssd, sssd-common, sssd-ad, sssd-ad-common, sssd-dbus, sssd-ipa, sssd-kcm, sssd-krb5, sssd-krb5-common, sssd-ldap, sssd-proxy, sssd-tools, libnss-sss, libpam-sss, libipa-hbac0, libipa-hbac-dev, libsss-certmap0, libsss-certmap-dev, libsss-idmap0, libsss-idmap-dev, libsss-nss-idmap0, libsss-nss-idmap-dev, libsss-sudo, libsss-simpleifp0, libsss-simpleifp-dev, python3-libipa-hbac, python3-libsss-nss-idmap, python3-sss
Architecture: any
Version: 2.6.3-1ubuntu3.2
Maintainer: Ubuntu Developers <ubuntu-devel-discuss@lists.ubuntu.com>
Uploaders: Timo Aaltonen <tjaalton@debian.org>, Dominik George <natureshadow@debian.org>
Homepage: https://github.com/SSSD/sssd
Standards-Version: 4.4.0
Vcs-Browser: https://salsa.debian.org/sssd-team/sssd
Vcs-Git: https://salsa.debian.org/sssd-team/sssd.git
Testsuite: autopkgtest
Testsuite-Triggers: expect, krb5-admin-server, krb5-kdc, krb5-user, ldap-utils, lsb-release, openssl, slapd
Build-Depends: autopoint, check <!nocheck>, cifs-utils, debhelper-compat (= 12), dh-apparmor, dh-python, dnsutils, docbook-xml, docbook-xsl, dpkg-dev (>= 1.16.1~), faketime <!nocheck>, gnutls-bin <!nocheck>, krb5-config, ldap-utils, libaugeas-dev, libc-ares-dev, libcmocka-dev <!nocheck>, libcollection-dev, libdbus-1-dev, libdhash-dev, libgdm-dev [!s390x !kfreebsd-any !hurd-any !i386], libglib2.0-dev, libini-config-dev, libjansson-dev, libkeyutils-dev [linux-any], libkrb5-dev (>= 1.12), libldap2-dev, libldb-dev, libltdl-dev, libnfsidmap-dev, libnl-3-dev [linux-any], libnl-route-3-dev [linux-any], libnss-wrapper <!nocheck>, libp11-kit-dev, libpam-wrapper <!nocheck>, libpam0g-dev | libpam-dev, libpcre2-dev, libpopt-dev, libsasl2-dev, libselinux1-dev [linux-any], libsemanage-dev [linux-any], libsmbclient-dev, libssl-dev, libsystemd-dev [linux-any], libtalloc-dev, libtdb-dev, libtevent-dev, libuid-wrapper <!nocheck>, libunistring-dev, libxml2-utils, lsb-release, openssh-client <!nocheck>, openssl <!nocheck>, python3-dev, python3-setuptools, samba-dev (>= 2:4.1.13), softhsm2 <!nocheck>, systemd, systemtap-sdt-dev, uuid-dev, xml-core, xsltproc
Package-List:
 libipa-hbac-dev deb libdevel optional arch=any
 libipa-hbac0 deb libs optional arch=any
 libnss-sss deb utils optional arch=any
 libpam-sss deb utils optional arch=any
 libsss-certmap-dev deb libdevel optional arch=any
 libsss-certmap0 deb libs optional arch=any
 libsss-idmap-dev deb libdevel optional arch=any
 libsss-idmap0 deb libs optional arch=any
 libsss-nss-idmap-dev deb libdevel optional arch=any
 libsss-nss-idmap0 deb libs optional arch=any
 libsss-simpleifp-dev deb libdevel optional arch=any
 libsss-simpleifp0 deb libs optional arch=any
 libsss-sudo deb libs optional arch=any
 python3-libipa-hbac deb python optional arch=any
 python3-libsss-nss-idmap deb python optional arch=any
 python3-sss deb python optional arch=any
 sssd deb metapackages optional arch=any
 sssd-ad deb utils optional arch=any
 sssd-ad-common deb utils optional arch=any
 sssd-common deb utils optional arch=any
 sssd-dbus deb utils optional arch=any
 sssd-ipa deb utils optional arch=any
 sssd-kcm deb utils optional arch=any
 sssd-krb5 deb utils optional arch=any
 sssd-krb5-common deb utils optional arch=any
 sssd-ldap deb utils optional arch=any
 sssd-proxy deb utils optional arch=any
 sssd-tools deb utils optional arch=amd64,arm64,armhf,ppc64el,riscv64,s390x
Checksums-Sha1:
 f226c2d9259a82d87ba67d85288d33c5852a9436 7510020 sssd_2.6.3.orig.tar.gz
 93a6a87a1aaff33d5c13944cfd027a1fbff8912b 488 sssd_2.6.3.orig.tar.gz.asc
 34da55af1981a49114f8cf136facb763793e97bc 42892 sssd_2.6.3-1ubuntu3.2.debian.tar.xz
Checksums-Sha256:
 3dd820b3da90cddbcb1041ef3c16102d78aad9d8c9ab25630e0c14a2f8992b18 7510020 sssd_2.6.3.orig.tar.gz
 4ea58e7d1853d6928d69c21dabda30a96346a79902be3325d4a458185a9a4f20 488 sssd_2.6.3.orig.tar.gz.asc
 e46f28b5d97fe11e14cbf992cc9d6efde595695112aad58ae79e230c57b223ee 42892 sssd_2.6.3-1ubuntu3.2.debian.tar.xz
Files:
 068a9258039dd72a793e9ff7d551e451 7510020 sssd_2.6.3.orig.tar.gz
 91bc8fc377e3b55b45bd1f4a2e1d553b 488 sssd_2.6.3.orig.tar.gz.asc
 5a5b215a47104ce09b134023422c53a6 42892 sssd_2.6.3-1ubuntu3.2.debian.tar.xz
Original-Maintainer: Debian SSSD Team <pkg-sssd-devel@alioth-lists.debian.net>

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE6S/Qs2sU8fTY4OsvEG2hyMPLvxQFAmM96tkACgkQEG2hyMPL
vxSgkg/+PKlsjVn7v7gUBJvb0bYI0cOKQWHc2VHwmINVsXwRuvTInqKmZWQrMzxz
N59udtX1ET2GlWX9ytn6/9BBi7POTOt+thoOlxM+u85gITyeZG7yRMCZgrpVin/h
lTcyQgsVVFDo+9XBBEz8tZjTpq3ihi/89FHsc6LMZemuTEk+fW4hf6Q6LbJNbi5V
FDnBdW2zvbjqwX+/qTkLw3QAe9hTmanadHC905C3mCiiQf+sX82H1OfNWrnO7ItA
G9FAX4WM3UPeM3oFEKPzKnWN1Xdgjv4noQ2HHwwoVkpgPr1HAKFd4GTSR5i9kv+0
yYRz6U1iRjnQJlX8MrVMNTdTbPm0PEvf6bksG81TNxOCcMBSG7871f+K+qpxDilM
7eYk3NDS8W5kATezC1jixCKqiiC3kEQh1TQiv+HmyuoFQV2TcYSC3JFuQeOadvVz
gKc3ZLXxLNXweDAay+ftpU0PAXDvKJt4DhOr320KCwz0UrjFwWISBxICJEUyDrZs
OjLR2GWHdR35Fb5r+HlO3mVw7cU4hMekxQbqbYUVtQIz3Q6KTPD2cW+76PZb0f6U
no00OEhCPAw1W2SKv5ybo7XyB3KDNYq+2ll0iKUzG6fQhHxyt3qwmdg2c8y+7/Hq
ZkwQfC9JhB8OFenFZkNhIRYlfzjcrZ44YH2XVjcnZK4i0wNzJvI=
=6tQd
-----END PGP SIGNATURE-----
