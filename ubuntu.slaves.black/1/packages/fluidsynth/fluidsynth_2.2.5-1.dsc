-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: fluidsynth
Binary: fluidsynth, libfluidsynth3, libfluidsynth-dev
Architecture: any
Version: 2.2.5-1
Maintainer: Debian Multimedia Maintainers <debian-multimedia@lists.debian.org>
Uploaders:  Alessio Treglia <alessio@debian.org>, David Henningsson <diwic@ubuntu.com>, Jaromír Mikeš <mira.mikes@seznam.cz>, Dennis Braun <d_braun@kabelmail.de>
Homepage: https://github.com/Fluidsynth/fluidsynth
Standards-Version: 4.6.0
Vcs-Browser: https://salsa.debian.org/multimedia-team/fluidsynth
Vcs-Git: https://salsa.debian.org/multimedia-team/fluidsynth.git
Testsuite: autopkgtest
Testsuite-Triggers: build-essential, libpulse-dev
Build-Depends: cmake, debhelper-compat (= 13), ladspa-sdk, libasound2-dev, libdbus-1-dev, libglib2.0-dev, libinstpatch-dev (>= 1.1.0), libjack-dev, libpulse-dev, libreadline-dev, libsdl2-dev, libsndfile-dev, libsystemd-dev [linux-any], libtool
Package-List:
 fluidsynth deb sound optional arch=any
 libfluidsynth-dev deb libdevel optional arch=any
 libfluidsynth3 deb libs optional arch=any
Checksums-Sha1:
 39ec19b25d7f3404e732d28349e783b6d6d96f12 1747610 fluidsynth_2.2.5.orig.tar.gz
 9ec4d4528dce283f5d6aaf13b714f6babd3e1563 19232 fluidsynth_2.2.5-1.debian.tar.xz
Checksums-Sha256:
 9037e703617f91c4c36039a5059e0f624164799d856af715bcd8a23c07ba03b8 1747610 fluidsynth_2.2.5.orig.tar.gz
 a75e9b30e2707d7e02b06a23176cc2775c479113bc4f81fa1c6757ad370c6299 19232 fluidsynth_2.2.5-1.debian.tar.xz
Files:
 f559100c34a037b387445c7c2177fe2b 1747610 fluidsynth_2.2.5.orig.tar.gz
 2e12ad068c444f2bce0d9bf15ea7d711 19232 fluidsynth_2.2.5-1.debian.tar.xz

-----BEGIN PGP SIGNATURE-----

iQJJBAEBCgAzFiEEPLfDAq+1fmGoxhfdY06lXZArmDYFAmH8VSYVHGRfYnJhdW5A
a2FiZWxtYWlsLmRlAAoJEGNOpV2QK5g2F8gQALUznRNXpRVV5LKdi335REQrAmwH
RayuQs3co1lJjHpT1A9VZOXJwPDCF63sI/QlgKunlQf7rABeB0DgpZYcll9nbgJk
7OGig7GyqgHpbMufFVz43V/1pUcRJoNXhwPzduOnTmni4WXQS/PZH9zTZniqt1GZ
XsXls+kfZ9+d5KPT28SzyA8xHsuExkds9i6MJ4MGZu+2rig6INn9s7xTUgvKMUxb
Jp7E1p9PAPvULg8WR8gRuRDyEy9QYv8duZ/V4chqAkhKjPXCkPs2lTbm8fVpvMKc
w2pFeRZ7ThYFqTLGAnIpRWYpqEzNGrJPbyLkitO05XPnPf+bKX8GBBT7lrpKVBxy
88DzIFPNJAp509GRlghUXq0M3HkwbPvCqbp0lM45jY+N69ygI4l6rAvAORZkwg8R
qyd8r27wn8t/XiyCKa5nPQp1SSFsxRz3dF0o+vGz3zT/8eXBJk2757ywuEX8zJ/P
d116c0Zkh0HuEGsezziNSH0yciNa7c5O9fZ5gn61y5LFBsIZN7AjoOFiLEUGyUSY
2MlYgT/0Qv8c2Ocya/5PFaVWXFwLFGDU893rRbh2372fDsXIY+hkpMrYTu3o5XrM
u+/tFZyQQj0+Q+YwSa4HrZAsPYpH3hY6HcJKdAYJQU0zwUWNJReyz1tGKoEHd9va
Mps8pEe8ccl9T5Oi
=dnmV
-----END PGP SIGNATURE-----
