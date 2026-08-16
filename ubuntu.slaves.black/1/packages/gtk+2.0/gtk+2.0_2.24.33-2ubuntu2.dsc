-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: gtk+2.0
Binary: libgtk2.0-0, libgtk2.0-0-udeb, libgtk2.0-common, libgtk2.0-bin, libgtk2.0-dev, libgtk2.0-doc, gtk2.0-examples, gtk2-engines-pixbuf, gir1.2-gtk-2.0, libgail18, libgail18-udeb, libgail-common, libgail-dev, libgail-doc
Architecture: any all
Version: 2.24.33-2ubuntu2
Maintainer: Ubuntu Developers <ubuntu-devel-discuss@lists.ubuntu.com>
Uploaders: Debian GNOME Maintainers <pkg-gnome-maintainers@lists.alioth.debian.org>
Homepage: http://www.gtk.org/
Standards-Version: 4.5.1
Vcs-Browser: https://salsa.debian.org/gnome-team/gtk2/tree/ubuntu/master
Vcs-Git: https://salsa.debian.org/gnome-team/gtk2.git -b ubuntu/master
Testsuite: autopkgtest
Testsuite-Triggers: build-essential, xauth, xvfb
Build-Depends: debhelper-compat (= 12), dh-python, gettext, gtk-doc-tools (>= 1.11), xsltproc, pkg-config, python3:any, libglib2.0-dev (>= 2.27.3), libgdk-pixbuf-2.0-dev (>= 2.22.1) | libgdk-pixbuf2.0-dev (>= 2.22.1), libpango1.0-dev (>= 1.28.3), libatk1.0-dev (>= 1.32.0), libx11-dev (>= 2:1.3.3-2), libxext-dev (>= 2:1.1.1-3), libxi-dev (>= 2:1.3-4), libxrandr-dev (>= 2:1.2.99), libxt-dev, libxrender-dev (>= 1:0.9.5-2), libxft-dev, libxcursor-dev (>= 1:1.1.10-2), libxcomposite-dev (>= 1:0.2.0-3), libxdamage-dev (>= 1:1.0.1-3), libxkbfile-dev, libxinerama-dev (>= 2:1.1-3), libxfixes-dev (>= 1:3.0.0-3), libcairo2-dev (>= 1.6.4-6.1), gnome-pkg-tools (>= 0.11), dpkg-dev (>= 1.16.1), x11proto-xext-dev, libcups2-dev (>= 1.2), gobject-introspection (>= 0.10.8-2), libgirepository1.0-dev (>= 0.9.3), quilt, gawk, shared-mime-info, docbook-xml, docbook-xsl, docbook-utils, libxml2-utils, xauth <!nocheck>, xvfb <!nocheck>
Build-Depends-Indep: libglib2.0-doc, libatk1.0-doc, libpango1.0-doc, libcairo2-doc
Package-List:
 gir1.2-gtk-2.0 deb introspection optional arch=any
 gtk2-engines-pixbuf deb graphics optional arch=any
 gtk2.0-examples deb x11 optional arch=any
 libgail-common deb libs optional arch=any
 libgail-dev deb libdevel optional arch=any
 libgail-doc deb doc optional arch=all
 libgail18 deb libs optional arch=any
 libgail18-udeb udeb debian-installer optional arch=any profile=!noudeb
 libgtk2.0-0 deb libs optional arch=any
 libgtk2.0-0-udeb udeb debian-installer optional arch=any profile=!noudeb
 libgtk2.0-bin deb misc optional arch=any
 libgtk2.0-common deb misc optional arch=all
 libgtk2.0-dev deb libdevel optional arch=any
 libgtk2.0-doc deb doc optional arch=all
Checksums-Sha1:
 6fb0199cbb858456ba5d6fc9d7e4641f73476e76 12661828 gtk+2.0_2.24.33.orig.tar.xz
 282520eb89a18327702cae050677c70ea473bd99 107252 gtk+2.0_2.24.33-2ubuntu2.debian.tar.xz
Checksums-Sha256:
 ac2ac757f5942d318a311a54b0c80b5ef295f299c2a73c632f6bfb1ff49cc6da 12661828 gtk+2.0_2.24.33.orig.tar.xz
 b1162c7e837d9f00e7c469f27048c72d8305be7f5bcfb6045141e36e7e7fec0c 107252 gtk+2.0_2.24.33-2ubuntu2.debian.tar.xz
Files:
 0118e98dbe0e4dab90ce475f9f0e6c0c 12661828 gtk+2.0_2.24.33.orig.tar.xz
 62c8d36c168eb2782a421fe07c4d7b19 107252 gtk+2.0_2.24.33-2ubuntu2.debian.tar.xz
Debian-Vcs-Browser: https://salsa.debian.org/gnome-team/gtk2
Debian-Vcs-Git: https://salsa.debian.org/gnome-team/gtk2.git
Original-Maintainer: Debian GNOME Maintainers <pkg-gnome-maintainers@lists.alioth.debian.org>

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEqx+XcX7ftBm4bj5/AhnKGdA0MwwFAmI7JycACgkQAhnKGdA0
Mww8hgf+JM2G5J4hXfnzWvPS6FsSLbznk6gg0GeCr9kG4Pcd1yHVZEADNptkLwT0
aVOCWoloEUw5ukFKj1O0w5IZnZuWL1hzu7k7NCYMq8chEA9qn1nKgj4rlQFW+GTQ
3wWKAzaTg9Z5wh6xyvXpL1esxctcYFujHbYPnp2FqkE91z+QdTdzIlNRuwCjZIJu
hsTdbGAayLPEMtDnrWMaistOqB/R3ilQlU5u7eDzG2+mJb7lfbHmZBrEh/a19fCt
wxqgcx0VLGz36ZRs7ipOCnA1xlO7zk919G3ndDM7GuBf4GRQGccJV5YF2T2UC5sx
Fqu/+XUUI60YflBmMwKxDAMdWC+EaA==
=8oj6
-----END PGP SIGNATURE-----
