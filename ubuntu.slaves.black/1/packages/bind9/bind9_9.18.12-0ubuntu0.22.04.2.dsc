-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: bind9
Binary: bind9, bind9utils, bind9-utils, bind9-doc, bind9-host, bind9-libs, bind9-dev, dnsutils, bind9-dnsutils
Architecture: any all
Version: 1:9.18.12-0ubuntu0.22.04.2
Maintainer: Ubuntu Developers <ubuntu-devel-discuss@lists.ubuntu.com>
Uploaders: Ondřej Surý <ondrej@debian.org>, Bernhard Schmidt <berni@debian.org>
Homepage: https://www.isc.org/downloads/bind/
Standards-Version: 4.1.2
Vcs-Browser: https://salsa.debian.org/dns-team/bind9
Vcs-Git: https://salsa.debian.org/dns-team/bind9.git -b isc/9.18
Testsuite: autopkgtest
Build-Depends: bison, debhelper-compat (= 12), dh-apparmor, dh-apport, dh-exec, libcap2-dev [linux-any], libcmocka-dev, libdb-dev, libedit-dev, libidn2-dev, libjson-c-dev, libkrb5-dev, libldap2-dev, liblmdb-dev, libltdl-dev, libmaxminddb-dev (>= 1.3.0), libnghttp2-dev, libssl-dev, libtool, libtool-bin, libuv1-dev, libxml2-dev, pkg-config, python3, zlib1g-dev
Build-Depends-Indep: fonts-freefont-otf, latexmk, python3-sphinx, python3-sphinx-rtd-theme, texlive-fonts-extra, texlive-latex-recommended, texlive-xetex, xindy
Package-List:
 bind9 deb net optional arch=any
 bind9-dev deb devel optional arch=any
 bind9-dnsutils deb net standard arch=any
 bind9-doc deb doc optional arch=all
 bind9-host deb net standard arch=any
 bind9-libs deb libs standard arch=any
 bind9-utils deb net optional arch=any
 bind9utils deb oldlibs optional arch=all
 dnsutils deb oldlibs optional arch=all
Checksums-Sha1:
 ccd2f3f2f28a3fcf74b0e6aa40b886bb3b491219 5420940 bind9_9.18.12.orig.tar.xz
 52000f079dd5faf67e514a43f8a0fa2fd5fa2367 833 bind9_9.18.12.orig.tar.xz.asc
 c02a961c3dfb8f9694577f17e84a7d1ef59a83e1 90772 bind9_9.18.12-0ubuntu0.22.04.2.debian.tar.xz
Checksums-Sha256:
 47766bb7b063aabbad054386b190aa7f6c14524427afd427c30ec426512027e7 5420940 bind9_9.18.12.orig.tar.xz
 ac76abe03b37f1bcd7337ea6302fea6ca211e377d4bd2fb975ba476c78eb064c 833 bind9_9.18.12.orig.tar.xz.asc
 fd21dc762f3764d68469b291bf2ec22ecc7855863df0a0be7a7028eca7e79318 90772 bind9_9.18.12-0ubuntu0.22.04.2.debian.tar.xz
Files:
 101a5d919a8d7da1ae98f36e36d1dc9f 5420940 bind9_9.18.12.orig.tar.xz
 9852b532a47685ac1994895d85124ade 833 bind9_9.18.12.orig.tar.xz.asc
 fc76abb4aba363baebcf4df62e48b8e9 90772 bind9_9.18.12-0ubuntu0.22.04.2.debian.tar.xz
Original-Maintainer: Debian DNS Team <team+dns@tracker.debian.org>

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEUMSg3c8x5FLOsZtRZWnYVadEvpMFAmSRsCsACgkQZWnYVadE
vpPWbxAAsEHhlPy7772sak7lfV8//wydGAWPGFeXo0b6hWwmKNn6VidoiU7VoVmQ
QQgjw/hSyE9gGTJTGmhiJbWpgKtGAya9czU1BquftgnYSEHq8PN3+y2sM1Japk1P
fu5tyKDtO3dkspOQhNrbem0u+GENv/CmxpXcpeM24VJahBa9sdONyucRF+UPsDyg
SuCiTIxjTcl4i08Q8TF/5MvKbfZcU/sA878RAiDS6Edl67sEPyikzLKIs63Kd56o
oDztfDON2qcS17WL1MWQWgCajGbcDdzQEZ3jAoyRxkk/YC2amZ17p1dG1j8Qa6F4
PNxFI3eDvFIdASHfVDy+6j6CB52ruwD3zYCpUpWXBkPHw1tpIBZjx3+qqIV/jmHd
sX5QPo7+0BMO3hfMJYZ5eMMReIDDgJMnnr3GgyK6CLYfkFnrcng5qzicWYlGUs+7
jCvpyK7woEzxLhYeI9miUAGBkZbLFEpZC1FfNcPuDwQ5CH58ZTu+HgycLcMRG9g1
WClu4BySGZpfSTP3xOmiOXs3FJ0ym+U2bkjl7eg4j7995hzgER1FgIJOejOyjRnW
D012UPSw4ZNJnbGTg6YbfvxSvW1ogcjVGTr7ad732wVlKiavg1e9Yu2QFF06RzTx
umc4uOB0ngfVZLmQJn93YDexuRREntRJ+oPLDcsWQIIzYjS/DwE=
=mUg4
-----END PGP SIGNATURE-----
