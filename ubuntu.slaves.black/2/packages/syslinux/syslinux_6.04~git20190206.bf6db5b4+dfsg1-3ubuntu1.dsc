-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

Format: 3.0 (quilt)
Source: syslinux
Binary: syslinux, syslinux-efi, extlinux, isolinux, pxelinux, syslinux-common, syslinux-utils
Architecture: amd64 i386 x32 all
Version: 3:6.04~git20190206.bf6db5b4+dfsg1-3ubuntu1
Maintainer: Ubuntu Developers <ubuntu-devel-discuss@lists.ubuntu.com>
Uploaders: Lukas Schwaighofer <lukas@schwaighofer.name>
Homepage: http://www.syslinux.org/
Standards-Version: 4.5.0
Vcs-Browser: https://salsa.debian.org/images-team/syslinux
Vcs-Git: https://salsa.debian.org/images-team/syslinux.git
Build-Depends: debhelper-compat (= 12), e2fslibs-dev, gcc-multilib [amd64 x32], libc6-dev-i386 [amd64 x32], nasm, python3, uuid-dev
Build-Depends-Indep: gnu-efi (>= 3.0.8)
Package-List:
 extlinux deb admin optional arch=amd64,i386,x32
 isolinux deb admin optional arch=all
 pxelinux deb admin optional arch=all
 syslinux deb admin optional arch=amd64,i386,x32
 syslinux-common deb admin optional arch=all
 syslinux-efi deb admin optional arch=all
 syslinux-utils deb admin optional arch=amd64,i386,x32
Checksums-Sha1:
 ebd33c9110080c49f1350b966675498cc9a6f185 3164384 syslinux_6.04~git20190206.bf6db5b4+dfsg1.orig.tar.xz
 e7b4763e673864115a3131adaf9e91ddc4667408 43180 syslinux_6.04~git20190206.bf6db5b4+dfsg1-3ubuntu1.debian.tar.xz
Checksums-Sha256:
 46169f43dabb5f6cb33a3f6fb79a61008179326756481845c0a42d429d0c5bee 3164384 syslinux_6.04~git20190206.bf6db5b4+dfsg1.orig.tar.xz
 7ecdf4fa869f15c6153e9d59618e787d82cce62b68f4d50fa8dbe6f7f684126a 43180 syslinux_6.04~git20190206.bf6db5b4+dfsg1-3ubuntu1.debian.tar.xz
Files:
 af14c068258814cc96f93ad374f6b18e 3164384 syslinux_6.04~git20190206.bf6db5b4+dfsg1.orig.tar.xz
 962e40719226c5fea30bf3ce62d5989c 43180 syslinux_6.04~git20190206.bf6db5b4+dfsg1-3ubuntu1.debian.tar.xz
Original-Maintainer: Debian CD Group <debian-cd@lists.debian.org>

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEiiBE+E9xaoW3f/djEd9ClMyjmJMFAmETUiQACgkQEd9ClMyj
mJNpng/9HOkV1UtH+8imvhW1WsSFeKvCOC47PRpT7j197uSVc0x/OQrvqKF1N87n
alwhSz7kzsGup74G15WteyOwp0Z6vxFUxvb7oqcV+0S1c4aPnIm0cc8PVajLZ/3d
vqZkbN/j784z/s00VN7pT8QOhOWn+M0DgqiOBgdXv6vXpaO/4ESWqP3tw9w1ifOK
rkD9ID2P2awraLp6z6A0943l7NfSDoPwpMnpLGcwPW0vwsFnFtOPBo/Er/Nochg7
C6HtrkYfTY+UYD5w1zRnNxOgyLR8UF2+e0tA2cuY3zpQL/ADvyNafs+e2MMBWJxU
gikxvG51Wv1c3+l8x2y2n+cfg6LWU/Nnl/lFJgGp8X2EHkukd/Au9AKxkOZ97eo8
wVNvaIJW2QS5VxmKZmLPWEmjypByg4cxcMT0E1L9nT2mEMTXl+0rvp1LZVPxvR1G
shyqzzV75n6qeYGRfzl4pNsTEgdmh7SGnCbzjvzIGupYnwFIM5J/2GEPaZvM8hqU
BX3cVqwDPLtYelLLPaUC5719CnCuAaCzMG6m5JCGxAAU22YAl47gvB1jWYoQBIN8
qwugCN17bT2THte74dUgJy33Eiteu/09G8SHbiHy+yuo40G2R+unhvpUTv0uB8eY
V438qmsuU039nD8khoO6D49iEW7IBcIVUudVzT3cFm5Qqaic9sM=
=uRbo
-----END PGP SIGNATURE-----
