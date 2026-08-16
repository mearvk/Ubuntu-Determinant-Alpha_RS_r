-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: libgusb
Binary: libgusb-dev, libgusb-doc, libgusb2, gir1.2-gusb-1.0
Architecture: any all
Version: 0.3.10-1
Maintainer: Debian UEFI Maintainers <debian-efi@lists.debian.org>
Uploaders: Steve McIntyre <93sam@debian.org>, Mario Limonciello <mario.limonciello@dell.com>
Homepage: http://www.hughski.com/downloads.html
Standards-Version: 4.5.1
Vcs-Browser: https://salsa.debian.org/efi-team/libgusb
Vcs-Git: https://salsa.debian.org/efi-team/libgusb.git
Build-Depends: debhelper-compat (= 13), libglib2.0-dev (>= 2.44.0), libusb-1.0-0-dev, gobject-introspection, libgirepository1.0-dev, gtk-doc-tools, valac (>= 0.20), meson
Build-Depends-Indep: libglib2.0-doc <!nodoc>
Package-List:
 gir1.2-gusb-1.0 deb introspection optional arch=any
 libgusb-dev deb libdevel optional arch=any
 libgusb-doc deb doc optional arch=all profile=!nodoc
 libgusb2 deb libs optional arch=any
Checksums-Sha1:
 0e97390516fbad748c206506f5cce72f559cb29d 42972 libgusb_0.3.10.orig.tar.xz
 2bd20f35d3a1341481a6aa49c703617a86d8b3d7 5988 libgusb_0.3.10-1.debian.tar.xz
Checksums-Sha256:
 0eb0b9ab0f8bba0c59631c809c37b616ef34eb3c8e000b0b9b71cf11e4931bdc 42972 libgusb_0.3.10.orig.tar.xz
 3c916610ebfe9b99e272ce12f4698f5304aa5e72788db5d3509688a4e1c598ea 5988 libgusb_0.3.10-1.debian.tar.xz
Files:
 5effbae7609134a51f3ec295733302c3 42972 libgusb_0.3.10.orig.tar.xz
 8c8bc8b0e942ecd5e4cbc18fce899b82 5988 libgusb_0.3.10-1.debian.tar.xz

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEECwtuSU6dXvs5GA2aLRkspiR3AnYFAmIKhn8ACgkQLRkspiR3
AnbgwBAAyz6YsKeQQxUjXRG574jZOqQkki0Zd8qMSN58dtkkTKzzVERxXKXJs3Jk
uCrlaJlfZZ4chNBle9IkFhwNjQvMkpXFmeGpWWZ5AlyT5nc6b3GFolfsVi/opRCN
VKJdio7BTeHY64+RoIig6KTq/EteACi8ms5OTrr5V0z0fS2xE4zGwQn89xy7ADjk
L0Nm2nCzJoa9ofd1cxmRXMk2iIbdpmJHfGBlcjygJkh9H8kqC9vqT1qRG4QgAbIo
Wucsc99cLulywtAISky/wRALlhSUKBUKrfcHY5ZtRYHLa6llECB7WiH5G1VICTVF
9xHv+JF9+NU0mpLOuCl3iUlFyI51HbIYSafLbSTUbwDjmQcGpkEKPvo4f+SU/RhA
OothrasQa0qVFY9GLXGO2E76CaCh7Cu0h9epCyTdknEhFybgctGAEWC0IKZ/0LiM
jyTLbnX950xpP9swPgh5nqOF0PxBxmJBivZuXznjjH35+5D18HY7jcvDeTK+Rxbs
stSlTJwH1goO83l9fw72VuYgAJLBHDv7T6D3pXKUjwSfZnkRbkQq3erizqYioZlQ
6HbXgYJZrwbq6kyOgh2PfugoraidKz/YJUA+XbJNjgIDJiJG1LiDGR49jz70Adji
BVyr4zIXgxl2rIt0fXGOfSYDOrvut2tDePQY9CMHDmHEB8XDvWY=
=nCV3
-----END PGP SIGNATURE-----
