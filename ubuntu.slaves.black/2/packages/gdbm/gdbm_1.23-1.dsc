-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: gdbm
Binary: libgdbm6, gdbm-l10n, libgdbm-dev, gdbmtool, libgdbm-compat4, libgdbm-compat-dev
Architecture: any all
Version: 1.23-1
Maintainer: Nicolas Mora <babelouest@debian.org>
Homepage: https://gnu.org/software/gdbm
Standards-Version: 4.6.0
Vcs-Browser: https://salsa.debian.org/debian/gdbm
Vcs-Git: https://salsa.debian.org/debian/gdbm.git
Testsuite: autopkgtest
Testsuite-Triggers: @builddeps@, build-essential
Build-Depends: texinfo, debhelper-compat (= 13), dh-exec, dietlibc-dev [alpha amd64 arm64 armeb armel armhf hppa i386 mips mipsel mips64el powerpc powerpcspe ppc64 ppc64el s390x sparc64 x32] <!pkg.gdbm.nodietlibc>, libreadline-dev, bison
Package-List:
 gdbm-l10n deb localization optional arch=all
 gdbmtool deb utils optional arch=any
 libgdbm-compat-dev deb libdevel optional arch=any
 libgdbm-compat4 deb libs optional arch=any
 libgdbm-dev deb libdevel optional arch=any
 libgdbm6 deb libs optional arch=any
Checksums-Sha1:
 50ba1b1d45ce33fd44e4fdaaf3b55a9d8f3dc418 1115854 gdbm_1.23.orig.tar.gz
 81599dbe10c7d0fb309ec1fa784860fd8a489f38 181 gdbm_1.23.orig.tar.gz.asc
 aa1958333ac2da9ae629bab758472dbe266098e1 18484 gdbm_1.23-1.debian.tar.xz
Checksums-Sha256:
 74b1081d21fff13ae4bd7c16e5d6e504a4c26f7cde1dca0d963a484174bbcacd 1115854 gdbm_1.23.orig.tar.gz
 64ebb68cc68e8915d62cb20ea40323c00b56051f844589ee0a52169fff34cecb 181 gdbm_1.23.orig.tar.gz.asc
 cc86b10814c2045967d29571ea7bed810fc4ec917d2918d056b8eb3e5622eb1c 18484 gdbm_1.23-1.debian.tar.xz
Files:
 8551961e36bf8c70b7500d255d3658ec 1115854 gdbm_1.23.orig.tar.gz
 1e65967aaf85d790831a51fbac1aebe2 181 gdbm_1.23.orig.tar.gz.asc
 1c7f4e40ce9d23d5f30770878b3eead8 18484 gdbm_1.23-1.debian.tar.xz

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEhAWwL8wo75dEyPJT/oITlEC9IrkFAmH+jkUACgkQ/oITlEC9
Irk0Og/9F3Hwe9M+hUrKRoVrEm7Wr/x3SaMDzDwmeKRmRkJy5frS8/kJ+1XEvn6w
SfaUR+5h0LL2djgW3tU5+3uBGnkdUWj7tNZFMn74nuf384cw0IitGbF1r/i93zRY
H1ydCmiPDPNPBknRIHztUxtsNy9Y1CCKRkBql93SVjKJqZA3SDlsqR4B3kwv3PE0
CXIE5D1YdBHamEABNWHX0wC9va5ISqjjUg7vZ9tqEqBgo8HQm9UaucFbwldrK1Yv
b89ocEcLsM9CcNjBA+EJs8MrC7z9eygGJC9brb59YwOJmVAZWpxf9jWffvsBv/Sc
N60KJuG0IYYtZxrKj5299dVdFrG1PweDKf7eg405mz+eD3a0W1J55AwPwCzH5N47
E494StC46WvPonrNNvT3+pbcJafrwiWILLzQjarntXS1/4rj0e6QL4cS5ZgFTtvG
HdjwQ6bqjqjY1H42F2TFqANyZKJf5NK9VtceGL4lTiaypJFNcOMpuiIab4eLERGe
+aVARLVNPDLo16J4SvFcmrC8U8Q2dm8W7m1z52RCkLEz8MAZ5xB+KYpjHkISbVr1
mVBWvGWq2vY1vec8oCQq6vfMdkDNY96bh3a8fRAJLQosMK2Q4wEoIiYW9bRkGOiY
ldCbHQnSgLlyaCA2K8M/BYcUe6L1FfbMkYWviEudXNHF2N8SQtg=
=1cxt
-----END PGP SIGNATURE-----
