-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: ffmpeg
Binary: ffmpeg, ffmpeg-doc, libavcodec58, libavcodec-extra58, libavcodec-extra, libavcodec-dev, libavdevice58, libavdevice-dev, libavfilter7, libavfilter-extra7, libavfilter-extra, libavfilter-dev, libavformat58, libavformat-extra58, libavformat-extra, libavformat-dev, libavutil56, libavutil-dev, libpostproc55, libpostproc-dev, libswresample3, libswresample-dev, libswscale5, libswscale-dev
Architecture: any all
Version: 7:4.4.2-0ubuntu0.22.04.1
Maintainer: Ubuntu Developers <ubuntu-devel-discuss@lists.ubuntu.com>
Uploaders:  Reinhard Tartler <siretart@tauware.de>, Balint Reczey <balint@balintreczey.hu>, James Cowgill <jcowgill@debian.org>, Sebastian Ramacher <sramacher@debian.org>,
Homepage: https://ffmpeg.org/
Standards-Version: 4.6.0
Vcs-Browser: https://salsa.debian.org/multimedia-team/ffmpeg
Vcs-Git: https://salsa.debian.org/multimedia-team/ffmpeg.git
Testsuite: autopkgtest
Testsuite-Triggers: build-essential, pkg-config
Build-Depends: clang [amd64 arm64 i386 ppc64el], debhelper-compat (= 13), flite1-dev, frei0r-plugins-dev <!pkg.ffmpeg.stage1>, ladspa-sdk, libaom-dev, libaribb24-dev, libass-dev, libbluray-dev, libbs2b-dev, libbz2-dev, libcaca-dev, libcdio-paranoia-dev, libchromaprint-dev <!pkg.ffmpeg.stage1>, libcodec2-dev, libdav1d-dev, libdc1394-dev [linux-any], libdrm-dev [linux-any], libffmpeg-nvenc-dev [amd64 arm64 i386], libfontconfig-dev, libfreetype-dev, libfribidi-dev, libgl1-mesa-dev | libgl-dev, libgme-dev, libgnutls28-dev, libgsm1-dev, libiec61883-dev [linux-any], libavc1394-dev [linux-any], libjack-jackd2-dev, liblilv-dev, liblzma-dev, libmfx-dev [amd64], libmp3lame-dev, libmysofa-dev, libopenal-dev, libomxil-bellagio-dev, libopencore-amrnb-dev, libopencore-amrwb-dev, libopenjp2-7-dev (>= 2.1), libopenmpt-dev, libopus-dev, libpocketsphinx-dev (>= 0.8+5prealpha+1-7~) [!i386 !alpha !hppa !ia64 !m68k !mipsel !mips64el !powerpc !ppc64 !s390x !sparc64], libpulse-dev, librabbitmq-dev, librubberband-dev, librsvg2-dev [!alpha !hppa !hurd-i386 !ia64 !kfreebsd-amd64 !kfreebsd-i386 !m68k !sh4 !x32], libsctp-dev [linux-any], libsdl2-dev, libshine-dev (>= 3.0.0), libsmbclient-dev (>= 4.13) [!hurd-i386], libsnappy-dev, libsoxr-dev, libspeex-dev, libsrt-gnutls-dev, libssh-gcrypt-dev, libtesseract-dev, libtheora-dev, libtwolame-dev, libva-dev (>= 1.3) [!hurd-any], libvdpau-dev, libvidstab-dev, libvo-amrwbenc-dev, libvorbis-dev, libvpx-dev, libwebp-dev, libx264-dev <!pkg.ffmpeg.stage1>, libx265-dev (>= 1.8), libxcb-shape0-dev, libxcb-shm0-dev, libxcb-xfixes0-dev, libxml2-dev, libxv-dev, libxvidcore-dev, libxvmc-dev, libzimg-dev, libzmq3-dev, libzvbi-dev, ocl-icd-opencl-dev | opencl-dev, pkg-config, texinfo, nasm, pkg-kde-tools, zlib1g-dev
Build-Depends-Indep: cleancss, doxygen, node-less, tree
Package-List:
 ffmpeg deb video optional arch=any
 ffmpeg-doc deb doc optional arch=all
 libavcodec-dev deb libdevel optional arch=any
 libavcodec-extra deb metapackages optional arch=any
 libavcodec-extra58 deb libs optional arch=any
 libavcodec58 deb libs optional arch=any
 libavdevice-dev deb libdevel optional arch=any
 libavdevice58 deb libs optional arch=any
 libavfilter-dev deb libdevel optional arch=any
 libavfilter-extra deb metapackages optional arch=any
 libavfilter-extra7 deb libs optional arch=any
 libavfilter7 deb libs optional arch=any
 libavformat-dev deb libdevel optional arch=any
 libavformat-extra deb metapackages optional arch=any
 libavformat-extra58 deb libs optional arch=any
 libavformat58 deb libs optional arch=any
 libavutil-dev deb libdevel optional arch=any
 libavutil56 deb libs optional arch=any
 libpostproc-dev deb libdevel optional arch=any
 libpostproc55 deb libs optional arch=any
 libswresample-dev deb libdevel optional arch=any
 libswresample3 deb libs optional arch=any
 libswscale-dev deb libdevel optional arch=any
 libswscale5 deb libs optional arch=any
Checksums-Sha1:
 e28cd4d19961f74a5bc20049d502fd9b2f5d7362 9562968 ffmpeg_4.4.2.orig.tar.xz
 b445c1f8f75398ea37aadcb56cd526fc2b1c1fdb 520 ffmpeg_4.4.2.orig.tar.xz.asc
 b64f62b9f6ffdc0f877d628ff23e4ddd5441ed6f 54484 ffmpeg_4.4.2-0ubuntu0.22.04.1.debian.tar.xz
Checksums-Sha256:
 af419a7f88adbc56c758ab19b4c708afbcae15ef09606b82b855291f6a6faa93 9562968 ffmpeg_4.4.2.orig.tar.xz
 9565fbabaf877939bbe48e80f04d424c02d4ce7be65a61d144c442658701f30e 520 ffmpeg_4.4.2.orig.tar.xz.asc
 d5d0c5e4156572a9d42c4c2de9e01384cae4fbcfe79c20dc239e88b24a4b2bb8 54484 ffmpeg_4.4.2-0ubuntu0.22.04.1.debian.tar.xz
Files:
 0dfb3330df82598750e9eb3e782255bd 9562968 ffmpeg_4.4.2.orig.tar.xz
 5b70a3d9b23a567390d797f14c733c13 520 ffmpeg_4.4.2.orig.tar.xz.asc
 3337a646bd0509fe67b1fa9ec952be73 54484 ffmpeg_4.4.2-0ubuntu0.22.04.1.debian.tar.xz
Original-Maintainer: Debian Multimedia Maintainers <debian-multimedia@lists.debian.org>

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEECtyyz6azUy6AZBzSkGeI6zGnN/8FAmKfe40ACgkQkGeI6zGn
N/+mGw/8CVNguGGFNabKOGfOfn8a7TTaVy4WWvhHwhzr5KYmC7MuE58n8TmYkQQ2
+KCieW6Ln/6a3tRTfetAd5wkjCC3nteyO00E4ABUmiQjcvCoYcFOP/EQoBOfYdD3
UONby6a+tptHAbWDboNbQz4Q6pVr/fH1+rLZXf9VnvTdXMIPL8hGQ0hOBf4U/Rhz
9Vbh0aLh6np25TpZhot4M5C6hyMs33g8v8NNTbW3XOPZ3O2Bzur+5sgNkzy+uXjz
/Ta8DO9wJpw5bBlrSwXyTwwsobkRvF0W4XIdWRL6R44NpMMSHndVlgi/Crg8++oE
ryJIZOtVV/VC0g4Z5vs7KqOlW+xeeSxy0GqnejJo0Fd2i8sv8EcGQQrZ4rKwU0eR
LmxdySqp3MLvK53EUS2OLn8nB0poBR5knuykEmUttxoz2eZsKXvLu63HUPvxSUYQ
aWb3CUNf0lRUKLjlIfKgZT3fGZ2ilnubwuiWe5S4rgD9NDG4mNeZiyzVPNZLg07/
rLOcrP9VKBUimLus5kktH6V0Zdw4eXDpm3FDmC/h4n9rvom9A0+VZAbqoxM0BxKH
FlZ+MG0M6T9XArtDKzHFXOWP7WrqSOHrvHVPnnggP+/VZ0bqHJxE8VIhcZ/6s3yl
QNpYiwWypoFmq8Ctvs/a/+AU/dNTcATE/KrMWhI3mfRhMFT1Oao=
=T4Za
-----END PGP SIGNATURE-----
