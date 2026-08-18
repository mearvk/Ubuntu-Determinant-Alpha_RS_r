-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: dlm
Binary: dlm-controld, libdlm3, libdlm-dev, libdlmcontrol3, libdlmcontrol-dev
Architecture: linux-any
Version: 4.1.1-1build1
Maintainer: Debian HA Maintainers <debian-ha-maintainers@lists.alioth.debian.org>
Uploaders: Ferenc Wágner <wferi@debian.org>, Valentin Vidic <vvidic@debian.org>
Homepage: https://pagure.io/dlm
Standards-Version: 4.6.0
Vcs-Browser: https://salsa.debian.org/ha-team/dlm
Vcs-Git: https://salsa.debian.org/ha-team/dlm.git
Testsuite: autopkgtest
Build-Depends: debhelper-compat (= 13), libcfg-dev (>= 1.99), libcmap-dev (>= 1.99), libcpg-dev (>= 1.99), libquorum-dev (>= 1.99), libsystemd-dev, libxml2-dev, pacemaker-dev, pkg-config, uuid-dev
Package-List:
 dlm-controld deb admin optional arch=linux-any
 libdlm-dev deb libdevel optional arch=linux-any
 libdlm3 deb libs optional arch=linux-any
 libdlmcontrol-dev deb libdevel optional arch=linux-any
 libdlmcontrol3 deb libs optional arch=linux-any
Checksums-Sha1:
 a8fef90c11d7da2a9420eb19aab221952686881c 134132 dlm_4.1.1.orig.tar.gz
 b8a7b56ef81aea5fb75eef5a8674b1d8f7646a7a 7832 dlm_4.1.1-1build1.debian.tar.xz
Checksums-Sha256:
 b5acab234253159bf11657f1071746bdd0ff6b7dda19809e4850b543b02e1445 134132 dlm_4.1.1.orig.tar.gz
 117870cc012d7696936280bc5bdfe13f00151485458d47032cde960e9899888e 7832 dlm_4.1.1-1build1.debian.tar.xz
Files:
 3804577098feb0ae039a6c23eaa6c076 134132 dlm_4.1.1.orig.tar.gz
 39fee55e5b699f03111e2ced9d4506a4 7832 dlm_4.1.1-1build1.debian.tar.xz

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEqx+XcX7ftBm4bj5/AhnKGdA0MwwFAmI7JbsACgkQAhnKGdA0
MwxkZAf+Pp8Ih9xojYk0/ABV9EYcLdwQCiIGkKE6+zoUmNHIrDyPp3zMN1pffq18
JxtFnL2sH05v3UZcKP4XsZ+UJ0pgvodxAUjd/owEVMn9jyOiXXp8hcn+UAfwJUMv
z12VyXkcZ/Vx/aNwjlN7bl7hkJBXmBJEE20I9/ktiueUoIOVZMGdf69f/KaE1NUK
/EvQWl5wpYDJLdfPK8zfC4impMoSvOlNTE7BZEsNrOF+Bh3/14dUO35CMcX+ATbm
XaMig7fmPYIRqoI/vFsl0C3cNRk1zN3rmXw30LYsSVHOQcquhak3KMflh3C2o7ul
AGPAS9kjMpp2VnEdyN2Ft4pk8p34+A==
=pJqj
-----END PGP SIGNATURE-----
