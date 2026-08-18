-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: openldap
Binary: slapd, slapd-contrib, slapd-smbk5pwd, ldap-utils, libldap-2.5-0, libldap-common, libldap-dev, libldap2-dev, slapi-dev
Architecture: any all
Version: 2.5.15+dfsg-0ubuntu0.22.04.1
Maintainer: Ubuntu Developers <ubuntu-devel-discuss@lists.ubuntu.com>
Uploaders: Steve Langasek <vorlon@debian.org>, Torsten Landschoff <torsten@debian.org>, Ryan Tandy <ryan@nardis.ca>
Homepage: https://www.openldap.org/
Standards-Version: 4.6.0
Vcs-Browser: https://salsa.debian.org/openldap-team/openldap
Vcs-Git: https://salsa.debian.org/openldap-team/openldap.git
Testsuite: autopkgtest
Testsuite-Triggers: heimdal-kdc, openssl, samba, schema2ldif
Build-Depends: debhelper-compat (= 12), dh-apparmor, dpkg-dev (>= 1.17.14), groff-base, heimdal-multidev (>= 7.4.0.dfsg.1-1~) <!pkg.openldap.noslapd>, libargon2-dev <!pkg.openldap.noslapd>, libgnutls28-dev, libltdl-dev <!pkg.openldap.noslapd>, libperl-dev (>= 5.8.0) <!pkg.openldap.noslapd>, libsasl2-dev, libwrap0-dev <!pkg.openldap.noslapd>, nettle-dev <!pkg.openldap.noslapd>, openssl <!nocheck>, perl:any, pkg-config (>= 0.29), po-debconf, unixodbc-dev <!pkg.openldap.noslapd>
Build-Conflicts: autoconf2.13, bind-dev, libbind-dev
Package-List:
 ldap-utils deb net optional arch=any
 libldap-2.5-0 deb libs optional arch=any
 libldap-common deb libs optional arch=all
 libldap-dev deb libdevel optional arch=any
 libldap2-dev deb oldlibs optional arch=all
 slapd deb net optional arch=any profile=!pkg.openldap.noslapd
 slapd-contrib deb net optional arch=any profile=!pkg.openldap.noslapd
 slapd-smbk5pwd deb oldlibs optional arch=all profile=!pkg.openldap.noslapd
 slapi-dev deb libdevel optional arch=any profile=!pkg.openldap.noslapd
Checksums-Sha1:
 94812c772217a8527f7367978ef24cef5052a4da 5616689 openldap_2.5.15+dfsg.orig.tar.gz
 a2e40256301fe1c7df2547696ec02400cdd0a4bd 171804 openldap_2.5.15+dfsg-0ubuntu0.22.04.1.debian.tar.xz
Checksums-Sha256:
 5323a88baa9d2bddc64391303cf93f02f3a3e32e04c38ee6b11446d9b86aa167 5616689 openldap_2.5.15+dfsg.orig.tar.gz
 ed20dce0333b1a7899b05bfe4470f27448eea74274027900196e708390de2146 171804 openldap_2.5.15+dfsg-0ubuntu0.22.04.1.debian.tar.xz
Files:
 0d134582f0b0552fc5f2cbbad90b35e8 5616689 openldap_2.5.15+dfsg.orig.tar.gz
 cb7645ede10eda190edb4e4a195f4bf2 171804 openldap_2.5.15+dfsg-0ubuntu0.22.04.1.debian.tar.xz
Original-Maintainer: Debian OpenLDAP Maintainers <pkg-openldap-devel@lists.alioth.debian.org>

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE6S/Qs2sU8fTY4OsvEG2hyMPLvxQFAmSvRcgACgkQEG2hyMPL
vxTXZg/9HPWje90INpLpdOfze2gcBaJ8n4ebqEb13sg9s70bR+MBhAl8H/8DTZ1T
18mQ9K8m2jeiKI8VfRF1NFfAe9rO+aDX/048RvTdFk2O3r7ByTjX9QOxjdxsW4r2
pFwxHzbHdaitweuD9TR9gyVKp+xQ7t4GWVSqN0xcweOtxF5cf5dRsB4j7gW86pUO
IIfmniCCWlAynlhWom86tKw3seCG59E/4QY96wXev3UZNLPylMts+Uw83W9I0zq1
H4XkSr5W4DGnQkO2vvXUCCMELPF2qxY+fcgjiyeEHnFtuy5y3qwPOoDzTe/h0pD1
7wNm0n7wEKlNLVIvPo3mFKas+/b60HeBVU2siJiEdnHSFLz7UIlQyMHCUQ82xY8o
2rJ0sxWd1xMm8GQpqkDgkS/HNtIr0gW1t2HJW+4hO29cef56rhpbVDSF6BoO5EMp
Dz4v3rxNo86NqhDwDIETRTHxpiMsFCMIqEGCHGQ/i4KV5xVOV2O1YMeeEyfXW/Cz
FSpNi30NcPH7Gc572/QWu/Z9XduFCPxmvx1KIkFOCQNeXzsH7J9RzMQ1U4j4pUVf
0BgJiwh+U7qLHQUvIDHcDbTR9INSjcP9jt/glWqef4fecEMS1IlqJMU5Ut/Yi8PW
hxAyNoNc1gHumqWLHFjlGb6k2j0BlAFk/g3xA30yj0H2cBYrkfE=
=msc1
-----END PGP SIGNATURE-----
