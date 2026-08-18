-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Format: 3.0 (quilt)
Source: lirc
Binary: lirc, lirc-doc, liblirc0, liblircclient0, liblircclient-dev, liblirc-dev, liblirc-client0, lirc-x
Architecture: any all
Version: 0.10.1-6.3ubuntu1
Maintainer: Ubuntu Developers <ubuntu-devel-discuss@lists.ubuntu.com>
Uploaders:  Stefan Lippers-Hollmann <s.l-h@gmx.de>, Alec Leamas <leamas.alec@gmail.com>
Homepage: https://sf.net/p/lirc
Standards-Version: 4.3.0
Vcs-Browser: https://gitlab.com/leamas/lirc
Vcs-Git: https://gitlab.com/leamas/lirc.git
Build-Depends: debhelper (>= 11), dh-exec, dh-python, doxygen, expect [!hurd-any], kmod [linux-any], libasound2-dev [linux-any kfreebsd-any], libftdi1-dev, libsystemd-dev [linux-any], libudev-dev [linux-any], libusb-1.0-0-dev [!kfreebsd-any], libusb-dev [!kfreebsd-any], libx11-dev, man2html-base, pkg-config, portaudio19-dev, python3-dev (>= 3.5), python3-setuptools, python3-yaml, socat [!hurd-any], systemd [linux-any], xsltproc
Package-List:
 liblirc-client0 deb libs optional arch=any
 liblirc-dev deb libdevel optional arch=any
 liblirc0 deb libs optional arch=any
 liblircclient-dev deb libdevel optional arch=any
 liblircclient0 deb libs optional arch=any
 lirc deb utils optional arch=any
 lirc-doc deb doc optional arch=all
 lirc-x deb utils optional arch=any
Checksums-Sha1:
 0188b9886d3bd0d4f0819050865001e2dc7e85e3 2715271 lirc_0.10.1.orig.tar.gz
 75728d7b3a8c4a47adc0877bc99809b7481e9ed8 39088 lirc_0.10.1-6.3ubuntu1.debian.tar.xz
Checksums-Sha256:
 25b0a5c761d927e9651e6eb54d0ce4cce3870ebb893afad5c4b181182fc642c1 2715271 lirc_0.10.1.orig.tar.gz
 42c8a2b2260350a910ee8132a17858d06ca59adf4ad778ec6e51657ac6b03753 39088 lirc_0.10.1-6.3ubuntu1.debian.tar.xz
Files:
 2a390b353181fe6c6b5b94dcd10ba743 2715271 lirc_0.10.1.orig.tar.gz
 a0d472ad83a76abd13337e2a0550ea3a 39088 lirc_0.10.1-6.3ubuntu1.debian.tar.xz
Original-Maintainer: Debian Lirc Team <team+debian-lirc@tracker.debian.org>

-----BEGIN PGP SIGNATURE-----

iHAEARECADAWIQTgLv71TsYonmdA1hxDGjztotfSkgUCYj2b0RIcc2ViMTI4QHVi
dW50dS5jb20ACgkQQxo87aLX0pIXFgCfbDPA578baJXESBrXQe10VRRKBIMAoMjd
siS4ke2zqs/lTOvklU44GlP0
=G3oz
-----END PGP SIGNATURE-----
