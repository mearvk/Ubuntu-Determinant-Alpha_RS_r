-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

Format: 3.0 (quilt)
Source: policykit-1
Binary: polkitd, pkexec, policykit-1, policykit-1-doc, libpolkit-gobject-1-0, libpolkit-gobject-1-dev, libpolkit-agent-1-0, libpolkit-agent-1-dev, gir1.2-polkit-1.0
Architecture: any all
Version: 0.105-33
Maintainer: Utopia Maintenance Team <pkg-utopia-maintainers@lists.alioth.debian.org>
Uploaders: Michael Biebl <biebl@debian.org>, Martin Pitt <mpitt@debian.org>, Simon McVittie <smcv@debian.org>,
Homepage: https://www.freedesktop.org/wiki/Software/polkit/
Standards-Version: 4.6.0
Vcs-Browser: https://salsa.debian.org/utopia-team/polkit
Vcs-Git: https://salsa.debian.org/utopia-team/polkit.git
Testsuite: autopkgtest
Build-Depends: dbus-daemon <!nocheck>, debhelper-compat (= 13), gobject-introspection (>= 0.9.12-4~), gtk-doc-tools, intltool (>= 0.40.0), libexpat1-dev, libgirepository1.0-dev (>= 0.9.12), libglib2.0-dev (>= 2.28.0), libglib2.0-doc, libgtk-3-doc, libpam0g-dev, libselinux1-dev [linux-any], libsystemd-dev [linux-any], pkg-config, xsltproc
Package-List:
 gir1.2-polkit-1.0 deb introspection optional arch=any
 libpolkit-agent-1-0 deb libs optional arch=any
 libpolkit-agent-1-dev deb libdevel optional arch=any
 libpolkit-gobject-1-0 deb libs optional arch=any
 libpolkit-gobject-1-dev deb libdevel optional arch=any
 pkexec deb admin optional arch=linux-any
 policykit-1 deb oldlibs optional arch=linux-any
 policykit-1-doc deb doc optional arch=all
 polkitd deb admin optional arch=linux-any
Checksums-Sha1:
 53d56484a5bffb0aaf645c8d813b3063e01e8423 1431080 policykit-1_0.105.orig.tar.gz
 943f09b6cf3c34fdcb09e3aca95d05df19d0ce9d 78052 policykit-1_0.105-33.debian.tar.xz
Checksums-Sha256:
 8fdc7cc8ba4750fcce1a4db9daa759c12afebc7901237e1c993c38f08985e1df 1431080 policykit-1_0.105.orig.tar.gz
 4b6bfdb7b4a2dddfdec016023042198a1bdb5653b680d7ef24b235155e1eb722 78052 policykit-1_0.105-33.debian.tar.xz
Files:
 9c29e1b6c214f0bd6f1d4ee303dfaed9 1431080 policykit-1_0.105.orig.tar.gz
 7d95f6c839f66efbb9bd86bf79918a20 78052 policykit-1_0.105-33.debian.tar.xz
Dgit: 4c02d969c70dcce3a8abb874cbcc455bd03ed155 debian archive/debian/0.105-33 https://git.dgit.debian.org/policykit-1

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEENuxaZEik9e95vv6Y4FrhR4+BTE8FAmIaD5cACgkQ4FrhR4+B
TE/Bzw/+Jz1i3fs5vyIbg+Sk2PjOf1HenaigZcyAceqaVmn1RBBy6eCWpL7A24Wm
QAczwsFNf3i5QgMxaiSYjwO1y3xTnmfpTrVlPG5np2/FwCXLwQrCaxl9awkpOGd1
utpf/h5MreT+cGmJnEsL6+CLLqwgu6Uu7Jg2o7EXj3bAvqNB2p20ftAv/x+SeFF5
/Bjlda+5WexGP/v/ol4iuhbUxE6rrHP1+YF8DXStRWjt/L1jm4MN0l9KQni+fOFp
5A04g49VFU4L9mrr5lm2dROUQS3FEtPFYMVDylI7fdliIY+CbbjPWkYxvAISBxWs
kZxrj+CbbsuI/EseArnFm4BUDIBxdya/IGUCUZFGu3Pk1/UdW4MKqGzkfpVjMhBy
em84iHK47AViijlG6rAtdRLaHRZ6IVmt5zye7fy5oYgeG5QzGM7ePMGvs6G6XyZL
OTrmCgdOV/hIBL9S3sGL1HJ7jQoIG2Y5YdZA1TfQk/jYOR5LZIH6PQhUFR6p/Rzx
0u4oCrnCIJIIUFeCmh8d36zTnnDdsdb1FHeUP0vC2EcHub8YRNmCJWPr2N2Ukeb7
zcg3jprZNINGOqs5BVZMEvX/Dnhskaxswl+tx1wgSoEbUkHGPVgOR8UUcfMW2o7p
cbhywYZOAwXjrxoRracoQMeYHKlzobCGgUyV32GAI+mhckXm8qU=
=jymu
-----END PGP SIGNATURE-----
