-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: gspell
Binary: libgspell-1-2, libgspell-1-common, libgspell-1-dev, gir1.2-gspell-1, libgspell-1-doc, gspell-1-tests
Architecture: any all
Version: 1.9.1-4
Maintainer: Debian GNOME Maintainers <pkg-gnome-maintainers@lists.alioth.debian.org>
Uploaders: Tanguy Ortolo <tanguy+debian@ortolo.eu>, Jeremy Bicha <jbicha@debian.org>, Laurent Bigonville <bigon@debian.org>, Michael Biebl <biebl@debian.org>
Homepage: https://wiki.gnome.org/Projects/gspell
Standards-Version: 4.6.0
Vcs-Browser: https://salsa.debian.org/gnome-team/gspell
Vcs-Git: https://salsa.debian.org/gnome-team/gspell.git
Testsuite: autopkgtest
Testsuite-Triggers: at-spi2-core, build-essential, dbus, gnome-desktop-testing, pkg-config, xauth, xvfb
Build-Depends: at-spi2-core <!nocheck>, dbus <!nocheck>, debhelper-compat (= 13), dh-sequence-gir, dh-sequence-gnome, gtk-doc-tools (>= 1.24-2), libenchant-2-dev (>= 2.1.3), libgirepository1.0-dev, libglib2.0-dev (>= 2.44), libgtk-3-dev (>= 3.20), libicu-dev, valac, xauth <!nocheck>, xvfb <!nocheck>
Build-Depends-Indep: libglib2.0-doc <!nodoc>, libgtk-3-doc <!nodoc>, libgtksourceview-4-doc <!nodoc>, libpango1.0-doc <!nodoc>
Package-List:
 gir1.2-gspell-1 deb introspection optional arch=any
 gspell-1-tests deb misc optional arch=any
 libgspell-1-2 deb libs optional arch=any
 libgspell-1-common deb libs optional arch=all
 libgspell-1-dev deb libdevel optional arch=any
 libgspell-1-doc deb doc optional arch=all profile=!nodoc
Checksums-Sha1:
 671c40ce4ca020ec166481341cff666348ff0b52 424252 gspell_1.9.1.orig.tar.xz
 2ca3e94ecec7153ee89e46b4dda415accdb82a99 8824 gspell_1.9.1-4.debian.tar.xz
Checksums-Sha256:
 dcbb769dfdde8e3c0a8ed3102ce7e661abbf7ddf85df08b29915e92cd723abdd 424252 gspell_1.9.1.orig.tar.xz
 4044494bf74ce7de843ae63f2697c44f517bd02f03dff892748941becfd73064 8824 gspell_1.9.1-4.debian.tar.xz
Files:
 a265a5500dca6cd72100213c3884f04d 424252 gspell_1.9.1.orig.tar.xz
 74cdf2defd1a08501e6b7a4ba2617b40 8824 gspell_1.9.1-4.debian.tar.xz

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEETQvhLw5HdtiqzpaW5mx3Wuv+bH0FAmIEXs4ACgkQ5mx3Wuv+
bH3/TQ//ThBBlyfnOI441dM4ASsUtwYDGr/EuN/nfOgaPmmlIbzhfyFFcNWGX0IX
V0TJfb0/5QHWfDFRvRFaaC2QINY14OAJTeIP+fq0kWu5NtzPLgxvuJO0D3gYE19n
qNhEFIKSnMLKPFXRmXSfHgVOerLOC8d8lISWAosZBOAey+q+md+P36V2ukrGWxpc
+A3CjpEcfjBdXwYoga+KUupftGM8FWS7kJxPn9iWiwI0z5InYGcqZ3bvq7hWlUAc
xTwcnG31p0/gDrSK2cCP0oPfNhmfEkwZxwNcnrqz4PmojYMnWsDBO2avhiJb1XmG
y9aIGJmA7lAGnD2xtg4yXj11jkkzGJ29KpNOr3JNr8yCmnxP8deEhGOdZGKosyAt
XUwHbmZxXsDLnY5mgHmCGOXuiJDh4KB2xZu9i8qOwG5aUoYbPnCmRYqNkxCpWfxH
bLOPd5Nd9MV4AWOjKiPksyb8meaM3UlFRA4zM3E2MgAefxXlt5ibnW0B059j7tEg
Frh42R774R2x0hC+p/phgJDD6mVi9M6TjbpLx+sabYw7rDQYZlEV6f0A4Mlk6cgC
rKmONBSsNze/DMjseG0w1NGtXjk8yxq8IaHGgMTdhCtn9cNK9iiL65z2ViEJUQ4g
B10Y+YaAxiYoGZ0fBCqnoWNsKoxe4WmdWtr9u9xWgAvUwHIn9vM=
=Liq+
-----END PGP SIGNATURE-----
