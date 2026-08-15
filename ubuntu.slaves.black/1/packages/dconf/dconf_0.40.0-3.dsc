-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: dconf
Binary: libdconf1, libdconf-dev, libdconf-doc, dconf-cli, dconf-gsettings-backend, dconf-service
Architecture: any all
Version: 0.40.0-3
Maintainer: Debian GNOME Maintainers <pkg-gnome-maintainers@lists.alioth.debian.org>
Uploaders: Iain Lane <laney@debian.org>, Jeremy Bicha <jbicha@debian.org>, Laurent Bigonville <bigon@debian.org>, Sebastien Bacher <seb128@debian.org>
Homepage: https://wiki.gnome.org/Projects/dconf
Standards-Version: 4.6.0
Vcs-Browser: https://salsa.debian.org/gnome-team/dconf
Vcs-Git: https://salsa.debian.org/gnome-team/dconf.git
Testsuite: autopkgtest
Testsuite-Triggers: build-essential, pkg-config
Build-Depends: bash-completion, dbus <!nocheck>, debhelper-compat (= 13), dh-sequence-gnome, docbook-xsl, libdbus-1-dev, libglib2.0-dev (>= 2.44.0), meson (>= 0.47.0), valac (>= 0.18.0), xsltproc
Build-Depends-Indep: gtk-doc-tools (>= 1.15) <!nodoc>, libglib2.0-doc <!nodoc>
Package-List:
 dconf-cli deb utils optional arch=any
 dconf-gsettings-backend deb libs optional arch=any
 dconf-service deb libs optional arch=any
 libdconf-dev deb libdevel optional arch=any
 libdconf-doc deb doc optional arch=all profile=!nodoc
 libdconf1 deb libs optional arch=any
Checksums-Sha1:
 c8e12b98b2b10ccae4ee13395a39b3e913f58ab6 117764 dconf_0.40.0.orig.tar.xz
 d7cbb905ef8613b319376a8ccb42c7c424926244 11056 dconf_0.40.0-3.debian.tar.xz
Checksums-Sha256:
 cf7f22a4c9200421d8d3325c5c1b8b93a36843650c9f95d6451e20f0bcb24533 117764 dconf_0.40.0.orig.tar.xz
 4c32ddffdef332282cf69669551c157d4e01487100cd2e9e354f4bc204d9ccd6 11056 dconf_0.40.0-3.debian.tar.xz
Files:
 ac8db20b0d6b996d4bbbeb96463d01f0 117764 dconf_0.40.0.orig.tar.xz
 22dfeb52d8b9893467bce69b4cb7f46f 11056 dconf_0.40.0-3.debian.tar.xz

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEETQvhLw5HdtiqzpaW5mx3Wuv+bH0FAmH686sACgkQ5mx3Wuv+
bH3N/g/9F6rT80SSVqS4DjGhvIqVAVxQNYrtYpTUSKi8M4rzjCSKFL4gQQ8bBUZM
X1imvESvADsjqAVNn23nmeornNgoaFQ1FlI/z397cyS4sjRySsT4bRuuU85fbyvD
EEVIO1ACYeNgtX2g7h+/rApZGZDRHwHPDKxmjTysmfBRvNWeRGquWasjrVHM873M
DaXVagyqRWS7Ycqk2Y8RTzE51NRQQvs7f4LLUzpdLk9r+1x1IO2Mrwj8ozNNYlIm
BobVPFSc/S84fsAVtILRJxb7wM/8FthXsIHJZsxVIqtmF6p+hT/Taugoz9dhL1dy
O6vDmNOvPFuO/0r257sS9KuJSmJF3ADjdvGyRmzSVcNmuseJsUO2C0ws7/fvV9DL
WTWBTPSYyK04UwmgizUE4t15CHX2o8aWwlrVRyQ+VQfVov9+/I5b250CC0uAudYX
Xn3He+CtQJ09v8ybvb+CZJShTcWTaY3HIr4KujeAiKkK4ek/qCfzs5SkQr5JA89f
W7q6pYGgzxuCQiuJjFDy30Uq0IKODJtE+bu5TKYKmt177i7U2RHnloc64nfri7fX
dZCChnTj1XbRsTf5gXuwLNNts40W2YJnL0nJZxlEASq6BxVlgoWo+LTTRtZOrDJz
L/157I6idV38VAbY8B9VXGaAECNUgUrP5lI8+vtj4XnqNAdwULs=
=CJ2k
-----END PGP SIGNATURE-----
