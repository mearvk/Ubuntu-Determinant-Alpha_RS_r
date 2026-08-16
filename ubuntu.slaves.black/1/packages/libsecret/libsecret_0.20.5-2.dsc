-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: libsecret
Binary: libsecret-1-dev, libsecret-1-0, libsecret-common, libsecret-tools, gir1.2-secret-1
Architecture: any all
Version: 0.20.5-2
Maintainer: Debian GNOME Maintainers <pkg-gnome-maintainers@lists.alioth.debian.org>
Uploaders: Jeremy Bicha <jbicha@debian.org>, Laurent Bigonville <bigon@debian.org>, Tim Lunn <tim@feathertop.org>
Homepage: https://wiki.gnome.org/Projects/Libsecret
Standards-Version: 4.5.1
Vcs-Browser: https://salsa.debian.org/gnome-team/libsecret
Vcs-Git: https://salsa.debian.org/gnome-team/libsecret.git
Testsuite: autopkgtest
Testsuite-Triggers: build-essential, dbus, pkg-config
Build-Depends: debhelper-compat (= 13), dh-sequence-gir, dh-sequence-gnome, gi-docgen, libglib2.0-dev (>= 2.44.0), libglib2.0-doc (>= 2.44.0), libgcrypt20-dev (>= 1.2.2), libgirepository1.0-dev (>= 1.29), meson (>= 0.50.), gtk-doc-tools (>= 1.9), valac (>= 0.17.2.12), python3-dbus <!nocheck>, python3-gi <!nocheck>, dbus <!nocheck>, gjs [amd64 arm64 armel armhf i386 mips64el mipsel ppc64el s390x] <!nocheck>
Package-List:
 gir1.2-secret-1 deb introspection optional arch=any
 libsecret-1-0 deb libs optional arch=any
 libsecret-1-dev deb libdevel optional arch=any
 libsecret-common deb libs optional arch=all
 libsecret-tools deb admin optional arch=any
Checksums-Sha1:
 0ee77b352e1f5216395d4171352f313998269710 187220 libsecret_0.20.5.orig.tar.xz
 33a2c4d4b5d846ff3dc9c4abc66b7bd4cfa2e1fe 10864 libsecret_0.20.5-2.debian.tar.xz
Checksums-Sha256:
 56cfc341137da870cf9e24e297d5c0b3c3e403493581609311a88d2149d7d0c3 187220 libsecret_0.20.5.orig.tar.xz
 5968b551febbfcf2700e3b9f1c9a61d1c142fdd1540fee985b5b47f40c8138fd 10864 libsecret_0.20.5-2.debian.tar.xz
Files:
 de2a1be8f0dab352246ec575decc84c7 187220 libsecret_0.20.5.orig.tar.xz
 1432fe1ca913fa76ca8812b736ab4409 10864 libsecret_0.20.5-2.debian.tar.xz

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEETQvhLw5HdtiqzpaW5mx3Wuv+bH0FAmIWSQMACgkQ5mx3Wuv+
bH1kNBAAz4Z1LaavKHX2Vu/uC97Tch4LFR71oj68VRNWjQFrFBk7K16dX64chQsJ
y1Vn7Sgw0dPMVggy4PXWuvI3oAa7Fy0Xwry3k/FWpyIoVM8P/UiG3UG8riQNarGQ
JVcG4qTP6ql6u/KO/8iA+zCuW7VItGnDdd88970eosDUsA6ODZcjk34Wukd7sa3v
TiweZ6s9l3j89YCg0fC4bAIAzePYDL3xXyL1jIlsWU81mNOS/WknGWA175FyjnRM
/dRu0G+hCJBcyDFvv6LAYeCUT6BfyWJhvsjf3bQftQruXhDgTJdq2+LSIXNvsvfX
NPuLNZ4o5Jv+I9i2TfTVG93ZBJJrAnku/NSfys6WbHefnL3/NjKQYGs053X1QtXw
kKR9q9mD8dsp4EThAcUzo5ramin9wkyEfa8vq6TcRaYEFZHDKReSdezdFHi6wy6i
4xGqPzCl/sFqEhp6gtYKUlBQFhqMtA2B+u05Yr34k/Dj7YwezdTlNn8btXzTMuoR
smFO20jWICfduQTW3ODvDZWDy5r/soLI0VBJ2s752Rbkw4xdfgm7TddZYXW7Zjb0
XodYu/tYxhVkYhnM5poOcHborJzbQTFNlG2q/YBWr96GotQCh6S1YQFqfIL4CJZO
+dwstjTnh9JGCo/CRGkWYQdknxVGE0bMWiyNxXhGRYwcN6X7NsY=
=hCs3
-----END PGP SIGNATURE-----
