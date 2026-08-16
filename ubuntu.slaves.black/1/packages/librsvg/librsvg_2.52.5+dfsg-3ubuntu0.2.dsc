-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: librsvg
Binary: librsvg2-dev, librsvg2-2, librsvg2-common, librsvg2-doc, librsvg2-bin, gir1.2-rsvg-2.0
Architecture: any all
Version: 2.52.5+dfsg-3ubuntu0.2
Maintainer: Ubuntu Developers <ubuntu-devel-discuss@lists.ubuntu.com>
Uploaders: Emilio Pozuelo Monfort <pochu@debian.org>, Iain Lane <laney@debian.org>, Laurent Bigonville <bigon@debian.org>, Michael Biebl <biebl@debian.org>, Tim Lunn <tim@feathertop.org>
Homepage: https://wiki.gnome.org/Projects/LibRsvg
Standards-Version: 4.6.0
Vcs-Browser: https://salsa.debian.org/gnome-team/librsvg
Vcs-Git: https://salsa.debian.org/gnome-team/librsvg.git
Testsuite: autopkgtest
Testsuite-Triggers: build-essential, file
Build-Depends: debhelper-compat (= 13), cargo, dh-sequence-gir, dh-sequence-gnome, gtk-doc-tools (>= 1.13), jq, libcairo2-dev (>= 1.2.0), libfreetype6-dev (>= 2.8.0), libgdk-pixbuf-2.0-dev (>= 2.23.5-2) | libgdk-pixbuf2.0-dev (>= 2.23.5-2), libgirepository1.0-dev (>= 0.10.8), libglib2.0-dev (>= 2.50.0), libharfbuzz-dev, libpango1.0-dev (>= 1.44.0), libxml2-dev (>= 2.9.0), locales, rustc (>= 1.52), valac (>= 0.17.5)
Build-Depends-Indep: libcairo2-doc (>= 1.15.4) <!nodoc>, libgdk-pixbuf2.0-doc (>= 2.23.5-2) <!nodoc>, libglib2.0-doc (>= 2.52.0) <!nodoc>
Package-List:
 gir1.2-rsvg-2.0 deb introspection optional arch=any
 librsvg2-2 deb libs optional arch=any
 librsvg2-bin deb graphics optional arch=any
 librsvg2-common deb libs optional arch=any
 librsvg2-dev deb libdevel optional arch=any
 librsvg2-doc deb doc optional arch=all profile=!nodoc
Checksums-Sha1:
 81bcad330f1a7865182486f6ba7e4ae86e6d7333 20813024 librsvg_2.52.5+dfsg.orig.tar.xz
 80735c289e340be6ce7be7eec071532cce5e79f9 37684 librsvg_2.52.5+dfsg-3ubuntu0.2.debian.tar.xz
Checksums-Sha256:
 66d01957678559bec1c23404aa5eab90d68f034ba0826a2bd48dd5fd106d86a4 20813024 librsvg_2.52.5+dfsg.orig.tar.xz
 b997f1bb479d2bb45e19fefe1c60b2da0629dac21797040206fe9e32dc5077b6 37684 librsvg_2.52.5+dfsg-3ubuntu0.2.debian.tar.xz
Files:
 adae2e33b7b45e009d28e2405d99fd8a 20813024 librsvg_2.52.5+dfsg.orig.tar.xz
 8d97a7a1989e42804ed94fbf2d4be327 37684 librsvg_2.52.5+dfsg-3ubuntu0.2.debian.tar.xz
Original-Maintainer: Debian GNOME Maintainers <pkg-gnome-maintainers@lists.alioth.debian.org>

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEUMSg3c8x5FLOsZtRZWnYVadEvpMFAmTECG4ACgkQZWnYVadE
vpMNBQ//TTsz1e4ob4TkLKAAjAFKCK8KZhYipv0yjcomF73+i+4IdgLjfd8g1y5j
hDTMcigAmF9qvrB3rE7J1qNDooYw0Fa0Ke/YGVGGzbbMEQZdkCEMjlrWDm6D+slm
rbCiyWo6kIsOr0jV7AH/ldJPXzXsUfXZ5eT0KHScjctCnM7ryS55+Px1SkFRGNgY
wFB6L/vkGX5Tg23hWwDrVvCdTRPrgj116qQcUo8bM0GKqyqKBSSy86jE9mK5f1FA
61et/VfcJFlmfwaQel+SvLEv2jxlibt1cUwf/sdMLhmVcTb7fDbLmDF2MZEfmjzK
ey0Ken6C6NFUPxVrMVW4Hp1Dr6k2x0U6iRBnfx9EBSmoNFyxtcD94OmAlYVjn4ND
p+11pBWny/lZocBNSwc4mjtcbG7XZy2zD0aUZZzOEEx7u6u06Y0QLSSC73S2/ZCV
SIEvgK/NnyNzgOBH6mK/oIrWs40HeaP2CvDgc7OEJgRVImXA9YGih9qR/m9rH42z
f8mt74oFI0qUOuZFVM1qntL41zN+i3lHi1kXMA3caCFprr0JUCgMWHZ3mxayVYdp
ryL2EY1UDAWARjhaPF6WGMZiFjgCs5+yxwHdr15j8y8SFRhNTpPEnWZBQTWLmpyd
oqcHoQg2E28j2fFESAT7cJKluEAn0Ayc0pWWBsCXDNUIpSYfQZI=
=GwJR
-----END PGP SIGNATURE-----
