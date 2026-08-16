-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Format: 3.0 (quilt)
Source: gnome-session
Binary: gnome-session, gnome-startup-applications, ubuntu-session, unity-session, gnome-session-bin, gnome-session-common
Architecture: any all
Version: 42.0-1ubuntu2
Maintainer: Ubuntu Developers <ubuntu-devel-discuss@lists.ubuntu.com>
Uploaders: Iain Lane <laney@debian.org>, Jeremy Bicha <jbicha@ubuntu.com>, Laurent Bigonville <bigon@debian.org>
Standards-Version: 4.6.0
Vcs-Browser: https://salsa.debian.org/gnome-team/gnome-session/tree/ubuntu/master
Vcs-Git: https://salsa.debian.org/gnome-team/gnome-session.git -b ubuntu/master
Build-Depends: debhelper-compat (= 13), dh-exec, dh-migrations, dh-sequence-gnome, libdbus-1-dev, libgl-dev, libgles-dev, libglib2.0-dev (>= 2.46.0), libgnome-desktop-3-dev (>= 3.34.2), libgtk-3-dev (>= 3.22.0), libice-dev, libjson-glib-dev (>= 0.10), libsm-dev, libsystemd-dev (>= 209) [linux-any], libx11-dev, libxau-dev, libxcomposite-dev, libxext-dev, libxrender-dev, libxt-dev, libxtst-dev, meson (>= 0.53.0), systemd [linux-any], xmlto, xsltproc, xtrans-dev
Package-List:
 gnome-session deb gnome optional arch=all
 gnome-session-bin deb gnome optional arch=any
 gnome-session-common deb gnome optional arch=all
 gnome-startup-applications deb gnome optional arch=any
 ubuntu-session deb gnome optional arch=all
 unity-session deb gnome optional arch=all
Checksums-Sha1:
 676e340c7321fbf9d4bc280105fdbc1015c389fd 485616 gnome-session_42.0.orig.tar.xz
 02169aaff4d71bb41bae448858d19a5cb50848c1 83532 gnome-session_42.0-1ubuntu2.debian.tar.xz
Checksums-Sha256:
 3cca06053ab682926920951a7da95f8cc6d72da74c682c46d0a0653332969caa 485616 gnome-session_42.0.orig.tar.xz
 98504a6d70839203af84e14837f358748c21a95a0f8e2c37221cb1544daa8bd2 83532 gnome-session_42.0-1ubuntu2.debian.tar.xz
Files:
 ab47b2cd924fb74d4dbc2edab886c32a 485616 gnome-session_42.0.orig.tar.xz
 9246f8891f07bf435d7aaadc4b94439a 83532 gnome-session_42.0-1ubuntu2.debian.tar.xz
Debian-Vcs-Browser: https://salsa.debian.org/gnome-team/gnome-session
Debian-Vcs-Git: https://salsa.debian.org/gnome-team/gnome-session.git
Original-Maintainer: Debian GNOME Maintainers <pkg-gnome-maintainers@lists.alioth.debian.org>

-----BEGIN PGP SIGNATURE-----

iHAEARECADAWIQTgLv71TsYonmdA1hxDGjztotfSkgUCYk821BIcc2ViMTI4QHVi
dW50dS5jb20ACgkQQxo87aLX0pI4iACfYdLkyjXHteyyYkXxvwgJYoX/wJkAn1yy
Rgdd6pz71VlQ2imvilNvB6xv
=N2gD
-----END PGP SIGNATURE-----
