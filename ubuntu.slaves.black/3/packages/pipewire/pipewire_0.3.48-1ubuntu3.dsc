-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: pipewire
Binary: libpipewire-0.3-0, libpipewire-0.3-common, libpipewire-0.3-dev, libpipewire-0.3-modules, libspa-0.2-dev, libspa-0.2-modules, pipewire-doc, pipewire, pipewire-bin, pipewire-pulse, pipewire-audio-client-libraries, pipewire-tests, gstreamer1.0-pipewire, libspa-0.2-bluetooth, libspa-0.2-jack
Architecture: linux-any all
Version: 0.3.48-1ubuntu3
Maintainer: Ubuntu Developers <ubuntu-devel-discuss@lists.ubuntu.com>
Uploaders: Jeremy Bicha <jbicha@debian.org>
Homepage: https://pipewire.org/
Standards-Version: 4.6.0
Vcs-Browser: https://salsa.debian.org/utopia-team/pipewire
Vcs-Git: https://salsa.debian.org/utopia-team/pipewire.git
Testsuite: autopkgtest
Testsuite-Triggers: build-essential, gnome-desktop-testing, gstreamer1.0-tools, pkg-config
Build-Depends: debhelper-compat (= 13), doxygen <!nodoc>, graphviz <!nodoc>, libasound2-dev, libavahi-client-dev, libbluetooth-dev, libdbus-1-dev, libglib2.0-dev (>= 2.32.0), libgstreamer-plugins-base1.0-dev, libgstreamer1.0-dev, libjack-jackd2-dev (>= 1.9.10), libcanberra-dev, libldacbt-abr-dev [!s390x !hppa !m68k !powerpc !ppc64 !sparc64], libldacbt-enc-dev [!s390x !hppa !m68k !powerpc !ppc64 !sparc64], liblilv-dev, libncurses-dev, libpulse-dev (>= 11.1), libreadline-dev, libsbc-dev, libsdl2-dev, libsndfile1-dev (>= 1.0.20), libssl-dev, libsystemd-dev [linux-any], libudev-dev [linux-any], libusb-1.0-0-dev, libv4l-dev, libwebrtc-audio-processing-dev, meson (>= 0.59.0), pkg-config (>= 0.22), python3-docutils, systemd [linux-any]
Build-Conflicts: libfdk-aac-dev
Package-List:
 gstreamer1.0-pipewire deb libs optional arch=linux-any
 libpipewire-0.3-0 deb libs optional arch=linux-any
 libpipewire-0.3-common deb libs optional arch=all
 libpipewire-0.3-dev deb libdevel optional arch=linux-any
 libpipewire-0.3-modules deb libs optional arch=linux-any
 libspa-0.2-bluetooth deb libs optional arch=linux-any
 libspa-0.2-dev deb libdevel optional arch=linux-any
 libspa-0.2-jack deb libs optional arch=linux-any
 libspa-0.2-modules deb libs optional arch=linux-any
 pipewire deb video optional arch=linux-any
 pipewire-audio-client-libraries deb libs optional arch=linux-any
 pipewire-bin deb video optional arch=linux-any
 pipewire-doc deb doc optional arch=all profile=!nodoc
 pipewire-pulse deb video optional arch=linux-any
 pipewire-tests deb misc optional arch=linux-any
Checksums-Sha1:
 e49c45d82f0293a64f490bb9a46f32cfed23d989 1310997 pipewire_0.3.48.orig.tar.bz2
 acc47b04ce434b9c6b4a78d3c79f2f6120e1f666 18544 pipewire_0.3.48-1ubuntu3.debian.tar.xz
Checksums-Sha256:
 68bbf83b4c12bbcaef5d4bfb0dda86177583cf0abe0026efcfedd837b2e4926e 1310997 pipewire_0.3.48.orig.tar.bz2
 bccd1db6208d5897ca938da000d7d2d403597e37cc1dcc1c02611487f78233e8 18544 pipewire_0.3.48-1ubuntu3.debian.tar.xz
Files:
 8539215a479b2ffa00745e5835073452 1310997 pipewire_0.3.48.orig.tar.bz2
 5a09c1f051ed371dbdc8d9af107c8220 18544 pipewire_0.3.48-1ubuntu3.debian.tar.xz
Original-Maintainer: Utopia Maintenance Team <pkg-utopia-maintainers@alioth-lists.debian.net>

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE2Y83frR8xt0lepoH5WS5wnW91S4FAmNsriwACgkQ5WS5wnW9
1S7tQw//e2/Lk6OPVgRVfl6pgUKem0f4kouLaMC3YAIa6HLJcxdi2x34ramoHg06
+xl6z7DkXFGKXpG3NLHuBjTVoxB05eicm05Ah3IS6ILkJCJ2Z8nuwOQfv503OJXd
qmFi3fyqZyUbYFAexOtoKw1Y5+f3tpmmZwt7pWSSWwXYQ45S9DNp0dhvxXhAKrb0
QZEOwgD7CGIqXzRuGDWKL4q/VN7IAkIZQRUIEBbpwYwGxna0n5PTUuMu15e9pdLF
ldY4WmGlc3D2Sg51J40024+zDbsB5SDj9laPUEav6TiDnlrI4U7sI9JqKLXuJaM1
ZbS2IiFVeuM+/rOoDYCZODgO6T9KmC1b4hbm3D+atGsFzSeSo5skbivPbCx4JGEt
1CsCRp3fAVXAxxD4iYb2LqPJIgcxSChkOLvQLLKfBsJ+BPvWMp/72/lkyYQv2Wql
GHmD4EflYHs0bJz3HPEuKhWLZ9j9yg2YKzmlWOYTN0vLxdUMB1W4DNe5Hau3Ao0J
S/k0tvT3NNKbtr/ajI0zUdQUQe8/VIgO2mHsztx+W1UZMszqj1elPXQ5bR6Tc9EG
jKTHVHNtYruQYitz8r1R0srPrG8JQCk3diLTka8dj2VpCTDFzboCNGQaIg13bhzf
ErvXYWO9gSJHYFlm3O3Msu0ZCyOmbhbQruw/tV/mjylRFl0amwM=
=C1I6
-----END PGP SIGNATURE-----
