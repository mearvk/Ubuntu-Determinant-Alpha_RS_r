-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: json-glib
Binary: libjson-glib-1.0-0, libjson-glib-dev, libjson-glib-1.0-common, libjson-glib-doc, gir1.2-json-1.0, json-glib-tools
Architecture: any all
Version: 1.6.6-1build1
Maintainer: Ubuntu Developers <ubuntu-devel-discuss@lists.ubuntu.com>
Uploaders: Iain Lane <laney@debian.org>, Jeremy Bicha <jbicha@debian.org>, Laurent Bigonville <bigon@debian.org>, Michael Biebl <biebl@debian.org>
Homepage: https://wiki.gnome.org/Projects/JsonGlib
Standards-Version: 4.5.1
Vcs-Browser: https://salsa.debian.org/gnome-team/json-glib
Vcs-Git: https://salsa.debian.org/gnome-team/json-glib.git
Testsuite: autopkgtest
Testsuite-Triggers: build-essential, gnome-desktop-testing
Build-Depends: debhelper-compat (= 13), dh-sequence-gir, dh-sequence-gnome, gir1.2-glib-2.0 (>= 0.9.12), gtk-doc-tools (>= 1.20), libgirepository1.0-dev (>= 0.9.12), libglib2.0-dev (>= 2.54.0), meson (>= 0.55.3), python3-jinja2, python3-toml, python3-typogrify, xsltproc
Build-Depends-Indep: libglib2.0-doc <!nodoc>
Package-List:
 gir1.2-json-1.0 deb introspection optional arch=any
 json-glib-tools deb devel optional arch=any
 libjson-glib-1.0-0 deb libs optional arch=any
 libjson-glib-1.0-common deb libs optional arch=all
 libjson-glib-dev deb libdevel optional arch=any
 libjson-glib-doc deb doc optional arch=all profile=!nodoc
Checksums-Sha1:
 77fb8e093ef975f6088c2c8043521331b59aa3b1 1291536 json-glib_1.6.6.orig.tar.xz
 436ca7fb006435da0533e17e990f6911b9c2fb23 8876 json-glib_1.6.6-1build1.debian.tar.xz
Checksums-Sha256:
 3c48f0d52b4c39fbfa440bfc729d9972cf02036b63f9c64cf5e880c46d9fa2c4 1291536 json-glib_1.6.6.orig.tar.xz
 1a77a410312f5e7f25cbabbc0fb30e3004089c62e61864dd481deba18781f6a8 8876 json-glib_1.6.6-1build1.debian.tar.xz
Files:
 be56b204496c1cd786ae46bc07233e5b 1291536 json-glib_1.6.6.orig.tar.xz
 2b6066aa35e0c175fa253b879f80b086 8876 json-glib_1.6.6-1build1.debian.tar.xz
Original-Maintainer: Debian GNOME Maintainers <pkg-gnome-maintainers@lists.alioth.debian.org>

-----BEGIN PGP SIGNATURE-----

iQJHBAEBCgAxFiEET7WIqEwt3nmnTHeHb6RY3R2wP3EFAmI8XsITHGp1bGlhbmtA
dWJ1bnR1LmNvbQAKCRBvpFjdHbA/cdtKD/440Kc4PJ/fpl3oPySoA7wpmMHF9mGq
+hgx0iq/B8htid66VVlRvT20nzG8Mfpzo2HpOPyR/5RraFnbaDkMTmpPab8tqKft
Qvaux/w7GwfIlQFoM5ffZ8/X60oMpGaBgz1G8DVS7BOhg8hz41pkRY5538EAiqCw
MmfZljKXbIIHpybbv4/jRsp49QB98ZxplLD0xaTozGO33MJEp5/5tcwbVHNhjUGx
iu4RpahhPBBEG9Ga9tPWXcghM8YrD+CfR3SkVcIwcrc1wz8W7ShiC6F7sSRCue7g
swU6NI5SOJv906x/5GMgMS98ARJuPW/yxLrOX603Pdkd7E3o/ICf8JE0OrUaOFb3
E+rDAO8/61Z/g1ZlNGyOE0h56tOiIN9lxmGUNhNmVub36iti3HsJQpiIe9gLzCNF
92/GqSZeczaUEJGLLd+rd//7WGst/DCJgvMxT04/gaGuLV8eKyr7Y8nxHaaePHIC
E96BPYpoTHtv7+MnptFQi3uMjw+siE3AWpO7u4TwoclLlRQinhO5gY35EXYZkn8i
MGrFHusjrwTPVWwZ2+wEypyHNaAGOEwDKZ0djuftM0kQoYPk1+h6LKnZqG4gUyro
dpgX9Bz2JHc5OlQnPZjd84pe3xWTMptrmsOLzwZpzSe9WuwPoQdfewQRodP00abT
l8W9o4oTz/zMmw==
=kJ1w
-----END PGP SIGNATURE-----
