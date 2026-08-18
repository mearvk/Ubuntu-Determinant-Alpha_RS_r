-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

Format: 3.0 (quilt)
Source: libxcrypt
Binary: libcrypt1, libcrypt-dev, libcrypt1-udeb, libxcrypt-source
Architecture: any all
Version: 1:4.4.27-1
Maintainer: Marco d'Itri <md@linux.it>
Standards-Version: 4.6.0.1
Vcs-Browser: https://salsa.debian.org/md/libxcrypt
Vcs-Git: https://salsa.debian.org/md/libxcrypt.git
Testsuite: autopkgtest
Testsuite-Triggers: build-essential, pkg-config
Build-Depends: debhelper-compat (= 12), debhelper (>= 12.7~), autoconf, automake, libtool, pkg-config
Package-List:
 libcrypt-dev deb libdevel optional arch=any
 libcrypt1 deb libs optional arch=any protected=yes
 libcrypt1-udeb udeb debian-installer optional arch=any
 libxcrypt-source deb devel optional arch=all
Checksums-Sha1:
 d256e77932bb37ad3899206fd6898b2c485e7f1e 391772 libxcrypt_4.4.27.orig.tar.xz
 b38048e7c108042ba2dbaaae80f0e56b2a1ceafa 7764 libxcrypt_4.4.27-1.debian.tar.xz
Checksums-Sha256:
 cc0762a751224a5cb45329fb731f25016a8d8292749d8b4010f4b68144db6961 391772 libxcrypt_4.4.27.orig.tar.xz
 92565f123e1e3bd5ebc53bc6b50dda46dc30e952fd02bb5b081bf9c113b733e8 7764 libxcrypt_4.4.27-1.debian.tar.xz
Files:
 a70fc1933f10943172fbd339a0770c16 391772 libxcrypt_4.4.27.orig.tar.xz
 c5c4a2632f42529ec286c3afa4b91de0 7764 libxcrypt_4.4.27-1.debian.tar.xz

-----BEGIN PGP SIGNATURE-----

iHUEARYIAB0WIQQnKUXNg20437dCfobLPsM64d7XgQUCYb0UvAAKCRDLPsM64d7X
geEdAP4yDA07P4vTF8s6Hf0z8w8arDWbfTGjwSulxJ/PqaT6oAEAuE+MdiuDguY/
wUBsJgnlAPAmXD/oEbJUYRZApQdEUQQ=
=pYsP
-----END PGP SIGNATURE-----
