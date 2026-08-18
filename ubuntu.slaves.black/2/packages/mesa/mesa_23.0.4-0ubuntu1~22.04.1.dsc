-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 1.0
Source: mesa
Binary: libxatracker2, libxatracker-dev, libd3dadapter9-mesa, libd3dadapter9-mesa-dev, libgbm1, libgbm-dev, libegl-mesa0, libegl1-mesa, libegl1-mesa-dev, libwayland-egl1-mesa, libgles2-mesa, libgles2-mesa-dev, libglapi-mesa, libglx-mesa0, libgl1-mesa-glx, libgl1-mesa-dri, libgl1-mesa-dev, mesa-common-dev, libosmesa6, libosmesa6-dev, mesa-va-drivers, mesa-vdpau-drivers, mesa-vulkan-drivers, mesa-opencl-icd, mesa-drm-shim
Architecture: any
Version: 23.0.4-0ubuntu1~22.04.1
Maintainer: Debian X Strike Force <debian-x@lists.debian.org>
Uploaders: Andreas Boll <aboll@debian.org>
Homepage: https://mesa3d.org/
Standards-Version: 4.1.4
Vcs-Browser: https://salsa.debian.org/xorg-team/lib/mesa
Vcs-Git: https://salsa.debian.org/xorg-team/lib/mesa.git
Testsuite: autopkgtest
Testsuite-Triggers: build-essential, pkg-config
Build-Depends: debhelper-compat (= 12), directx-headers-dev (>= 1.602.0) [linux-amd64 linux-arm64], glslang-tools [amd64 arm64 armel armhf i386 mips64el mipsel powerpc ppc64 ppc64el riscv64 s390x sparc64 x32], meson (>= 0.45), quilt (>= 0.63-8.2~), pkg-config, libdrm-dev (>= 2.4.107-4), libx11-dev, libxxf86vm-dev, libexpat1-dev, libsensors-dev [!hurd-any], libxfixes-dev, libxext-dev, libva-dev (>= 1.6.0) [linux-any kfreebsd-any] <!pkg.mesa.nolibva>, libvdpau-dev (>= 1.1.1) [linux-any kfreebsd-any], libvulkan-dev [amd64 arm64 armel armhf i386 mips64el mipsel powerpc ppc64 ppc64el riscv64 s390x sparc64 x32], x11proto-dev, linux-libc-dev (>= 2.6.31) [linux-any], libx11-xcb-dev, libxcb-dri2-0-dev (>= 1.8), libxcb-glx0-dev (>= 1.8.1), libxcb-xfixes0-dev, libxcb-dri3-dev, libxcb-present-dev, libxcb-randr0-dev, libxcb-shm0-dev, libxcb-sync-dev, libxrandr-dev, libxshmfence-dev (>= 1.1), libzstd-dev, python3, python3-mako, python3-ply, python3-setuptools, flex, bison, libelf-dev [amd64 arm64 armel armhf i386 mips64el mipsel powerpc ppc64 ppc64el riscv64 s390x sparc64 x32], libwayland-dev (>= 1.15.0) [linux-any], libwayland-egl-backend-dev (>= 1.15.0) [linux-any], llvm-15-dev [amd64 arm64 armel armhf i386 mips64el mipsel powerpc ppc64 ppc64el riscv64 s390x sparc64 x32], libclang-15-dev [amd64 arm64 armel armhf i386 mips64el mipsel powerpc ppc64 ppc64el riscv64 s390x sparc64 x32], libclang-cpp15-dev [amd64 arm64 armel armhf i386 mips64el mipsel powerpc ppc64 ppc64el riscv64 s390x sparc64 x32], libclc-15-dev [amd64 arm64 armel armhf i386 mips64el mipsel powerpc ppc64 ppc64el riscv64 s390x sparc64 x32], wayland-protocols (>= 1.24), zlib1g-dev, libglvnd-core-dev (>= 1.3.2), valgrind [amd64 arm64 armhf i386 mips64el mipsel powerpc ppc64 ppc64el s390x], rustc [amd64 arm64 armel armhf mips64el mipsel ppc64el s390x], bindgen [amd64 arm64 armel armhf mips64el mipsel ppc64el s390x], llvm-spirv-15 [amd64 arm64 armel armhf mips64el mipsel ppc64el s390x], libclc-15 [amd64 arm64 armel armhf mips64el mipsel ppc64el s390x], libllvmspirvlib-15-dev [amd64 arm64 armel armhf mips64el mipsel ppc64el s390x]
Package-List:
 libd3dadapter9-mesa deb libs optional arch=amd64,arm64,armel,armhf,i386,powerpc
 libd3dadapter9-mesa-dev deb libdevel optional arch=amd64,arm64,armel,armhf,i386,powerpc
 libegl-mesa0 deb libs optional arch=any
 libegl1-mesa deb oldlibs optional arch=any
 libegl1-mesa-dev deb libdevel optional arch=any
 libgbm-dev deb libdevel optional arch=linux-any,kfreebsd-any
 libgbm1 deb libs optional arch=linux-any,kfreebsd-any
 libgl1-mesa-dev deb oldlibs optional arch=any
 libgl1-mesa-dri deb libs optional arch=any
 libgl1-mesa-glx deb oldlibs optional arch=any
 libglapi-mesa deb libs optional arch=any
 libgles2-mesa deb oldlibs optional arch=any
 libgles2-mesa-dev deb oldlibs optional arch=any
 libglx-mesa0 deb libs optional arch=any
 libosmesa6 deb libs optional arch=any
 libosmesa6-dev deb libdevel optional arch=any
 libwayland-egl1-mesa deb oldlibs optional arch=linux-any
 libxatracker-dev deb libdevel optional arch=amd64,i386,x32
 libxatracker2 deb libs optional arch=amd64,i386,x32
 mesa-common-dev deb libdevel optional arch=any
 mesa-drm-shim deb libs optional arch=amd64,arm64,armel,armhf,i386,mips64el,mipsel,powerpc,ppc64,ppc64el,s390x,sparc64
 mesa-opencl-icd deb libs optional arch=amd64,arm64,armel,armhf,i386,mips64el,mipsel,powerpc,ppc64,ppc64el,riscv64,s390x,sparc64,x32
 mesa-va-drivers deb libs optional arch=linux-any,kfreebsd-any profile=!pkg.mesa.nolibva
 mesa-vdpau-drivers deb libs optional arch=linux-any,kfreebsd-any
 mesa-vulkan-drivers deb libs optional arch=amd64,arm64,armel,armhf,i386,mips64el,mipsel,powerpc,ppc64,ppc64el,riscv64,s390x,sparc64,x32
Checksums-Sha1:
 80cea9651bd6a748e8eb8925823d0455999e17d5 28758000 mesa_23.0.4.orig.tar.gz
 354b4ca59a9c3f2bb6870951963bd358cb542112 124256 mesa_23.0.4-0ubuntu1~22.04.1.diff.gz
Checksums-Sha256:
 6198d62cd022644aac48c6a869ebb4c9b9bfc214ebacc2b455304c1d5637c87a 28758000 mesa_23.0.4.orig.tar.gz
 525fb0dbc1cf0dffc0035b9a8ee9d4454ec6126f0e2306fc736c3c238e50970b 124256 mesa_23.0.4-0ubuntu1~22.04.1.diff.gz
Files:
 de0250aaa35ab6e2390d396c86516db3 28758000 mesa_23.0.4.orig.tar.gz
 76f8ad06964ebe7bc4756786f57e1e29 124256 mesa_23.0.4-0ubuntu1~22.04.1.diff.gz

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEdS3ifE3rFwGbS2Yjy3AxZaiJhNwFAmSQPxYACgkQy3AxZaiJ
hNxwlA/+OBcLbwOx1ThmYLd3BFs7V51HUIQaz7rpmTL9aY+iJsiLwgdVabGZD+66
9rSZ/Lwnj5wVzHJ7Q/zxfwBm7GMsbJGQUEyqB5fo1vhD9Y5v0EHANgVEmF8ChOhp
ruU6zOLlMdMRn5P3FPx/YX8Jj8DpwHNJwD9epfMOESM0RcM8F61/SygG8DG9EJnT
36EIWOB5aK2srJVzp1dQl658Ak3GIpO39+5SayPR1jj4paLJF8QXm2WJ93qBWzcW
Z1JBmPsX6vFzDNso6QrMKzcSbSGXJRgbYBYt9TKSQg35OTvclZXJXiCaY+wdqlhn
gy9DEfosB7b+eo7X5UIZAlB73X2+cKPxFPJVOL5vEvzYjQ43FIlk6v4mjCKwmbmJ
pNV1i0Fbed9Q7E5CvrvIxxdO3iScyJH7ZiDszzKtzJltOLXtJ8AYqF8cMMejNmiM
kbskIWAbqT2n6d1W/SRWo0btfcR87SviMqN08D3oeEHU2zHiATERhnTkOrA1O5/Q
igsF7tMvMGHjsUaFtSiH2qzD2E92WY1oPf+4A5Rv27RIiRg/B2W33CqbEYZ2a3WB
WlBLXfehZ1eTEMYOKfuSDM6njE9PVAxeFvxkTRW00/JsJcaS4YiEQcL3N4ELDyPc
6Q2PYZFzD8EnrseTEvy9CRTOfOaRay5fqcC21p5A9PO1yoQIQj4=
=mgz5
-----END PGP SIGNATURE-----
