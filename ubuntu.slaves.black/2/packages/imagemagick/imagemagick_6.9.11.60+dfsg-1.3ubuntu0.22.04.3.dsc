-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: imagemagick
Binary: imagemagick-6-common, imagemagick-6-doc, libmagickcore-6-headers, libmagickwand-6-headers, libmagick++-6-headers, libimage-magick-perl, libmagickcore-6-arch-config, imagemagick-6.q16, libmagickcore-6.q16-6, libmagickcore-6.q16-6-extra, libmagickcore-6.q16-dev, libmagickwand-6.q16-6, libmagickwand-6.q16-dev, libmagick++-6.q16-8, libmagick++-6.q16-dev, libimage-magick-q16-perl, imagemagick-6.q16hdri, libmagickcore-6.q16hdri-6, libmagickcore-6.q16hdri-6-extra, libmagickcore-6.q16hdri-dev, libmagickwand-6.q16hdri-6, libmagickwand-6.q16hdri-dev, libmagick++-6.q16hdri-8, libmagick++-6.q16hdri-dev, libimage-magick-q16hdri-perl, imagemagick-common, imagemagick-doc, perlmagick, libmagickcore-dev, libmagickwand-dev, libmagick++-dev, imagemagick
Architecture: any all
Version: 8:6.9.11.60+dfsg-1.3ubuntu0.22.04.3
Maintainer: Ubuntu Developers <ubuntu-devel-discuss@lists.ubuntu.com>
Uploaders: Luciano Bello <luciano@debian.org>, Bastien Roucariès <rouca@debian.org>,
Homepage: https://www.imagemagick.org/
Standards-Version: 4.3.0
Vcs-Browser: https://salsa.debian.org/debian/imagemagick
Vcs-Git: https://salsa.debian.org/debian/imagemagick.git
Testsuite: autopkgtest
Testsuite-Triggers: gsfonts, libaliased-perl, netpbm
Build-Depends: debhelper (>= 11), dh-exec, g++ (>= 4:7), pkg-config, libltdl-dev, chrpath, libfftw3-dev, liblcms2-dev, liblqr-1-0-dev, libfreetype6-dev, libfontconfig1-dev, gsfonts, zlib1g-dev, liblzma-dev, libbz2-dev, libx11-dev, libxext-dev, libxt-dev, ghostscript, libdjvulibre-dev, libexif-dev, libjpeg-dev, libopenjp2-7-dev, libopenexr-dev, libperl-dev, libpng-dev, libtiff-dev, libwmf-dev, libheif-dev, libwebp-dev, libpango1.0-dev, librsvg2-bin, librsvg2-dev, libxml2-dev, pkg-kde-tools, dpkg-dev (>= 1.17.6)
Build-Depends-Indep: doxygen, doxygen-latex, graphviz, libxml2-utils, xsltproc, jdupes
Package-List:
 imagemagick deb oldlibs optional arch=any
 imagemagick-6-common deb graphics optional arch=all
 imagemagick-6-doc deb doc optional arch=all
 imagemagick-6.q16 deb graphics optional arch=any
 imagemagick-6.q16hdri deb graphics optional arch=any
 imagemagick-common deb oldlibs optional arch=all
 imagemagick-doc deb oldlibs optional arch=all
 libimage-magick-perl deb perl optional arch=all
 libimage-magick-q16-perl deb perl optional arch=any
 libimage-magick-q16hdri-perl deb perl optional arch=any
 libmagick++-6-headers deb libdevel optional arch=all
 libmagick++-6.q16-8 deb libs optional arch=any
 libmagick++-6.q16-dev deb libdevel optional arch=any
 libmagick++-6.q16hdri-8 deb libs optional arch=any
 libmagick++-6.q16hdri-dev deb libdevel optional arch=any
 libmagick++-dev deb oldlibs optional arch=all
 libmagickcore-6-arch-config deb libdevel optional arch=any
 libmagickcore-6-headers deb libdevel optional arch=all
 libmagickcore-6.q16-6 deb libs optional arch=any
 libmagickcore-6.q16-6-extra deb libs optional arch=any
 libmagickcore-6.q16-dev deb libdevel optional arch=any
 libmagickcore-6.q16hdri-6 deb libs optional arch=any
 libmagickcore-6.q16hdri-6-extra deb libs optional arch=any
 libmagickcore-6.q16hdri-dev deb libdevel optional arch=any
 libmagickcore-dev deb oldlibs optional arch=all
 libmagickwand-6-headers deb libdevel optional arch=all
 libmagickwand-6.q16-6 deb libs optional arch=any
 libmagickwand-6.q16-dev deb libdevel optional arch=any
 libmagickwand-6.q16hdri-6 deb libs optional arch=any
 libmagickwand-6.q16hdri-dev deb libdevel optional arch=any
 libmagickwand-dev deb oldlibs optional arch=all
 perlmagick deb oldlibs optional arch=all
Checksums-Sha1:
 824a63dce5e54bd8b78077d671d8ab06300a8848 9395144 imagemagick_6.9.11.60+dfsg.orig.tar.xz
 ee6919981764eb3b57ba55836158ff12fa7f90fa 248200 imagemagick_6.9.11.60+dfsg-1.3ubuntu0.22.04.3.debian.tar.xz
Checksums-Sha256:
 472fb516df842ee9c819ed80099c188463b9e961303511c36ae24d0eaa8959c4 9395144 imagemagick_6.9.11.60+dfsg.orig.tar.xz
 dcfd299d07f31ad020216a632132ac216e1823936638904df62c0e4855d01bd7 248200 imagemagick_6.9.11.60+dfsg-1.3ubuntu0.22.04.3.debian.tar.xz
Files:
 8b8f7b82bd1299cf30aa3c488c46a3cd 9395144 imagemagick_6.9.11.60+dfsg.orig.tar.xz
 a1d56d57883f89f72a2338a4023aa868 248200 imagemagick_6.9.11.60+dfsg-1.3ubuntu0.22.04.3.debian.tar.xz
Original-Maintainer: ImageMagick Packaging Team <pkg-gmagick-im-team@lists.alioth.debian.org>

-----BEGIN PGP SIGNATURE-----

iQJMBAEBCgA2FiEEkCdEQ5T6DutSveCybUp5kL3izGYFAmQlyH8YHHBmc21vcmln
b0BjYW5vbmljYWwuY29tAAoJEG1KeZC94sxmYHMP/0FKErrGot+1vSgqxfQeWKrG
9nBgVNbWfe1vsPaKJ0gEuJ7iv4mPWQt3NubNmWY8nvS5xJqOleO2DrOFrATZZFoV
ZWIX189eJjJ41VV5fe1+kzSC8b53cqiTKxl9pyvg2H+Ejqeg6Ge0+ubCj7/bPcqK
c+EiRpHsFjH2RR2+kBuc/kyFLwTQO8J2ARQ27jbmXXXEMm2KYkRcOaj/5LQSsGAT
ixJN6o2ZCk4xc6q6Q4/8XquWHdOtjA+P4xoCibHF+UKggVckCMEzo7oYcB6jvwM0
gkSccV3BkenKw78W1YqobQ0TW1MF4zxMnedPTqTzwRnq7Q2BDagn7d6ZsbHPHWG+
WVK18QCR+DgfGey/dMdy/uFO8B6s7W9Oj4H8o47Ab4r2SGIvRfKb5wWXT1lMJOea
nCTizOEqlWI0zoiESOmVAWtAoCzhwjhPyHYCwQ4lcH+LNGmgvb24VLd8x27VaeDq
7Xb4OwQ1UCQoTt/PDDTVsD5Gyl8rt3J9iDrWMAodtuUoR7QImUKcQNK/2CJIJBv+
ZT3TQvaMSWmpWY7YZwSCECbjMynvxm9WUMqhexG4ZWUSEmvCaDp3cfdM3fzVT1NL
Fvs37c4D9OfWKIU93GIQ61mHnIkpMsadJX4Xps38Aq6W8/VjfAnJjexUC+93DcfK
Fnbj9a7Anl2rVhZlrFBG
=ltzj
-----END PGP SIGNATURE-----
