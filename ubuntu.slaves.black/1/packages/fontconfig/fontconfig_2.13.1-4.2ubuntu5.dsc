-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: fontconfig
Binary: fontconfig, fontconfig-config, fontconfig-udeb, libfontconfig-dev, libfontconfig1-dev, libfontconfig1, libfontconfig-doc
Architecture: any all
Version: 2.13.1-4.2ubuntu5
Maintainer: Ubuntu Developers <ubuntu-devel-discuss@lists.ubuntu.com>
Uploaders: Keith Packard <keithp@debian.org>, Josselin Mouette <joss@debian.org>, Emilio Pozuelo Monfort <pochu@debian.org>,
Homepage: https://www.freedesktop.org/wiki/Software/fontconfig/
Standards-Version: 4.2.1
Vcs-Browser: https://salsa.debian.org/freedesktop-team/fontconfig
Vcs-Git: https://salsa.debian.org/freedesktop-team/fontconfig.git
Build-Depends: debhelper-compat (= 11), libfreetype6-dev (>= 2.8.1), libexpat1-dev, uuid-dev, pkg-config, gperf, po-debconf
Build-Depends-Indep: docbook <!nodoc>, docbook-utils <!nodoc>, texlive-formats-extra <!nodoc>
Package-List:
 fontconfig deb fonts optional arch=any
 fontconfig-config deb fonts optional arch=all
 fontconfig-udeb udeb debian-installer optional arch=any
 libfontconfig-dev deb libdevel optional arch=any
 libfontconfig-doc deb doc optional arch=all profile=!nodoc
 libfontconfig1 deb libs optional arch=any
 libfontconfig1-dev deb oldlibs optional arch=any
Checksums-Sha1:
 75612356ef4f801735b49baf987f8942b4a7a5e1 1723639 fontconfig_2.13.1.orig.tar.bz2
 71e6665135daf11593edc4a30fb0a6dad3bff0fb 28084 fontconfig_2.13.1-4.2ubuntu5.debian.tar.xz
Checksums-Sha256:
 f655dd2a986d7aa97e052261b36aa67b0a64989496361eca8d604e6414006741 1723639 fontconfig_2.13.1.orig.tar.bz2
 15ade6954950577f355a55abcebe59f58e13df3dc616419af34ca0c19bbae0bd 28084 fontconfig_2.13.1-4.2ubuntu5.debian.tar.xz
Files:
 36cdea1058ef13cbbfdabe6cb019dc1c 1723639 fontconfig_2.13.1.orig.tar.bz2
 c044d124c0cdeb0101011182e08c928e 28084 fontconfig_2.13.1-4.2ubuntu5.debian.tar.xz
Original-Maintainer: Debian freedesktop.org maintainers <pkg-freedesktop-maintainers@lists.alioth.debian.org>

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEqx+XcX7ftBm4bj5/AhnKGdA0MwwFAmI7JicACgkQAhnKGdA0
MwyN0gf/Ww8gLNrGarhm7chhEhj5OSM4pA0qhsamOEqsRpXjF9pcv1CKxIXx/YUA
722U7d1G+7h1XHElDe8CpFE8oH+4zamTheme3d5DqyVNOHFcNpSHvASks3TRPMdH
UZs14+EwDkyeUxkU0ek+MYImftT3RpEc+COSvtQplbJMrS8H5qcw3WgrTrtXHyL/
J+p7SF/I3lBt89X+KEpx/V3mlCreKQOk7PN79r1oe01pNxKDBsjE0Bn6ZS4C6OWG
kmvIfPIUuTXsdoBJwMIGhUiI7BLDaZx5/5FSlCvspyeebkgfQFQT6AJu7wOlY2z8
OgeBDz9rEMXzo/ArLxSv/G3wQlKDQQ==
=Nlhp
-----END PGP SIGNATURE-----
