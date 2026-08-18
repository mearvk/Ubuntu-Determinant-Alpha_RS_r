-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: libdecor-0
Binary: libdecor-0-0, libdecor-0-dev, libdecor-0-plugin-1-cairo, libdecor-tests
Architecture: any
Version: 0.1.0-3build1
Maintainer: Ubuntu Developers <ubuntu-devel-discuss@lists.ubuntu.com>
Uploaders:  Christian Rauch <Rauch.Christian@gmx.de>, Simon McVittie <smcv@debian.org>
Homepage: https://gitlab.gnome.org/jadahl/libdecor
Standards-Version: 4.6.0
Vcs-Browser: https://salsa.debian.org/sdl-team/libdecor-0
Vcs-Git: https://salsa.debian.org/sdl-team/libdecor-0.git
Testsuite: autopkgtest
Testsuite-Triggers: build-essential, libwayland-dev, libxkbcommon-dev, pkg-config, wayland-protocols, weston
Build-Depends: debhelper-compat (= 13), libcairo2-dev, libdbus-1-dev, libegl-dev <!noinsttest>, libgl-dev <!noinsttest>, libopengl-dev <!noinsttest>, libpango1.0-dev, libwayland-dev (>= 1.18), libxkbcommon-dev <!noinsttest>, meson (>= 0.47), pkg-config, wayland-protocols (>= 1.15)
Package-List:
 libdecor-0-0 deb libs optional arch=any
 libdecor-0-dev deb libdevel optional arch=any
 libdecor-0-plugin-1-cairo deb libs optional arch=any
 libdecor-tests deb misc optional arch=any profile=!noinsttest
Checksums-Sha1:
 f5306554cc175da42404475cda908b6397181d4b 45026 libdecor-0_0.1.0.orig.tar.gz
 1f81e54833bebf1c7ca08ebb14b47c77020b78f8 8540 libdecor-0_0.1.0-3build1.debian.tar.xz
Checksums-Sha256:
 1d5758cb49dcb9ceaa979ad14ceb6cdf39282af5ce12ebe6073dd193d6b2fb5e 45026 libdecor-0_0.1.0.orig.tar.gz
 e3ba5546d3d34a30808fbe4d7dfae3146aa4a952dd70cac9f45b8971c53000ca 8540 libdecor-0_0.1.0-3build1.debian.tar.xz
Files:
 f5c382edc16e52c00ec14e7c9c3cfd38 45026 libdecor-0_0.1.0.orig.tar.gz
 231f8a7c761baa0cf1b4d1f46e5413e1 8540 libdecor-0_0.1.0-3build1.debian.tar.xz
Original-Maintainer: Debian SDL packages maintainers <pkg-sdl-maintainers@lists.alioth.debian.org>

-----BEGIN PGP SIGNATURE-----

iQJHBAEBCgAxFiEET7WIqEwt3nmnTHeHb6RY3R2wP3EFAmI8X9ATHGp1bGlhbmtA
dWJ1bnR1LmNvbQAKCRBvpFjdHbA/cS7kD/0Xh5y6ZWsyUcIH+CKbraPJVVKDWtso
grMru58RcjrF/5C6cQ1t1VwjbnK34CipuewRNJXWrgiAFYCatw+C0F5MKCE04UIK
DRljAMXw+Ioo9sQ2m8IG2OkkTavS9lDWI9vWkPxO/96TVR8rH8WOk3clcrYTlEXu
IOzMmHEBEJLs3K90YPaLBEBTcCKEzW8f/jwZlscZGi706AxIQ8OGL1U2xCZLy7QV
yaacPl29ZeVPfHco9uFQx7K15wkuOv72AQdpy8TSLXXKwee5HR8aLY+8tcRGzRQU
qSDg0rS2MCTdq8YTKTy2mVQ3istN7U6XkkYIII/pxCJ5fxzWfLcycBGPSlckZEi+
JR3l2OoAF1zvN+hjVuVSCDsw6Q/3NFvaW/tp3VXOYPC+D2k5dLnkNm8AS464Vpsc
6uOfJUivGfkfE4q5mMQJ7BOIxgw62ujvYr2/lpHfPjq55JjTMopEZpAGBczqObff
uM1c9GfbAxxw1ohIs8DNBpfg9syb6JbDZ1Uf6ZVNs+RmEqa+Apbnw848v//isSI8
ZbmcfPfnCmIamvcC9LgGpXMQLb3+te3KsWZemaWOoFhx2tOCgkJp+BO6F9GJABTw
ryWXtV7DkAZ+Rs2vvLVh4hs9faU0l5o8IAQpyX11y2s/gMSgQhH6LmExTU0uRFkc
BHlkaglJ0r7iyQ==
=VJN/
-----END PGP SIGNATURE-----
