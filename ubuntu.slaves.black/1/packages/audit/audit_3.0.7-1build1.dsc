-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

Format: 3.0 (quilt)
Source: audit
Binary: auditd, libauparse0, libauparse-dev, libaudit1, libaudit-common, libaudit-dev, python3-audit, golang-redhat-audit-dev, audispd-plugins
Architecture: linux-any all
Version: 1:3.0.7-1build1
Maintainer: Laurent Bigonville <bigon@debian.org>
Homepage: https://people.redhat.com/sgrubb/audit/
Standards-Version: 4.6.0
Vcs-Browser: https://salsa.debian.org/debian/audit
Vcs-Git: https://salsa.debian.org/debian/audit.git
Testsuite: autopkgtest
Testsuite-Triggers: build-essential, pkg-config, python3-all
Build-Depends: debhelper-compat (= 12), dh-python <!nopython>, dpkg-dev (>= 1.16.1~), libcap-ng-dev, libkrb5-dev, libldap2-dev <!pkg.audit.noldap>, libwrap0-dev, linux-libc-dev (>= 5.9~), python3-all-dev:any <!nopython>, libpython3-all-dev <!nopython>, swig
Build-Depends-Indep: golang-go
Package-List:
 audispd-plugins deb admin optional arch=linux-any profile=!pkg.audit.noldap
 auditd deb admin optional arch=linux-any
 golang-redhat-audit-dev deb devel optional arch=all
 libaudit-common deb libs optional arch=all
 libaudit-dev deb libdevel optional arch=linux-any
 libaudit1 deb libs optional arch=linux-any
 libauparse-dev deb libdevel optional arch=linux-any
 libauparse0 deb libs optional arch=linux-any
 python3-audit deb python optional arch=linux-any profile=!nopython
Checksums-Sha1:
 7c485e7c97eb25f7413eaf1dd3edb03ad0b2619f 1180226 audit_3.0.7.orig.tar.gz
 cef9a30ca6e8dc00a6215754f08b246301a5ebb1 17772 audit_3.0.7-1build1.debian.tar.xz
Checksums-Sha256:
 8b4c78632a9301a1c7f859b0e38fc0b9c260b8214d6b7c771bf28b3d73a62597 1180226 audit_3.0.7.orig.tar.gz
 003b4423c8a1414591f4f8e05eedb82b2ae9761f99c96032bf2eb800da70c3be 17772 audit_3.0.7-1build1.debian.tar.xz
Files:
 34fab69e80ea6668e9c72e73ec24fd88 1180226 audit_3.0.7.orig.tar.gz
 a359a77e0acc0b7112a569bcc33ea881 17772 audit_3.0.7-1build1.debian.tar.xz

-----BEGIN PGP SIGNATURE-----

iQJEBAEBCAAuFiEE1WVxuIqLuvFAv2PWvX6qYHePpvUFAmIzdSYQHGRva29AdWJ1
bnR1LmNvbQAKCRC9fqpgd4+m9dtKD/9z0V1Fj/m4wtumqnAg+fMt4ZHXeC5+7nUs
GT+XY5mAD1dht0RztvTF9KTvMREN4KTS+A0MqeLpFCa0QUh4kBVTVObIZ0xTtBh+
t3D1usBvdMR4NN308GgA9HOjODM/6c0CH64Ug5JX3Jr9lnhtt78vFJMlUogCE5OP
o1V4puc0/OPO+cf/v0SkIA0TCvb0VFOhzqOmZlKVzxPzyIfXZBOtmjAshKraClmA
fnwkJrSaorSkyj6tK2b7qej4/achz3yoRLv5tjEXAaWkZNu8/WtErmuvQD+sS9ev
HbbgrjxQ2RXm3VS4F1T/AVdZRoPLfJ830tUAuk4b/RC1k6Erz6rRcNJaV/QsszKh
jrkLDBbx/VHaT/4eSVK+cRttc9QMm8TGObmadI6Huzu2ht1ShATJXu9nYd7UTlvl
njDsxTjShYp5b7V5RXskxTWXHeSjOdzE7WiGTTGWFj2057aactpkPjL5UQa2xtY6
+viqF08L/Sbn+OWnDgYPQbnVmst5xwxdqV6DCbCV1Tf8aNhUzqy8nre2VkOpbaW/
mXnqS3DKnF30KgUWg8VKRpp+snAbHy5buYZzyK0VqVlxjdHN9gyXPcEcYtLL3s2h
Nmu3Nav0AzCIlT55cCL5r+Q9jOJWkWA0i4pWY18OolFI+gxUbOw+XdPYFaBO9yza
kQt6HRZRiQ==
=0uUi
-----END PGP SIGNATURE-----
