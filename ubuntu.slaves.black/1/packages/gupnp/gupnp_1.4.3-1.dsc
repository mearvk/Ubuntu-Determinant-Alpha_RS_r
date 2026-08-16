-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: gupnp
Binary: libgupnp-1.2-1, gir1.2-gupnp-1.2, libgupnp-1.2-dev, libgupnp-doc
Architecture: any all
Version: 1.4.3-1
Maintainer: Debian GNOME Maintainers <pkg-gnome-maintainers@lists.alioth.debian.org>
Uploaders: Jeremy Bicha <jbicha@debian.org>, Laurent Bigonville <bigon@debian.org>
Homepage: https://wiki.gnome.org/Projects/GUPnP
Standards-Version: 4.6.0
Vcs-Browser: https://salsa.debian.org/gnome-team/gupnp
Vcs-Git: https://salsa.debian.org/gnome-team/gupnp.git
Build-Depends: debhelper-compat (= 13), ca-certificates <!nocheck>, dh-sequence-gir, dh-sequence-gnome, dh-sequence-python3, uuid-dev, libglib2.0-dev (>= 2.66), libsoup2.4-dev (>= 2.48.0), libxml2-dev, libgssdp-1.2-dev (>= 1.3.0), meson (>= 0.54.0), valac (>= 0.14.0), shared-mime-info, gtk-doc-tools, xsltproc, docbook-xml, docbook-xsl (>= 1.75.2+dfsg-5), libgirepository1.0-dev (>= 0.10.7-1~)
Build-Depends-Indep: libglib2.0-doc <!nodoc>, libgssdp-doc (>= 1.1) <!nodoc>, libsoup2.4-doc <!nodoc>
Package-List:
 gir1.2-gupnp-1.2 deb introspection optional arch=any
 libgupnp-1.2-1 deb libs optional arch=any
 libgupnp-1.2-dev deb libdevel optional arch=any
 libgupnp-doc deb doc optional arch=all profile=!nodoc
Checksums-Sha1:
 2c58d6a04f0355608d4674e2ec2d0b5e12e08a16 154812 gupnp_1.4.3.orig.tar.xz
 dbb3537c1f0ced8151493a4e2591a50d7e8bbb49 10576 gupnp_1.4.3-1.debian.tar.xz
Checksums-Sha256:
 14eda777934da2df743d072489933bd9811332b7b5bf41626b8032efb28b33ba 154812 gupnp_1.4.3.orig.tar.xz
 0a7deaa07c8e7428776ecbfdeb64cb73ccb78f6d0bc2af31ee2096e3a0c3ff42 10576 gupnp_1.4.3-1.debian.tar.xz
Files:
 ce880490a55b516aa78a5f994227dcfe 154812 gupnp_1.4.3.orig.tar.xz
 c6739dbfd73fecf37cc12b9da5ab83ac 10576 gupnp_1.4.3-1.debian.tar.xz

-----BEGIN PGP SIGNATURE-----

iQJFBAEBCgAvFiEE+uHltkZSvnmOJ4zCC8R9xk0TUwYFAmH37DcRHGFuZHJlYXNA
ZmF0YWwuc2UACgkQC8R9xk0TUwa7zg/9E3RuymMgwzeQ2qhiBEXFzMvHRWH9Wbn8
C6mODSRrIx8niIZjY7pxkGMZ0Tiyj+KpuaOS6Lxzn43c2z3+95tljc4IOjW5Fo1B
xUHX0lIHrAekwoY4A35ycBEI4X/wF0mvbSKN3HVAGEEoTgu6eav7tNTxD7ubGJaC
/HBU9cZYYYGAzoV8zSF0SFczlb8IgZZs7zkm1kvafZ5JyUo32VwXCSuml7/FiwbE
ffcvVpLdviXuemgkiC04RAsBJ2i4c+wxvMfIfUMAGwhEH3G4pmjkHmn5EWKCphBy
dPjtI6oQQFaW5jiRX/Z6gvTqUNoZzfXqA94qcY9LxrqdZGugJw9X4/2U8x3sGLqT
GhIe31wjeT3TEss1bbqc9+a8C4fxVA4WSBQWOy7wQfXNg2DaDImTB7m8SQwoVQjU
xwe9x2aLSIT4X1+1KaKIlnTCECnZ+qbdLB59tkUYsjfp9tH7DY4A7wvJtb3O/cSI
4vaGtPFzBgXb0GvqqGFjFIPIL9dYhV/I8WYA55bEXSlBYTkYyrFNtVM7y3qKxGht
gQWsu18UToe6HUftRaKOO0NAjfCAonKqBJZ7ZoiuofUj7btTAbTAujXZe5yrntNb
ftpZ/H4eKYCS6vtFL+zB6BwPi5lejKbITJAbkZvfwEqOpUlrbdNoPCLhm+3HEhiN
MFOL4zR1pUM=
=abPp
-----END PGP SIGNATURE-----
