-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: libffado
Binary: libffado-dev, libffado2, ffado-tools, ffado-dbus-server, ffado-mixer-qt4
Architecture: linux-any all
Version: 2.4.5-1
Maintainer: Debian Multimedia Maintainers <debian-multimedia@lists.debian.org>
Uploaders:  Adrian Knoth <adi@drcomp.erfurt.thur.de>, Free Ekanayaka <freee@debian.org>, Sebastian Ramacher <sramacher@debian.org>,
Homepage: http://www.ffado.org/
Standards-Version: 4.6.0
Vcs-Browser: https://salsa.debian.org/multimedia-team/ffado
Vcs-Git: https://salsa.debian.org/multimedia-team/ffado.git
Build-Depends: dbus <!nocheck>, debhelper-compat (= 13), dh-sequence-python3, libconfig++-dev, libdbus-1-dev, libdbus-c++-bin, libdbus-c++-dev, libiec61883-dev, libraw1394-dev, libxml++2.6-dev, libxml2-dev, pkg-config, python3, scons
Build-Depends-Indep: pyqt5-dev-tools, python3-dbus, python3-dbus.mainloop.pyqt5, python3-pyqt5
Package-List:
 ffado-dbus-server deb sound optional arch=linux-any
 ffado-mixer-qt4 deb sound optional arch=all
 ffado-tools deb sound optional arch=linux-any
 libffado-dev deb libdevel optional arch=linux-any
 libffado2 deb libs optional arch=linux-any
Checksums-Sha1:
 59dc80542e9b596f62f451e8e246c134d1febd28 1229890 libffado_2.4.5.orig.tar.gz
 a3309b380179bd0862254cebb6fa8fd8453b0d45 12948 libffado_2.4.5-1.debian.tar.xz
Checksums-Sha256:
 59599bdde897dbc9533b0d2a282099193725030c3ab100737a1dbe673166af96 1229890 libffado_2.4.5.orig.tar.gz
 779db536dbf92fec3bc27f3adf1dd8aa3c69bbd8d1219b84730cf472723ca3f1 12948 libffado_2.4.5-1.debian.tar.xz
Files:
 474fe28a1735eeb80c9a5f5e5fc24233 1229890 libffado_2.4.5.orig.tar.gz
 1ec6053b4ef189f2eb8ed44cd1ec0691 12948 libffado_2.4.5-1.debian.tar.xz

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE94y6B4F7sUmhHTOQafL8UW6nGZMFAmIaOj4ACgkQafL8UW6n
GZOYeA//eZYPmt1Yw1Nw6dH5KvSnvPJNzeFlobSUmf94Ovm0zH/yck/57/9xA1SP
JTDOD6O50GJb2LboYS5ABSg9X8LrrIbRHbPEReGrTUKKE64SXZQViGlmOSmqqW5B
iJWFd8S2G3qCTNPWPMMcQyfTwpCg/kY0AHvjpmrYfnlhJ939kjUmmKV6v9yH+4cC
Tx/wVQatRHyC7LyB7LZ8W+oEECUuVlXH6lh0ZzZAjYDaq7APDvxHDqAUoW53oASz
66U/HAu48PAw9tMb1iYclHCiaFN3qrT096iiHrm1bwVIhhthtGPXpKE21Qmix7Q+
iQ7X1hKfaJ2kYLuUwHmTh6j9hW/9KjGZstTr0e3lTogT5WDTx9I1za4TSgq793RO
z4mjJxqwLIsjx7hCGWL4ntO4XoMKZgW7WmN2kKdBlX00xkH5lE3lW1+YJVnMaDEd
6KQfXqndTiFmRxuhoJkKHl3Z7YobGW9KNJ0/cedgiJkH+1hPLXrib3IFOpHg1AaO
yUI71mpEa0wIAow0l3EXD3epWjFeTQErJmDTmO2Aj38JEop+HtxmVvGf03O9aXcU
vIAzylcOd8LnzvS/k0lau+X5TK3AXakKAiUAFUAJb0bqcRScjsN2kOWh+hADoyII
EuuFh0ozetQR/YMOs2mBmvTpg79Qkaxc74VjqXB+rl0vFv2kZbE=
=m551
-----END PGP SIGNATURE-----
