-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Format: 3.0 (quilt)
Source: libqmi
Binary: libqmi-glib-dev, libqmi-glib-doc, libqmi-glib5, libqmi-utils, libqmi-proxy, gir1.2-qmi-1.0
Architecture: linux-any all
Version: 1.32.0-1ubuntu0.22.04.1
Maintainer: Ubuntu Developers <ubuntu-devel-discuss@lists.ubuntu.com>
Uploaders: Arnaud Ferraris <aferraris@debian.org>, Guido Günther <agx@sigxcpu.org>, Henry-Nicolas Tourneur <debian@nilux.be>, Martin <debacle@debian.org>
Homepage: https://www.freedesktop.org/wiki/Software/libqmi
Standards-Version: 4.6.1
Vcs-Browser: https://salsa.debian.org/DebianOnMobile-team/libqmi
Vcs-Git: https://salsa.debian.org/DebianOnMobile-team/libqmi.git
Build-Depends: bash-completion, debhelper-compat (= 13), gobject-introspection, gtk-doc-tools <!nodoc>, help2man, libgirepository1.0-dev, libglib2.0-dev (>= 2.56), libgudev-1.0-dev (>= 232), libmbim-glib-dev (>= 1.27~), meson, pkg-config, python3:any
Build-Depends-Indep: libglib2.0-doc <!nodoc>
Package-List:
 gir1.2-qmi-1.0 deb introspection optional arch=linux-any
 libqmi-glib-dev deb libdevel optional arch=linux-any
 libqmi-glib-doc deb doc optional arch=all profile=!nodoc
 libqmi-glib5 deb libs optional arch=linux-any
 libqmi-proxy deb net optional arch=linux-any
 libqmi-utils deb net optional arch=linux-any
Checksums-Sha1:
 9cfaf3dfc283c36bcf1b2a6cc67a4de09f88f78a 1500852 libqmi_1.32.0.orig.tar.xz
 c1018d8c077633d376265ef75d866867826ff76c 33268 libqmi_1.32.0-1ubuntu0.22.04.1.debian.tar.xz
Checksums-Sha256:
 cec94c2140a96a2e747b5f85cd74cd73f33a388561ac6b8f0cc1bbf52898ff1a 1500852 libqmi_1.32.0.orig.tar.xz
 2ede02b3d5dc77bb97593c5e7ae16f6f945706efffed75f3d69356c7e47b81f8 33268 libqmi_1.32.0-1ubuntu0.22.04.1.debian.tar.xz
Files:
 8348633ccce6318a99fb07e513b81be0 1500852 libqmi_1.32.0.orig.tar.xz
 dfa45969baba8e94fd3fd975b7d7201c 33268 libqmi_1.32.0-1ubuntu0.22.04.1.debian.tar.xz
Original-Maintainer: DebianOnMobile Maintainers <debian-on-mobile-maintainers@alioth-lists.debian.net>

-----BEGIN PGP SIGNATURE-----

iHAEARECADAWIQTgLv71TsYonmdA1hxDGjztotfSkgUCY5hyLBIcc2ViMTI4QHVi
dW50dS5jb20ACgkQQxo87aLX0pKzyQCfTAbrZwSrjYae0I39opDkwjdr4/8An3iT
hv+LWurKXSllcqBLTtJQCTHG
=U4cB
-----END PGP SIGNATURE-----
