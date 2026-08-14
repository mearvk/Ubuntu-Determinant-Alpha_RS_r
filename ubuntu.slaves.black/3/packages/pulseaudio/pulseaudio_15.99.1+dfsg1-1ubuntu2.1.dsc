-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: pulseaudio
Binary: pulseaudio, pulseaudio-utils, pulseaudio-module-zeroconf, pulseaudio-module-jack, pulseaudio-module-lirc, pulseaudio-module-gsettings, pulseaudio-module-raop, pulseaudio-module-bluetooth, pulseaudio-equalizer, libpulse0, libpulse-mainloop-glib0, libpulse-dev, libpulsedsp
Architecture: any
Version: 1:15.99.1+dfsg1-1ubuntu2.1
Maintainer: Ubuntu Developers <ubuntu-devel-discuss@lists.ubuntu.com>
Uploaders: Sjoerd Simons <sjoerd@debian.org>, Felipe Sateler <fsateler@debian.org>, Sebastien Bacher <seb128@debian.org>
Homepage: http://www.pulseaudio.org
Standards-Version: 4.6.0
Vcs-Browser: https://git.launchpad.net/~ubuntu-audio-dev/pulseaudio
Vcs-Git: https://git.launchpad.net/~ubuntu-audio-dev/pulseaudio
Testsuite: autopkgtest
Testsuite-Triggers: build-essential
Build-Depends: debhelper-compat (= 12), meson, ninja-build, check <!nocheck>, desktop-file-utils <!nocheck>, dh-exec, doxygen, dpkg-dev (>= 1.17.14), intltool, libapparmor-dev [linux-any], libasound2-dev [linux-any], libasyncns-dev, libavahi-client-dev, libbluetooth-dev [linux-any] <!stage1>, libsbc-dev [linux-any], libcap-dev [linux-any], libfftw3-dev, libglib2.0-dev, libgstreamer1.0-dev (>= 1.14), libgstreamer-plugins-base1.0-dev, libgtk-3-dev, libice-dev, libjack-dev, liblirc-dev, libltdl-dev (>= 2.2.6a-2), liborc-0.4-dev (>= 1:0.4.11), libsamplerate0-dev, libsndfile1-dev (>= 1.0.20), liblircclient-dev, libsnapd-glib-dev (>= 1.49), libsoxr-dev (>= 0.1.1), libspeexdsp-dev (>= 1.2~rc1), libssl-dev, libsystemd-dev [linux-any], libtdb-dev, libudev-dev [linux-any], libwebrtc-audio-processing-dev (>= 0.2) [linux-any], libwrap0-dev, libx11-xcb-dev, libxcb1-dev, libxml2-utils <!nocheck>, libxtst-dev, systemd [linux-any]
Package-List:
 libpulse-dev deb libdevel optional arch=any
 libpulse-mainloop-glib0 deb sound optional arch=any
 libpulse0 deb libs optional arch=any
 libpulsedsp deb sound optional arch=any
 pulseaudio deb sound optional arch=any
 pulseaudio-equalizer deb sound optional arch=any
 pulseaudio-module-bluetooth deb sound optional arch=linux-any profile=!stage1
 pulseaudio-module-gsettings deb sound optional arch=any
 pulseaudio-module-jack deb sound optional arch=any
 pulseaudio-module-lirc deb sound optional arch=any
 pulseaudio-module-raop deb sound optional arch=any
 pulseaudio-module-zeroconf deb sound optional arch=any
 pulseaudio-utils deb sound optional arch=any
Checksums-Sha1:
 d3d75cfebd2f8ad46d7e05e1bd1bc2d401b82f58 1439224 pulseaudio_15.99.1+dfsg1.orig.tar.xz
 a1018bf73cfe2dd6c6cd3f413aa7973624110e9f 98140 pulseaudio_15.99.1+dfsg1-1ubuntu2.1.debian.tar.xz
Checksums-Sha256:
 f924e6dc26a63e11e83fd014662f6fdc23a3554ce90c457ae4181387d4fd29f7 1439224 pulseaudio_15.99.1+dfsg1.orig.tar.xz
 9134fb02f569cd36445ffcee9f5f6fe1e13f534f9d9ec3413bbb691ff723f860 98140 pulseaudio_15.99.1+dfsg1-1ubuntu2.1.debian.tar.xz
Files:
 83ae2720c5a3fd82540e5d8ce4b594ef 1439224 pulseaudio_15.99.1+dfsg1.orig.tar.xz
 edf62653c5d384189de929a668b72b19 98140 pulseaudio_15.99.1+dfsg1-1ubuntu2.1.debian.tar.xz
Original-Maintainer: Pulseaudio maintenance team <pkg-pulseaudio-devel@lists.alioth.debian.org>

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEdS3ifE3rFwGbS2Yjy3AxZaiJhNwFAmP2DicACgkQy3AxZaiJ
hNwGjBAAjSyLaOwXTWKgx+Bwfp6aStxxxB6wzIbeQecnrLoHhYvNAGWyx61B/pg6
OatyYO8dwATfIgtpQBHy6D6Xfhh7GfoH/mkXYkBSzAX9zIw4kXSvpDZxsOcluV1z
jtgyTCt7YRfYIiSLDRPaetGzC1YfJ3G5XNhdu+agrSX//QuTfwewC2g9JFOxY5mw
OH5O8AMCKdl06nXJUU70+H37owmtIp945jgt0nQhPn4UFurFgCgkVfO556R2oMIH
ksxuKB6aKAfz2sI5XCW92mFZ2m9joK1K7O0yuZF65UbKopotFiplA+wnSm/T0Avc
IPIJ8YAk8/x9YDyl+KQP827TunlXjqeYRbQN1IAAHdUW/DVfHpHvI9vRJTskV3FA
buYJKBxVFzXM2B/Sas1bl6ewzT/8ZWsdW/wRJSrwPriRoxOAxPDKtLppRVqjcuPk
kj90RRclBpb4RcP7X/9jtkVmdVvjnKEOGUxIxht8FCM6/JUz0HaqhjQ2GFeXTN0/
KjVnSixbG6nTMIaEUiEjxGsXUS6p4tPP2XGg91ilY6R4zCpzg8b6e4TbUw5hTFQS
9uc4K6pekGkph8dg1vGaZBefUTTQOEhNBeqjppMX2LWiCpP/cEBioXXdrib0wZSt
SwDyYh/UjamxxDsCiOt5E62MsFZ4KTwwz7ModBrEZ8qE1guDzUw=
=FbqP
-----END PGP SIGNATURE-----
