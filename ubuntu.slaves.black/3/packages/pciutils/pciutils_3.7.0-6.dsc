-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: pciutils
Binary: pciutils, libpci-dev, libpci3, pciutils-udeb, libpci3-udeb
Architecture: any
Version: 1:3.7.0-6
Maintainer: Guillem Jover <guillem@debian.org>
Homepage: https://mj.ucw.cz/sw/pciutils/
Standards-Version: 4.5.1
Vcs-Browser: https://git.hadrons.org/cgit/debian/pkgs/pciutils.git
Vcs-Git: https://git.hadrons.org/git/debian/pkgs/pciutils.git
Testsuite: autopkgtest
Testsuite-Triggers: build-essential, pkg-config
Build-Depends: debhelper-compat (= 13), pci.ids (>= 0.0~2019.11.10-2) <!noudeb>, pkg-config, libkmod-dev [linux-any], libudev-dev (>= 196) [linux-any], zlib1g-dev
Package-List:
 libpci-dev deb libdevel optional arch=any
 libpci3 deb libs optional arch=any
 libpci3-udeb udeb debian-installer optional arch=any profile=!noudeb
 pciutils deb admin standard arch=any
 pciutils-udeb udeb debian-installer optional arch=any profile=!noudeb
Checksums-Sha1:
 faf65ed0452c85414206f04d2ed40a7b504fb911 516418 pciutils_3.7.0.orig.tar.gz
 e351221add098847b067d347b703134548d4d66f 833 pciutils_3.7.0.orig.tar.gz.asc
 009dc9d43fb74b2e55c463918701f3e22b7dc53f 21532 pciutils_3.7.0-6.debian.tar.xz
Checksums-Sha256:
 08c27e01030d1fcc700d02bc2ea66c638f58a3d150e45e58852aa82ad4160d84 516418 pciutils_3.7.0.orig.tar.gz
 f1c3ef27541bba787c1a12d96580cf4df0c169783b12eea5ca36717970eeba6b 833 pciutils_3.7.0.orig.tar.gz.asc
 3fe6d64750196c5227e373ea1f9d13d5d28bbf6eab5102e46e924a6aca8fb133 21532 pciutils_3.7.0-6.debian.tar.xz
Files:
 51554c538b5a57b61123326e14ea28a1 516418 pciutils_3.7.0.orig.tar.gz
 7f714d692ae5f197b6bd2cdaec1a909b 833 pciutils_3.7.0.orig.tar.gz.asc
 83eec3b4ba2f989a9ab2f2d68d970320 21532 pciutils_3.7.0-6.debian.tar.xz

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEETz509DYFDBD1aWV0uXK/PqSuV6MFAmEsUyIACgkQuXK/PqSu
V6PZlw/+PGPf4U1IMmrhQkvujRHwAstZXExdSFptkVM2T5UrbkHW2k/RgVYWAqA6
twKm9iXVY8sNQR6Wd+XgVSppJ22sPsgYxAeIMRIjPCwvqcw1NoxzTkCn3sTrz3RP
MOQz4lobCxCPAgunPn2vTlMRPU9skQdClIi67DAuh8te6ouJuhC3u4mgam/KL7t5
gh3ZwoSD6USsGijX8349W1jDiMmzz64cXQFqA+qs0nXDzBHdehHCrwa/J7cRc39L
hOYUvv5Ey2bxFxCBPtES12lZPm9VjPLv6YcRLfLLHhjDFQy3rLwKL1LE97CP71FY
vu8KINKBZOX5WzHcb+f7JM8AmtSn7Mxp2PABvnkfYoMojNuQg/DEBbpjlEBelhK9
L4khLVunS2WtEibgGqOkae/KjusgZkUkN0j88tUfUiRa6tRhtOBvVMvegxwNzBBJ
6cNGPWM0QQqEurD8UV8HBVJ+mj30MR+i3N937DePYlL1rxDmVZLLBVeYlV1yyea6
GhsStJ9HsiCdoesr6F3NpPcQLUkf9zFFp2c6raOT2su3thKmq5T44It28jw8/ff4
hw0IxeDumME6ZYT5Bqy5i48vQAAZ6JEx3OBMPt9Sw9j+oez12EPl9e/4AKJJHUF2
jdrIkn4vauitHWrSyIQTE99Y2ksSLTtrD5tIMJRurf8CdIYoAXU=
=0WzK
-----END PGP SIGNATURE-----
