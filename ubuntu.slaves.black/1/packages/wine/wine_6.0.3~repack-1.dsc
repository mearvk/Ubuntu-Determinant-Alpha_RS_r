-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: wine
Binary: wine, wine32, wine64, wine32-preloader, wine64-preloader, wine32-tools, wine64-tools, libwine, libwine-dev, wine-binfmt, fonts-wine
Architecture: all i386 armel armhf amd64 arm64
Version: 6.0.3~repack-1
Maintainer: Debian Wine Party <debian-wine@lists.debian.org>
Uploaders:  Michael Gilbert <mgilbert@debian.org>, Stephen Kitt <skitt@debian.org>, Jens Reyer <jre.winesim@gmail.com>,
Homepage: https://www.winehq.org
Standards-Version: 4.5.1
Vcs-Browser: https://salsa.debian.org/wine-team/wine
Vcs-Git: https://salsa.debian.org/wine-team/wine.git
Build-Depends: debhelper-compat (= 13), clang [arm64], gcc-mingw-w64-i686 [i386], gcc-mingw-w64-x86-64 [amd64], libz-mingw-w64-dev, lzma, flex, bison, quilt, unzip, gettext, icoutils, sharutils, pkg-config, dctrl-tools, imagemagick, librsvg2-bin, fontforge-nox, khronos-api (>= 4.6), unicode-data (>= 14), unicode-data (<< 15), libxi-dev, libxt-dev, libxmu-dev, libx11-dev, libxext-dev, libxfixes-dev, libxrandr-dev, libxcursor-dev, libxrender-dev, libxkbfile-dev, libxxf86vm-dev, libxxf86dga-dev, libxinerama-dev, libgl1-mesa-dev, libglu1-mesa-dev, libxcomposite-dev, libxml-simple-perl, libxml-parser-perl, libpng-dev, libssl-dev, libv4l-dev, libsdl2-dev, libxml2-dev, libgsm1-dev, libjpeg-dev, libkrb5-dev, libtiff-dev, libudev-dev, libpulse-dev, liblcms2-dev, libldap2-dev, libxslt1-dev, unixodbc-dev, libcups2-dev, libvkd3d-dev, libcapi20-dev, libvulkan-dev, libfaudio-dev (>= 19.06.07), libopenal-dev, libdbus-1-dev, freeglut3-dev, libmpg123-dev, libunwind-dev, libasound2-dev, libgphoto2-dev, libosmesa6-dev, libpcap0.8-dev, libgnutls28-dev, libncurses5-dev, libgettextpo-dev, libfreetype6-dev (>= 2.6.2), libfontconfig1-dev, ocl-icd-opencl-dev, libgstreamer-plugins-base1.0-dev
Package-List:
 fonts-wine deb fonts optional arch=all
 libwine deb libs optional arch=amd64,i386,armel,armhf,arm64
 libwine-dev deb libdevel optional arch=amd64,i386,armel,armhf,arm64
 wine deb otherosfs optional arch=all
 wine-binfmt deb otherosfs optional arch=all
 wine32 deb otherosfs optional arch=i386,armel,armhf
 wine32-preloader deb otherosfs optional arch=i386,armel,armhf
 wine32-tools deb libdevel optional arch=i386,armel,armhf
 wine64 deb otherosfs optional arch=amd64,arm64
 wine64-preloader deb otherosfs optional arch=amd64,arm64
 wine64-tools deb libdevel optional arch=amd64,arm64
Checksums-Sha1:
 3ef4095750951e60b931411b6caffc82aee36d65 21383612 wine_6.0.3~repack.orig.tar.xz
 a43ef61be3900b4158affe22133bd058e7489233 5734104 wine_6.0.3~repack-1.debian.tar.xz
Checksums-Sha256:
 5dd347b907fb1b3189e1654ceb2142f2d210f082f5e784c29dda2d73b8a4e589 21383612 wine_6.0.3~repack.orig.tar.xz
 03f963af26f35be2dbfdf94696bf44a4eed673d026dd614b2629525c93095c21 5734104 wine_6.0.3~repack-1.debian.tar.xz
Files:
 169fd6854d8239c8476765314e25a0df 21383612 wine_6.0.3~repack.orig.tar.xz
 7919a9699b65261124577ea4b3056f7e 5734104 wine_6.0.3~repack-1.debian.tar.xz

-----BEGIN PGP SIGNATURE-----

iQQzBAEBCgAdFiEEIwTlZiOEpzUxIyp4mD40ZYkUaygFAmIthskACgkQmD40ZYkU
ayitsSAAoEFgfFYk6q2cSWDMJytMFV8E8/np5s/CRaIj7zJaeenst+KvynSy3JV0
2gRsQKjVn4MxUwq/gXtTbpJySAGuZ+3absrXohMQEkz1I33MaW1CReh5v35eblgp
QUnQPNBPTM7jpNijEzOrFuFkg+WjCl6I7aKH8PJy9elBB8uxlYztlWc2e1vAx0lD
RST6FGv5ruGan3RiRLPjdI+ANLyz2O3uUu/KWRDHJkNJ180G1QwajA5ZUVA9KB/r
7Gz+qn955uRLurvCdQ+mEKyK+IH3u8SVCe5n8zkK5xCgjPdnI03+LXngiE2WtjGw
7PjDj0nnj/0CqNd6hLMLwWSGOrVYNe8qGIOgdHX8rgpUds9UkBBQ7Rs4BhI6Vajk
AorKmHk35uizZ//J/sBoq2befATSGmQrxsLcBB+52xJMcI8Ls7BNTC2Oclg/d62X
8juJQPfB/uXTTYYxg4KSaSVbrwJ+VyDOLPLGGgZ90J9EizAibCM5pfaoOAkTBMeR
FvokH+o+sMtC+URvOropkkvMlTM9k3FddsxhmvWkkwZXHEKDN2zKzEayyyxZoQZp
AoFvy43rJNxZCj8otFGA1jyufSv/IjryZXx6qZlfS4p6fGLIQWKLa+04hJ2ri3bs
AgMzFaPHcCsIlpVDYP3sVhEYhDWVDwyBCC2e6t+8+IgmcrGHAgCrdDXPZ6go+Aa4
9jXfsegMEsafYEQbZqfzaFuoO5a7e+r16INyv3nJATYXgzUietg4MXxgYymJIW5/
yCEMGhYn6yDwUliOTDJpubQuTWTim8MHuV4owGtibTNmD/csOi72rYbvnzLbtcMv
zK0OQtnkZU119h5JWRx9JFce826sVU/mNbX/2Aiu0tyxDpTZnJA5Mtnc+NCmxORV
I+lFg3xxPoOFT/u7NywLFhcBTre9qO+xDUtZ+Vtu0+dwsOTH4vXuyKQsZAFlGpLH
DbPRDZRUPntaJ9T57uUtXtV3mqVc5HijJSQH4rGf2QyAaXYGeE7OtEX12m4kqMuR
RwPblypSN42JilsuFPzj9lCkEy3MIhPe7GNgo0LL6gdtcMrmBXkeXo+RLhZdTAAA
XpKd8nz12boTDVdQV1pUUIW7cea2RA0UkXJBGuUE8sg8tJZNChvcAm/KOWimlZwE
dr6ebICeG5jH2T3GL4GgZuzQ5rZaM1XMaJkUBWEjZD5yNMEHfPexFOzkVFsM2bwE
9S6VSynLqO75ombxVmTKBeiMjkDhuQHUvmSddicPtaUi8Lr3GYV5lJSJMaBEzQoQ
w8j0y9V2fC5aoepTSfk3Py4izHPusDoNQHojgjKWEd8MPOKH/1aQNcmKbnK4NOzt
JsdPwpj7Gj/UWf6zVPzLMRcFOFw5/A==
=UEqI
-----END PGP SIGNATURE-----
