-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: gcr
Binary: gcr, libgck-1-dev, libgck-1-doc, libgck-1-0, gir1.2-gck-1, libgcr-3-dev, libgcr-3-doc, libgcr-base-3-1, libgcr-ui-3-1, gir1.2-gcr-3
Architecture: any all
Version: 3.40.0-4
Maintainer: Debian GNOME Maintainers <pkg-gnome-maintainers@lists.alioth.debian.org>
Uploaders: Emilio Pozuelo Monfort <pochu@debian.org>, Iain Lane <laney@debian.org>, Jeremy Bicha <jbicha@ubuntu.com>, Laurent Bigonville <bigon@debian.org>, Michael Biebl <biebl@debian.org>, Sjoerd Simons <sjoerd@debian.org>
Homepage: https://wiki.gnome.org/Projects/GnomeKeyring
Standards-Version: 4.5.1
Vcs-Browser: https://salsa.debian.org/gnome-team/gcr
Vcs-Git: https://salsa.debian.org/gnome-team/gcr.git
Testsuite: autopkgtest
Testsuite-Triggers: build-essential, dbus, pkg-config, xauth, xvfb
Build-Depends: dbus <!nocheck>, debhelper-compat (= 13), dh-sequence-gir, dh-sequence-gnome, docbook-xml, gnupg, gtk-doc-tools (>= 1.9), libdbus-1-dev (>= 1.0), libgcrypt20-dev (>= 1.4.5), libgirepository1.0-dev (>= 1.34), libglib2.0-dev (>= 2.44.0), libgtk-3-dev (>= 3.22.0), libp11-kit-dev (>= 0.19.0), libtasn1-6-dev, libtasn1-bin, meson (>= 0.49), valac, xsltproc
Build-Depends-Indep: libglib2.0-doc <!nodoc>, libgtk-3-doc <!nodoc>
Package-List:
 gcr deb gnome optional arch=any
 gir1.2-gck-1 deb introspection optional arch=any
 gir1.2-gcr-3 deb introspection optional arch=any
 libgck-1-0 deb libs optional arch=any
 libgck-1-dev deb libdevel optional arch=any
 libgck-1-doc deb doc optional arch=all profile=!nodoc
 libgcr-3-dev deb libdevel optional arch=any
 libgcr-3-doc deb doc optional arch=all profile=!nodoc
 libgcr-base-3-1 deb libs optional arch=any
 libgcr-ui-3-1 deb libs optional arch=any
Checksums-Sha1:
 d1267ce6f7821c8bf0d2a7df06d458d0df3769ce 1011044 gcr_3.40.0.orig.tar.xz
 5ce57aabfdcd184d7cd5bb40970815ef7da9d3b6 23872 gcr_3.40.0-4.debian.tar.xz
Checksums-Sha256:
 b9d3645a5fd953a54285cc64d4fc046736463dbd4dcc25caf5c7b59bed3027f5 1011044 gcr_3.40.0.orig.tar.xz
 f35133457e8af592c87b61c48027a65d7d6b8e745cc2e766c366879ced1d54f8 23872 gcr_3.40.0-4.debian.tar.xz
Files:
 fa34048b5562f80587a71d11931a7c29 1011044 gcr_3.40.0.orig.tar.xz
 a634ba5acb42e548c2023dd6b403a74e 23872 gcr_3.40.0-4.debian.tar.xz

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEETQvhLw5HdtiqzpaW5mx3Wuv+bH0FAmI7gKoACgkQ5mx3Wuv+
bH3f9xAAiP6ybpkqBryvxSBHzbB7MyUVyJwII9j0VpNyC8c1eXMsp34kxwEfHtLp
/Xk8N0ShspDzc803qRvBbrQ79RWVB541rp6Di/oTMFrrEHNCV2qooONP6/37CeSt
+grmdIz11i70Mx3bZumhOPDqdAw89N3OMU78uU0KWF53FRGMcviVUrNV3RoMnuXJ
iYJeWFtBfTA2KSlZqmmjSnVuQwLyeaE91LhZ/Riu2RNuL23waDf6Bksipi2YODtA
kMguQbAJpLIa/uWjhGh5VaYMQMtYpSTjI1Ss1EKpf4hqqrGlRpS03xFzwbrE5zxd
Plyi0KPnGnczB0CUBnelaxi52bOrgp7f4YuGLuKoE5ExiH3mPnJWqNnhJHvEzW5W
wSD+vKiLyP2QcPHDnVVbfnT14x84CYftgU9DSMfEC8QHDPZmXsdUH0GJXY2BUv6F
B9Ps21Gzp6NTHTO5kdjwAecTjgSfkiVSbsZpK8Plu2QEIjQ+Lb8ZZmfhff2/HjL8
/E71wODnAo3bKdk0d4qphWVjL/8jiRyW1SI+24KCOmFLjMCMY2HubDUv/iPuUsLo
zMLf/RVmFWWJd5i6BilTbHz0snQ4uWwVhXijw6slDf02qZ9TRioQ34vN7RkHv0Ew
7Wdkw2tbmUk+ubh1/LA2zGbSa+1dmXny2zyyOVtflVfKme70eb4=
=GAtz
-----END PGP SIGNATURE-----
