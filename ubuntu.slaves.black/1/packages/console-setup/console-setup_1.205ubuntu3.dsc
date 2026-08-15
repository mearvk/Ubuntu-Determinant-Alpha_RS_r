-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Format: 3.0 (native)
Source: console-setup
Binary: keyboard-configuration, console-setup, console-setup-mini, console-setup-linux, bdf2psf, console-setup-udeb, console-setup-amiga-ekmap, console-setup-ataritt-ekmap, console-setup-pc-ekmap, console-setup-sun4-ekmap, console-setup-sun5-ekmap, console-setup-pc-ekbd, console-setup-linux-fonts-udeb, console-setup-linux-charmaps-udeb
Architecture: all
Version: 1.205ubuntu3
Maintainer: Ubuntu Developers <ubuntu-devel-discuss@lists.ubuntu.com>
Uploaders: Anton Zinoviev <zinoviev@debian.org>
Standards-Version: 3.9.1
Vcs-Bzr: http://bazaar.launchpad.net/~ubuntu-core-dev/console-setup/ubuntu
Build-Depends: perl, debhelper (>= 9.20160709), po-debconf, libxml-parser-perl, bdfresize, liblocale-gettext-perl
Build-Depends-Indep: xkb-data (>= 1.6), locales-all, sharutils, keymapper
Package-List:
 bdf2psf deb utils optional arch=all
 console-setup deb utils optional arch=all
 console-setup-amiga-ekmap udeb debian-installer optional arch=all profile=!noudeb
 console-setup-ataritt-ekmap udeb debian-installer optional arch=all profile=!noudeb
 console-setup-linux deb utils optional arch=all
 console-setup-linux-charmaps-udeb udeb debian-installer optional arch=all profile=!noudeb
 console-setup-linux-fonts-udeb udeb debian-installer optional arch=all profile=!noudeb
 console-setup-mini deb utils optional arch=all
 console-setup-pc-ekbd udeb debian-installer optional arch=all profile=!noudeb
 console-setup-pc-ekmap udeb debian-installer optional arch=all profile=!noudeb
 console-setup-sun4-ekmap udeb debian-installer optional arch=all profile=!noudeb
 console-setup-sun5-ekmap udeb debian-installer optional arch=all profile=!noudeb
 console-setup-udeb udeb debian-installer optional arch=all profile=!noudeb
 keyboard-configuration deb utils optional arch=all
Checksums-Sha1:
 ac2bd5eebef6b9775fb9abdc0776359b54f744ee 1815916 console-setup_1.205ubuntu3.tar.xz
Checksums-Sha256:
 f9d691da6394b0806bfc930cb00414c64cf47c639d384b793c8bf9bd867030ca 1815916 console-setup_1.205ubuntu3.tar.xz
Files:
 0626514f3222b9f6f662e0539ad0a3a8 1815916 console-setup_1.205ubuntu3.tar.xz
Debian-Vcs-Browser: https://salsa.debian.org/installer-team/console-setup
Debian-Vcs-Git: https://salsa.debian.org/installer-team/console-setup.git
Original-Maintainer: Debian Install System Team <debian-boot@lists.debian.org>

-----BEGIN PGP SIGNATURE-----

iF0EARECAB0WIQTgLv71TsYonmdA1hxDGjztotfSkgUCYZvICwAKCRBDGjztotfS
kuX4AJ9paZKMpxgj0uRKxmrxiiq70M/yWQCfbbcMEcftYZ2WSOq5bG4YRF8nkeo=
=dxSp
-----END PGP SIGNATURE-----
