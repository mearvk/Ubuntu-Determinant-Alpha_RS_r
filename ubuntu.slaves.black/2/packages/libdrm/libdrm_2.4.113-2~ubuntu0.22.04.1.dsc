-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: libdrm
Binary: libdrm-dev, libdrm2, libdrm-common, libdrm-tests, libdrm2-udeb, libdrm-intel1, libdrm-nouveau2, libdrm-radeon1, libdrm-omap1, libdrm-freedreno1, libdrm-exynos1, libdrm-tegra0, libdrm-amdgpu1, libdrm-etnaviv1
Architecture: any all
Version: 2.4.113-2~ubuntu0.22.04.1
Maintainer: Debian X Strike Force <debian-x@lists.debian.org>
Uploaders: Andreas Boll <aboll@debian.org>
Homepage: https://cgit.freedesktop.org/mesa/drm/
Standards-Version: 4.6.0
Vcs-Browser: https://salsa.debian.org/xorg-team/lib/libdrm
Vcs-Git: https://salsa.debian.org/xorg-team/lib/libdrm
Build-Depends: debhelper-compat (= 13), meson, quilt, xsltproc, libx11-dev, pkg-config, python3-setuptools, xutils-dev (>= 1:7.6+2), libudev-dev [linux-any], libpciaccess-dev, python3-docutils
Package-List:
 libdrm-amdgpu1 deb libs optional arch=linux-any,kfreebsd-any,hurd-any
 libdrm-common deb libs optional arch=all
 libdrm-dev deb libdevel optional arch=linux-any,kfreebsd-any,hurd-any
 libdrm-etnaviv1 deb libs optional arch=armhf,arm64
 libdrm-exynos1 deb libs optional arch=any-arm
 libdrm-freedreno1 deb libs optional arch=any-arm,arm64
 libdrm-intel1 deb libs optional arch=amd64,i386,kfreebsd-amd64,kfreebsd-i386,hurd-i386,x32
 libdrm-nouveau2 deb libs optional arch=linux-any
 libdrm-omap1 deb libs optional arch=any-arm
 libdrm-radeon1 deb libs optional arch=linux-any,kfreebsd-any,hurd-any
 libdrm-tegra0 deb libs optional arch=any-arm,arm64
 libdrm-tests deb libs optional arch=any
 libdrm2 deb libs optional arch=linux-any,kfreebsd-any,hurd-any
 libdrm2-udeb udeb debian-installer optional arch=linux-any,kfreebsd-any,hurd-any
Checksums-Sha1:
 eb7db45e34586d3ec048fd2e9b704016793ca957 457064 libdrm_2.4.113.orig.tar.xz
 8cd2a9b5c16b46470d1a1254ed3a5198ae1f5279 833 libdrm_2.4.113.orig.tar.xz.asc
 92a5b7b3d85e31356135265cc1bd8ae9b932b4cd 60984 libdrm_2.4.113-2~ubuntu0.22.04.1.debian.tar.xz
Checksums-Sha256:
 7fd7eb2967f63beb4606f22d50e277d993480d05ef75dd88a9bd8e677323e5e1 457064 libdrm_2.4.113.orig.tar.xz
 105067ab75c6b05fd2d202fda83e35864e6ff21cd565302ba2228aa498c13289 833 libdrm_2.4.113.orig.tar.xz.asc
 cb1ee404ce432906c306a5a2fa8bcadcae42bf1adc91c434dfd7d1e26aa272c0 60984 libdrm_2.4.113-2~ubuntu0.22.04.1.debian.tar.xz
Files:
 34a4dcf7eaf0c771b3b0757b5fd5f803 457064 libdrm_2.4.113.orig.tar.xz
 4d670ab47d15f0bf5add8d32383049bb 833 libdrm_2.4.113.orig.tar.xz.asc
 9570de754bc5cc0e7bb8a4b75104f9d2 60984 libdrm_2.4.113-2~ubuntu0.22.04.1.debian.tar.xz

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEdS3ifE3rFwGbS2Yjy3AxZaiJhNwFAmObJaEACgkQy3AxZaiJ
hNzXfg//byQIcaY/IENvBXg60xp6LsbX1+OIGfDacywFOuKCJrBLc9YkqePRC3W4
28HniJAR/jN57C7FyGwFo4ipAmGDDyvGK7WEyKNXSHsVkmFdPWOUypNn8vCn5bmi
tt3QNjQwWwwY0BBxpCApPzzh3Ex5mqQXLif6vVbQqyXLfHTpZu6LDgHqC+lRIb41
krvbtNrryRovmOBQwN9aJTSB71phCJjm8YCZNj2Dgb+OAvVcj2KduP1Ca6N6wPYi
kWrl5L25PiyEaeHMah+d3zYQE4l3K6nZsQxIGV/apBhPCejMKalX+lajLGYfHJMW
8JuZseM1Zn/SIsBoU8QPgtWTb1RGoYYW9S4g9oUxco1dpecbqqpWj5e1JKHmsIFA
h1aYbLxCW4OLEpKgdXBC9j+OAAxqtr447bGlDO+sSBqeMKeBQa1mAlHCpgvf3twe
8+FK3xMRhxoJy0LxZ7jTxPoV8MzFpAc0a0rWfdvMePkoKK7/0kufpdOY8A2mq9Ol
UQ6GrNH6aXZzDOiwaUOSqGH1usfGoM7/q/sBdYOnepcXrm83JM5ZdRGkq4Wzwv/r
1TP8LY4VCjlaFQu65yJwtc1elKrZHNk5iKDZ3Cm0DZY7s8K0stSMmsro0m6ta+dv
VDOmE4a/RxXMQgPEY7jW5bEUjPTYxz/TPROWdRlOs0Bw77ai2Cw=
=dq/L
-----END PGP SIGNATURE-----
